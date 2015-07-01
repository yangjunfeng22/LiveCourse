// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Knowledge2SentenceModel.h instead.

#import <CoreData/CoreData.h>

extern const struct Knowledge2SentenceModelAttributes {
	__unsafe_unretained NSString *kID;
	__unsafe_unretained NSString *sID;
} Knowledge2SentenceModelAttributes;

@interface Knowledge2SentenceModelID : NSManagedObjectID {}
@end

@interface _Knowledge2SentenceModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) Knowledge2SentenceModelID* objectID;

@property (nonatomic, strong) NSString* kID;

//- (BOOL)validateKID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sID;

//- (BOOL)validateSID:(id*)value_ error:(NSError**)error_;

@end

@interface _Knowledge2SentenceModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveKID;
- (void)setPrimitiveKID:(NSString*)value;

- (NSString*)primitiveSID;
- (void)setPrimitiveSID:(NSString*)value;

@end
