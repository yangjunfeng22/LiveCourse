// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CheckPointTransModel.m instead.

#import "_CheckPointTransModel.h"

const struct CheckPointTransModelAttributes CheckPointTransModelAttributes = {
	.cpID = @"cpID",
	.language = @"language",
	.name = @"name",
};

@implementation CheckPointTransModelID
@end

@implementation _CheckPointTransModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CheckPointTransModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CheckPointTransModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CheckPointTransModel" inManagedObjectContext:moc_];
}

- (CheckPointTransModelID*)objectID {
	return (CheckPointTransModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic cpID;

@dynamic language;

@dynamic name;

@end

