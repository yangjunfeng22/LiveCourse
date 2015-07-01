// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KnowledgeTransModel.h instead.

#import <CoreData/CoreData.h>

extern const struct KnowledgeTransModelAttributes {
	__unsafe_unretained NSString *explain;
	__unsafe_unretained NSString *kID;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *quote;
	__unsafe_unretained NSString *title;
} KnowledgeTransModelAttributes;

@interface KnowledgeTransModelID : NSManagedObjectID {}
@end

@interface _KnowledgeTransModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KnowledgeTransModelID* objectID;

@property (nonatomic, strong) NSString* explain;

//- (BOOL)validateExplain:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* kID;

//- (BOOL)validateKID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* language;

//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* quote;

//- (BOOL)validateQuote:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@end

@interface _KnowledgeTransModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveExplain;
- (void)setPrimitiveExplain:(NSString*)value;

- (NSString*)primitiveKID;
- (void)setPrimitiveKID:(NSString*)value;

- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;

- (NSString*)primitiveQuote;
- (void)setPrimitiveQuote:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

@end
