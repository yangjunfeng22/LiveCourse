#import "KnowledgeModel.h"
#import "KnowledgeTransModel.h"
#import "CheckPointDAL.h"
#import "AppDelegate.h"


@interface KnowledgeModel ()

// Private interface goes here.

@end


@implementation KnowledgeModel

// Custom logic goes here.

-(NSString *)tExplain{
    
    KnowledgeTransModel *knowledgeTransModel = [CheckPointDAL queryKnowledgeTranslationWithKID:self.kID language:currentLanguage()];
    NSString *explain = knowledgeTransModel.explain ? knowledgeTransModel.explain:self.explain;
    return explain;
}

-(NSString *)tQuote{
    
    KnowledgeTransModel *knowledgeTransModel = [CheckPointDAL queryKnowledgeTranslationWithKID:self.kID language:currentLanguage()];
    NSString *quote = knowledgeTransModel.quote ? knowledgeTransModel.quote : self.quote;
    return quote;
}

@end
