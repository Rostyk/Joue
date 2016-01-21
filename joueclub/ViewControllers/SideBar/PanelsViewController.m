//
//  RootViewController.m
//  arthome
//
//  Created by Steven on 13/10/14.
//  Copyright (c) 2014 Umbrella. All rights reserved.
//

#import "PanelsViewController.h"

#import "MTMenuViewController.h"


@interface PanelsViewController ()

@end

@implementation PanelsViewController

- (void)awakeFromNib {
    self.isShadow = YES;
}

- (void)setPanels {
    self.isShadow = self.isPanelShadow;
    self.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"MTMenuViewController"];
    self.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard    instantiateViewControllerWithIdentifier:@"MTHomeViewController"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCentralPanelControllerWithIdentifier:(NSString *)identifier {
    @autoreleasepool {
        self.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:identifier]];
    }
}

- (void)setCentralPanelControllerViewController:(UIViewController *)viewController {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.centerPanel = navController;
}

@end
