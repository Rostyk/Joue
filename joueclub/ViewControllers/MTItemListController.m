//
//  MTItemListController.m
//  joueclub
//
//  Created by Nick Savula on 7/28/15.
//  Copyright (c) 2015 Tilf AB. All rights reserved.
//

#import "MTItemListController.h"
#import "MTItemDetailsController.h"
#import "VCFloatingActionButton.h"
#import "MTProgressHUD.h"
#import "MTBarcodeViewController.h"

#import "SDDispatcher.h"
#import "MTGetItemListRequest.h"
#import "MTGetItemListResponse.h"

#import "JCProduct.h"
#import "MTProductItemView.h"
#import "MTJoueSyncManager.h"
#import "MTSideBarConfig.h"

#define SEARCH_BAR_HEIGHT             44
#define FLOATING_BUTTON_RIGHT_MARGIN  74

@implementation UISearchBar (enabler)

- (void) alwaysEnableSearch:(id<UITextFieldDelegate>)delegate {    
    // loop around subviews of UISearchBar
    NSMutableSet *viewsToCheck = [NSMutableSet setWithArray:[self subviews]];
    while ([viewsToCheck count] > 0) {
        UIView *searchBarSubview = [viewsToCheck anyObject];
        [viewsToCheck addObjectsFromArray:searchBarSubview.subviews];
        [viewsToCheck removeObject:searchBarSubview];
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                // always force return key to be enabled
                [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:NO];
            }
            @catch (NSException * e) {
                // ignore exception
            }
        }
    }
}

@end

@interface MTItemListController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, floatMenuDelegate, MTSidebarProtocol>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSMutableDictionary *productImages;

@property (nonatomic, strong) JCProduct *selectedProduct;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic) unsigned int keyboardHeight;
@property (nonatomic, strong) VCFloatingActionButton *codeBarButton;
@end

