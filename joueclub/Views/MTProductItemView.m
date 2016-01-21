//
//  MTProductItemView.m
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "MTProductItemView.h"

@interface MTProductItemView()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *promoStartHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *promoEndHeight;
@end

@implementation MTProductItemView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

-(void)shouldDisplayPromo:(BOOL)shouldDisplayPromo {
    if(shouldDisplayPromo == false) {
        self.promoEndLabel.text = @"";
        self.promoStartLabel.text = @"";
        //self.promoEndHeight.constant = 0;
        self.promoStartHeight.constant = 0;
    }
    else {
        //self.promoEndHeight.constant = 21;
        self.promoStartHeight.constant = 21;
    }
}

@end
