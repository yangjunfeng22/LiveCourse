// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GrammarModel.h instead.

#import <CoreData/CoreData.h>

extern const struct GrammarModelAttributes {
	__unsafe_unretained NSString *explain;
	__unsafe_unretained NSString *gID;
} GrammarModelAttributes;

@interface GrammarModelID : NSManagedObjectID {}
@end

@interface _GrammarModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GrammarModelID* objectID;

@property (nonatomic, strong) NSString* explain;

//- (BOOL)validateExplain:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* gID;

//- (BOOL)validateGID:(id*)value_ error:(NSError**)error_;

@end

@interface _GrammarModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveExplain;
- (void)setPrimitiveExplain:(NSString*)value;

- (NSString*)primitiveGID;
- (void)setPrimitiveGID:(NSString*)value;

@end
