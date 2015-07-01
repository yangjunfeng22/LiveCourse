//
//  HSBaseTool.m
//  HSWordsPass
//
//  Created by Lu on 14-9-9.
//

#import "HSBaseTool.h"
#import "MBProgressHUD.h"
#import "NSDateFormatter+HelloHSK.h"


@implementation HSBaseTool
hsSharedInstanceImpClass(HSBaseTool)

+ (NSString *)audioPathWithCheckPoinID:(NSString *)cpID audio:(NSString *)audio
{
    NSString *dataDPath = [NSString stringWithFormat:@"%@", cpID];
    NSString *destionPath = [kDownloadedPath stringByAppendingPathComponent:dataDPath];
    NSString *tAudio = [audio isEqualToString:@""] ? @"" : [destionPath stringByAppendingPathComponent:audio];
    return tAudio;
}

+ (NSString *)picturePathWithCheckPoinID:(NSString *)cpID picture:(NSString *)picture
{
    NSString *dataDPath = [NSString stringWithFormat:@"%@", cpID];
    NSString *destionPath = [kDownloadedPath stringByAppendingPathComponent:dataDPath];
    NSString *tPicture = [picture isEqualToString:@""] ? @"" : [destionPath stringByAppendingPathComponent:picture];
    return tPicture;
}

+(NSDateFormatter*)getDateFormat
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc]init];
        //[format setCalendar:[NSCalendar currentCalendar]];
        //[format setLocale:[NSLocale currentLocale]];
        //[format setTimeZone:[NSTimeZone systemTimeZone]];
    });
    [format setDateFormat:defDateFormatter];
    
    return format;
}


//把Date 转换成String
+(NSString *)stringWithDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    NSString* datestr = [formatter stringFromDate:date];
    return datestr;
}
+(NSString *)stringWithDate:(NSDate *)date format:(NSString *)format{
    if (!date) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    [formatter setDateFormat:format];
    NSString* datestr = [formatter stringFromDate:date];
    return datestr;
}
+(NSString *)stringWithStringDate:(NSString *)dateString format:(NSString *)format{
    NSDate *date = [HSBaseTool dateWithString:dateString format:format];
    return [HSBaseTool stringWithDate:date format:format];
}

+(NSDate *)dateWithString:(NSString *)str
{
    if (!str) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    NSDate* date = [formatter dateFromString:str];
    return date;
}
+(NSDate *)dateWithString:(NSString *)str format:(NSString *)format{
    if (!str) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:str];
    return date;
}
+(NSDate *)dateWithDate:(NSDate *)date format:(NSString *)format{
    NSString *dateStr = [HSBaseTool stringWithDate:date format:format];
    return [HSBaseTool dateWithString:dateStr format:format];
}



#pragma mark 格式化文件大小
+ (NSString *)formattedFileSize:(unsigned long long)size
{
    NSString *formattedStr = nil;
    if (size == 0)
        //formattedStr = @"Empty";
        formattedStr = @"0.0KB";
    else
        if (size > 0 && size < 1024)
            formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
        else
            if (size >= 1024 && size < pow(1024, 2))
                formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                else
                    if (size >= pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.3f GB", (size / pow(1024, 3))];
    
    return formattedStr;
}



#pragma mark iphone应用变成中，不识别16进制的表示法，需要转化成rgb表示法
+(UIColor *) getHexColor:(NSString *)hexColor
{
    if ([NSString isNullString:hexColor]) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}


+ (UIColor *)getHexColor:(NSString *)hexColor alpha:(CGFloat)alpha
{
    if ([NSString isNullString:hexColor]) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}

//传入一个颜色值，返回一个可拉伸的纯色方块Image对象 ( 10 * 10 )
+(UIImage *)pureColorImageFromColor:(UIColor *)color{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    if (color) {
        view.backgroundColor = color;
    }else{
        view.backgroundColor = [UIColor blackColor];
    }
    UIImage *image = [UIImage convertToImageFromView:view];
    UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    image = nil;
    view = nil;
    return resizableImage;
}


#pragma mark - superview && subview
//传入一个View，返回指定的Class的superview
+(id)superviewFromView:(UIView *)view superClass:(Class)clazz{
    if (!view.superview) {
        return nil;
    }
    UIView *superview = view.superview;
    while (superview && ![superview isKindOfClass:clazz]) {
        superview = superview.superview;
    }
    return superview;
}
//传入一个View，返回指定的Class的subviews
+(NSArray *)subviewFromView:(UIView *)view subviewClass:(Class)clazz{
    if (!view || !clazz) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *sub in [view subviews]) {
        if ([sub isKindOfClass:clazz]) {
            [array addObject:sub];
        }
    }
    return array;
}


