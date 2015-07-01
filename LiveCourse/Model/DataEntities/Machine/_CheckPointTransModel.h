// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPointTransModel.h instead.

#import <CoreData/CoreData.h>

extern const struct CheckPointTransModelAttributes {
	__unsafe_unretained NSString *cpID;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *name;
} CheckPointTransModelAttributes;

@interface CheckPointTransModelID : NSManagedObjectID {}
@end

@interface _CheckPointTransModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CheckPointTransModelID* objectID;

@property (nonatomic, strong) NSString* cpID;

//- (BOOL)validateCpID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* language;

//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _CheckPointTransModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCpID;
- (void)setPrimitiveCpID:(NSString*)value;

- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
