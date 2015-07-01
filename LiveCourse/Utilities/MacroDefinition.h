//
//  MacroDefinition.h
//  HSWordsPass
//
//  Created by yang on 14-9-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#ifndef HSWordsPass_MacroDefinition_h
#define HSWordsPass_MacroDefinition_h

//-------------------获取设备大小-------------------------
#define StatuBar_HEIGHT 20
//NavBar高度
#define NavigationBar_HEIGHT 44
//TabBar高度
#define TabBar_HEIGHT 49.0
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//-------------------获取设备大小-------------------------

//-------------------文件路径-------------------------

#pragma mark - 获取沙盒路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//-------------------文件路径-------------------------

//-------------------打印日志-------------------------
#pragma mark - 打印日志
//DEBUG  模式下打印日志,当前行
/*
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
 */

#ifdef  DEBUG
#define DLOG_METHOD NSLog(@"%s", __func__)
#define DLOG_CMETHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#define DCOUNT(p) NSLog(@"%s(%d): rcount = %d\n", __func__, __LINE__, [p retainCount]);
#define DLOG_TRACE(x) do {printf x; putchar('\n'); fflush(stdout);} while (0)
#define DLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DLOG_METHOD
#define DLOG_CMETHOD
#define DCOUNT(p)
#define DLOG_TRACE(x)
#define DLog( s, ... )
#endif


//重写NSLog,Debug模式下打印日志和当前行数

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) do {                                                      \
          fprintf(stderr, "<%s : %d> %s\n",                                          \
          [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
          __LINE__, __func__);                                                       \
          (NSLog)((FORMAT), ##__VA_ARGS__);                                          \
          fprintf(stderr, "----------------------->\n");                             \
        } while(0)
#endif

// 打印rect, size, point的值。
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#define ITTDEBUG
#define ITTLOGLEVEL_INFO     10
#define ITTLOGLEVEL_WARNING  3
#define ITTLOGLEVEL_ERROR    1

#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)  ((void)0)
#endif

#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
ITTDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

#define ITTAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)

//---------------------打印日志--------------------------


//----------------------系统----------------------------
#pragma mark - 系统
// 判断是否越狱
#define kiSJailBroken [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#define kiOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define kiOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kSoftwareVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]
#define kSoftwareName    [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey]
#define kApplicationID   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppID"]
#define kApplicationName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppName"]
//#define kIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------系统----------------------------


//----------------------内存----------------------------
#pragma mark - 内存
//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil



//----------------------内存----------------------------


//----------------------图片----------------------------
#pragma mark - 图片
//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------



//----------------------颜色类---------------------------
#pragma mark - 颜色
// rgb颜色转换（16进制->10进制）
#define UIColorFromHEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromHEXA(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

#define HEXCOLOR(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define HEXCOLORA(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R green:G blue:B alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//----------------------颜色类--------------------------


//----------------------其他----------------------------
#pragma mark - 其他
//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//定义一个API
#define APIURL                @"http://xxxxx/"
//登陆API
#define APILogin              [APIURL stringByAppendingString:@"Login"]

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
//#define MyLocal(x, ...) NSLocalizedString(x, nil)
#define MyLocal(x, ...) GDLocal(x)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#define foo4random() (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)
//-----------------------其他-------------------------------

//单例化一个类
#pragma mark - 单例化
//获取单例
#define hsGetSharedInstanceClass(cls)  ((cls *)[cls sharedInstance])

//单例定义
#define hsSharedInstanceDefClass(cls)  +(cls *)sharedInstance;
#define hsSharedInstanceDefId  +(id)sharedInstance;

//单例实现
#define hsSharedInstanceImpClass(cls)            \
+(id)sharedInstance                             \
{                                               \
static id ShardInstance;                        \
static dispatch_once_t onceToken;               \
dispatch_once(&onceToken, ^{                    \
ShardInstance=[[cls alloc] init];               \
});                                             \
return ShardInstance;                           \
}                                               \

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

#pragma mark - 快速定义通知
//方便postNotification
#define kPostNotification(name,obj,info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info]
//注册通知
#define kAddObserverNotification(observer,sel,n,obj)  [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel name:n object:obj]
//移除通知
#define kRemoveObserverNotification(observer,n,obj)  [[NSNotificationCenter defaultCenter] removeObserver:observer name:n object:obj];

#endif
