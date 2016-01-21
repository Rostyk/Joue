//
//  MTProductItemView.h
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProductItemView : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UILabel *discountPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *regularPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *salePriceLabel;

@property (nonatomic, weak) IBOutlet UILabel *refLabel;
@property (nonatomic, weak) IBOutlet UILabel *codeBarreLabel;

@property (nonatomic, weak) IBOutlet UILabel *promoStartLabel;
@property (nonatomic, weak) IBOutlet UILabel *promoEndLabel;


-(void)shouldDisplayPromo:(BOOL)shouldDisplayPromo;
@end
