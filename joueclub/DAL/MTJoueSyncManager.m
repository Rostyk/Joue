//
//  MTJoueSyncManager.m
//  joueclub
//
//  Created by Ross on 10/12/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTJoueSyncManager.h"
#import "MTGetItemListRequest.h"
#import "MTGetItemListResponse.h"
#import "MTGetPostsRequest.h"
#import "MTGetPostsResponse.h"

#define NUMBER_OF_PAGES                   90
#define NUMBER_OF_SIMULTANEOUS_REQUESTS    30

@interface MTJoueSyncManager()
@property (nonatomic, strong) SDRequestGeneralProgressBlock progressBlock;
@property (nonatomic, strong) SDRequestCompletionBlock completion;
@property (nonatomic, strong) SDRequestCompletionBlock postsCompletion;
@property (nonatomic) unsigned int numberOfRequestsPerformed;
@property (nonatomic) unsigned int totalNumberOfRequestsPerformed;
@property (nonatomic, strong) NSMutableArray *currentResuests;
@end

@implementation MTJoueSyncManager

NSString *imageChangedNotification = @"imageChangedNotification";
NSString *syncAllFinishedNotification = @"SyncAllFinishednotification";
NSString *syncChagesFinished = @"SyncChangesFinishednotification";
NSString *jarryUserDefaultsKey = @"jarryUserDefaultsKey";
NSString *gourbeyreUserDefaultsKey = @"gourbeyreUserDefaultsKey";

+ (MTJoueSyncManager *)sharedManager {
    static MTJoueSyncManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil) {
            sharedMyManager = [[MTJoueSyncManager alloc] init];
            [sharedMyManager setupValues];
        }
    }
    return sharedMyManager;
}

- (void)setupValues {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    if([[defs objectForKey:jarryUserDefaultsKey] boolValue] == false && [[defs objectForKey:gourbeyreUserDefaultsKey] boolValue] == false) {
        [self gourbeyreSelected];
    }
    else {
        if([self isGourbeyreSelected]) {
            self.URL = [self gourbeyreURL];
        }
        if([self isJarrySelected]) {
            self.URL = [self jarryURL];
        }
    }
}

- (void)cancelRequests {
    for(SDRequest *request in self.currentResuests) {
        [request cancel];
    }
    
    _isSyncing = false;
}

- (void)syncAll:(SDRequestCompletionBlock)completion
       progress:(SDRequestGeneralProgressBlock)progress {
    /*Cancel previous equests*/
    self.progressBlock = progress;
    [self.currentResuests removeAllObjects];
    
    self.completion = completion;
    
    _isSyncing = true;
    [[MTDataModel sharedDatabaseStorage] removeAllProducts];
    
    /*Eliminate previous request if exists*/
    if(self.currentResuests) {
        for(SDRequest *request in self.currentResuests) {
            [request cancel];
        }
        self.currentResuests = nil;
    }
    
    self.totalNumberOfRequestsPerformed = 0;
    
    /*Add first NUMBER_OF_SIMULTANEOUS_REQUESTS to the queqe. When they complete, we
     add the next ones. Utill we reach the number NUMBER_OF_PAGES.*/
    [self addFewRequests];
    
}

/*Add NUMBER_OF_SIMULTANEOUS_REQUESTS to the que*/
-(void)addFewRequests {
    self.numberOfRequestsPerformed = 0;
    for(int i=self.totalNumberOfRequestsPerformed; i<self.totalNumberOfRequestsPerformed + NUMBER_OF_SIMULTANEOUS_REQUESTS; i++) {
        [self addRequests:i];
    }
}

- (void)addRequests:(unsigned int)i {
    MTGetItemListRequest *request = [MTGetItemListRequest requestWithOwner:self];
    [self.currentResuests addObject: request];
    request.page = @(i);
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        [self.currentResuests removeObject:request];
        self.numberOfRequestsPerformed++;
        self.totalNumberOfRequestsPerformed++;
        
        NSLog(@"Total requests: %d", self.totalNumberOfRequestsPerformed);
        self.progressBlock(self.totalNumberOfRequestsPerformed*1.0 / NUMBER_OF_PAGES * 1.0);
        if(self.numberOfRequestsPerformed == NUMBER_OF_SIMULTANEOUS_REQUESTS)  {
            /*We reached the final number of all pages*/
            if(self.totalNumberOfRequestsPerformed == NUMBER_OF_PAGES) {
                _isSyncing = false;
                self.completion(request, response);
                return;
            }
            else if(self.totalNumberOfRequestsPerformed < NUMBER_OF_PAGES){
                /*Add the next number of requests*/
                [self addFewRequests];
            }
        }
        
    };
    
    [[SDDispatcher sharedInstance] processRequest:request];
}

- (void)syncLatestChanges {
    
}

- (void) getPosts:(SDRequestCompletionBlock)completion {
    [[MTDataModel sharedDatabaseStorage] removeAllPosts];
    self.postsCompletion = completion;
    
    MTGetPostsRequest *request = [MTGetPostsRequest requestWithOwner:self];
    [self.currentResuests addObject: request];
    request.postsNumber = @(215);
    request.completionBlock = ^(SDRequest *request, SDResult *response)
    {
        self.postsCompletion(request, response);
    };
    
    [[SDDispatcher sharedInstance] processRequest:request];
}


- (void)gourbeyreSelected {
    self.URL = [self gourbeyreURL];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(true) forKey:gourbeyreUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setObject:@(false) forKey:jarryUserDefaultsKey];
}

- (void)jarrySelected {
    self.URL = [self jarryURL];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(false) forKey:gourbeyreUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setObject:@(true) forKey:jarryUserDefaultsKey];
}

- (BOOL)isJarrySelected {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:jarryUserDefaultsKey] boolValue];
}

- (BOOL)isGourbeyreSelected {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:gourbeyreUserDefaultsKey] boolValue];
}

- (NSString *)jarryURL {
    return @"https://192.168.0.125:8069";
}

- (NSString *)gourbeyreURL {
    return @"https://81.248.168.84:8069";
}

- (NSMutableArray *)currentResuests {
    if(!_currentResuests) {
        _currentResuests = [[NSMutableArray alloc] init];
    }
    
    return _currentResuests;
}


@end
