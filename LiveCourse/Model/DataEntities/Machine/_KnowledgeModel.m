// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KnowledgeModel.m instead.

#import "_KnowledgeModel.h"

const struct KnowledgeModelAttributes KnowledgeModelAttributes = {
	.explain = @"explain",
	.kID = @"kID",
	.quote = @"quote",
	.quotePinyin = @"quotePinyin",
	.title = @"title",
	.weight = @"weight",
};

@implementation KnowledgeModelID
@end

@implementation _KnowledgeModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KnowledgeModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KnowledgeModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KnowledgeModel" inManagedObjectContext:moc_];
}

- (KnowledgeModelID*)objectID {
	return (KnowledgeModelID*)[super objectID];
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

@dynamic explain;

@dynamic kID;

@dynamic quote;

@dynamic quotePinyin;

@dynamic title;

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

