#import "ExamModel.h"
#import "ExamTransModel.h"
#import "CheckPointDAL.h"

@interface ExamModel ()
@property (nonatomic, readwrite, copy) NSString *tTypeAlias;
// Private interface goes here.

@end


@implementation ExamModel
@dynamic tTypeAlias;

- (NSString *)tTypeAlias
{
    ExamTransModel *trans = [CheckPointDAL queryExamTranslationWithEID:self.eID language:currentLanguage()];
    NSString *typeAlias = trans.typeAlias ? trans.typeAlias:self.typeAlias;
    return typeAlias;
}
// Custom logic goes here.

@end
