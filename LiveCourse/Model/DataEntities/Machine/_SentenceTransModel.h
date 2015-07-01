// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceTransModel.h instead.

#import <CoreData/CoreData.h>

extern const struct SentenceTransModelAttributes {
	__unsafe_unretained NSString *chinese;
	__unsafe_unretained NSString *language;
	__unsafe_unretained NSString *sID;
} SentenceTransModelAttributes;

@interface SentenceTransModelID : NSManagedObjectID {}
@end

@interface _SentenceTransModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SentenceTransModelID* objectID;

@property (nonatomic, strong) NSString* chinese;

//- (BOOL)validateChinese:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* language;

//- (BOOL)validateLanguage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sID;

//- (BOOL)validateSID:(id*)value_ error:(NSError**)error_;

@end

@interface _SentenceTransModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveChinese;
- (void)setPrimitiveChinese:(NSString*)value;

- (NSString*)primitiveLanguage;
- (void)setPrimitiveLanguage:(NSString*)value;

- (NSString*)primitiveSID;
- (void)setPrimitiveSID:(NSString*)value;

@end
