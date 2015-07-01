//
//  HSCommunityPlateView.m
//  LiveCourse
//
//  Created by Lu on 15/5/22.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSCommunityPlateView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Extra.h"

//横向
#define horizontalNum 4
#define horizontalBorderSpace 15

//垂直
#define verticalSapce 10
#define verticalBorderSpace 15

//按钮
#define btnItemWidth 65
#define btnItemHeight 100


#pragma mark - plateBtn


NSInteger communityPlateModelSort(CommunityPlateModel *obj1, CommunityPlateModel *obj2, void *context)
{
    float price1 = [obj1.weight floatValue];
    float price2 = [obj2.weight floatValue];
    
    if (price1 > price2) {
        return (NSComparisonResult)NSOrderedDescending;
    }else if (price1 < price2){
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame; ;
}




@interface PlateBtn ()

@property (nonatomic, strong) UILabel *plateTitleLabel;

@property (nonatomic, strong) UIImageView *plateImageView;

@property (nonatomic, strong) UILabel *messageNumLabel;

@end


@implementation PlateBtn

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kColorClear;
    }
    return self;
}

-(void)loadUIWithPlateModel:(CommunityPlateModel *)plateModel{
    self.communityPlateModel = plateModel;
    
    self.plateImageView.backgroundColor = kColorClear;
    
    NSURL *imageUrl = [NSURL URLWithString:plateModel.icon];
    
    
    [self.plateImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"img_community_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.plateImageView showClipImageWithImage:image];
    }];
    
    
    self.plateTitleLabel.text = [NSString stringWithFormat:@"%@",plateModel.title];
    
    
    NSInteger quantity = plateModel.quantityValue;
    if (quantity > 0) {
        
        if (quantity >= 99999) {
            quantity = 99999;
        }

        self.messageNumLabel.text = [NSString stringWithFormat:@"%i",quantity];
        self.messageNumLabel.numberOfLines = 1;
        [self.messageNumLabel sizeToFit];
        
        self.messageNumLabel.width += 10;
        self.messageNumLabel.textAlignment = NSTextAlignmentCenter;
        self.messageNumLabel.right = btnItemWidth;
    }else{
        _messageNumLabel.hidden = YES;
    }
}




-(UIImageView *)plateImageView{
    if (!_plateImageView) {
        _plateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btnItemWidth, btnItemWidth)];
        
        _plateImageView.layer.cornerRadius = btnItemWidth/2;
        _plateImageView.layer.masksToBounds = YES;
        
        [self addSubview:_plateImageView];
    }
    return _plateImageView;
}


-(UILabel *)plateTitleLabel{
    if (!_plateTitleLabel) {
        
        _plateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.plateImageView.bottom, btnItemWidth, btnItemHeight - btnItemWidth)];
        _plateTitleLabel.backgroundColor = kColorClear;
        _plateTitleLabel.numberOfLines = 2;
        _plateTitleLabel.textAlignment = NSTextAlignmentCenter;
        _plateTitleLabel.textColor = kColorWord;
        _plateTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        
        [self addSubview:_plateTitleLabel];
    }
    return _plateTitleLabel;
}

-(UILabel *)messageNumLabel{
    if (!_messageNumLabel) {
        _messageNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnItemWidth, 30)];
        _messageNumLabel.backgroundColor = kColorGolden;
        _messageNumLabel.layer.cornerRadius = 7;
        _messageNumLabel.layer.masksToBounds = YES;
        _messageNumLabel.numberOfLines = 1;
        _messageNumLabel.textColor = kColorWhite;
        _messageNumLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_messageNumLabel];
    }
    return _messageNumLabel;
}

@end





#pragma mark HSCommunityPlateView
@interface HSCommunityPlateView ()

@end

@implementation HSCommunityPlateView
{
    NSMutableArray *plateDataArray;
    NSMutableArray *plateBtnArray;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kColorWhite;
        
        plateBtnArray = [NSMutableArray arrayWithCapacity:2];
        
    }
    return self;
}


