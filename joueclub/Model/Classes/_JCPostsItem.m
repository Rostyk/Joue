// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCPostsItem.m instead.

#import "_JCPostsItem.h"

const struct JCPostsItemAttributes JCPostsItemAttributes = {
	.content = @"content",
	.itemId = @"itemId",
	.title = @"title",
};

@implementation JCPostsItemID
@end

@implementation _JCPostsItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JCPostsItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JCPostsItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JCPostsItem" inManagedObjectContext:moc_];
}

- (JCPostsItemID*)objectID {
	return (JCPostsItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"itemIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itemId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic content;

@dynamic itemId;

- (int64_t)itemIdValue {
	NSNumber *result = [self itemId];
	return [result longLongValue];
}

- (void)setItemIdValue:(int64_t)value_ {
	[self setItemId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveItemIdValue {
	NSNumber *result = [self primitiveItemId];
	return [result longLongValue];
}

- (void)setPrimitiveItemIdValue:(int64_t)value_ {
	[self setPrimitiveItemId:[NSNumber numberWithLongLong:value_]];
}

@dynamic title;

@end

