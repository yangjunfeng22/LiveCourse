//
//  SentenceDAL.m
//  LiveCourse
//
//  Created by Lu on 15/2/2.
//  Copyright (c) 2015年 junfengyang. All rights reserved.
//

#import "SentenceDAL.h"
#import "SentenceModel.h"
#import "SentenceTransModel.h"

@implementation SentenceDAL


//保存例句
+(void)saveSentenceWithSID:(NSString *)sID chinese:(NSString *)chinese picture:(NSString *)picture pinyin:(NSString *)pinyin audio:(NSString *)audio weight:(float)weight
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
        SentenceModel *sentenceModel = (SentenceModel *)[SentenceModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [sentenceModel.sID isEqualToString:sID];
        
        SentenceModel *tSentenceModel = needUpdate ? [sentenceModel inContext:localContext] : [SentenceModel createEntityInContext:localContext];
        
        sID ? tSentenceModel.sID = sID:sID;
        chinese ? tSentenceModel.chinese = chinese : chinese;
        picture ? tSentenceModel.picture = picture:picture;
        pinyin ? tSentenceModel.pinyin = pinyin:pinyin;
        audio ? tSentenceModel.audio = audio:audio;
        tSentenceModel.weightValue = weight;
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
}

+ (void)saveSentenceWithSID:(NSString *)sID groupID:(NSString *)gID chinese:(NSString *)chinese picture:(NSString *)picture pinyin:(NSString *)pinyin audio:(NSString *)audio weight:(float)weight completion:(void (^)(BOOL, id, NSError *))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
        SentenceModel *sentenceModel = (SentenceModel *)[SentenceModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [sentenceModel.sID isEqualToString:sID];
        
        SentenceModel *tSentenceModel = needUpdate ? [sentenceModel inContext:localContext] : [SentenceModel createEntityInContext:localContext];
        
        sID ? tSentenceModel.sID = sID:sID;
        gID ? tSentenceModel.gID = gID:gID;
        chinese ? tSentenceModel.chinese = chinese : chinese;
        picture ? tSentenceModel.picture = picture:picture;
        pinyin ? tSentenceModel.pinyin = pinyin:pinyin;
        audio ? tSentenceModel.audio = audio:audio;
        tSentenceModel.weightValue = weight;
        
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+(void)saveSentenceTransWithSID:(NSString *)sID language:(NSString *)language chinese:(NSString *)chinese
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@ AND language == %@ ", sID,language];
        SentenceTransModel *sentenceTransModel = (SentenceTransModel *)[SentenceTransModel findFirstWithPredicate:predicate inContext:localContext];
        
        BOOL needUpdate = [sentenceTransModel.sID isEqualToString:sID];
        
        SentenceTransModel *tSentenceTransModel = needUpdate ? [sentenceTransModel inContext:localContext] : [SentenceTransModel createEntityInContext:localContext];
        sID ? tSentenceTransModel.sID = sID:sID;
        language ? tSentenceTransModel.language = language : language;
        ![NSString isNullString:chinese] ? tSentenceTransModel.chinese = chinese:chinese;
        
    }completion:^(BOOL success, NSError *error) {
        
    }];
}

+(NSArray *)querySentenceListWithSID:(NSString *)sID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
    
    NSArray *list = [SentenceModel findAllSortedBy:@"weight" ascending:YES withPredicate:predicate inContext:context];
    return list;
}

+(SentenceTransModel *)querySentenceTranslationWithSID:(NSString *)sID language:(NSString *)language{
    
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@ AND language == %@", sID, language];
    SentenceTransModel *sentenceTran = (SentenceTransModel *)[SentenceTransModel findFirstWithPredicate:predicate inContext:context];
    return sentenceTran;
}

@end
