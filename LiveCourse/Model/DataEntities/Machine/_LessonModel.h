// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LessonModel.h instead.

#import <CoreData/CoreData.h>

extern const struct LessonModelAttributes {
	__unsafe_unretained NSString *cID;
	__unsafe_unretained NSString *lID;
	__unsafe_unretained NSString *lessonType;
	__unsafe_unretained NSString *obtain;
	__unsafe_unretained NSString *parentID;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *reward;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *version;
	__unsafe_unretained NSString *weight;
} LessonModelAttributes;

@interface LessonModelID : NSManagedObjectID {}
@end

@interface _LessonModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LessonModelID* objectID;

@property (nonatomic, strong) NSString* cID;

//- (BOOL)validateCID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lID;

//- (BOOL)validateLID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* lessonType;

@property (atomic) int32_t lessonTypeValue;
- (int32_t)lessonTypeValue;
- (void)setLessonTypeValue:(int32_t)value_;

//- (BOOL)validateLessonType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* obtain;

//- (BOOL)validateObtain:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* parentID;

//- (BOOL)validateParentID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* picture;

//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* reward;

@property (atomic) int32_t rewardValue;
- (int32_t)rewardValue;
- (void)setRewardValue:(int32_t)value_;

//- (BOOL)validateReward:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* status;

@property (atomic) int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* version;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* weight;

@property (atomic) float weightValue;
- (float)weightValue;
- (void)setWeightValue:(float)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;

@end

@interface _LessonModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCID;
- (void)setPrimitiveCID:(NSString*)value;

- (NSString*)primitiveLID;
- (void)setPrimitiveLID:(NSString*)value;

- (NSNumber*)primitiveLessonType;
- (void)setPrimitiveLessonType:(NSNumber*)value;

- (int32_t)primitiveLessonTypeValue;
- (void)setPrimitiveLessonTypeValue:(int32_t)value_;

- (NSString*)primitiveObtain;
- (void)setPrimitiveObtain:(NSString*)value;

- (NSString*)primitiveParentID;
- (void)setPrimitiveParentID:(NSString*)value;

- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;

- (NSNumber*)primitiveReward;
- (void)setPrimitiveReward:(NSNumber*)value;

- (int32_t)primitiveRewardValue;
- (void)setPrimitiveRewardValue:(int32_t)value_;

- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSString*)primitiveVersion;
- (void)setPrimitiveVersion:(NSString*)value;

- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (float)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(float)value_;

@end
