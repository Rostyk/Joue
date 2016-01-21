//
//  BarcodeViewController.m
//  onninen
//
//  Created by Ross on 1/21/15.
//  Copyright (c) 2015 Varpu. All rights reserved.
//

#import "MTBarcodeViewController.h"
#import "MTJoueSyncManager.h"

#define NAVIGATION_BAR_HEIGHT                          44

@interface MTBarcodeViewController ()
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong)AVCaptureDeviceInput *input;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic)BOOL _running;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic) BOOL blockScanning;
@end

@implementation MTBarcodeViewController

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.blockScanning = NO;
    [self startReading];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopReading];
}

#pragma mark barcode scanning
- (BOOL)startReading {
    
    [self turnTorchOn:true];
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if(!error) {
        self.session = [[AVCaptureSession alloc] init];
        
        self.output = [[AVCaptureMetadataOutput alloc] init];
        [self.session addOutput:self.output];
        [self.session addInput:self.input];
        
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

        NSMutableArray *types = [NSMutableArray new];
        [types addObjectsFromArray:
            @[ // iOS 7 and later
              AVMetadataObjectTypeQRCode,
              AVMetadataObjectTypeEAN13Code,
              AVMetadataObjectTypePDF417Code,
              AVMetadataObjectTypeAztecCode,
              AVMetadataObjectTypeCode93Code,
              AVMetadataObjectTypeEAN8Code,
              AVMetadataObjectTypeCode39Mod43Code,
              AVMetadataObjectTypeCode39Code,
              AVMetadataObjectTypeUPCECode,
              AVMetadataObjectTypeCode128Code
              ]];
        if (&AVMetadataObjectTypeInterleaved2of5Code != NULL) {
            [types addObjectsFromArray:
                @[ // iOS 8 and later
               AVMetadataObjectTypeInterleaved2of5Code,
               AVMetadataObjectTypeDataMatrixCode,
               AVMetadataObjectTypeITF14Code
               ]];
        }
        self.output.metadataObjectTypes = types;

        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        AVCaptureConnection *con = self.preview.connection;
        
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if(orientation == UIDeviceOrientationLandscapeLeft)
           con.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        else if(orientation == UIDeviceOrientationLandscapeRight)
           con.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        else
            con.videoOrientation = AVCaptureVideoOrientationPortrait;
        
        [self.view.layer insertSublayer:self.preview atIndex:1];
        [self.session startRunning];
        return YES;
    }
    [self handleError:error];
    
    return NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIDeviceOrientation deviceOrientation =
    [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation;
    
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        avcaptureOrientation  = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        avcaptureOrientation  = AVCaptureVideoOrientationLandscapeLeft;
    else
        avcaptureOrientation  = AVCaptureVideoOrientationPortrait;
    
    [self.preview.connection setVideoOrientation:avcaptureOrientation];
    
    self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)stopReading{
     [self turnTorchOn:false];
    // Stop video capture and make the capture session object nil.
    [self.session stopRunning];
    
    // Remove the video preview layer from the viewPreview view's layer.
    //[_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0 && self.blockScanning == NO) {
        self.blockScanning = YES;
        AudioServicesPlaySystemSound(1108);
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            [self stopReading];
            [MTJoueSyncManager sharedManager].barCode = [metadataObj stringValue];
            NSLog(@"Metadata %@", [metadataObj stringValue]);
            [self showActionSheet];
    }
}

#pragma mark

- (void)alert:(NSString *)alertString settingsButton:(BOOL)settingsButton{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertString
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:settingsButton ? @"Settings" : nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
          [self.navigationController popViewControllerAnimated:YES];
    }
    //Settings
    if(buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    //return supported orientation masks
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark error handling

- (void)handleError:(NSError *)error {
    if(error.code == -11852) {
        [self alert:@"Please allow the application access to the camera. You can do this from iPhone's Privacy settings." settingsButton:YES];
    }
    else {
        [self alert:error.localizedFailureReason settingsButton:NO];
    }
}


#pragma mark action sheet

- (void)showActionSheet {
    
    NSString *openString =  @"Open" ;
    NSString *cancelSting = @"Cancel";
    NSString *productCode = [MTJoueSyncManager sharedManager].barCode;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:productCode delegate:self cancelButtonTitle:cancelSting destructiveButtonTitle:nil otherButtonTitles:
                            openString,
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self openProduct];
                    break;
                case 1: {
                    self.blockScanning = NO;
                    [self.session startRunning];
                    break;
                }
            }
            break;
        }
        default:
            
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //[BarcodeProvider sharedProvider].barcode = nil;
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)openProduct {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) turnTorchOn: (bool) on {
    
    // check if flashlight available
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                //torchIsOn = YES; //define as a variable/property if you need to know status
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                //torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

@end