@implementation MTItemListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Joue Club";
    [self setupRefreshButton];
    self.productImages = [NSMutableDictionary dictionary];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTProductItemView"
                                                    bundle:nil]
                                forCellWithReuseIdentifier:@"productItemReuseIdentifier"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataLoaded:)
                                                 name:syncAllFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageChanged:)
                                                 name:imageChangedNotification
                                               object:nil];
    
    NSNotificationCenter *kShow = [NSNotificationCenter defaultCenter];
    [kShow addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    NSNotificationCenter *kHide = [NSNotificationCenter defaultCenter];
    [kHide addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardDidHideNotification object:nil];
    
    NSNotificationCenter *kChange = [NSNotificationCenter defaultCenter];
    [kChange addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    NSArray *allProducts = [[MTDataModel sharedDatabaseStorage] getShellProducts];
    if(allProducts.count == 0) {
         [self fetchData];
    }
    else {
        [self loadItemsFromDatabase];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Joue Club";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:168./255. green:0.0 blue:0.0 alpha:1],
        NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:22]};
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.title = 0;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    
    [self.searchBar alwaysEnableSearch:self];
    if([MTJoueSyncManager sharedManager].barCode) {
        NSArray *products = [[MTDataModel sharedDatabaseStorage] fetchObjectsForEntityName:@"JCProduct" withPredicate:nil];
        
        products = [products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"fieldcodebarre = %@", [MTJoueSyncManager sharedManager].barCode]];
        
        if(products.count > 0) {
            JCProduct *product = [products firstObject];
            self.selectedProduct = product;
            self.selectedIndexPath = [NSIndexPath indexPathForItem:[self.products indexOfObject:self.selectedProduct] inSection:0];
            [self performSegueWithIdentifier:@"ItemListToItemSegue"
                                      sender:self];
        }
        else {
            [MTJoueSyncManager sharedManager].barCode = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No product found matching the barcode"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

//set the edge inset in order avoid the collection view to be underneath the nav bar
- (void) viewDidLayoutSubviews {
    CGFloat top = self.topLayoutGuide.length;
    CGFloat bottom = self.bottomLayoutGuide.length;
    UIEdgeInsets newInsets = UIEdgeInsetsMake(top + 4 + SEARCH_BAR_HEIGHT, 0, bottom, 0);
    self.collectionView.contentInset = newInsets;
}

- (void)dataLoaded:(NSNotification *)notification {
    self.products = [[MTDataModel sharedDatabaseStorage]
                     fetchObjectsForEntityName:@"JCProduct"
                     withPredicate:nil];
    [self.collectionView reloadData];
}

- (void)imageChanged:(NSNotification *)notification {
    self.productImages[self.selectedProduct.productId] = nil;
    if(self.selectedIndexPath)
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
}

// Download the list of products
- (void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [self fetchData];
}

- (void)fetchData {
    [[MTProgressHUD sharedHUD] showOnView:self.view percentage:true];
    
    //self.collectionView.dataSource = nil;
    //self.collectionView.delegate = nil;
    
    [[MTJoueSyncManager sharedManager] syncAll:^(SDRequest *request, SDResult *response) {
        //self.collectionView.dataSource = self;
        if (response.isSuccess)
        {
            /*These are new products serialized into storge*/
            [self loadItemsFromDatabase];
        }
        else
        {
            /*These are old(received during the last successfull sync) products*/ 
            [self loadItemsFromDatabase];
        }
        
        [[MTProgressHUD sharedHUD] dismiss];
    } progress:^(float progress) {
        [[MTProgressHUD sharedHUD] updateLabelProgress:progress];
    }];
    
}

- (void)showSearchBar {
    //fade in
    [UIView animateWithDuration:0.6f animations:^{
        
        [self.searchBar setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
    }];
}

- (void)loadItemsFromDatabase {
    self.products = [[MTDataModel sharedDatabaseStorage]
                     fetchObjectsForEntityName:@"JCProduct"
                     withPredicate:nil];
    
    if (self.products.count <= 0)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"product list is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [self showSearchBar];
    self.backgroundImageView.hidden = true;
    [self setupFloatingButton];
    [self.collectionView reloadData];

}

- (void)setupFloatingButton {
    CGRect floatFrame = CGRectMake(self.view.bounds.size.width -  FLOATING_BUTTON_RIGHT_MARGIN, self.view.bounds.size.height - FLOATING_BUTTON_RIGHT_MARGIN, 50, 50);
    self.codeBarButton =
    [[VCFloatingActionButton alloc]initWithFrame:floatFrame
                                    normalImage:[UIImage imageNamed:@"ic_codebarre"]
                                 andPressedImage:[UIImage imageNamed:@"ic_codebarre"]
                                  withScrollview:self.collectionView];
    self.codeBarButton.labelArray = nil;
    self.codeBarButton.imageArray = nil;
    
    self.codeBarButton.hideWhileScrolling = YES;
    self.codeBarButton.delegate = self;
    
    [self.view addSubview:self.codeBarButton];
}

- (void)setupRefreshButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(fetchData)];
    self.navigationItem.rightBarButtonItem = button;
}

-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTBarcodeViewController *barcodeController = [main instantiateViewControllerWithIdentifier:@"MTBarcodeViewController"];
    [self.navigationController pushViewController:barcodeController animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ItemListToItemSegue"])
    {
        MTItemDetailsController *detailController = segue.destinationViewController;
        detailController.product = self.selectedProduct;
    }
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    
    //force the elements to get laid out again with the new size
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    [flowLayout invalidateLayout];

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending &&
    [date compare:lastDate]  == NSOrderedAscending;
}

- (BOOL)isFullCell:(NSIndexPath *)indexPath {
    BOOL isFullCell = NO;
    JCProduct *product = self.products[indexPath.row];
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

#pragma mark - Collection View Delegate & Data Source
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
        CGFloat width = self.collectionView.bounds.size.width / 2.f - 4.f;
        return CGSizeMake(width, 194);
        
    } else {
        CGFloat width = self.collectionView.bounds.size.width - 5.f;
        if([self isFullCell:indexPath]) {
            return CGSizeMake(width, 194);
        }
        else {
            return CGSizeMake(width, 174);
        }
    }
    
    return CGSizeMake(self.collectionView.bounds.size.width - 4.f, 178);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTProductItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productItemReuseIdentifier" forIndexPath:indexPath];
    
    JCProduct *product = self.products[indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yy"];
    
    if(![self isFullCell:indexPath]) {
        [cell shouldDisplayPromo:NO];
        cell.salePriceLabel.text = @"";
        cell.regularPriceLabel.text = [NSString stringWithFormat:@"%@€", product.regularPrice];

    }
    else {
        [cell shouldDisplayPromo:YES];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yy"];
        
        NSString *startDate = [formatter stringFromDate:product.promoStart];
        NSString *endDate = [formatter stringFromDate:product.promoEnd];
        cell.promoStartLabel.text = [NSString stringWithFormat:@"Début promo: %@", startDate];
        cell.promoEndLabel.text = [NSString stringWithFormat:@"Fin promo: %@", endDate];
        
        if (product.salePrice.length > 0)
        {
            cell.salePriceLabel.text = [NSString stringWithFormat:@"%@€", product.salePrice];
            NSString *priceText = [NSString stringWithFormat:@"%@€", product.price];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:priceText];
            [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                    value:@2
                                    range:NSMakeRange(0, [attributeString length])];
            cell.regularPriceLabel.attributedText = attributeString;
        }
        else {
            cell.salePriceLabel.text = @"";
            cell.regularPriceLabel.text = [NSString stringWithFormat:@"%@€" ,product.regularPrice];
        }
    }
    
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    
    BOOL isSyncing = [MTJoueSyncManager sharedManager].isSyncing;
    if(!isSyncing) {
        if(product.customImage) {
            UIImage *image = [[UIImage alloc] initWithData:product.customImage];
            if(image.size.width > 100) {
                UIImage *scaledImage = [self imageWithImage:image scaledToSize:CGSizeMake(104, 104)];
                self.productImages[product.productId] = scaledImage;
            }
            else {
                self.productImages[product.productId] = image;
            }
            
            cell.productImageView.image = image;
        }
        else {
            /*Check if the image existst*/
            if (self.productImages[product.productId] == nil)
            {
                cell.productImageView.image = nil;
                __weak __typeof__(cell) weakCell = cell;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:product.imageURL]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image != nil)
                        {
                            if(image.size.width > 100) {
                                UIImage *scaledImage = [self imageWithImage:image scaledToSize:CGSizeMake(104, 104)];
                                if(![MTJoueSyncManager sharedManager].isSyncing)
                                    self.productImages[product.productId] = scaledImage;
                                
                            }
                            else {
                                if(![MTJoueSyncManager sharedManager].isSyncing)
                                    self.productImages[product.productId] = image;
                                
                            }
                            
                            [UIView transitionWithView:weakCell.productImageView
                                              duration:0.3f
                                               options:UIViewAnimationOptionTransitionCrossDissolve
                                            animations:^{
                                                weakCell.productImageView.image = self.productImages[product.productId];
                                            } completion:nil];
                        }
                    });
                });
            }
            else
            {
                if(![MTJoueSyncManager sharedManager].isSyncing)
                    cell.productImageView.image = self.productImages[product.productId];
            }
        }
        cell.titleLabel.text = product.title;
        
        cell.refLabel.text = [NSString stringWithFormat:@"Ref: %@", product.refId];
        cell.codeBarreLabel.text = [NSString stringWithFormat:@"CodeBarre: %@", product.fieldcodebarre];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // navigate to product details
    self.selectedProduct = self.products[indexPath.row];
    self.selectedIndexPath = [NSIndexPath indexPathForItem:[self.products indexOfObject:self.selectedProduct] inSection:0];
    [self performSegueWithIdentifier:@"ItemListToItemSegue"
                              sender:self];
}

