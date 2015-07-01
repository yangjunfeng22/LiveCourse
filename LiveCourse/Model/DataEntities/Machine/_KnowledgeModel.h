// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KnowledgeModel.h instead.

#import <CoreData/CoreData.h>

extern const struct KnowledgeModelAttributes {
	__unsafe_unretained NSString *explain;
	__unsafe_unretained NSString *kID;
	__unsafe_unretained NSString *quote;
	__unsafe_unretained NSString *quotePinyin;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *weight;
} KnowledgeModelAttributes;

@interface KnowledgeModelID : NSManagedObjectID {}
@end

@interface _KnowledgeModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KnowledgeModelID* objectID;

@property (nonatomic, strong) NSString* explain;

//- (BOOL)validateExplain:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* kID;

//- (BOOL)validateKID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* quote;

//- (BOOL)validateQuote:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* quotePinyin;

//- (BOOL)validateQuotePinyin:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* weight;

@property (atomic) float weightValue;
- (float)weightValue;
- (void)setWeightValue:(float)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;

@end

@interface _KnowledgeModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveExplain;
- (void)setPrimitiveExplain:(NSString*)value;

- (NSString*)primitiveKID;
- (void)setPrimitiveKID:(NSString*)value;

- (NSString*)primitiveQuote;
- (void)setPrimitiveQuote:(NSString*)value;

- (NSString*)primitiveQuotePinyin;
- (void)setPrimitiveQuotePinyin:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (float)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(float)value_;

@end
