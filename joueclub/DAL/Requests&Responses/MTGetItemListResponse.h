//
//  MTGetItemListResponse.h
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "SDResult.h"

@interface MTGetItemListResponse : SDResult

@property (nonatomic, strong) NSArray *items;

@end
