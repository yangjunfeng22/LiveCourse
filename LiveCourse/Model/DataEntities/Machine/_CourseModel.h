// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CourseModel.h instead.

#import <CoreData/CoreData.h>

extern const struct CourseModelAttributes {
	__unsafe_unretained NSString *cID;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *parentID;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *version;
	__unsafe_unretained NSString *weight;
} CourseModelAttributes;

@interface CourseModelID : NSManagedObjectID {}
@end

@interface _CourseModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CourseModelID* objectID;

@property (nonatomic, strong) NSString* cID;

//- (BOOL)validateCID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* parentID;

//- (BOOL)validateParentID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* picture;

//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* status;

@property (atomic) int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* version;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* weight;

@property (atomic) float weightValue;
- (float)weightValue;
- (void)setWeightValue:(float)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;

@end

@interface _CourseModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCID;
- (void)setPrimitiveCID:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveParentID;
- (void)setPrimitiveParentID:(NSString*)value;

- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;

- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;

- (NSString*)primitiveVersion;
- (void)setPrimitiveVersion:(NSString*)value;

- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (float)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(float)value_;

@end
