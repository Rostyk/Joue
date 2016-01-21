//
//  MTItemDetailsController.m
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "MTItemDetailsController.h"
#import "FDTakeController.h"
#import "JCProduct.h"
#import "MTDataModel.h"
#import "MTJoueSyncManager.h"

#define LONG_PRODUCT_TITLE                    20

@interface MTItemDetailsController () <FDTakeDelegate>

@property (nonatomic, weak) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) FDTakeController *takeController;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topImageURLTextFieldViewConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topDViewConstraint;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray*interButtonContraints;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *urlContainerView;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *dViews;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *dCaptions;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *dLabels;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *promoStartConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *promoEndConstraint;
@property (nonatomic, weak) IBOutlet UILabel *promoEndLabel;
@property (nonatomic, weak) IBOutlet UILabel *promoStartLabel;
@property (nonatomic, weak) IBOutlet UILabel *salesPrice;
@property (nonatomic, weak) IBOutlet UILabel *deliveryDateLabel;

@property (nonatomic, weak) IBOutlet UILabel *regularPrice;
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UILabel *refLabel;
@property (nonatomic, weak) IBOutlet UILabel *manufacturerLabel;
@property (nonatomic, weak) IBOutlet UILabel *SKULabel;

@property (nonatomic, weak) IBOutlet UILabel *d1Label;
@property (nonatomic, weak) IBOutlet UILabel *d2Label;
@property (nonatomic, weak) IBOutlet UILabel *d3Label;
@property (nonatomic, weak) IBOutlet UILabel *d4Label;
@property (nonatomic, weak) IBOutlet UILabel *d5Label;
@property (nonatomic, weak) IBOutlet UILabel *d6Label;
@property (nonatomic, weak) IBOutlet UILabel *d7Label;
@property (nonatomic, weak) IBOutlet UILabel *rLabel;

@property (nonatomic, weak) IBOutlet UIView *d1View;
@property (nonatomic, weak) IBOutlet UIView *d2View;
@property (nonatomic, weak) IBOutlet UIView *d3View;
@property (nonatomic, weak) IBOutlet UIView *d4View;
@property (nonatomic, weak) IBOutlet UIView *d5View;
@property (nonatomic, weak) IBOutlet UIView *d6View;
@property (nonatomic, weak) IBOutlet UIView *d7View;
@property (nonatomic, weak) IBOutlet UIView *rView;

@end

