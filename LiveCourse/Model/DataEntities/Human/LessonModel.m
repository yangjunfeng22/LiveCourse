#import "LessonModel.h"
#import "LessonTransModel.h"
#import "CourseDAL.h"

@interface LessonModel ()

// Private interface goes here.
@property (nonatomic, readwrite, copy) NSString *tTitle;
@property (nonatomic, readwrite, copy) NSString *tObtain;

@end


@implementation LessonModel
@dynamic tTitle;
@dynamic tObtain;
// Custom logic goes here.

- (NSString *)tTitle
{
    LessonTransModel *model = [CourseDAL queryLessonTranslationWithLessonID:self.lID language:currentLanguage()];
    NSString *title = model.title ? model.title : self.title;
    return title;
}

- (NSString *)tObtain
{
    LessonTransModel *model = [CourseDAL queryLessonTranslationWithLessonID:self.lID language:currentLanguage()];
    NSString *obtain = model.obtain ? model.obtain:self.obtain;
    return obtain;
}

@end