#pragma mark 邮箱手机格式验证
+ (BOOL)isEmailString:(NSString *)email{
    NSString *reg = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return [regexEmail evaluateWithObject:email];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 方便添加RightBarButtonItem

UIBarButtonItem* CreatViewControllerImageBarButtonItem(UIImage *image,SEL action,UIViewController *viewController,BOOL isLeft)
{
    
    /**
     * ios7 下使用
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:viewController action:action];
//    if (isLeft) {
//        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    }else{
//        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
//    }
//    return barButtonItem;
     */
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    button.frame = CGRectMake(0, 0, 40, 38);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }else{
        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    }
    return barButtonItem;
}


UIBarButtonItem* CreatViewControllerTitleBarButtonItem(NSString *title,SEL action,UIViewController *viewController,BOOL isLeft)
{
    /*
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:viewController action:action];
//    if (isLeft) {
//        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    }else{
//        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
//    }
//    return barButtonItem;
     */
    
    //UIFont *font = [UIFont systemFontOfSize:16.0f];
    //CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(80, 32) lineBreakMode:NSLineBreakByTruncatingTail];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectMake(0, 0, ceilf(size.width), ceilf(size.height));
    button.frame = CGRectMake(0, 0, 48, 30);
//    UIImage *leftButtonImage = BarItemNormalBackgroundImage;
//    UIImage *leftButtonHighlightedImage = BarItemHighlightBackgroundImage;
//    [button setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:leftButtonHighlightedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kColorMain forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }else{
        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    }
    return barButtonItem;
}


UIBarButtonItem* CreatViewControllerTitleBarButtonItemWithTag(NSString *title,id target,SEL action,UIViewController *viewController,BOOL isLeft)
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    if (isLeft) {
        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }else{
        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    }
    return barButtonItem;

}




-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)isHide position:(HUDYOffSetPosition)position{
    CGFloat yOffset = 0;
    switch (position) {
        case HUDYOffSetPositionTop:      {yOffset = -120; } break;
        case HUDYOffSetPositionCenter:   {yOffset = 0; } break;
        case HUDYOffSetPositionBottom:   {yOffset = 120; } break;
        default: break;
    }
    [self HUDForView:view Title:title detail:nil isHide:isHide afterDelay:1.0f yOffset:yOffset];
}

-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)hide{
    [self HUDForView:view Title:title detail:nil isHide:hide afterDelay:1.0f];
}

-(void)HUDForView:(UIView *)view detail:(NSString *)title isHide:(BOOL)hide{
    [self HUDForView:view Title:nil detail:title isHide:hide afterDelay:1.5f yOffset:0];
}

-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay{
    [self HUDForView:view Title:title detail:str isHide:hide afterDelay:delay yOffset:120];
}
-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay yOffset:(CGFloat)yOffset{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:view];
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:view];
        __block __weak MBProgressHUD *tempProgressHUD = progressHUD;
        [view addSubview:tempProgressHUD];
        tempProgressHUD.userInteractionEnabled = NO;
        tempProgressHUD.yOffset = yOffset;
        tempProgressHUD.mode = MBProgressHUDModeText;
        tempProgressHUD.animationType = MBProgressHUDAnimationZoomOut;
        tempProgressHUD.labelText = title;
        tempProgressHUD.detailsLabelText = str;
        [tempProgressHUD show:YES];
        
        if (hide) {
            [tempProgressHUD hide:YES afterDelay:delay];
            [tempProgressHUD setCompletionBlock:^(void){
                [tempProgressHUD removeFromSuperview];
                tempProgressHUD = nil;
            }];
        }
    }else{
        __block __weak MBProgressHUD *tempProgressHUD = progressHUD;
        tempProgressHUD.labelText = title;
        tempProgressHUD.detailsLabelText = str;
        tempProgressHUD.yOffset = yOffset;
        [tempProgressHUD show:YES];
        
        if (hide) {
            [tempProgressHUD hide:YES afterDelay:delay];
            [tempProgressHUD setCompletionBlock:^(void){
                [tempProgressHUD removeFromSuperview];
                tempProgressHUD = nil;
            }];
        }
    }
}

