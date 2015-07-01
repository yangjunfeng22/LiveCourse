// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPoint2ContentModel.m instead.

#import "_CheckPoint2ContentModel.h"

const struct CheckPoint2ContentModelAttributes CheckPoint2ContentModelAttributes = {
	.checkPointType = @"checkPointType",
	.coID = @"coID",
	.cpID = @"cpID",
	.gID = @"gID",
	.weight = @"weight",
};

@implementation CheckPoint2ContentModelID
@end

@implementation _CheckPoint2ContentModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CheckPoint2ContentModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CheckPoint2ContentModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CheckPoint2ContentModel" inManagedObjectContext:moc_];
}

- (CheckPoint2ContentModelID*)objectID {
	return (CheckPoint2ContentModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"checkPointTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"checkPointType"];
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

@dynamic checkPointType;

- (int32_t)checkPointTypeValue {
	NSNumber *result = [self checkPointType];
	return [result intValue];
}

- (void)setCheckPointTypeValue:(int32_t)value_ {
	[self setCheckPointType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCheckPointTypeValue {
	NSNumber *result = [self primitiveCheckPointType];
	return [result intValue];
}

- (void)setPrimitiveCheckPointTypeValue:(int32_t)value_ {
	[self setPrimitiveCheckPointType:[NSNumber numberWithInt:value_]];
}

@dynamic coID;

@dynamic cpID;

@dynamic gID;

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

