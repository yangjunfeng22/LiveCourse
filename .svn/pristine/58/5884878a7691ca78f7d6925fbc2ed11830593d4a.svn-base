#import "SentenceModel.h"
#import "SentenceTransModel.h"
#import "SentenceDAL.h"


@interface SentenceModel ()

// Private interface goes here.

@end


@implementation SentenceModel

// Custom logic goes here.


-(NSString *)tChinese{
    SentenceTransModel *sentenceTransModel = [SentenceDAL querySentenceTranslationWithSID:self.sID language:currentLanguage()];
//    NSString *chinese = sentenceTransModel.chinese ? sentenceTransModel.chinese:self.chinese;
    return sentenceTransModel.chinese;
}

@end
