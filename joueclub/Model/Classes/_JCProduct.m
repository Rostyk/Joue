// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCProduct.m instead.

#import "_JCProduct.h"

const struct JCProductAttributes JCProductAttributes = {
	.createdAt = @"createdAt",
	.customImage = @"customImage",
	.d1 = @"d1",
	.d2 = @"d2",
	.d3 = @"d3",
	.d4 = @"d4",
	.d5 = @"d5",
	.d6 = @"d6",
	.d7 = @"d7",
	.deliveryDate = @"deliveryDate",
	.fieldcodebarre = @"fieldcodebarre",
	.imageURL = @"imageURL",
	.isInStock = @"isInStock",
	.manufacturer = @"manufacturer",
	.price = @"price",
	.priceHTML = @"priceHTML",
	.productId = @"productId",
	.promoEnd = @"promoEnd",
	.promoStart = @"promoStart",
	.promoTime = @"promoTime",
	.r = @"r",
	.refId = @"refId",
	.regularPrice = @"regularPrice",
	.salePrice = @"salePrice",
	.sku = @"sku",
	.status = @"status",
	.stockAmount = @"stockAmount",
	.title = @"title",
	.type = @"type",
	.updatedAt = @"updatedAt",
};

@implementation JCProductID
@end

@implementation _JCProduct

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JCProduct" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JCProduct";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JCProduct" inManagedObjectContext:moc_];
}

- (JCProductID*)objectID {
	return (JCProductID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isInStockValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isInStock"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"productIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"productId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stockAmountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"stockAmount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdAt;

@dynamic customImage;

@dynamic d1;

@dynamic d2;

@dynamic d3;

@dynamic d4;

@dynamic d5;

@dynamic d6;

@dynamic d7;

@dynamic deliveryDate;

@dynamic fieldcodebarre;

@dynamic imageURL;

@dynamic isInStock;

- (BOOL)isInStockValue {
	NSNumber *result = [self isInStock];
	return [result boolValue];
}

- (void)setIsInStockValue:(BOOL)value_ {
	[self setIsInStock:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsInStockValue {
	NSNumber *result = [self primitiveIsInStock];
	return [result boolValue];
}

- (void)setPrimitiveIsInStockValue:(BOOL)value_ {
	[self setPrimitiveIsInStock:[NSNumber numberWithBool:value_]];
}

@dynamic manufacturer;

@dynamic price;

@dynamic priceHTML;

@dynamic productId;

- (int64_t)productIdValue {
	NSNumber *result = [self productId];
	return [result longLongValue];
}

- (void)setProductIdValue:(int64_t)value_ {
	[self setProductId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveProductIdValue {
	NSNumber *result = [self primitiveProductId];
	return [result longLongValue];
}

- (void)setPrimitiveProductIdValue:(int64_t)value_ {
	[self setPrimitiveProductId:[NSNumber numberWithLongLong:value_]];
}

@dynamic promoEnd;

@dynamic promoStart;

@dynamic promoTime;

@dynamic r;

@dynamic refId;

@dynamic regularPrice;

@dynamic salePrice;

@dynamic sku;

@dynamic status;

@dynamic stockAmount;

- (int32_t)stockAmountValue {
	NSNumber *result = [self stockAmount];
	return [result intValue];
}

- (void)setStockAmountValue:(int32_t)value_ {
	[self setStockAmount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStockAmountValue {
	NSNumber *result = [self primitiveStockAmount];
	return [result intValue];
}

- (void)setPrimitiveStockAmountValue:(int32_t)value_ {
	[self setPrimitiveStockAmount:[NSNumber numberWithInt:value_]];
}

@dynamic title;

@dynamic type;

@dynamic updatedAt;

@end

