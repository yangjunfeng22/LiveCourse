// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordModel.h instead.

#import <CoreData/CoreData.h>

extern const struct WordModelAttributes {
	__unsafe_unretained NSString *audio;
	__unsafe_unretained NSString *chinese;
	__unsafe_unretained NSString *gID;
	__unsafe_unretained NSString *picture;
	__unsafe_unretained NSString *pinyin;
	__unsafe_unretained NSString *property;
	__unsafe_unretained NSString *wID;
	__unsafe_unretained NSString *weight;
} WordModelAttributes;

@interface WordModelID : NSManagedObjectID {}
@end

@interface _WordModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WordModelID* objectID;

@property (nonatomic, strong) NSString* audio;

//- (BOOL)validateAudio:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* chinese;

//- (BOOL)validateChinese:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* gID;

//- (BOOL)validateGID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* picture;

//- (BOOL)validatePicture:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pinyin;

//- (BOOL)validatePinyin:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* property;

//- (BOOL)validateProperty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* wID;

//- (BOOL)validateWID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* weight;

@property (atomic) float weightValue;
- (float)weightValue;
- (void)setWeightValue:(float)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;

@end

@interface _WordModel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAudio;
- (void)setPrimitiveAudio:(NSString*)value;

- (NSString*)primitiveChinese;
- (void)setPrimitiveChinese:(NSString*)value;

- (NSString*)primitiveGID;
- (void)setPrimitiveGID:(NSString*)value;

- (NSString*)primitivePicture;
- (void)setPrimitivePicture:(NSString*)value;

- (NSString*)primitivePinyin;
- (void)setPrimitivePinyin:(NSString*)value;

- (NSString*)primitiveProperty;
- (void)setPrimitiveProperty:(NSString*)value;

- (NSString*)primitiveWID;
- (void)setPrimitiveWID:(NSString*)value;

- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (float)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(float)value_;

@end