- (void)dealloc {
    /*[[NSNotificationCenter defaultCenter] removeObserver:self
                                              forKeyPath:syncAllFinishedNotification];*/
}

#pragma mark SearchBar delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchBar resignFirstResponder];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length > 0) {
        NSArray *allProducts = [[MTDataModel sharedDatabaseStorage] fetchObjectsForEntityName:@"JCProduct" withPredicate:nil];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(fieldcodebarre contains[cd] %@) OR (title contains[cd] %@) OR (manufacturer contains[cd] %@) OR (sku contains[cd] %@)", searchText, searchText, searchText, searchText];
        NSArray *results = [allProducts filteredArrayUsingPredicate:pred];
        
        self.products = results;
        [self reloadData];
    }
    else {
         NSArray *allProducts = [[MTDataModel sharedDatabaseStorage] fetchObjectsForEntityName:@"JCProduct" withPredicate:nil];
        self.products = allProducts;
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
        [self reloadData];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    [aSearchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)moveFloatingButtonUp {
    CGRect frame = self.codeBarButton.frame;
    frame.origin.x = self.view.bounds.size.width -  FLOATING_BUTTON_RIGHT_MARGIN;
    frame.origin.y = self.view.bounds.size.height - self.keyboardHeight - frame.size.height - 10;
    self.codeBarButton.frame = frame;
}

- (void)moveFloatingButtonDown {
    CGRect frame = self.codeBarButton.frame;
    frame.origin.x = self.view.bounds.size.width -  FLOATING_BUTTON_RIGHT_MARGIN;
    frame.origin.y = self.view.bounds.size.height - FLOATING_BUTTON_RIGHT_MARGIN;
    self.codeBarButton.frame = frame;

}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar;                       {
    [searchBar resignFirstResponder];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark screen cleanup

- (void)cleanup {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MTJoueSyncManager sharedManager] cancelRequests];
    self.productImages = nil;
    
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    
    self.products = nil;
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    self.keyboardHeight = keyboardFrame.size.height;
    
    [self moveFloatingButtonUp];
}

-(void)keyboardOffScreen:(NSNotification *)notification {
    [self moveFloatingButtonDown];
}

@end
