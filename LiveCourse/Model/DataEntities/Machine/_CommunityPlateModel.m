// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CommunityPlateModel.m instead.

#import "_CommunityPlateModel.h"

const struct CommunityPlateModelAttributes CommunityPlateModelAttributes = {
	.boardID = @"boardID",
	.icon = @"icon",
	.quantity = @"quantity",
	.title = @"title",
	.userID = @"userID",
	.weight = @"weight",
};

@implementation CommunityPlateModelID
@end

@implementation _CommunityPlateModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CommunityPlateModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CommunityPlateModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CommunityPlateModel" inManagedObjectContext:moc_];
}

- (CommunityPlateModelID*)objectID {
	return (CommunityPlateModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"boardIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"boardID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"quantityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"quantity"];
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

@dynamic boardID;

- (int32_t)boardIDValue {
	NSNumber *result = [self boardID];
	return [result intValue];
}

- (void)setBoardIDValue:(int32_t)value_ {
	[self setBoardID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveBoardIDValue {
	NSNumber *result = [self primitiveBoardID];
	return [result intValue];
}

- (void)setPrimitiveBoardIDValue:(int32_t)value_ {
	[self setPrimitiveBoardID:[NSNumber numberWithInt:value_]];
}

@dynamic icon;

@dynamic quantity;

- (int32_t)quantityValue {
	NSNumber *result = [self quantity];
	return [result intValue];
}

- (void)setQuantityValue:(int32_t)value_ {
	[self setQuantity:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveQuantityValue {
	NSNumber *result = [self primitiveQuantity];
	return [result intValue];
}

- (void)setPrimitiveQuantityValue:(int32_t)value_ {
	[self setPrimitiveQuantity:[NSNumber numberWithInt:value_]];
}

@dynamic title;

@dynamic userID;

@dynamic weight;

- (int32_t)weightValue {
	NSNumber *result = [self weight];
	return [result intValue];
}

- (void)setWeightValue:(int32_t)value_ {
	[self setWeight:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWeightValue {
	NSNumber *result = [self primitiveWeight];
	return [result intValue];
}

- (void)setPrimitiveWeightValue:(int32_t)value_ {
	[self setPrimitiveWeight:[NSNumber numberWithInt:value_]];
}

@end

