//
//  SentenceDAL.h
//  LiveCourse
//
//  Created by Lu on 15/2/2.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SentenceTransModel.h"

@interface SentenceDAL : NSObject


/**
 *  保存例句
 *
 *  @param sID     例句ID
 *  @param chinese <#chinese description#>
 *  @param picture <#picture description#>
 *  @param pinyin  <#pinyin description#>
 *  @param audio   <#audio description#>
 *  @param weight  <#weight description#>
 */
+(void)saveSentenceWithSID:(NSString *)sID chinese:(NSString *)chinese picture:(NSString *)picture pinyin:(NSString *)pinyin audio:(NSString *)audio weight:(float)weight;

+ (void)saveSentenceWithSID:(NSString *)sID groupID:(NSString *)gID chinese:(NSString *)chinese picture:(NSString *)picture pinyin:(NSString *)pinyin audio:(NSString *)audio weight:(float)weight completion:(void (^)(BOOL, id, NSError *))completion;


/**
 *  保存例句翻译
 *
 *  @param sID      <#sID description#>
 *  @param language <#language description#>
 *  @param chinese  <#chinese description#>
 */
+(void)saveSentenceTransWithSID:(NSString *)sID language:(NSString *)language chinese:(NSString *)chinese;



/**
 *  根据sid查询例句数据
 *
 *  @param sID <#sID description#>
 *
 *  @return <#return value description#>
 */
+(NSArray *)querySentenceListWithSID:(NSString *)sID;



/**
 *  查询例句翻译
 *
 *  @param sID      <#sID description#>
 *  @param language <#language description#>
 *
 *  @return <#return value description#>
 */
+ (SentenceTransModel *)querySentenceTranslationWithSID:(NSString *)sID language:(NSString *)language;


@end
