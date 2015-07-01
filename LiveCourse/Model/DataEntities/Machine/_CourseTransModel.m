// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CourseTransModel.m instead.

#import "_CourseTransModel.h"

const struct CourseTransModelAttributes CourseTransModelAttributes = {
	.cID = @"cID",
	.language = @"language",
	.name = @"name",
};

@implementation CourseTransModelID
@end

@implementation _CourseTransModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CourseTransModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CourseTransModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CourseTransModel" inManagedObjectContext:moc_];
}

- (CourseTransModelID*)objectID {
	return (CourseTransModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic cID;

@dynamic language;

@dynamic name;

@end

