#import "UserModel.h"


@interface UserModel ()

// Private interface goes here.

@end


@implementation UserModel
@synthesize isLogined = _isLogined;
@dynamic userCoin;
@dynamic vipEndTime;
@dynamic userRole;

- (void)setIsLogined:(BOOL)isLogined
{
    _isLogined = isLogined;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    self.loginedValue = isLogined;
    [localContext saveToPersistentStoreAndWait];
}

- (BOOL)isLogined
{
    return self.loginedValue;
}


-(void)setUserCoin:(NSInteger)aUserCoin{
    [NSManagedObjectContext clearContextForCurrentThread];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    self.coinValue = (int32_t)aUserCoin;
    [context saveToPersistentStoreAndWait];
}

- (void)setVipEndTime:(NSUInteger)vipEndTime
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    self.roleEndDateValue = vipEndTime;
    [context saveToPersistentStoreAndWait];
}

- (void)setUserRole:(NSString *)userRole
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    self.role = userRole;
    [context saveToPersistentStoreAndWait];
}

// Custom logic goes here.

@end
