//
//  HSPinyinLabel.m
//  LiveCourse
//
//  Created by junfengyang on 15/1/29.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "HSPinyinLabel.h"

@interface HSPinyinLabel ()
{
    CGFloat totalHeight;
    CGFloat totalWidth;
    
    BOOL isPinyin;
}

@property (nonatomic, strong) NSMutableArray *arrShowData;
@property (nonatomic, strong) NSMutableDictionary *dicLineWidth;


@end

@implementation HSPinyinLabel

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

- (void)appendTextWithSting:(NSString *)aString
{
    NSPredicate *pinYinTest = [NSPredicate predicateWithFormat:@"SELF LIKE %@", @"*^*"];
    isPinyin = [pinYinTest evaluateWithObject:aString];
    
    NSString *format = isPinyin ? @"|%@":@"%@";
    NSString *strSentence = [self.text stringByAppendingFormat:format, aString];
    self.text = strSentence;
}

- (void)trimTextWithString:(NSString *)aString
{
    NSString *format = isPinyin ? @"|%@":@"%@";
    NSString *trimString = [[NSString alloc] initWithFormat:format, aString];
    NSString *strSentence = [self.text stringByReplacingOccurrencesOfString:trimString withString:@""];
    self.text = strSentence;
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
        nSize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:self.lineBreakMode];
        nSize.height = nSize.height > size.height ? nSize.height:size.height;
        nSize = [super sizeThatFits:nSize];
    }
    return nSize;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    return bounds;
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
        // 首先将atext按照|分割开来。
        NSArray *arrTemp = [aText componentsSeparatedByString:@"|"];
        NSInteger totalCount = [arrTemp count];
        // 这里考虑折行的问题，计算出每一行显示字符的占宽。
        // 如果是左对齐，那么直接显示即可。
        // 如果是居中对齐，那么需要知道每一行的占宽，用总的中点减去这个宽的中点，取得偏移量。
        // 然后每个词的中点(一开始以居左对齐创建)加上这个偏移量就可以居中对齐了。
        NSInteger line = 0;
        NSInteger index = 0;
        for (NSString *obj in arrTemp)
        {
            if ([obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0)
            {
                totalCount--;
                continue;
            }
            // 将每个object以^分割开来
            // obj[0]是中文; obj[1]是拼音
            NSArray *arrObj = [obj componentsSeparatedByString:@"^"];
            // 中文和拼音两个中，占宽较大的那个。记录下最宽的。
            CGFloat maxWidth = 0;
            
            // 中文的size
            CGSize cSize = CGSizeZero;
            // 拼音的size
            CGSize pSize = CGSizeZero;
            // 中文
            NSString *tmpChinese;
            // 拼音
            NSString *tmpPinyin;
            
            if ([arrObj count] >=2)
            {
                tmpChinese = arrObj[0];
                tmpPinyin  = arrObj[1];
                
                // 用空格取代非正常字符。
                //tmpPinyin = [HSBaseTool replaceMoverSymbol:tmpPinyin withString:@" "];
                cSize = [tmpChinese sizeWithFont:self.font];
                pSize = [tmpPinyin sizeWithFont:self.font];
                
                maxWidth = cSize.width > pSize.width ? cSize.width:pSize.width;
            }
            
            // 看看再加一个词上去是不是要换行了。
            if (alreadWidth+maxWidth-xSpace > areaWidth)
            {
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
            
            CGRect pinyinRect  = CGRectMake(alreadWidth, alreadHeight, maxWidth, pSize.height);
            NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
            
            CGRect chineseRect = CGRectMake(CGRectGetMidX(pinyinRect) - cSize.width*0.5f, alreadHeight+pSize.height+ (kiPhone4 ? 0:ySpace) , cSize.width, cSize.height);
            NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
            // 记录字符与位置之间的关系。
            NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:chineseValue, tmpChinese,pinyinValue, tmpPinyin, nil];
            [arrRecords addObject:dicAChar];
            
            // 将这个最大的宽度加上。接着加上一个屁股后面的空格的宽度。
            alreadWidth += maxWidth+xSpace;
            totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
            index++;
            
            if (index >= totalCount)
            {
                NSMutableArray *arrTmpRecords = [[NSMutableArray alloc] initWithCapacity:1];
                [arrTmpRecords addObjectsFromArray:arrRecords];
                NSDictionary *dicLineRecord = [[NSDictionary alloc] initWithObjectsAndKeys:arrTmpRecords, @(line), nil];
                [self.arrShowData addObject:dicLineRecord];
                [arrRecords removeAllObjects];
                
                [self.dicLineWidth setObject:@(alreadWidth-xSpace) forKey:@(line)];
                
                alreadHeight += cSize.height+ySpace+pSize.height+ySpace;
            }
        }// end for
        totalHeight = alreadHeight;
    }
}


@end
