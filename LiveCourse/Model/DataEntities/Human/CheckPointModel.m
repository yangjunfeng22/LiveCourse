#import "CheckPointModel.h"
#import "CheckPointTransModel.h"
#import "CheckPointDAL.h"

@interface CheckPointModel ()
@property (nonatomic, readwrite, copy) NSString *tName;

// Private interface goes here.

@end


@implementation CheckPointModel
@dynamic tName;

- (NSString *)nexCpID
{
    CheckPointModel *checkPoint = [CheckPointDAL queryNextCheckPointWithLessonID:self.lID index:self.indexValue];
    return checkPoint.cpID;
}

- (NSString *)tName
{
    CheckPointTransModel *model = [CheckPointDAL queryCheckPointTranslationWithCheckPointID:self.cpID language:currentLanguage()];
    NSString *name = model.name ? model.name:self.name;
    return name;
}

@end
