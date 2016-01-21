// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JCProduct.h instead.

#import <CoreData/CoreData.h>

extern const struct JCProductAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *customImage;
	__unsafe_unretained NSString *d1;
	__unsafe_unretained NSString *d2;
	__unsafe_unretained NSString *d3;
	__unsafe_unretained NSString *d4;
	__unsafe_unretained NSString *d5;
	__unsafe_unretained NSString *d6;
	__unsafe_unretained NSString *d7;
	__unsafe_unretained NSString *deliveryDate;
	__unsafe_unretained NSString *fieldcodebarre;
	__unsafe_unretained NSString *imageURL;
	__unsafe_unretained NSString *isInStock;
	__unsafe_unretained NSString *manufacturer;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *priceHTML;
	__unsafe_unretained NSString *productId;
	__unsafe_unretained NSString *promoEnd;
	__unsafe_unretained NSString *promoStart;
	__unsafe_unretained NSString *promoTime;
	__unsafe_unretained NSString *r;
	__unsafe_unretained NSString *refId;
	__unsafe_unretained NSString *regularPrice;
	__unsafe_unretained NSString *salePrice;
	__unsafe_unretained NSString *sku;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *stockAmount;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *updatedAt;
} JCProductAttributes;

@interface JCProductID : NSManagedObjectID {}
@end

@interface _JCProduct : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) JCProductID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* customImage;

//- (BOOL)validateCustomImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* d1;

//- (BOOL)validateD1:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* d2;

//- (BOOL)validateD2:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* d3;

//- (BOOL)validateD3:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* d4;

//- (BOOL)validateD4:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* d5;

//- (BOOL)validateD5:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* d6;

//- (BOOL)validateD6:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* d7;

//- (BOOL)validateD7:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* deliveryDate;

//- (BOOL)validateDeliveryDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fieldcodebarre;

//- (BOOL)validateFieldcodebarre:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* imageURL;

//- (BOOL)validateImageURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isInStock;

@property (atomic) BOOL isInStockValue;
- (BOOL)isInStockValue;
- (void)setIsInStockValue:(BOOL)value_;

//- (BOOL)validateIsInStock:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* manufacturer;

//- (BOOL)validateManufacturer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* price;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* priceHTML;

//- (BOOL)validatePriceHTML:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* productId;

@property (atomic) int64_t productIdValue;
- (int64_t)productIdValue;
- (void)setProductIdValue:(int64_t)value_;

//- (BOOL)validateProductId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* promoEnd;

//- (BOOL)validatePromoEnd:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* promoStart;

//- (BOOL)validatePromoStart:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* promoTime;

//- (BOOL)validatePromoTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* r;

//- (BOOL)validateR:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* refId;

//- (BOOL)validateRefId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* regularPrice;

//- (BOOL)validateRegularPrice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* salePrice;

//- (BOOL)validateSalePrice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sku;

//- (BOOL)validateSku:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* stockAmount;

@property (atomic) int32_t stockAmountValue;
- (int32_t)stockAmountValue;
- (void)setStockAmountValue:(int32_t)value_;

//- (BOOL)validateStockAmount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@end

@interface _JCProduct (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSData*)primitiveCustomImage;
- (void)setPrimitiveCustomImage:(NSData*)value;

- (NSString*)primitiveD1;
- (void)setPrimitiveD1:(NSString*)value;

- (NSString*)primitiveD2;
- (void)setPrimitiveD2:(NSString*)value;

- (NSString*)primitiveD3;
- (void)setPrimitiveD3:(NSString*)value;

- (NSString*)primitiveD4;
- (void)setPrimitiveD4:(NSString*)value;

- (NSString*)primitiveD5;
- (void)setPrimitiveD5:(NSString*)value;

- (NSString*)primitiveD6;
- (void)setPrimitiveD6:(NSString*)value;

- (NSString*)primitiveD7;
- (void)setPrimitiveD7:(NSString*)value;

- (NSDate*)primitiveDeliveryDate;
- (void)setPrimitiveDeliveryDate:(NSDate*)value;

- (NSString*)primitiveFieldcodebarre;
- (void)setPrimitiveFieldcodebarre:(NSString*)value;

- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;

- (NSNumber*)primitiveIsInStock;
- (void)setPrimitiveIsInStock:(NSNumber*)value;

- (BOOL)primitiveIsInStockValue;
- (void)setPrimitiveIsInStockValue:(BOOL)value_;

- (NSString*)primitiveManufacturer;
- (void)setPrimitiveManufacturer:(NSString*)value;

- (NSString*)primitivePrice;
- (void)setPrimitivePrice:(NSString*)value;

- (NSString*)primitivePriceHTML;
- (void)setPrimitivePriceHTML:(NSString*)value;

- (NSNumber*)primitiveProductId;
- (void)setPrimitiveProductId:(NSNumber*)value;

- (int64_t)primitiveProductIdValue;
- (void)setPrimitiveProductIdValue:(int64_t)value_;

- (NSDate*)primitivePromoEnd;
- (void)setPrimitivePromoEnd:(NSDate*)value;

- (NSDate*)primitivePromoStart;
- (void)setPrimitivePromoStart:(NSDate*)value;

- (NSString*)primitivePromoTime;
- (void)setPrimitivePromoTime:(NSString*)value;

- (NSString*)primitiveR;
- (void)setPrimitiveR:(NSString*)value;

- (NSString*)primitiveRefId;
- (void)setPrimitiveRefId:(NSString*)value;

- (NSString*)primitiveRegularPrice;
- (void)setPrimitiveRegularPrice:(NSString*)value;

- (NSString*)primitiveSalePrice;
- (void)setPrimitiveSalePrice:(NSString*)value;

- (NSString*)primitiveSku;
- (void)setPrimitiveSku:(NSString*)value;

- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;

- (NSNumber*)primitiveStockAmount;
- (void)setPrimitiveStockAmount:(NSNumber*)value;

- (int32_t)primitiveStockAmountValue;
- (void)setPrimitiveStockAmountValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

@end
