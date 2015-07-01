//
//  APIDefinition.h
//  LiveCourse
//
//  Created by junfengyang on 15/1/5.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#ifndef LiveCourse_APIDefinition_h
#define LiveCourse_APIDefinition_h

#pragma mark - API

#ifdef DEBUG
static NSString * const kLifeHostUrl = @"http://api.hellohsk.com/life_test/";
static NSString * const kHostUrl     = @"http://test.hschinese.com/app/api/";
static NSString * const kHpnsUrl     = @"http://api.hellohsk.com/hpns/";

#else

static NSString * const kLifeHostUrl = @"http://api.hellohsk.com/life/";
static NSString * const kHostUrl     = @"http://www.hschinese.com/app/api/";
static NSString * const kHpnsUrl     = @"http://api.hellohsk.com/hpns/";

#endif

// api的版本。
static NSInteger const kAPIVersion = 3;

//------------>登录注册相关<------------------
static NSString * const kLoginMethod             = @"user/login";
static NSString * const kRegistMethod            = @"user/register";
static NSString * const kVipList                 = @"vip/list";
static NSString * const kVipBuy                  = @"vip/buy";
static NSString * const kTextContent             = @"text/content";

//----------->课程相关<----------------------
static NSString * const kCourseList              = @"course/list";
static NSString * const kLessonList              = @"lesson/list";
static NSString * const kLessonProgress          = @"lesson/progress";
static NSString * const kLessonText              = @"lesson/text";
static NSString * const kKnowledge               = @"knowledge/list";

//----------->关卡相关<----------------------
static NSString * const kCheckPointList          = @"checkpoint/list";
static NSString * const kCheckPointProgress      = @"checkpoint/progress";
static NSString * const kCheckPointVersion       = @"checkpoint/version";
// 关卡与内容之间的关系。
static NSString * const kCheckPointRelation      = @"checkpoint/relation";
// 关卡的词汇数据
static NSString * const kCheckPointWord          = @"checkpoint/word";
// 关卡的句子数据
static NSString * const kCheckPointSentence      = @"checkpoint/sentences";
// 关卡的课文数据
static NSString * const kCheckPointLesson        = @"checkpoint/lesson";
// 关卡的知识点数据
static NSString * const kCheckPointKnowledge     = @"checkpoint/knowledge";
// 关卡的测试题
static NSString * const kCheckPointExam          = @"checkpoint/exercise";

static NSString * const kDownloadFile            = @"file/checkpoint/address";

static NSString * const kTempUserLoginMethod     = @"user/anonymity/create";
static NSString * const kThirdLoginMethod        = @"user/thirdLogin";

static NSString * const kThirdRegistMethod       = @"user/anonymity/thirdRegister";
static NSString * const kTempUserRegistMethod    = @"user/anonymity/register";
static NSString * const kFindPassword            = @"user/passwordBack";
static NSString * const kUserInfo                = @"user/info";

static NSString * const kUpdateApp               = @"version/check";
static NSString * const KAppRecommend            = @"product/list";
static NSString * const kHSCoinsIntro            = @"task/intro";

//----------->知识点相关<--------------------
static NSString * const kKnowledgeList           = @"knowledge/list";

static NSString * const kMessageList             = @"message/list";
static NSString * const kMessageCount            = @"message/count";
static NSString * const kMessageContent           = @"message/content";
static NSString * const kMessageUpdate           = @"message/update";

static NSString * const kNotificationToken       = @"notification/token";
static NSString * const kNotificationBadge       = @"notification/badge";
static NSString * const kEverydayTaskNet         = @"task/list";
static NSString * const kEverydayDoTaskNet       = @"task/do";
static NSString * const kInAppPurchaseNet        = @"pay/product";
static NSString * const kInAppPurchaseOrderNet   = @"pay/order/create";
static NSString * const kInAppPurchaseSuccessNet = @"pay/order/update";


//信鸽apns。
static NSString * const hpnsRegister             = @"device/register";


// ------------>社区<------------
// 帖子列表
static NSString * const kCommunityList           = @"bbs/list";
// 帖子详情
static NSString * const kCommunityDetail         = @"bbs/detail";
// 回复帖子
static NSString * const kCommunityReply          = @"bbs/reply";
// 更多回复
static NSString * const kCommunityMoreReply      = @"bbs/moreReply";
// 赞/取消赞
static NSString * const kCommunityLaud           = @"bbs/like";
// 发帖
static NSString * const kCommunityPost           = @"bbs/post";
//板块
static NSString * const kCommunityPlatePost      = @"bbs/category";

static NSString * const kPracticeRecord          = @"practice/record";

#endif
