// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPointModel.m instead.

#import "_CheckPointModel.h"

const struct CheckPointModelAttributes CheckPointModelAttributes = {
	.address = @"address",
	.checkPointType = @"checkPointType",
	.cpID = @"cpID",
	.index = @"index",
	.lID = @"lID",
	.name = @"name",
	.version = @"version",
};

@implementation CheckPointModelID
@end

@implementation _CheckPointModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CheckPointModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CheckPointModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CheckPointModel" inManagedObjectContext:moc_];
}

- (CheckPointModelID*)objectID {
	return (CheckPointModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"checkPointTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"checkPointType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

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

@dynamic cpID;

@dynamic index;

- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithInt:value_]];
}

@dynamic lID;

@dynamic name;

@dynamic version;

@end

