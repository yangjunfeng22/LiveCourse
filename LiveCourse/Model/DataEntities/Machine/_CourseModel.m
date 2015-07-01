// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CourseModel.m instead.

#import "_CourseModel.h"

const struct CourseModelAttributes CourseModelAttributes = {
	.cID = @"cID",
	.name = @"name",
	.parentID = @"parentID",
	.picture = @"picture",
	.status = @"status",
	.version = @"version",
	.weight = @"weight",
};

@implementation CourseModelID
@end

@implementation _CourseModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CourseModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CourseModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CourseModel" inManagedObjectContext:moc_];
}

- (CourseModelID*)objectID {
	return (CourseModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
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

@dynamic cID;

@dynamic name;

@dynamic parentID;

@dynamic picture;

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

@dynamic version;

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

