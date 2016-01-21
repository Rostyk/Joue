//
//  MTGetPostsRequest.m
//  joueclub
//
//  Created by Ross on 10/18/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTGetPostsRequest.h"
#import "MTGetPostsResponse.h"

@implementation MTGetPostsRequest

- (NSMutableURLRequest *)serviceURLRequest
{
    NSMutableString *configurationString = [NSMutableString stringWithFormat:@"%@/posts/%@", [SDUserSettings postsServiceURL], self.postsNumber];
    
    NSMutableURLRequest *networkRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:configurationString]];
    
    networkRequest.HTTPMethod = @"GET";
    return networkRequest;
}

- (SDResult *)emptyResponse
{
    return [[MTGetPostsResponse alloc] init];
}

@end
