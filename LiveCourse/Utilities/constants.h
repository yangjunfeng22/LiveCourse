//
//  constants.h
//  HelloHSK
//
//  Created by yang on 14-2-20.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "customViewTags.h"

#ifndef HelloHSK_constants_h
#define HelloHSK_constants_h

//-------------------下载路径--------------------------
#pragma mark - 存储路径
#ifdef DEBUG
#define kDownloadingPath [kDocumentPath stringByAppendingPathComponent:@"Downloading"]
#define kDownloadedPath [kDocumentPath stringByAppendingPathComponent:@"Downloaded"]
#else

#define kDownloadingPath [kCachePath stringByAppendingPathComponent:@"Downloading"]
#define kDownloadedPath [kCachePath stringByAppendingPathComponent:@"Downloaded"]

#endif

//-------------------下载路径--------------------------


//-------------------关键字----------------------------
#pragma mark - 关键字
static NSString * const kDeviceTokenRegisteredKey = @"DeviceTokenReigstered";
static NSString * const kDeviceTokenStringKey     = @"DeviceToken";
static NSString * const kMD5_KEY                  = @"hansheng";

static NSString * const kMessageAll               = @"all";
static NSString * const kMessageTeacher           = @"teacher";
static NSString * const kMessageSystem            = @"system";
static NSString * const kMessageFriend            = @"friend";
static NSString * const kMessageBBS               = @"bbs";

//-------------------关键字----------------------------


//-------------------字体-----------------------------
#pragma mark - 字体
#define kFontHel(F) [UIFont fontWithName:@"Helvetica" size:F]
#define kFontHelB(F) [UIFont fontWithName:@"Helvetica-Bold" size:F]
#define kFontSys(F) [UIFont systemFontOfSize:F]
#define kFontSysB(F) [UIFont boldSystemFontOfSize:F]
//-------------------字体-----------------------------



//-------------------bbCode-----------------------
#pragma mark - bbCode
static NSString * const kBBCodeUnderline = @"*[u]*[/u]*";
static NSString * const kBBCodeBoldText  = @"*[b]*[/b]*";
//-------------------bbCode-----------------------


#pragma mark - 常量
// 社区发帖的版块ID
#define kCommunityBoardID 18

#define kTableViewRowHeight 44.0f

#define LEFTDISTANCE 22
#define TOPDISTANCE 12

#define CELL_LEFT_FACTOR 9.0
#define CELL_VALUE2_TEXTLABEL_WIDTH 90.0

//-------------------颜色-----------------------
#pragma mark - 颜色

#define kColorClear [UIColor clearColor]
#define kColorWhite COLOR(1, 1, 1, 1)
#define kColorBlack COLOR(0, 0, 0, 1)
#define kColorRed [UIColor redColor]

#define kColorHintGray COLOR(0, 0, 0, 0.8)
#define kColorBoardWithA(a) HEXCOLORA(0xb6b6b6, a)
#define kColorLine  HEXCOLOR(0xf4f4f4)
#define kColorLine2 HEXCOLOR(0xCFD3D0)
#define kColorLine3 HEXCOLOR(0xA3A3A3)
#define kColorWord  HEXCOLOR(0x777777)

#define kColorMainHalf     HEXCOLORA(0x00aee0, 0.5)
#define kColorMainWithA(a) HEXCOLORA(0x00aee0, a)
#define kColorGreen        HEXCOLOR(0x43C55D)

#define kColorGolden        HEXCOLOR(0xfe7522)

#define kColorMain        HEXCOLOR(0x00aee0)
#define kColorDarkOrange  HEXCOLOR(0xff6000)
#define kColorLightOrange HEXCOLOR(0xfe8209)
#define kColorLightRed    HEXCOLOR(0xff5555)
#define kColorLightGreen  HEXCOLOR(0x53d37e)

#define kColorFFBackground HEXCOLOR(0xFFFFFF)
#define kColorFABackground HEXCOLOR(0xFAFAFA)
#define kColorEEBackground HEXCOLOR(0xEEEEEE)
#define kColorDBBackground HEXCOLOR(0xDBDBDB)
#define kColorBDBackground HEXCOLOR(0xBDBDBD)
#define kColor88Background HEXCOLOR(0x888888)
#define kColor20Background HEXCOLOR(0x202020)
#define kColor00Background HEXCOLOR(0x000000)

#define kColorBackgroundD0 RGB(208,208,208)

//乳白色
#define kColorMilkWhite HEXCOLOR(0xf8f9f8)
//-------------------颜色-----------------------

//是否是临时用户
static NSString * const isTempUser                = @"isTempUser";

static NSString * const kUDKEY_UserID             = @"UserID";
static NSString * const kUDKEY_Email              = @"Email";
static NSString * const kUDKEY_CourseCategoryID   = @"CourseCategoryID";

#pragma mark - 其他
#define kSetUDUserID(ID)           ([USER_DEFAULT setObject:ID forKey:kUDKEY_UserID], [USER_DEFAULT synchronize])
#define kSetUDUserEamil(email)     ([USER_DEFAULT setObject:email forKey:kUDKEY_Email], [USER_DEFAULT synchronize])
#define kSetUDTempUser(bool)       ([USER_DEFAULT setBool:bool forKey:isTempUser], [USER_DEFAULT synchronize])
#define kSetUDCourseCategoryID(ID) ([USER_DEFAULT setObject:ID forKey:kUDKEY_CourseCategoryID], [USER_DEFAULT synchronize])

#define kUserID [USER_DEFAULT objectForKey:kUDKEY_UserID]
#define kEmail  [USER_DEFAULT objectForKey:kUDKEY_Email]
//是否是游客登陆
#define kIsTempUser       [USER_DEFAULT boolForKey:isTempUser]
#define kCourseCategoryID [USER_DEFAULT objectForKey:kUDKEY_CourseCategoryID]

#define DEPRECATED(_version) __attribute__((deprecated))

#endif


// 课时状态
typedef NS_ENUM(NSUInteger, LessonLearnedStatus) {
    LessonLearnedStatusLocked = 0,
    LessonLearnedStatusUnLocked,
    LessonLearnedStatusFinished
};

//关卡类型
typedef  NS_ENUM(NSInteger, LiveCourseCheckPointType)
{
    LiveCourseCheckPointTypeWord = 0, //词
    LiveCourseCheckPointTypeSentence = 1,//句子
    LiveCourseCheckPointTypeLesson = 2,//课文
    LiveCourseCheckPointTypeKnowledge = 3,//知识点
    LiveCourseCheckPointTypeTest = 4,//测试
    LiveCourseCheckPointTypeExpandRead = 5,//扩展阅读
};

// 关卡状态
typedef NS_ENUM(NSUInteger, CheckPointLearnedStatus) {
    CheckPointLearnedStatusLocked = 0,
    CheckPointLearnedStatusUnLocked,
    CheckPointLearnedStatusFinished
};

