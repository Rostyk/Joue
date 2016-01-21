//
//  MTSettignsViewController.m
//  joueclub
//
//  Created by Ross on 10/15/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTSettignsViewController.h"
#import "MTJoueSyncManager.h"

@interface MTSettignsViewController ()
@property (nonatomic, weak) IBOutlet UISwitch *gourbeyreSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *jarrySwitch;
@end

@implementation MTSettignsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (IBAction)gourbeyreSwitchChnaged:(id)sender {
    if(self.gourbeyreSwitch.on) {
        self.jarrySwitch.on = false;
        [[MTJoueSyncManager sharedManager] gourbeyreSelected];
    }
    else {
        self.jarrySwitch.on = true;
        [[MTJoueSyncManager sharedManager] jarrySelected];
    }
    
}

- (IBAction)jarrySwitchChnaged:(id)sender {
    if(self.jarrySwitch.on) {
        self.gourbeyreSwitch.on = false;
        [[MTJoueSyncManager sharedManager] jarrySelected];
    }
    else {
        self.gourbeyreSwitch.on = true;
        [[MTJoueSyncManager sharedManager] gourbeyreSelected];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.jarrySwitch.on = [[MTJoueSyncManager sharedManager] isJarrySelected];
    self.gourbeyreSwitch.on = [[MTJoueSyncManager sharedManager] isGourbeyreSelected];
}
@end
