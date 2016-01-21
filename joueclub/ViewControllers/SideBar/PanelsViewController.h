//
//  RootViewController.h
//  arthome
//
//  Created by Steven on 13/10/14.
//  Copyright (c) 2014 Umbrella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"

@interface PanelsViewController : JASidePanelController

- (void)setPanels;
- (void)setCentralPanelControllerWithIdentifier:(NSString *)identifier;
- (void)setCentralPanelControllerViewController:(UIViewController *)viewController;

@property (nonatomic, assign) BOOL isPanelShadow;

@end
