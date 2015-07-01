// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserLaterStatuModel.m instead.

#import "_UserLaterStatuModel.h"

const struct UserLaterStatuModelAttributes UserLaterStatuModelAttributes = {
	.cID = @"cID",
	.ccID = @"ccID",
	.cpID = @"cpID",
	.lID = @"lID",
	.nexCpID = @"nexCpID",
	.timeStamp = @"timeStamp",
	.uID = @"uID",
	.unitID = @"unitID",
};

@implementation UserLaterStatuModelID
@end

@implementation _UserLaterStatuModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UserLaterStatuModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UserLaterStatuModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UserLaterStatuModel" inManagedObjectContext:moc_];
}

- (UserLaterStatuModelID*)objectID {
	return (UserLaterStatuModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"timeStampValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timeStamp"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic cID;

@dynamic ccID;

@dynamic cpID;

@dynamic lID;

@dynamic nexCpID;

@dynamic timeStamp;

- (int32_t)timeStampValue {
	NSNumber *result = [self timeStamp];
	return [result intValue];
}

- (void)setTimeStampValue:(int32_t)value_ {
	[self setTimeStamp:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTimeStampValue {
	NSNumber *result = [self primitiveTimeStamp];
	return [result intValue];
}

- (void)setPrimitiveTimeStampValue:(int32_t)value_ {
	[self setPrimitiveTimeStamp:[NSNumber numberWithInt:value_]];
}

@dynamic uID;

@dynamic unitID;

@end

