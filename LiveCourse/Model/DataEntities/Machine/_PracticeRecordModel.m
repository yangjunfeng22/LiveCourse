// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PracticeRecordModel.m instead.

#import "_PracticeRecordModel.h"

const struct PracticeRecordModelAttributes PracticeRecordModelAttributes = {
	.answer = @"answer",
	.courseCategoyID = @"courseCategoyID",
	.courseID = @"courseID",
	.lessonID = @"lessonID",
	.result = @"result",
	.rightTimes = @"rightTimes",
	.timeStamp = @"timeStamp",
	.topicID = @"topicID",
	.userID = @"userID",
	.wrongTimes = @"wrongTimes",
};

@implementation PracticeRecordModelID
@end

@implementation _PracticeRecordModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PracticeRecordModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PracticeRecordModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PracticeRecordModel" inManagedObjectContext:moc_];
}

- (PracticeRecordModelID*)objectID {
	return (PracticeRecordModelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"resultValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"result"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rightTimesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rightTimes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"wrongTimesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wrongTimes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic answer;

@dynamic courseCategoyID;

@dynamic courseID;

@dynamic lessonID;

@dynamic result;

- (int32_t)resultValue {
	NSNumber *result = [self result];
	return [result intValue];
}

- (void)setResultValue:(int32_t)value_ {
	[self setResult:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveResultValue {
	NSNumber *result = [self primitiveResult];
	return [result intValue];
}

- (void)setPrimitiveResultValue:(int32_t)value_ {
	[self setPrimitiveResult:[NSNumber numberWithInt:value_]];
}

@dynamic rightTimes;

- (int32_t)rightTimesValue {
	NSNumber *result = [self rightTimes];
	return [result intValue];
}

- (void)setRightTimesValue:(int32_t)value_ {
	[self setRightTimes:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRightTimesValue {
	NSNumber *result = [self primitiveRightTimes];
	return [result intValue];
}

- (void)setPrimitiveRightTimesValue:(int32_t)value_ {
	[self setPrimitiveRightTimes:[NSNumber numberWithInt:value_]];
}

@dynamic timeStamp;

@dynamic topicID;

@dynamic userID;

@dynamic wrongTimes;

- (int32_t)wrongTimesValue {
	NSNumber *result = [self wrongTimes];
	return [result intValue];
}

- (void)setWrongTimesValue:(int32_t)value_ {
	[self setWrongTimes:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWrongTimesValue {
	NSNumber *result = [self primitiveWrongTimes];
	return [result intValue];
}

- (void)setPrimitiveWrongTimesValue:(int32_t)value_ {
	[self setPrimitiveWrongTimes:[NSNumber numberWithInt:value_]];
}

@end

