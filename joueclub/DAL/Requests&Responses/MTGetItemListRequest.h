//
//  MTGetItemListRequest.h
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "SDRequest.h"

@interface MTGetItemListRequest : SDRequest

@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSNumber *page;
@end
