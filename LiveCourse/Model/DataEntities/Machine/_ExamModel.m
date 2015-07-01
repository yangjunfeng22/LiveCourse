// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ExamModel.m instead.

#import "_ExamModel.h"

const struct ExamModelAttributes ExamModelAttributes = {
	.answer = @"answer",
	.audio = @"audio",
	.category = @"category",
	.eID = @"eID",
	.explain = @"explain",
	.image = @"image",
	.items = @"items",
	.level = @"level",
	.parentID = @"parentID",
	.question = @"question",
	.status = @"status",
	.subject = @"subject",
	.subjectFormat = @"subjectFormat",
	.time = @"time",
	.title = @"title",
	.total = @"total",
	.type = @"type",
	.typeAlias = @"typeAlias",
	.weight = @"weight",
};

@implementation ExamModelID
@end

@implementation _ExamModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ExamModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ExamModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ExamModel" inManagedObjectContext:moc_];
}

- (ExamModelID*)objectID {
	return (ExamModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"categoryValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"category"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"levelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"level"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"timeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"totalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"total"];
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

@dynamic answer;

@dynamic audio;

@dynamic category;

- (int32_t)categoryValue {
	NSNumber *result = [self category];
	return [result intValue];
}

- (void)setCategoryValue:(int32_t)value_ {
	[self setCategory:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCategoryValue {
	NSNumber *result = [self primitiveCategory];
	return [result intValue];
}

- (void)setPrimitiveCategoryValue:(int32_t)value_ {
	[self setPrimitiveCategory:[NSNumber numberWithInt:value_]];
}

@dynamic eID;

@dynamic explain;

@dynamic image;

@dynamic items;

@dynamic level;

- (int32_t)levelValue {
	NSNumber *result = [self level];
	return [result intValue];
}

- (void)setLevelValue:(int32_t)value_ {
	[self setLevel:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLevelValue {
	NSNumber *result = [self primitiveLevel];
	return [result intValue];
}

- (void)setPrimitiveLevelValue:(int32_t)value_ {
	[self setPrimitiveLevel:[NSNumber numberWithInt:value_]];
}

@dynamic parentID;

@dynamic question;

@dynamic status;

- (int32_t)statusValue {
	NSNumber *result = [self status];
	return [result intValue];
}

- (void)setStatusValue:(int32_t)value_ {
	[self setStatus:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result intValue];
}

- (void)setPrimitiveStatusValue:(int32_t)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithInt:value_]];
}

@dynamic subject;

@dynamic subjectFormat;

@dynamic time;

- (int32_t)timeValue {
	NSNumber *result = [self time];
	return [result intValue];
}

- (void)setTimeValue:(int32_t)value_ {
	[self setTime:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTimeValue {
	NSNumber *result = [self primitiveTime];
	return [result intValue];
}

- (void)setPrimitiveTimeValue:(int32_t)value_ {
	[self setPrimitiveTime:[NSNumber numberWithInt:value_]];
}

@dynamic title;

@dynamic total;

- (int32_t)totalValue {
	NSNumber *result = [self total];
	return [result intValue];
}

- (void)setTotalValue:(int32_t)value_ {
	[self setTotal:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTotalValue {
	NSNumber *result = [self primitiveTotal];
	return [result intValue];
}

- (void)setPrimitiveTotalValue:(int32_t)value_ {
	[self setPrimitiveTotal:[NSNumber numberWithInt:value_]];
}

@dynamic type;

@dynamic typeAlias;

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

