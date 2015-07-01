//
//  CheckPointDAL.h
//  HSWordsPass
//
//  Created by yang on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckPointModel;
@class CheckPointProgressModel;

@interface CheckPointDAL : NSObject
#pragma mark - 组装请求的参数列表

#pragma mark -
+ (NSString *)getCheckPointRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID lessonID:(NSString *)lID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getCheckPointRelationRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getCheckPointTranslationRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getCheckPointProgressRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID lessonID:(NSString *)lID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID version:(NSString *)version;

+ (NSString *)getCheckPointVersionRequestURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID productID:(NSString *)productID;

+ (NSString *)getDownloadCheckPointDataURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID address:(NSString *)address productID:(NSString *)productID version:(NSString *)version;

#pragma mark - 解析数据

#pragma mark -
/**
 *  解关卡的数据
 *
 *  @param resultData 网络请求的结果：json格式的数据
 *  @param completion 结束后的block回调
 */
+ (void)parseCheckPointByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;
/**
 *  解关卡关系的数据
 *
 *  @param resultData <#resultData description#>
 *  @param cpID       <#cpID description#>
 *  @param completion <#completion description#>
 */
+ (void)parseCheckPointReplationByData:(id)resultData checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion;
/**
 *  解关卡进度的数据
 *
 *  @param resultData 网络请求的结果：json格式的数据
 *  @param completion 回调
 */
+ (void)parseCheckPointProgressByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  解关卡版本数据
 *
 *  @param resultData 返回数据
 *  @param completion 回调
 */
+ (void)parseCheckPointVersionByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  解析关卡词列表下载所需的链接
 *
 *  @param resultData 下载的链接地址
 *  @param completion block回调
 */
+ (void)parseCheckPointDownloadByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;


#pragma mark - 保存数据
+ (void)saveCheckPointProgressWithUserID:(NSString *)uID CheckPointID:(NSString *)cpID lessonID:(NSString *)lID version:(NSString *)version progress:(CGFloat)progress status:(NSInteger)status completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  保存对应关系
 *
 *  @param coID           <#coID description#>
 *  @param cpID           <#cpID description#>
 *  @param gID            <#gID description#>
 *  @param checkPointType <#checkPointType description#>
 */
+(void)saveCheckPoint2ContentWithCoID:(NSString *)coID Cpid:(NSString *)cpID gID:(NSString *)gID checkPointType:(LiveCourseCheckPointType)checkPointType weight:(CGFloat)weight;

#pragma mark - 删除数据
/**
 *  <#Description#>
 *
 *  @param bID <#bID description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)deleteAllCheckPointWithLessonID:(NSString *)lID;

/**
 *  删除所有的关卡数据
 *
 *  @return 删除是否成功
 */
+ (BOOL)deleteAllCheckPoint;
+ (BOOL)deleteAllCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID;

+ (BOOL)deleteAllCheckPointProgress;

/**
 *  删除对应关系
 *
 *  @param coID <#coID description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)deleteCheckPoint2ContentWithCpID:(NSString *)cpID;

#pragma mark 查询数据
/**
 *  查询指定Book下面的所有的关卡
 *
 *  @param bID book的ID
 *
 *  @return 返回所有的值
 */
+ (NSArray *)queryCheckPointsWithLessonID:(NSString *)lID;

/**
 *  返回指定的关卡，功能之一是提供一个关卡的名字
 *
 *  @param bID  所属的book的ID
 *  @param cpID 关卡本身的ID
 *
 *  @return 返回该指定的关卡
 */
+ (CheckPointModel *)queryCheckPointWithLessonID:(NSString *)lID checkPointID:(NSString *)cpID;

/**
 *  关卡翻译的数据
 *
 *  @param cpID     <#cpID description#>
 *  @param language <#language description#>
 *
 *  @return <#return value description#>
 */
+ (id)queryCheckPointTranslationWithCheckPointID:(NSString *)cpID language:(NSString *)language;

/**
 *  查询下一关的信息
 *
 *  @param lID   <#lID description#>
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
+ (CheckPointModel *)queryNextCheckPointWithLessonID:(NSString *)lID index:(NSInteger)index;

+ (CheckPointModel *)queryCheckPointWithLessonID:(NSString *)lID index:(NSInteger)index;

/**
 *  提供指定book的所有关卡的数量
 *
 *  @param bID book的ID
 *
 *  @return 数量
 */
+ (NSInteger)checkPointCountWithLessonID:(NSString *)lID;


/**
 *  获取单个关卡的进度信息
 *   -- 每个关卡加载的时候根据本身所携带的用户ID、书本ID和关卡ID来加载当前关卡的信息。
 *
 *  @param uID  用户ID
 *  @param bID  书本ID
 *  @param cpID 关卡ID
 *
 *  @return 关卡进度信息
 */
