//
//  MTHomeViewController.m
//  joueclub
//
//  Created by Ross on 10/18/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTSideBarConfig.h"
#import "MTProgressHUD.h"
#import "MTJoueSyncManager.h"
#import "MTDataModel.h"
#import "MTGetPostsResponse.h"
#import "JCPostsItem.h"
#import "MTProgressHUD.h"

@interface MTHomeViewController ()<MTSidebarProtocol>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation MTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchPosts];
}

- (void) fetchPosts {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:false];
    
    [[MTJoueSyncManager sharedManager] getPosts:^(SDRequest *request, SDResult *response) {
        
        NSArray *items = [[MTDataModel sharedDatabaseStorage] fetchObjectsForEntityName:@"JCPostsItem" withPredicate:nil];
        
        if(items.count > 0) {
            JCPostsItem *item = [items firstObject];
            [self.webView loadHTMLString:[item.content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
            self.webView.scalesPageToFit = YES;
        }
        
        [[MTProgressHUD sharedHUD] dismiss];
    }];
}


- (void)cleanup {
    self.webView.delegate = nil;
}

@end
