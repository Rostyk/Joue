//
//  MTGetItemListResponse.m
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "MTGetItemListResponse.h"

@implementation MTGetItemListResponse

- (void)parseResponseData:(NSData *)responseData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.items = [[MTDataModel sharedDatabaseStorage] parseItemListData:responseData];
    });
}

@end
