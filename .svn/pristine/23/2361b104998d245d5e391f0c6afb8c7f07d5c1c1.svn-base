#import "WordModel.h"
#import "CheckPointDAL.h"
#import "WordTransModel.h"

#import "Word2SentenceModel.h"
#import "SentenceModel.h"

@interface WordModel ()

// Private interface goes here.

@end


@implementation WordModel

// Custom logic goes here.

- (NSString *)tChinese
{
    
    WordTransModel *wordTrans = [CheckPointDAL queryWordTransWithWordID:self.wID language:currentLanguage()];
    NSString *chinese = wordTrans.chinese ? wordTrans.chinese:self.chinese;
    return chinese;
}

- (NSString *)tProperty
{
    WordTransModel *wordTrans = [CheckPointDAL queryWordTransWithWordID:self.wID language:currentLanguage()];
    NSString *property = wordTrans.property ? wordTrans.property:self.property;
    return property;
}

- (id)tSentence
{
    Word2SentenceModel *w2s = [CheckPointDAL queryWord2SentenceWithWordID:self.wID];
    SentenceModel *sen = [CheckPointDAL querySentenceWithSentenceID:w2s.sID];
    //DLog(@"句子： %@", sen);
    return sen;
}

@end
