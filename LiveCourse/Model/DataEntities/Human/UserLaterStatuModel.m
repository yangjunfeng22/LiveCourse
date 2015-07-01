#import "UserLaterStatuModel.h"


@interface UserLaterStatuModel ()

// Private interface goes here.

@end


@implementation UserLaterStatuModel
@dynamic categoryID;
@dynamic courseID;
@dynamic lessonUnitID;
@dynamic lessonID;

// Custom logic goes here.

- (void)setCategoryID:(NSString *)categoryID
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    self.ccID = categoryID;
    [context saveToPersistentStoreAndWait];
}

- (void)setCourseID:(NSString *)courseID
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    self.cID = courseID;
    [context saveToPersistentStoreAndWait];
}

- (void)setLessonUnitID:(NSString *)lessonUnitID
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    self.unitID = lessonUnitID;
    [context saveToPersistentStoreAndWait];
}

- (void)setLessonID:(NSString *)lessonID
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    self.lID = lessonID;
    [context saveToPersistentStoreAndWait];
}

@end