+ (CheckPointProgressModel *)queryCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID checkPointID:(NSString *)cpID;
/**
 *  获取单个关卡的进度信息
 *   -- 每个关卡加载的时候根据本身所携带的用户ID和关卡ID来加载当前关卡的信息。
 *
 *
 *  @param uID  用户ID
 *  @param cpID 关卡ID
 *
 *  @return 单个的关卡信息。
 */
//+ (CheckPointProgressModel *)queryCheckPointProgressWithUserID:(NSString *)uID checkPointID:(NSString *)cpID;


+ (NSInteger)countOfCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID;


/**
 *  查询指定课程的所有关卡的进度信息
 *
 *  @param uID 用户ID
 *  @param lID 课程ID
 *
 *  @return 所有关卡的进度
 */
+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID;

/**
 *  查询指定课程下的指定状态的关卡进度信息
 *
 *  @param uID   用户ID
 *  @param lID   课程ID
 *  @param statu 状态
 *
 *  @return 关卡进度信息。
 */
+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID lessonID:(NSString *)lID statu:(CheckPointLearnedStatus)statu;

/**
 *  已完成的关卡的数量
 *
 *  @param uID   用户ID
 *  @param lID   课程ID
 *  @param statu 状态
 *
 *  @return 数量
 */
+ (NSInteger)queryAllCheckPointProgressCountWithUserID:(NSString *)uID lessonID:(NSString *)lID statu:(CheckPointLearnedStatus)statu;
/**
 *  获取该用户下面所有的关卡的进度信息
 *
 *  @param uID 用户ID
 *
 *  @return 返回的信息
 */
+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID;

/**
 *  查询关卡下得内容ID
 *
 *  @param cpID           <#cpID description#>
 *  @param gID            <#gID description#>
 *  @param checkPointType <#checkPointType description#>
 *
 *  @return <#return value description#>
 */
+(NSArray *)queryConIDWIthCpID:(NSString *)cpID gID:(NSString *)gID checkPointType:(LiveCourseCheckPointType)checkPointType;


/**
 *  获取关卡与内容之间关系列表
 *
 *  @param cpID 关卡ID
 *
 *  @return 列表
 */

+ (id)queryCheckPoint2ContentDataWithCheckPointID:(NSString *)cpID;
/**
 *  获取关卡与内容对应关系的数量
 *   -- 用来判断是否有数据
 *
 *  @param cpID 关卡ID
 *
 *  @return 数量
 */
+ (NSInteger)queryCheckPoint2ContentCountWithCheckPointID:(NSString *)cpID;

/**
 *  获取关卡内容的数量
 *
 *  @param arrRelation 关系数组
 *  @param type        关卡类型
 *
 *  @return 数量
 */
+ (NSInteger)queryCheckPointContentCountWithCheckPointRelation:(NSArray *)arrRelation checkPintType:(LiveCourseCheckPointType)type;


/**
 *  根据关卡ID和关卡种类获取关卡内容数据列表
 *
 *  @param cpID 关卡ID
 *  @param type 关卡种类
 *
 *  @return 列表
 */
+ (id)queryCheckPointContentDataListWithCheckPointID:(NSString *)cpID checkPointType:(LiveCourseCheckPointType)type;



+ (id)aggregateCheckPoint2ContentDataWithCheckPointID:(NSString *)cpID;

+ (NSInteger)countOfCheckPoint2ContentDataWithCheckPointID:(NSString *)cpID;


@end

#pragma mark - Word
@interface CheckPointDAL (Word)

#pragma mark - 组装请求的参数列表
+ (NSString *)getCheckPointContentURLParamsWithApKey:(NSString *)apKey userID:(NSString *)uID checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID;

#pragma mark - 解析数据
+ (void)parseCheckPointContentWordByData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

#pragma mark - 查询数据
+ (id)queryWordWithWordID:(NSString *)wID;
+ (id)queryWordTransWithWordID:(NSString *)wID language:(NSString *)language;
+ (id)queryWord2SentenceWithWordID:(NSString *)wID;

@end

#pragma mark - Sentence
@interface CheckPointDAL (Sentence)

#pragma mark - 组装请求的参数列表


#pragma mark - 解析数据

+ (void)parseCheckPointContentSentenceByData:(id)resultData completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

#pragma mark - 保存数据
+ (void)saveSentenceWithSID:(NSString *)sID groupID:(NSString *)gID chinese:(NSString *)chinese picture:(NSString *)picture pinyin:(NSString *)pinyin audio:(NSString *)audio weight:(float)weight mode:(NSInteger)mode tChinese:(NSString *)qChinese tPinyin:(NSString *)qPinyin completion:(void (^)(BOOL, id, NSError *))completion;
+(void)saveSentenceTransWithSID:(NSString *)sID language:(NSString *)language chinese:(NSString *)chinese completion:(void (^)(BOOL, id, NSError *))completion;

