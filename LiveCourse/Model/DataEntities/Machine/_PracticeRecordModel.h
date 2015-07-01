// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PracticeRecordModel.h instead.

#import <CoreData/CoreData.h>

extern const struct PracticeRecordModelAttributes {
	__unsafe_unretained NSString *answer;
	__unsafe_unretained NSString *courseCategoyID;
	__unsafe_unretained NSString *courseID;
	__unsafe_unretained NSString *lessonID;
	__unsafe_unretained NSString *result;
	__unsafe_unretained NSString *rightTimes;
	__unsafe_unretained NSString *timeStamp;
	__unsafe_unretained NSString *topicID;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *wrongTimes;
} PracticeRecordModelAttributes;

@interface PracticeRecordModelID : NSManagedObjectID {}
@end

@interface _PracticeRecordModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PracticeRecordModelID* objectID;

@property (nonatomic, strong) NSString* answer;

//- (BOOL)validateAnswer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseCategoyID;

//- (BOOL)validateCourseCategoyID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseID;

//- (BOOL)validateCourseID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lessonID;

//- (BOOL)validateLessonID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* result;

@property (atomic) int32_t resultValue;
- (int32_t)resultValue;
- (void)setResultValue:(int32_t)value_;

//- (BOOL)validateResult:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* rightTimes;

@property (atomic) int32_t rightTimesValue;
- (int32_t)rightTimesValue;
- (void)setRightTimesValue:(int32_t)value_;

//- (BOOL)validateRightTimes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* timeStamp;

//- (BOOL)validateTimeStamp:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* topicID;

//- (BOOL)validateTopicID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userID;

//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* wrongTimes;

@property (atomic) int32_t wrongTimesValue;
- (int32_t)wrongTimesValue;
- (void)setWrongTimesValue:(int32_t)value_;

//- (BOOL)validateWrongTimes:(id*)value_ error:(NSError**)error_;

@end

@interface _PracticeRecordModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAnswer;
- (void)setPrimitiveAnswer:(NSString*)value;

- (NSString*)primitiveCourseCategoyID;
- (void)setPrimitiveCourseCategoyID:(NSString*)value;

- (NSString*)primitiveCourseID;
- (void)setPrimitiveCourseID:(NSString*)value;

- (NSString*)primitiveLessonID;
- (void)setPrimitiveLessonID:(NSString*)value;

- (NSNumber*)primitiveResult;
- (void)setPrimitiveResult:(NSNumber*)value;

- (int32_t)primitiveResultValue;
- (void)setPrimitiveResultValue:(int32_t)value_;

- (NSNumber*)primitiveRightTimes;
- (void)setPrimitiveRightTimes:(NSNumber*)value;

- (int32_t)primitiveRightTimesValue;
- (void)setPrimitiveRightTimesValue:(int32_t)value_;

- (NSString*)primitiveTimeStamp;
- (void)setPrimitiveTimeStamp:(NSString*)value;

- (NSString*)primitiveTopicID;
- (void)setPrimitiveTopicID:(NSString*)value;

- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;

- (NSNumber*)primitiveWrongTimes;
- (void)setPrimitiveWrongTimes:(NSNumber*)value;

- (int32_t)primitiveWrongTimesValue;
- (void)setPrimitiveWrongTimesValue:(int32_t)value_;

@end
