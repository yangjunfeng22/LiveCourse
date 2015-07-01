// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FailOrderModel.h instead.

#import <CoreData/CoreData.h>

extern const struct FailOrderModelAttributes {
	__unsafe_unretained NSString *createDate;
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *orderID;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *showPrice;
} FailOrderModelAttributes;

@interface FailOrderModelID : NSManagedObjectID {}
@end

@interface _FailOrderModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FailOrderModelID* objectID;

@property (nonatomic, strong) NSDate* createDate;

//- (BOOL)validateCreateDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* orderID;

//- (BOOL)validateOrderID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* price;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* showPrice;

//- (BOOL)validateShowPrice:(id*)value_ error:(NSError**)error_;

@end

@interface _FailOrderModel (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreateDate;
- (void)setPrimitiveCreateDate:(NSDate*)value;

- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveOrderID;
- (void)setPrimitiveOrderID:(NSString*)value;

- (NSString*)primitivePrice;
- (void)setPrimitivePrice:(NSString*)value;

- (NSString*)primitiveShowPrice;
- (void)setPrimitiveShowPrice:(NSString*)value;

@end
