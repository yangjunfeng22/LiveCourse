// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KnowledgeTransModel.m instead.

#import "_KnowledgeTransModel.h"

const struct KnowledgeTransModelAttributes KnowledgeTransModelAttributes = {
	.explain = @"explain",
	.kID = @"kID",
	.language = @"language",
	.quote = @"quote",
	.title = @"title",
};

@implementation KnowledgeTransModelID
@end

@implementation _KnowledgeTransModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KnowledgeTransModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KnowledgeTransModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KnowledgeTransModel" inManagedObjectContext:moc_];
}

- (KnowledgeTransModelID*)objectID {
	return (KnowledgeTransModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic explain;

@dynamic kID;

@dynamic language;

@dynamic quote;

@dynamic title;

@end

