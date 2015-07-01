// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Word2SentenceModel.m instead.

#import "_Word2SentenceModel.h"

const struct Word2SentenceModelAttributes Word2SentenceModelAttributes = {
	.sID = @"sID",
	.wID = @"wID",
};

@implementation Word2SentenceModelID
@end

@implementation _Word2SentenceModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Word2SentenceModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Word2SentenceModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Word2SentenceModel" inManagedObjectContext:moc_];
}

- (Word2SentenceModelID*)objectID {
	return (Word2SentenceModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic sID;

@dynamic wID;

@end

