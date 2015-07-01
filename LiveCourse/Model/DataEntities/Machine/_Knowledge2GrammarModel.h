// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Knowledge2GrammarModel.h instead.

#import <CoreData/CoreData.h>

extern const struct Knowledge2GrammarModelAttributes {
	__unsafe_unretained NSString *gID;
	__unsafe_unretained NSString *kID;
} Knowledge2GrammarModelAttributes;

@interface Knowledge2GrammarModelID : NSManagedObjectID {}
@end

@interface _Knowledge2GrammarModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) Knowledge2GrammarModelID* objectID;

@property (nonatomic, strong) NSString* gID;

//- (BOOL)validateGID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* kID;

//- (BOOL)validateKID:(id*)value_ error:(NSError**)error_;

@end

@interface _Knowledge2GrammarModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveGID;
- (void)setPrimitiveGID:(NSString*)value;

- (NSString*)primitiveKID;
- (void)setPrimitiveKID:(NSString*)value;

@end
