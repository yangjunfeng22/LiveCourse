#import "CourseModel.h"
#import "CourseTransModel.h"
#import "CourseDAL.h"


@interface CourseModel ()
@property (nonatomic, readwrite, copy) NSString *tName;

// Private interface goes here.

@end


@implementation CourseModel
@dynamic tName;

// Custom logic goes here.

- (NSString *)tName
{
    CourseTransModel *model = [CourseDAL queryCourseTranslationWithCourseID:self.cID language:currentLanguage()];
    NSString *name = model.name ? model.name:self.name;
    return name;
}

@end