@implementation MTItemDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.product.title;
    
    float fontSize = 16.0f;
    
    if(self.product.title.length > LONG_PRODUCT_TITLE) {
        fontSize = 13.0f;
    }
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationController.navigationBar.titleTextAttributes = @{
    NSForegroundColorAttributeName: [UIColor colorWithRed:168./255. green:0.0 blue:0.0 alpha:1],
    NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:fontSize]};
    
    //Adjust red views container
    self.containerView.layer.borderWidth = 0.5;
    self.containerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    //Adjust Url Text field
    self.urlTextField.layer.borderWidth = 0.5;
    self.urlTextField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.d1View.layer.cornerRadius = self.d1View.frame.size.width / 2.f;
    self.d2View.layer.cornerRadius = self.d2View.frame.size.width / 2.f;
    self.d3View.layer.cornerRadius = self.d3View.frame.size.width / 2.f;
    self.d4View.layer.cornerRadius = self.d4View.frame.size.width / 2.f;
    self.d5View.layer.cornerRadius = self.d5View.frame.size.width / 2.f;
    self.d6View.layer.cornerRadius = self.d6View.frame.size.width / 2.f;
    self.d7View.layer.cornerRadius = self.d7View.frame.size.width / 2.f;
    self.rView.layer.cornerRadius = self.rView.frame.size.width / 2.f;
    
    [self setupTakeController];
    if(self.product.deliveryDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yy"];
        
        NSString *deliveryDate = [formatter stringFromDate:self.product.deliveryDate];
        self.deliveryDateLabel.text = [NSString stringWithFormat:@"Livraison: %@",deliveryDate];
    }
    else {
        self.deliveryDateLabel.text = @"";
    }
    
    if(![self isFullCell:self.product]) {
        self.promoStartConstraint.constant = 0;
        self.promoEndConstraint.constant = 0;
        
        self.salesPrice.text = @"";
        self.regularPrice.text = [NSString stringWithFormat:@"%@ €", self.product.regularPrice];
    }
    else {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yy"];
        
        NSString *startDate = [formatter stringFromDate:self.product.promoStart];
        NSString *endDate = [formatter stringFromDate:self.product.promoEnd];
        self.promoStartLabel.text = [NSString stringWithFormat:@"Début promo: %@", startDate];
        self.promoEndLabel.text = [NSString stringWithFormat:@"Fin promo: %@", endDate];
        
        if (self.product.salePrice.length > 0)
        {
            self.salesPrice.text = [NSString stringWithFormat:@"%@ €", self.product.salePrice];
            NSString *priceText = [NSString stringWithFormat:@"%@ €", self.product.price];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:priceText];
            [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                    value:@2
                                    range:NSMakeRange(0, [attributeString length])];
            self.regularPrice.attributedText = attributeString;
        }
        else {
            self.salesPrice.text = @"";
            self.regularPrice.text = [NSString stringWithFormat:@"%@ €", self.product.regularPrice];
        }
    }
    __weak __typeof__(self) weakSelf = self;
    
    /*Check if there's a predefiend image*/
    if(self.product.customImage) {
        UIImage *image = [[UIImage alloc] initWithData:self.product.customImage];
        if(image.size.width > 100) {
            UIImage *scaledImage = [self imageWithImage:image scaledToSize:CGSizeMake(104, 104)];
            self.productImageView.image = scaledImage;
            
        }
        else {
            self.productImageView.image = image;
        }
    }
    /*Load image from URL*/
    else {
        [self loadImage:weakSelf.productImageView];
    }
    
    self.refLabel.text =  [NSString stringWithFormat:@"Ref: %@", self.product.refId];
    self.manufacturerLabel.text = [NSString stringWithFormat:@"Fabricant: %@",self.product.manufacturer];
    self.SKULabel.text = [NSString stringWithFormat:@"SKU: %@", self.product.sku];
    
    if (self.product.d1.length > 0 && self.product.d1.integerValue > 0)
    {
        self.d1Label.text = self.product.d1;
        self.d1View.backgroundColor = [UIColor greenColor];
    }
    
    if (self.product.d2.length > 0 && self.product.d2.integerValue > 0)
    {
        self.d2Label.text = self.product.d2;
        self.d2View.backgroundColor = [UIColor greenColor];
    }
    
    if (self.product.d3.length > 0 && self.product.d3.integerValue > 0)
    {
        self.d3Label.text = self.product.d3;
        self.d3View.backgroundColor = [UIColor greenColor];
    }
    
    if (self.product.d4.length > 0 && self.product.d4.integerValue > 0)
    {
        self.d4Label.text = self.product.d4;
        self.d4View.backgroundColor = [UIColor greenColor];
    }
    
    if (self.product.d5.length > 0 && self.product.d5.integerValue > 0)
    {
        self.d5Label.text = self.product.d5;
        self.d5View.backgroundColor = [UIColor greenColor];
    }
    
    if (self.product.d6.length > 0 && self.product.d6.integerValue > 0)
    {
        self.d6Label.text = self.product.d6;
        self.d6View.backgroundColor = [UIColor greenColor];
    }
    
    if (self.product.d7.length > 0 && self.product.d7.integerValue > 0)
    {
        self.d7Label.text = self.product.d7;
        self.d7View.backgroundColor = [UIColor greenColor];
    }
    
    if (self.product.r.length > 0 && self.product.r.integerValue > 0)
    {
        self.rLabel.text = self.product.r;
        self.rView.backgroundColor = [UIColor orangeColor];
    }
}

