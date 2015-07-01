#import "LessonProgressModel.h"


@interface LessonProgressModel ()

// Private interface goes here.

@end


@implementation LessonProgressModel
@dynamic obtainStars;
@dynamic totalStars;

// Custom logic goes here.

- (void)setObtainStars:(NSInteger)obtainStars
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    self.curStarsValue = (int32_t)obtainStars;
    [localContext saveToPersistentStoreAndWait];
}

- (void)setTotalStars:(NSInteger)totalStars
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    self.allStarsValue = (int32_t)totalStars;
    [localContext saveToPersistentStoreAndWait];
}

@end
