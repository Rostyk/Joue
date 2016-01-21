//
//  MTGetPostsResposne.h
//  joueclub
//
//  Created by Ross on 10/18/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDResult.h"
@class JCPostsItem;

@interface MTGetPostsResponse : SDResult
@property (nonatomic, strong) JCPostsItem *postsItem;
@end
