//
//  MTDataModel.h
//  rent
//
//  Created by Nick Savula on 6/4/15.
//  Copyright (c) 2015 Maliwan Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

// NOTE: to update models:  mogenerator -m MTDataModel.xcdatamodel/ -O ../Classes/ --template-var arc=YES

@class JCProduct;
@class JCPostsItem;

@interface MTDataModel : NSObject

+ (MTDataModel *)sharedDatabaseStorage;

- (void)saveContext;
- (NSArray *)getShellProducts;
- (void)removeAllProducts;
- (void)removeAllPosts;

// parsing routines
- (NSArray *)parseItemListData:(NSData *)data;
- (JCPostsItem *)parsePostsData:(NSData *)data;
- (void)removeDuplicates:(NSArray *)newItems;
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                         withPredicate:(NSPredicate *)predicate;

@end
