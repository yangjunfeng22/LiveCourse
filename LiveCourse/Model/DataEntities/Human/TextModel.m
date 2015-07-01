#import "TextModel.h"
#import "TextTransModel.h"
#import "CheckPointDAL.h"

@interface TextModel ()

// Private interface goes here.

@property (nonatomic, readwrite, copy) NSString *tBackground;
@property (nonatomic, readwrite, copy) NSString *tChinese;

@end


@implementation TextModel
@dynamic tBackground;
@dynamic tChinese;

// Custom logic goes here.

- (NSString *)tBackground
{
    TextTransModel *text = [CheckPointDAL queryLessonTextTranslationWithTextID:self.tID language:currentLanguage()];
    NSString *back = text.background ? text.background : self.background;
    return back;
}


-(NSString *)tChinese
{
    TextTransModel *text = [CheckPointDAL queryLessonTextTranslationWithTextID:self.tID language:currentLanguage()];
//    NSString *back = text.chinese ? text.chinese : self.background;
    return text.chinese;
}


@end
