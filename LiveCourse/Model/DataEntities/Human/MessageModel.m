#import "MessageModel.h"


@interface MessageModel ()

// Private interface goes here.

@end


@implementation MessageModel

// Custom logic goes here.
@dynamic isReaded;
@dynamic isDeleted;

// Custom logic goes here.

- (void)setIsReaded:(BOOL)aReaded
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    self.readedValue = aReaded;
    [localContext saveToPersistentStoreAndWait];
}

- (BOOL)isReaded
{
    return self.readedValue;
}

- (void)setIsDeleted:(BOOL)aDeleted
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    self.statusValue = aDeleted;
    [localContext saveToPersistentStoreAndWait];
}

- (BOOL)isDeleted
{
    return self.statusValue;
}

- (BOOL)isLink
{
    BOOL aLink = ![[self.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
    return aLink;
}

@end