- (BOOL)isFullCell:(JCProduct *)product {
    BOOL isFullCell = NO;
    if(product.promoStart && product.promoEnd) {
        NSDate *now = [[NSDate alloc] init];
        if([self isDate:now
       inRangeFirstDate:product.promoStart
               lastDate:product.promoEnd]) {
            isFullCell = YES;
        }
    }
    
    return isFullCell;
}

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending &&
    [date compare:lastDate]  == NSOrderedAscending;
}



- (void) loadImage:(UIImageView *)imageView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.product.imageURL]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image != nil)
            {
                if(image.size.width > 208) {
                    UIImage *scaledImage = [self imageWithImage:image scaledToSize:CGSizeMake(104, 104)];
                    image = scaledImage;
                }
                
                [UIView transitionWithView:imageView
                                  duration:0.3f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    imageView.image = image;
                                } completion:nil];
            }
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MTJoueSyncManager sharedManager].barCode = nil;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    int viewWidth = 26;
    float spacing = (self.containerView.frame.size.width - viewWidth * 8 - 22) / 9;
    
    for(NSLayoutConstraint *constraint in self.interButtonContraints) {
       constraint.constant = spacing;
    }
    
    if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
        
        if(IS_IPHONE_4) {
            self.urlContainerView.hidden = YES;
            self.topImageURLTextFieldViewConstraint.constant = -30;
            self.topDViewConstraint.constant = -40;
            self.containerView.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        if(IS_IPHONE_5) {
            self.urlContainerView.hidden = YES;
            self.topImageURLTextFieldViewConstraint.constant = -32;
            self.topDViewConstraint.constant = -40;
            self.containerView.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        if(IS_IPHONE_6) {
            self.urlContainerView.hidden = YES;
            self.topImageURLTextFieldViewConstraint.constant = -20;
            self.topDViewConstraint.constant = -12;
        }
        
        if(IS_IPHONE_6_PLUS) {
            
        }
        
    } else {
        self.urlContainerView.hidden = NO;
        self.topImageURLTextFieldViewConstraint.constant = 0;
        
        int margin = 0;
        if(!self.product.deliveryDate) {
            margin = 24;
        }
        self.topDViewConstraint.constant = 23 - margin;
        self.containerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
}

#pragma mark photo url

- (void)setupTakeController {
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    self.takeController.takePhotoText = @"Take Photo";
    self.takeController.takeVideoText = @"Take Video";
    self.takeController.chooseFromPhotoRollText = @"Choose Existing";
    self.takeController.chooseFromLibraryText = @"Choose Existing";
    self.takeController.cancelText = @"Cancel";
    self.takeController.noSourcesText = @"No Photos Available";
}


- (IBAction)addUrlButtonClicked:(id)sender {
    NSString *enteredURL = self.urlTextField.text;
    
    NSURL *url = [NSURL URLWithString:enteredURL];
    if (url && url.scheme && url.host) {
        self.product.imageURL = enteredURL;
        [[MTDataModel sharedDatabaseStorage] saveContext];
         __weak __typeof__(self) weakSelf = self;
        [self loadImage:weakSelf.productImageView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:imageChangedNotification
                                                            object:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"The url is invalid"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)photoButtonClicked:(id)sender {
    [self.takeController takePhotoOrChooseFromLibrary];
}

#pragma mark - Image Picker Controller delegate methods

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
    //User cancelled the take photto controller
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    //self.urlTextField.text = info[@"UIImagePickerControllerReferenceURL"];
    UIImage *scaledImage = [self imageWithImage:photo scaledToSize:CGSizeMake(120, 120)];
    self.productImageView.image = scaledImage;
    self.product.customImage = UIImagePNGRepresentation(scaledImage);
    [[MTDataModel sharedDatabaseStorage] saveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:imageChangedNotification
                                                        object:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