#pragma mark - 查询数据
+ (id)querySentenceWithSentenceID:(NSString *)sID;
+ (id)querySentenceTransWithSentenceID:(NSString *)sID language:(NSString *)language;

@end

#pragma mark - Text
@interface CheckPointDAL (Text)

#pragma mark - 组装请求的参数列表


#pragma mark - 解析数据
+(void)parseLessonTextByCpID:(NSString *)cpID Data:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

#pragma mark - 保存数据


#pragma mark - 查询数据
+ (id)queryLessonTextWithTextID:(NSString *)tID;
+ (id)queryLessonTextTranslationWithTextID:(NSString *)tID language:(NSString *)language;
+ (id)queryLessonTextWithCheckPointID:(NSString *)cpID;

@end

#pragma mark - Knowledge
@interface CheckPointDAL (Knowledge)

#pragma mark - 组装请求的参数列表


#pragma mark - 解析数据
+ (void)parseKnowledgeByData:(id)resultData cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion;;

#pragma mark - 保存数据

#pragma mark - 删除数据

#pragma mark 删除知识点语法描述对应关系
+(BOOL)deleteKnowledge2GrammarWithKID:(NSString *)kID;
#pragma mark 删除知识点例句对应关系
+(BOOL)deleteKnowledge2SentenceWithKID:(NSString *)kID;
#pragma mark 删除语法例句对应关系
+(BOOL)deleGrammar2SentenceWithGID:(NSString *)gID;

#pragma mark - 查询数据
/**
 *  查询知识点数据
 *
 *  @param cpID <#tID description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)queryKnowledgeDataWithcpID:(NSString *)cpID;

+(id)queryKnowledgeDataWithKID:(NSString *)kID;
/**
 *  查询翻译
 *
 *  @param kID      知识点ID
 *  @param language <#language description#>
 *
 *  @return <#return value description#>
 */
+ (id)queryKnowledgeTranslationWithKID:(NSString *)kID language:(NSString *)language;


/**
 *  查询没有语法描述的例句
 *
 *  @param kID <#kID description#>
 *
 *  @return <#return value description#>
 */
+(NSArray *)querySentenceNoGrammarWithKID:(NSString *)kID;


/**
 *  查询有语法描述的例句
 *
 *  @param kID <#kID description#>
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)querySentenceHasGrammarWithKID:(NSString *)kID;

@end

#pragma mark - Exam
@interface CheckPointDAL (Exam)

+ (NSString *)getPracticeRecordURLParamsWithApKey:(NSString *)apKey userID:(NSString *)userID record:(NSString *)record language:(NSString *)language productID:(NSString *)productID;
#pragma mark - 解析数据
+ (void)parseFinalTestByData:(id)resultData cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion;

+ (void)parsePracticeRecordByData:(id)data completion:(void (^)(BOOL finished, id data, NSError *error))completion;

#pragma mark - 保存数据
+ (void)savePracticeRecordWithUserID:(NSString *)userID courseCategoryID:(NSString *)courseCategoryID courseID:(NSString *)courseID lessonID:(NSString *)lessonID topicID:(NSString *)topicID rightTimes:(NSInteger)rightTimes wrongTimes:(NSInteger)wrongTimes result:(NSInteger)result answer:(NSString *)answer completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

#pragma mark - 删除数据
/**
 *  删除关卡下面的所有数据
 *
 *  @param cpID 关卡ID
 */
+ (void)deleteSonDataWithCpID:(NSString *)cpID;

#pragma mark - 查询数据

+(id)queryExamDataWithEID:(NSString *)eID;
+(id)queryExamTranslationWithEID:(NSString *)eID language:(NSString *)language;
/**
 *  查询测试题数据
 *
 *  @param cpID 关卡id
 *
 *  @return 测试题
 */
+(NSArray *)queryFinalTestDataWithcpID:(NSString *)cpID;


/**
 *  查询子题
 *
 *  @param parentID 父id
 *
 *  @return
 */
+(NSArray *)queryFinalTestSonDataWithParentID:(NSString *)parentID;

/**
 *  查询指定用户所有的做题记录
 *
 *  @param userID 用户ID
 *
 *  @return
 */
+ (NSArray *)queryPracticeRecordsWithUserID:(NSString *)userID;

/**
 *  查询单条记录
 *
 *  @param userID           用户ID
 *  @param courseCategoryID 课程种类ID
 *  @param courseID         课程ID
 *  @param lessonID         课时ID
 *  @param topicID          题型ID
 *
 *  @return
 */
+ (id)queryPracticeRecordWithUserID:(NSString *)userID courseCategoryID:(NSString *)courseCategoryID courseID:(NSString *)courseID lessonID:(NSString *)lessonID topicID:(NSString *)topicID;

@end
