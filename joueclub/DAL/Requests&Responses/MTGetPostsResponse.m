//
//  MTGetPostsResposne.m
//  joueclub
//
//  Created by Ross on 10/18/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTGetPostsResponse.h"

@implementation MTGetPostsResponse
- (void)parseResponseData:(NSData *)responseData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.postsItem = [[MTDataModel sharedDatabaseStorage] parsePostsData:responseData];
    });
}
@end
