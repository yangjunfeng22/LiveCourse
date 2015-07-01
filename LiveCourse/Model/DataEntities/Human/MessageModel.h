#import "_MessageModel.h"

@interface MessageModel : _MessageModel {}
// Custom logic goes here.
@property (nonatomic) BOOL isReaded;
@property (nonatomic) BOOL isDeleted;

- (BOOL)isLink;
@end
