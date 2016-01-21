//
//  LeftSideBarViewController.m
//  arthome
//
//  Created by Steven on 13/10/14.
//  Copyright (c) 2014 Umbrella. All rights reserved.
//

#import "MTMenuViewController.h"
#import "PanelsViewController.h"
#import "MTMenuViewCell.h"
#import "LKBadgeView.h"
#import "MTDataModel.h"
#import "MTItemListController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Blur.h"
#import "MTSideBarConfig.h"
#import "MTSettignsViewController.h"
#import "MTHomeViewController.h"
#import "MTAboutViewController.h"

static NSString * const kMenuCellCelldentifier = @"MTMenuViewCell";

@interface MTMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarRightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIImageView *facebookUserAvatar;
@property (nonatomic, weak) IBOutlet UILabel *facebookUserName;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *containerTopBar;


@end

@implementation MTMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.facebookUserAvatar.layer.masksToBounds = YES;
    self.facebookUserAvatar.layer.cornerRadius = 27.0;
    self.facebookUserAvatar.layer.borderWidth = 1.5;
    self.facebookUserAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];


    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.containerTopBar.bounds];
    self.containerTopBar.layer.masksToBounds = NO;
    self.containerTopBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerTopBar.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.containerTopBar.layer.shadowOpacity = 0.3f;
    self.containerTopBar.layer.shadowPath = shadowPath.CGPath;

   // self.backgroundImageView.image = [[UIImage imageNamed:@"background"] blurredImage:0.7f];


    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];

    if (IS_IPHONE_6_PLUS) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
        CGPoint point = self.tableView.contentOffset;
        point .y -= self.tableView.rowHeight;
        self.tableView.contentOffset = point;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    /* 0.25 is the JASidePanelViewCOntroller's (1 - leftGapPercentage) */
    self.topBarRightConstraint.constant = self.view.bounds.size.width * RIGHT_GAP;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTMenuViewCell *menuViewCell = (MTMenuViewCell *)[tableView dequeueReusableCellWithIdentifier:kMenuCellCelldentifier];
    if (menuViewCell == nil) {
        menuViewCell = [[MTMenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMenuCellCelldentifier];
    }

    switch (indexPath.row) {
        case 0:{
            menuViewCell.cellStatus = MTMenuCellHome;
            menuViewCell.titleLabel.text = @"Accueil";
            menuViewCell.leftImage.image = [UIImage imageNamed:@"ic_home"];
        } break;
        case 1:{
            menuViewCell.cellStatus = MTMenuCellProducts;
            menuViewCell.titleLabel.text = @"Produits";
            menuViewCell.leftImage.image = [UIImage imageNamed:@"ic_list"];
        } break;
            
        case 2:{
            menuViewCell.cellStatus = MTMenuCellSettings;
            menuViewCell.titleLabel.text = @"Paramétres";
            menuViewCell.leftImage.image = [UIImage imageNamed:@"ic_settings"];
        } break;
            
        case 3:{
            menuViewCell.cellStatus = MTMenuCellAbout;
            menuViewCell.titleLabel.text = @"A propos";
            menuViewCell.leftImage.image = [UIImage imageNamed:@"ic_settings"];
        } break;

        default:
            break;
    }
    
    return menuViewCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPHONE_4)
       return 58;
    
    if(IS_IPHONE_5)
       return 64;
    
    if(IS_IPHONE_6)
       return 64;
    
    if(IS_IPHONE_6_PLUS)
       return 72;
    
    return 40;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MTHomeViewController *homeController = [main instantiateViewControllerWithIdentifier:@"MTHomeViewController"];
            [[AppDelegate sharedPanel] setCentralPanelControllerViewController:homeController];
        } break;
            
        case 1:{
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MTItemListController *productListController = [main instantiateViewControllerWithIdentifier:@"MTItemListController"];
            
            productListController.title = @"Joue Club";
            [[AppDelegate sharedPanel] setCentralPanelControllerViewController:productListController];
        } break;
        case 2:{
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MTSettignsViewController *settingsController = [main instantiateViewControllerWithIdentifier:@"MTSettignsViewController"];
            [[AppDelegate sharedPanel] setCentralPanelControllerViewController:settingsController];
        } break;
            
        case 3:{
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MTSettignsViewController *aboutController = [main instantiateViewControllerWithIdentifier:@"MTAboutViewController"];
            [[AppDelegate sharedPanel] setCentralPanelControllerViewController:aboutController];
        } break;

        default:
            break;
    }
}

@end
