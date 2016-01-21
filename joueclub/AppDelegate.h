//
//  AppDelegate.h
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PanelsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
+ (PanelsViewController *)sharedPanel;

@property (strong, nonatomic) UIWindow *window;



@end

