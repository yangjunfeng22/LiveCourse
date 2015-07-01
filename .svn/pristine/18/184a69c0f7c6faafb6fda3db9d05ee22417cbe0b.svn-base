// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordModel.m instead.

#import "_WordModel.h"

const struct WordModelAttributes WordModelAttributes = {
	.audio = @"audio",
	.chinese = @"chinese",
	.gID = @"gID",
	.picture = @"picture",
	.pinyin = @"pinyin",
	.property = @"property",
	.wID = @"wID",
	.weight = @"weight",
};

@implementation WordModelID
@end

@implementation _WordModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WordModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WordModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WordModel" inManagedObjectContext:moc_];
}

- (WordModelID*)objectID {
	return (WordModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

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

@dynamic picture;

@dynamic pinyin;

@dynamic property;

@dynamic wID;

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

