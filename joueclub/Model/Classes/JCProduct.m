#import "JCProduct.h"

#import "NSObject+PNCast.h"

@interface JCProduct ()

// Private interface goes here.

@end

@implementation JCProduct

- (void)parseNode:(NSDictionary *)node
{
    self.d1 = [NSString cast:node[@"d1"]];
    self.d2 = [NSString cast:node[@"d2"]];
    self.d3 = [NSString cast:node[@"d3"]];
    self.d4 = [NSString cast:node[@"d4"]];
    self.d5 = [NSString cast:node[@"d5"]];
    self.d6 = [NSString cast:node[@"d6"]];
    self.d7 = [NSString cast:node[@"d7"]];
    self.r = [NSString cast:node[@"reliquat"]];
    
    if([node[@"sku"] isEqualToString:@"12021890"]) {
        NSDictionary *ddd = node[@"reference_int"];
        NSDictionary *aaa = ddd;

    }
    
    NSString *promoStartStr = node[@"product_discount_date_start"];
    NSString *promoEndStr = node[@"product_discount_date_end"];
    if(promoStartStr && promoEndStr) {
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormat setDateFormat:@"dd-MMM-yy"];

        NSDate *sDate = [dateFormat dateFromString:promoStartStr];
        self.promoStart = sDate;
        
        NSDate *eDate = [dateFormat dateFromString:promoEndStr];
        
        NSDate *oldDate = eDate; // Or however you get it.
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:oldDate];
        comps.hour   = 23;
        comps.minute = 59;
        comps.second = 59;
        NSDate *newEndDate = [calendar dateFromComponents:comps];
        
        self.promoEnd = newEndDate;
    }
    
    NSString *deliveryDateStr = node[@"date_reception_theorique"];
    if(deliveryDateStr) {
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MMM-yy"];
        self.deliveryDate = [dateFormat dateFromString:deliveryDateStr];
    }
    
    self.fieldcodebarre = [NSString cast:node[@"fieldcodebarre"]];
    
#warning load image URLs array (create entity "JCImage" and make relations
    self.imageURL = [NSString cast:node[@"images"][0][@"src"]];
    
    self.isInStock = [NSNumber cast:node[@"in_stock"]];
    self.price = [NSString cast:node[@"price"]];
    self.priceHTML = [NSString cast:node[@"price_html"]];
    self.regularPrice = [NSString cast:node[@"regular_price"]];
    self.salePrice = [NSString cast:node[@"sale_price"]];
    
    self.productId = [NSNumber cast:node[@"id"]];
    
    NSString *refId = [NSString cast:node[@"reference_int"]];
    self.refId = refId;
    
    self.promoTime = [NSString cast:node[@"date_reception_theorique"]];
    self.sku = [NSString cast:node[@"sku"]];
    self.status = [NSString cast:node[@"status"]];
    self.stockAmount = [NSNumber cast:node[@"stock_quantity"]];
    self.title = [NSString cast:node[@"title"]];
    self.type = [NSString cast:node[@"type"]];
    
//    self.createdAt = [NSString cast:node[@""]];
//    self.updatedAt = [NSString cast:node[@""]];
    
    self.manufacturer = [NSString cast:node[@"manufacturer_name"]];
}

@end
