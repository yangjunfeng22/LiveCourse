// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CommunityModel.h instead.

#import <CoreData/CoreData.h>

extern const struct CommunityModelAttributes {
	__unsafe_unretained NSString *audio;
	__unsafe_unretained NSString *boardID;
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *liked;
	__unsafe_unretained NSString *owner;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *posted;
	__unsafe_unretained NSString *replied;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *summary;
	__unsafe_unretained NSString *tag;
	__unsafe_unretained NSString *tagName;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *topicID;
	__unsafe_unretained NSString *userID;
} CommunityModelAttributes;

@interface CommunityModelID : NSManagedObjectID {}
@end

@interface _CommunityModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CommunityModelID* objectID;

@property (nonatomic, strong) NSString* audio;

//- (BOOL)validateAudio:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* boardID;

//- (BOOL)validateBoardID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* duration;

@property (atomic) int32_t durationValue;
- (int32_t)durationValue;
- (void)setDurationValue:(int32_t)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* liked;

@property (atomic) int32_t likedValue;
- (int32_t)likedValue;
- (void)setLikedValue:(int32_t)value_;

//- (BOOL)validateLiked:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* owner;

//- (BOOL)validateOwner:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* picture;

//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* posted;

@property (atomic) int32_t postedValue;
- (int32_t)postedValue;
- (void)setPostedValue:(int32_t)value_;

//- (BOOL)validatePosted:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* replied;

@property (atomic) int32_t repliedValue;
- (int32_t)repliedValue;
- (void)setRepliedValue:(int32_t)value_;

//- (BOOL)validateReplied:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* status;

@property (atomic) int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* summary;

//- (BOOL)validateSummary:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* tag;

//- (BOOL)validateTag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* tagName;

//- (BOOL)validateTagName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* topicID;

//- (BOOL)validateTopicID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userID;

//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;

@end

@interface _CommunityModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAudio;
- (void)setPrimitiveAudio:(NSString*)value;

- (NSString*)primitiveBoardID;
- (void)setPrimitiveBoardID:(NSString*)value;

- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (int32_t)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(int32_t)value_;

- (NSNumber*)primitiveLiked;
- (void)setPrimitiveLiked:(NSNumber*)value;

- (int32_t)primitiveLikedValue;
- (void)setPrimitiveLikedValue:(int32_t)value_;

- (NSString*)primitiveOwner;
- (void)setPrimitiveOwner:(NSString*)value;

- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;

- (NSNumber*)primitivePosted;
- (void)setPrimitivePosted:(NSNumber*)value;

- (int32_t)primitivePostedValue;
- (void)setPrimitivePostedValue:(int32_t)value_;

- (NSNumber*)primitiveReplied;
- (void)setPrimitiveReplied:(NSNumber*)value;

- (int32_t)primitiveRepliedValue;
- (void)setPrimitiveRepliedValue:(int32_t)value_;

- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;

- (NSString*)primitiveSummary;
- (void)setPrimitiveSummary:(NSString*)value;

- (NSString*)primitiveTag;
- (void)setPrimitiveTag:(NSString*)value;

- (NSString*)primitiveTagName;
- (void)setPrimitiveTagName:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSString*)primitiveTopicID;
- (void)setPrimitiveTopicID:(NSString*)value;

- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;

@end
