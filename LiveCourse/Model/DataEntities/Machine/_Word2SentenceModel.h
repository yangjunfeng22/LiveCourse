// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Word2SentenceModel.h instead.

#import <CoreData/CoreData.h>

extern const struct Word2SentenceModelAttributes {
	__unsafe_unretained NSString *sID;
	__unsafe_unretained NSString *wID;
} Word2SentenceModelAttributes;

@interface Word2SentenceModelID : NSManagedObjectID {}
@end

@interface _Word2SentenceModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) Word2SentenceModelID* objectID;

@property (nonatomic, strong) NSString* sID;

//- (BOOL)validateSID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* wID;

//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;

@end

@interface _Word2SentenceModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveSID;
- (void)setPrimitiveSID:(NSString*)value;

- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;

@end