-(void)hideAllHUDForView:(UIView *)view animated:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}



//设置段落
-(NSMutableAttributedString *)paragraphStyleAndString:(NSString *)text font:(UIFont *)font space:(NSUInteger)space{
    //设置段落类型
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = space;
    
    NSMutableAttributedString *summarizeString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    
    return summarizeString;
}

#pragma mark - 谷歌分析 页面访问记录
+ (void)googleAnalyticsPageView:(NSString *)pageName
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:pageName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

+ (void)googleAnalyticsLogCategory:(NSString *)category action:(NSString *)action event:(NSString *)event pageView:(NSString *)pageName
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:pageName];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:event
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}


+ (NSString *)dateFromTimeIntervalSince1970:(NSTimeInterval)secs
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    // 1. 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components :unit fromDate :[ NSDate date ]];
    // 2. 获得 date 的年月日
    NSDateComponents *otherCmps = [calendar components :unit fromDate:date];
    //直接分别用当前对象和现在的时间进行比较，比较的属性就是年月日
    BOOL isToday = ((otherCmps.year == nowCmps.year) && (otherCmps.month == nowCmps.month) && (otherCmps.day == nowCmps.day));
    BOOL isYear = (otherCmps.year == nowCmps.year);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setAMSymbol:@"AM"];
    //[dateFormatter setPMSymbol:@"PM"];
    NSString *dateFromat = isYear ? (isToday ? @"HH:mm" : @"MM-dd") : @"yyyy-MM-dd";
    [dateFormatter setDateFormat:dateFromat];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}


+ (NSString *)postDateFromTimeIntervalSince1970:(NSTimeInterval)secs
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *dateFormatter = [NSDateFormatter helloHSKDateFormatter];
    NSString *strDate = [[NSString alloc] initWithString:[dateFormatter stringFromDate:date]];
    return strDate;
}


+(NSString *)removerSymbol:(NSString *)oldStr
{
    NSString *theString = [oldStr copy];
    NSString *pattern = @"([^\u4e00-\u9fa50-9a-zA-Z]+)";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    NSString *newString = [regex stringByReplacingMatchesInString:theString
                                                          options:0
                                                            range:NSMakeRange(0, [theString length])
                                                     withTemplate:@""];
    return newString;
}

+ (NSString *)replaceMoverSymbol:(NSString *)oldStr withString:(NSString *)replace
{
    NSString *theString = [oldStr copy];
    //NSString *pattern = @"([^\u4e00-\u9fa50-9a-zA-Z]+)";
    NSString *pattern = @"([^a-zA-Zà-ǜa-z]+)";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    NSString *newString = [regex stringByReplacingMatchesInString:theString
                                                          options:0
                                                            range:NSMakeRange(0, [theString length])
                                                     withTemplate:replace];
    return newString;
}

+ (NSMutableArray *)chaosArrayFromArry:(NSArray *)oldArry withReturnNumber:(NSInteger)returnNumber{
    if (returnNumber > oldArry.count) {
        return nil;
    }
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:2];
    NSMutableArray *oldMutableArray = [NSMutableArray arrayWithArray:oldArry];
    for (int i = 0; i < returnNumber; i++) {
        NSInteger random = arc4random()%oldMutableArray.count;
        id tempItem = [oldMutableArray objectAtIndex:random];
        [newArray insertObject:tempItem atIndex:i];
        [oldMutableArray removeObject:tempItem];
    }
    return newArray;
}



+(NSString *)getAbcStrWithIndex:(NSUInteger)index{
    char item[] = "A";
    
    item[0] += index;
    
    NSString *abcStr = [[NSString alloc] initWithUTF8String:item];
    
    return abcStr;
}

+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    if (minutes <= 0) {
        return [NSString stringWithFormat:@"%d\"", seconds];
    }
    
    int hours = totalSeconds / 3600;
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%d\'%d\"", minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%d:%d:%d",hours, minutes, seconds];
    }
}

@end
