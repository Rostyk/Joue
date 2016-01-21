//
//  IMGActivityIndicator.h
//  IMGActivityIndicator
//
//  Created by Maijid Moujaled on 11/12/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMGActivityIndicator : UIView

- (id)initWithFrame:(CGRect)frame percentage:(BOOL)percentage;
- (void)updateLabelProgress:(float)progress;

@property (nonatomic, strong) UIColor *strokeColor;

@end
