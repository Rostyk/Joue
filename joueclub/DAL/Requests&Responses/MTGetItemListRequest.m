//
//  MTGetItemListRequest.m
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "MTGetItemListRequest.h"
#import "MTGetItemListResponse.h"

#import "NSString+SDAdditions.h"

@implementation MTGetItemListRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSMutableString *configurationString = [NSMutableString stringWithFormat:@"%@/products?page=%@&consumer_key=ck_c75960167d45ede074b207f1d99e2955&consumer_secret=cs_9288476bafd91216d7a272af0c6c11c0", [SDUserSettings serviceURL], self.page];
    
    if (self.limit != nil)
    {
        [configurationString appendFormat:@"&"];
        [configurationString appendString:[[NSString stringWithFormat:@"filter[limit]=%@", self.limit] URLEncodedString]];
    }
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:configurationString]];
    
    networkRequest.HTTPMethod = @"GET";
    return networkRequest;
}

- (SDResult *)emptyResponse
{
    return [[MTGetItemListResponse alloc] init];
}

@end
