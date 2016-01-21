//
//  MTMenuViewCell.h
//  PineTar
//
//  Created by Stepan Koposov on 3/4/15.
//  Copyright (c) 2015 Stepan Koposov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTMenuCellStatus) {
    MTMenuCellHome,
    MTMenuCellProducts,
    MTMenuCellSettings,
    MTMenuCellAbout
};

@interface MTMenuViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;

@property (assign, nonatomic) MTMenuCellStatus cellStatus;
@end
