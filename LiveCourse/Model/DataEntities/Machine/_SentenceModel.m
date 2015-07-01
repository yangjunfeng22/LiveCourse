// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SentenceModel.m instead.

#import "_SentenceModel.h"

const struct SentenceModelAttributes SentenceModelAttributes = {
	.audio = @"audio",
	.chinese = @"chinese",
	.gID = @"gID",
	.mode = @"mode",
	.picture = @"picture",
	.pinyin = @"pinyin",
	.qChinese = @"qChinese",
	.qPinyin = @"qPinyin",
	.sID = @"sID",
	.weight = @"weight",
};

@implementation SentenceModelID
@end

@implementation _SentenceModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SentenceModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SentenceModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SentenceModel" inManagedObjectContext:moc_];
}

- (SentenceModelID*)objectID {
	return (SentenceModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"modeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"mode"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic audio;

@dynamic chinese;

@dynamic gID;

@dynamic mode;

- (int32_t)modeValue {
	NSNumber *result = [self mode];
	return [result intValue];
}

- (void)setModeValue:(int32_t)value_ {
	[self setMode:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveModeValue {
	NSNumber *result = [self primitiveMode];
	return [result intValue];
}

- (void)setPrimitiveModeValue:(int32_t)value_ {
	[self setPrimitiveMode:[NSNumber numberWithInt:value_]];
}

@dynamic picture;

@dynamic pinyin;

@dynamic qChinese;

@dynamic qPinyin;

@dynamic sID;

@dynamic weight;

- (float)weightValue {
	NSNumber *result = [self weight];
	return [result floatValue];
}

- (void)setWeightValue:(float)value_ {
	[self setWeight:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveWeightValue {
	NSNumber *result = [self primitiveWeight];
	return [result floatValue];
}

- (void)setPrimitiveWeightValue:(float)value_ {
	[self setPrimitiveWeight:[NSNumber numberWithFloat:value_]];
}

@end

