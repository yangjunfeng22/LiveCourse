// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CommunityAudioModel.m instead.

#import "_CommunityAudioModel.h"

const struct CommunityAudioModelAttributes CommunityAudioModelAttributes = {
	.audioData = @"audioData",
	.audioUrl = @"audioUrl",
	.createTime = @"createTime",
};

@implementation CommunityAudioModelID
@end

@implementation _CommunityAudioModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CommunityAudioModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CommunityAudioModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CommunityAudioModel" inManagedObjectContext:moc_];
}

- (CommunityAudioModelID*)objectID {
	return (CommunityAudioModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic audioData;

@dynamic audioUrl;

@dynamic createTime;

@end

