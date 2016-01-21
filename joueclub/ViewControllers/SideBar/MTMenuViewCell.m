//
//  MTMenuViewCell.m
//  PineTar
//
//  Created by Stepan Koposov on 3/4/15.
//  Copyright (c) 2015 Stepan Koposov. All rights reserved.
//

#import "MTMenuViewCell.h"
#import "MTSideBarConfig.h"

@interface MTMenuViewCell()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightConstraint;
@end

@implementation MTMenuViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self selectedCellStatus:selected];

    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.090 green:0.145 blue:0.231 alpha:0.520];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)selectedCellStatus:(BOOL)isSelected {
    self.titleLabel.textColor =  isSelected ? [UIColor colorWithRed:192./255. green:0.0 blue:0.0 alpha:1.000]
    :[UIColor colorWithRed:0.545 green:0.643 blue:0.776 alpha:1.000];
    switch (self.cellStatus) {
        case 0:
            self.leftImage.image  = isSelected ? [UIImage imageNamed:@"ic_home_active"]:[UIImage imageNamed:@"ic_home"];
            break;
        case 1:
            self.leftImage.image  = isSelected ? [UIImage imageNamed:@"ic_list_active"]:[UIImage imageNamed:@"ic_list"];
            break;

        case 2:
            self.leftImage.image  = isSelected ? [UIImage imageNamed:@"ic_settings_active"]:[UIImage imageNamed:@"ic_settings"];
            break;
        case 3:
            self.leftImage.image  = isSelected ? [UIImage imageNamed:@"ic_about_active"]:[UIImage imageNamed:@"ic_about"];
            break;

        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //
    self.rightConstraint.constant = self.contentView.bounds.size.width * RIGHT_GAP;
}

@end
