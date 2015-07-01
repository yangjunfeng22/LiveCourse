//
//  HSBaseFormatTool.h
//  HSWordsPass
//
//  Created by Lu on 14-9-9.
//

#import <Foundation/Foundation.h>

#define defDateFormatter @"yyyy-MM-dd HH:mm:ss"

//#define HEXCOLOR(hex) [HSBaseTool getHexColor:(hex)]
//#define HEXCOLORA(hex, a) [HSBaseTool getHexColor:(hex) alpha:a]

typedef NS_ENUM(NSUInteger, HUDYOffSetPosition) {
    HUDYOffSetPositionTop = 0,
    HUDYOffSetPositionCenter,
    HUDYOffSetPositionBottom,
};

@interface HSBaseTool : NSObject

hsSharedInstanceDefClass(HSBaseTool)

#pragma mark NSDate和NSString转化
+(NSDate *)dateWithString:(NSString *)str;
+(NSDate *)dateWithString:(NSString *)str format:(NSString *)format;
+(NSDate *)dateWithDate:(NSDate *)date format:(NSString *)format;
+(NSString *)stringWithDate:(NSDate *)date;
+(NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
+(NSString *)stringWithStringDate:(NSString *)dateString format:(NSString *)format;


// 获取音频和图片的最终路径.
+ (NSString *)audioPathWithCheckPoinID:(NSString *)cpID audio:(NSString *)audio;
+ (NSString *)picturePathWithCheckPoinID:(NSString *)cpID picture:(NSString *)picture;

#pragma mark 格式化文件大小
//格式化文件大小
+ (NSString *)formattedFileSize:(unsigned long long)size;


#pragma mark 颜色的16进制的表示法
//phone应用变成中，不识别16进制的表示法，需要转化成rgb表示法
+ (UIColor *) getHexColor:(NSString *)hexColor; //通过宏 HEXCOLOR 来调用

+ (UIColor *)getHexColor:(NSString *)hexColor alpha:(CGFloat)alpha;

//传入一个颜色值，返回一个可拉伸的纯色Image对象 ( 10 * 10 )
+(UIImage *)pureColorImageFromColor:(UIColor *)color;


#pragma mark - superview && subview
//传入一个View，返回指定的Class的superview
+(id)superviewFromView:(UIView *)view superClass:(Class)clazz;
//传入一个View，返回指定的Class的subviews
+(NSArray *)subviewFromView:(UIView *)view subviewClass:(Class)clazz;



#pragma mark 邮箱手机格式验证
+ (BOOL)isEmailString:(NSString *)email;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;



#pragma mark - 方便添加RightBarButtonItem
UIBarButtonItem* CreatViewControllerImageBarButtonItem(UIImage *image,SEL action,UIViewController *viewController,BOOL isLeft);
UIBarButtonItem* CreatViewControllerTitleBarButtonItem(NSString *title,SEL action,UIViewController *viewController,BOOL isLeft);
UIBarButtonItem* CreatViewControllerTitleBarButtonItemWithTag(NSString *title,id target,SEL action,UIViewController *viewController,BOOL isLeft);

#pragma mark - 方便添加hub
-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)hide;
-(void)HUDForView:(UIView *)view detail:(NSString *)title isHide:(BOOL)hide;
-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay;
-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay yOffset:(CGFloat)yOffset;
-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)isHide position:(HUDYOffSetPosition)postion;

-(void)hideAllHUDForView:(UIView *)view animated:(BOOL)animated;



-(NSMutableAttributedString *)paragraphStyleAndString:(NSString *)text font:(UIFont *)font space:(NSUInteger)space;

#pragma mark - 谷歌分析 页面访问记录
+ (void)googleAnalyticsPageView:(NSString *)pageName;

+ (void)googleAnalyticsLogCategory:(NSString *)category action:(NSString *)action event:(NSString *)event pageView:(NSString *)pageName;


+ (NSString *)dateFromTimeIntervalSince1970:(NSTimeInterval)secs;
+ (NSString *)postDateFromTimeIntervalSince1970:(NSTimeInterval)secs;


/**
 *  去除中英数字意外的符号
 *
 *  @param oldStr <#oldStr description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)removerSymbol:(NSString *)oldStr;

+(NSString *)replaceMoverSymbol:(NSString *)oldStr withString:(NSString *)replace;



/**
 *  传入一个数组 并返回需要长度的数组  且 不能重复
 *
 *  @param oldArry      <#oldArry description#>
 *  @param returnNumber <#returnNumber description#>
 *
 *  @return <#return value description#>
 */
+(NSMutableArray *)chaosArrayFromArry:(NSArray *)oldArry withReturnNumber:(NSInteger)returnNumber;


/**
 *  获取abc字符串
 *
 *  @param index 索引
 *
 *  @return abc字符
 */
+(NSString *)getAbcStrWithIndex:(NSUInteger)index;



//时间格式化
+ (NSString *)timeFormatted:(int)totalSeconds;


@end
