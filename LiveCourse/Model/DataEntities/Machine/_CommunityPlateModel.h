// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CommunityPlateModel.h instead.

#import <CoreData/CoreData.h>

extern const struct CommunityPlateModelAttributes {
	__unsafe_unretained NSString *boardID;
	__unsafe_unretained NSString *icon;
	__unsafe_unretained NSString *quantity;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *weight;
} CommunityPlateModelAttributes;

@interface CommunityPlateModelID : NSManagedObjectID {}
@end

@interface _CommunityPlateModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CommunityPlateModelID* objectID;

@property (nonatomic, strong) NSNumber* boardID;

@property (atomic) int32_t boardIDValue;
- (int32_t)boardIDValue;
- (void)setBoardIDValue:(int32_t)value_;

//- (BOOL)validateBoardID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* icon;

//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* quantity;

@property (atomic) int32_t quantityValue;
- (int32_t)quantityValue;
- (void)setQuantityValue:(int32_t)value_;

//- (BOOL)validateQuantity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userID;

//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* weight;

@property (atomic) int32_t weightValue;
- (int32_t)weightValue;
- (void)setWeightValue:(int32_t)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;

@end

@interface _CommunityPlateModel (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBoardID;
- (void)setPrimitiveBoardID:(NSNumber*)value;

- (int32_t)primitiveBoardIDValue;
- (void)setPrimitiveBoardIDValue:(int32_t)value_;

- (NSString*)primitiveIcon;
- (void)setPrimitiveIcon:(NSString*)value;

- (NSNumber*)primitiveQuantity;
- (void)setPrimitiveQuantity:(NSNumber*)value;

- (int32_t)primitiveQuantityValue;
- (void)setPrimitiveQuantityValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;

- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (int32_t)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(int32_t)value_;

@end
