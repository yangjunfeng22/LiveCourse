// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CommunityModel.m instead.

#import "_CommunityModel.h"

const struct CommunityModelAttributes CommunityModelAttributes = {
	.audio = @"audio",
	.boardID = @"boardID",
	.duration = @"duration",
	.liked = @"liked",
	.owner = @"owner",
	.picture = @"picture",
	.posted = @"posted",
	.replied = @"replied",
	.status = @"status",
	.summary = @"summary",
	.tag = @"tag",
	.tagName = @"tagName",
	.title = @"title",
	.topicID = @"topicID",
	.userID = @"userID",
};

@implementation CommunityModelID
@end

@implementation _CommunityModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CommunityModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CommunityModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CommunityModel" inManagedObjectContext:moc_];
}

- (CommunityModelID*)objectID {
	return (CommunityModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"likedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"liked"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"postedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"posted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"repliedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"replied"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic audio;

@dynamic boardID;

@dynamic duration;

- (int32_t)durationValue {
	NSNumber *result = [self duration];
	return [result intValue];
}

- (void)setDurationValue:(int32_t)value_ {
	[self setDuration:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result intValue];
}

- (void)setPrimitiveDurationValue:(int32_t)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithInt:value_]];
}

@dynamic liked;

- (int32_t)likedValue {
	NSNumber *result = [self liked];
	return [result intValue];
}

- (void)setLikedValue:(int32_t)value_ {
	[self setLiked:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLikedValue {
	NSNumber *result = [self primitiveLiked];
	return [result intValue];
}

- (void)setPrimitiveLikedValue:(int32_t)value_ {
	[self setPrimitiveLiked:[NSNumber numberWithInt:value_]];
}

@dynamic owner;

@dynamic picture;

@dynamic posted;

- (int32_t)postedValue {
	NSNumber *result = [self posted];
	return [result intValue];
}

- (void)setPostedValue:(int32_t)value_ {
	[self setPosted:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePostedValue {
	NSNumber *result = [self primitivePosted];
	return [result intValue];
}

- (void)setPrimitivePostedValue:(int32_t)value_ {
	[self setPrimitivePosted:[NSNumber numberWithInt:value_]];
}

@dynamic replied;

- (int32_t)repliedValue {
	NSNumber *result = [self replied];
	return [result intValue];
}

- (void)setRepliedValue:(int32_t)value_ {
	[self setReplied:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRepliedValue {
	NSNumber *result = [self primitiveReplied];
	return [result intValue];
}

- (void)setPrimitiveRepliedValue:(int32_t)value_ {
	[self setPrimitiveReplied:[NSNumber numberWithInt:value_]];
}

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

@dynamic summary;

@dynamic tag;

@dynamic tagName;

@dynamic title;

@dynamic topicID;

@dynamic userID;

@end

