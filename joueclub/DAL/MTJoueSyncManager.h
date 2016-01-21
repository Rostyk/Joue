//
//  MTJoueSyncManager.h
//  joueclub
//
//  Created by Ross on 10/12/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDRequest.h"

@interface MTJoueSyncManager : NSObject

extern NSString *imageChangedNotification;
extern NSString *syncAllFinishedNotification;
extern NSString *syncChangesFinished;
extern NSString *jarryUserDefaultsKey;
extern NSString *gourbeyreUserDefaultsKey;

@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *barCode;
@property (nonatomic, readonly) BOOL isSyncing;

+ (MTJoueSyncManager *)sharedManager;
- (void)cancelRequests;
- (void) getPosts:(SDRequestCompletionBlock)completion;
- (void)syncAll:(SDRequestCompletionBlock)completion
       progress:(SDRequestGeneralProgressBlock)progress;

- (void)syncLatestChanges;

- (void)gourbeyreSelected;
- (void)jarrySelected;

- (BOOL)isJarrySelected;
- (BOOL)isGourbeyreSelected;
@end
