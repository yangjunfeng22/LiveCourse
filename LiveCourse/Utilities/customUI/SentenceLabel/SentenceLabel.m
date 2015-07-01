//
//  SentenceLabel.m
//  LiveCourse
//
//  Created by junfengyang on 15/2/10.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "SentenceLabel.h"
@interface SentenceLabel ()
{
    CGFloat totalHeight;
    CGFloat totalWidth;
    
    BOOL isPinyin;
}

@property (nonatomic, strong) NSMutableArray *arrShowData;
@property (nonatomic, strong) NSMutableDictionary *dicLineWidth;


@end

@implementation SentenceLabel
{
    BOOL isPinyinHighlight;
    UIColor *pinyinHighColor;
}

- (NSMutableArray *)arrShowData
{
    if (!_arrShowData)
    {
        _arrShowData = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _arrShowData;
}

- (NSMutableDictionary *)dicLineWidth
{
    if (!_dicLineWidth)
    {
        _dicLineWidth = [[NSMutableDictionary alloc] initWithCapacity:1];
        
    }
    return _dicLineWidth;
}


- (void)setText:(NSString *)aText
{
    //要加上这个super，不然不能触发drawRect函数
    [super setText:aText];
    [self decodeText:aText rect:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize nSize = size;
    if (isPinyin)
    {
        //[self decodeText:self.text rect:self.bounds];
        nSize = CGSizeMake(totalWidth, totalHeight);
    }
    else
    {
        [super sizeThatFits:size];
    }
    return nSize;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    return bounds;
}


-(void)isPinyinHighlight:(BOOL)isHighlight andColor:(UIColor *)color
{
    isPinyinHighlight = isHighlight;
    pinyinHighColor = color;
    [self setNeedsDisplay];
}



- (void)drawTextInRect:(CGRect)rect
{
    CGRect nRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    
    if (isPinyin)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, self.textColor.CGColor);
        
        for (NSDictionary *dicRecord in self.arrShowData)
        {
            id key = [[dicRecord allKeys] objectAtIndex:0];
            CGFloat lineWidth = [[self.dicLineWidth objectForKey:key] floatValue];
            CGFloat distance = self.textAlignment == NSTextAlignmentCenter ?  (self.width - lineWidth)*0.5 : 0;
            NSArray *arrRecords = [dicRecord objectForKey:key];
            for (NSDictionary *dicAChar in arrRecords)
            {
                NSArray *arrKey = [dicAChar allKeys];
                for (int j = 0; j < [arrKey count]; j++)
                {
                    NSString *key    = [arrKey objectAtIndex:j];
                    NSValue *value   = [dicAChar objectForKey:key];
                    CGRect valueRect = [value CGRectValue];
                    CGRect showRect  = CGRectMake(valueRect.origin.x+distance, valueRect.origin.y, valueRect.size.width, valueRect.size.height);
                    
                    
                    //拼音高亮
                    if (arrKey.count > 1 && isPinyinHighlight && ![self isHighlighted]) {
                        if (arrKey.count >= 2 && j == 0) {
                            NSString *keyOne = [arrKey objectAtIndex:0];
                            
                            NSValue *valueOne   = [dicAChar objectForKey:keyOne];
                            CGRect valueRectOne = [valueOne CGRectValue];
                            
                            NSString *keyTwo = [arrKey objectAtIndex:1];
                            NSValue *valueTwo  = [dicAChar objectForKey:keyTwo];
                            CGRect valueRectTwo = [valueTwo CGRectValue];
                            
                            if (valueRectOne.origin.y < valueRectTwo.origin.y) {
                                CGContextSetFillColorWithColor(context, pinyinHighColor.CGColor);
                            }else{
                                CGContextSetFillColorWithColor(context, self.textColor.CGColor);
                            }
                        }else if (arrKey.count >= 2 && j == 1){
                            NSString *keyOne = [arrKey objectAtIndex:0];
                            
                            NSValue *valueOne   = [dicAChar objectForKey:keyOne];
                            CGRect valueRectOne = [valueOne CGRectValue];
                            
                            NSString *keyTwo = [arrKey objectAtIndex:1];
                            NSValue *valueTwo  = [dicAChar objectForKey:keyTwo];
                            CGRect valueRectTwo = [valueTwo CGRectValue];
                            
                            if (valueRectOne.origin.y > valueRectTwo.origin.y) {
                                CGContextSetFillColorWithColor(context, pinyinHighColor.CGColor);
                            }else{
                                CGContextSetFillColorWithColor(context, self.textColor.CGColor);
                            }
                        }
                    }

                    
                    
                    if ([self isHighlighted]) {
                        CGContextSetFillColorWithColor(context, kColorWhite.CGColor);
                    }
                    [key drawInRect:showRect withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
                }
            }
        }
        
        CGContextFlush(context);
    }
    else
    {
        [super drawTextInRect:nRect];
    }
    
}

- (void)decodeText:(NSString *)aText rect:(CGRect)rect
{
    if (aText)
    {
        NSPredicate *pinYinTest = [NSPredicate predicateWithFormat:@"SELF LIKE %@", @"*^*"];
        isPinyin = [pinYinTest evaluateWithObject:aText];
        if (!isPinyin) {
            return;
        }
        //CGRect nRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
        // 总的宽度
        CGFloat areaWidth = rect.size.width;
        //DLog(@"总的宽度: %f", areaWidth);
        // 在一行中，要计算后面的位置的话，需要先计算出前面已经占据了多少的宽度。
        CGFloat alreadWidth = 0;
        // 在一列中，要计算换行后，后面的行的y轴的起始位置的话，需要知道上面共占据了多高
        CGFloat alreadHeight = 0;
        // 空格的宽度
        CGFloat xSpace = 4;
        CGFloat ySpace = 5;
        // 先删除所有的旧的数据
        [self.arrShowData removeAllObjects];
        [self.dicLineWidth removeAllObjects];
        // 最终记录显示位置的数组
        NSMutableArray *arrRecords = [[NSMutableArray alloc] initWithCapacity:1];
        // 首先将atext按照尖尖号分割开来。
        NSArray *arrText = [aText componentsSeparatedByString:@"^"];
        
        // 取出中文
        NSString *strTempChinese = [arrText objectAtIndex:0];
        // 取出拼音
        NSString *strTempPinyin = [arrText objectAtIndex:1];
        // 分割拼音
        NSArray *arrTempPinyin  = [strTempPinyin componentsSeparatedByString:@" "];
        // 分割中文
        NSArray *arrTempChinese = [strTempChinese componentsSeparatedByString:@" "];
        
        //DLog(@"arrTempPinyin: %@; arrTempChinese: %@", arrTempPinyin, arrTempChinese);
        
        // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
        NSInteger pinYinCount  = [arrTempPinyin count];
        NSInteger chineseCount = [arrTempChinese count];
        // 选出最小的那个
        NSInteger count = pinYinCount > chineseCount ? chineseCount : pinYinCount;
        
        // 这里考虑折行的问题，计算出每一行显示字符的占宽。
        // 如果是左对齐，那么直接显示即可。
        // 如果是居中对齐，那么需要知道每一行的占宽，用总的中点减去这个宽的中点，取得偏移量。
        // 然后每个词的中点(一开始以居左对齐创建)加上这个偏移量就可以居中对齐了。
        NSInteger line = 0;
        // 计算出每一个拼音的位置以及对应的字的位置
        for (NSInteger j = 0; j < count; j++)
        {
            NSString *tmpPinyin = [arrTempPinyin objectAtIndex:j];
            // 用空格取代非正常字符。
            //tmpPinyin = [HSBaseTool replaceMoverSymbol:tmpPinyin withString:@" "];
            CGSize pSize = [tmpPinyin sizeWithFont:self.font];
            
            NSString *tmpChinese = [arrTempChinese objectAtIndex:j];
            CGSize cSize = [tmpChinese sizeWithFont:self.font];
            
            CGFloat cWidth = pSize.width > cSize.width ? pSize.width : cSize.width;
    
            //DLog(@"最大的字符宽度: %f", cWidth);
            // 看看再加一个词上去是不是要换行了。
            if (alreadWidth+cWidth-xSpace > areaWidth)
            {
                //DLog(@"换行时: alreadWidth: %f; areaWidth: %f; j: %d", alreadWidth, areaWidth, j);
                NSMutableArray *arrTmpRecords = [[NSMutableArray alloc] initWithCapacity:1];
                [arrTmpRecords addObjectsFromArray:arrRecords];
                NSDictionary *dicLineRecord = [[NSDictionary alloc] initWithObjectsAndKeys:arrTmpRecords, @(line), nil];
                [self.arrShowData addObject:dicLineRecord];
                [arrRecords removeAllObjects];
                
                [self.dicLineWidth setObject:@(alreadWidth-xSpace) forKey:@(line)];
                
                line++;
                alreadWidth = 0;
                // 第一个ySpace为拼音和中文之间的间隔,第二个ySpace为中文与下一行之间的间隔
                alreadHeight += cSize.height+ySpace+pSize.height+ySpace;
            }
            
            CGRect pinyinRect  = CGRectMake(alreadWidth, alreadHeight, cWidth, pSize.height);
            NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
            
            CGRect chineseRect = CGRectMake(CGRectGetMidX(pinyinRect) - cSize.width*0.5f, alreadHeight+pSize.height+ySpace , cSize.width, cSize.height);
            NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
            // 记录字符与位置之间的关系。
            NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:chineseValue, tmpChinese,pinyinValue, tmpPinyin, nil];
            [arrRecords addObject:dicAChar];
            
            // 将这个最大的宽度加上。接着加上一个屁股后面的空格的宽度。
            alreadWidth += cWidth+xSpace;
            totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;

            if (j >= count-1)
            {
                NSMutableArray *arrTmpRecords = [[NSMutableArray alloc] initWithCapacity:1];
                [arrTmpRecords addObjectsFromArray:arrRecords];
                NSDictionary *dicLineRecord = [[NSDictionary alloc] initWithObjectsAndKeys:arrTmpRecords, @(line), nil];
                [self.arrShowData addObject:dicLineRecord];
                [arrRecords removeAllObjects];
                
                [self.dicLineWidth setObject:@(alreadWidth-xSpace) forKey:@(line)];
                
                alreadHeight += cSize.height+ySpace+pSize.height+ySpace;
            }
        }
        //NSLog(@"arrShowData: %@", arrShowData);
        totalHeight = alreadHeight;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //[self decodeText:self.text rect:self.bounds];
}

@end