-(void)setPlateDataArray:(NSArray *)dataArray{

    plateDataArray = [NSMutableArray arrayWithArray:[dataArray sortedArrayUsingFunction:communityPlateModelSort context:nil]];
    
    CGFloat horizontalSpace = (self.width - horizontalNum * btnItemWidth - horizontalBorderSpace * 2) / (horizontalNum - 1);
    
    NSInteger plateDataArrayCount = plateDataArray.count;
    NSInteger plateBtnArrayCount = plateBtnArray.count;
    
    //第一次进入 生成等数量的按钮
    if (plateBtnArrayCount <= 0) {
        
        __block CGFloat selfHeight = 0;
        
        [plateDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            CommunityPlateModel *plateModel = (CommunityPlateModel *)obj;
            
            NSInteger lineNum = idx/horizontalNum;
            NSInteger columnNum = idx%horizontalNum;
            
            CGFloat tempTop = verticalBorderSpace + btnItemHeight * lineNum + verticalSapce*lineNum;
            CGFloat tempLeft = horizontalBorderSpace + btnItemWidth * columnNum + horizontalSpace*columnNum;
            
            
            PlateBtn *plateBtn = [[PlateBtn alloc] initWithFrame:CGRectMake(tempLeft, tempTop, btnItemWidth, btnItemHeight)];
            
            [plateBtn addTarget:self action:@selector(choosePlateAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:plateBtn];
            
            [plateBtnArray addObject:plateBtn];
            
            selfHeight = plateBtn.bottom + verticalBorderSpace;
            
            [plateBtn loadUIWithPlateModel:plateModel];
            
        }];
        
        self.height = selfHeight;
        
    }else{
        if (plateDataArrayCount == plateBtnArrayCount) {
            
            [plateBtnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PlateBtn *plateBtn = (PlateBtn *)obj;
                [plateBtn loadUIWithPlateModel:[plateDataArray objectAtIndex:idx]];
            }];
        }

        else if (plateDataArrayCount < plateBtnArrayCount) {
            //服务器减少了
            for (NSInteger i = 0; i < plateBtnArrayCount; i++) {
                if (i < plateDataArrayCount) {
                    //直接赋值
                    PlateBtn *plateBtn = (PlateBtn *)[plateBtnArray objectAtIndex:i];
                    [plateBtn loadUIWithPlateModel:[plateDataArray objectAtIndex:i]];
                }else{
                    //超过的按钮需要删除
                    PlateBtn *plateBtn = (PlateBtn *)[plateBtnArray objectAtIndex:i];
                    [plateBtn removeFromSuperview];
                }
            }
            
            //数组删除
            NSRange range = NSMakeRange(plateDataArray.count, plateBtnArray.count - plateDataArray.count);
            [plateBtnArray removeObjectsInRange:range];

            self.height = ((PlateBtn *)plateBtnArray.lastObject).bottom + verticalBorderSpace;
        }
        
        else if (plateDataArrayCount > plateBtnArrayCount)
        {
            //服务器增加了
            for (NSInteger i = 0; i < plateDataArrayCount; i++) {
                
                //存在的直接赋值
                if (i < plateBtnArray.count) {
                    PlateBtn *plateBtn = (PlateBtn *)[plateBtnArray objectAtIndex:i];
                    [plateBtn loadUIWithPlateModel:[plateDataArray objectAtIndex:i]];
                }else{
                    //不存在的 新建btn 再赋值
                    
                    NSInteger lineNum = i/horizontalNum;
                    NSInteger columnNum = i%horizontalNum;
                    
                    CGFloat tempTop = verticalBorderSpace + btnItemHeight * lineNum + verticalSapce*lineNum;
                    CGFloat tempLeft = horizontalBorderSpace + btnItemWidth * columnNum + horizontalSpace*columnNum;
                    
                    
                    PlateBtn *plateBtn = [[PlateBtn alloc] initWithFrame:CGRectMake(tempLeft, tempTop, btnItemWidth, btnItemHeight)];
                    
                    [plateBtn addTarget:self action:@selector(choosePlateAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self addSubview:plateBtn];
                    
                    [plateBtnArray addObject:plateBtn];
                    
                    self.height = plateBtn.bottom + verticalBorderSpace;
                    
                    [plateBtn loadUIWithPlateModel:[plateDataArray objectAtIndex:i]];
                }
            }
        }
    }
}

-(void)choosePlateAction:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:KAudioShouldStopNotification object:nil];
    
    PlateBtn *plateBtn = (PlateBtn *)sender;
    
    NSInteger boardID = plateBtn.communityPlateModel.boardIDValue;
    NSString *title = [NSString stringWithFormat:@"%@",plateBtn.communityPlateModel.title];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityPlateViewChoosePlateDelegate:andTitle:)]) {
        [self.delegate communityPlateViewChoosePlateDelegate:boardID andTitle:[NSString safeString:title]];
    }
}



@end

