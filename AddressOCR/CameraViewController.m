//
//  ViewController.m
//  AddressOCR
//
//  Created by Aadesh Patel on 12/23/14.
//  Copyright (c) 2014 Aadesh Patel. All rights reserved.
//

#import "CameraViewController.h"
#import "AppDelegate.h"
#import "FlashlightButton.h"
#import <TesseractOCR/TesseractOCR.h>

@interface CameraViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic) UIImagePickerController *picker;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = [AppDelegate sharedDelegate];
    
    NSLog(@"%@", [_appDelegate getTextFromImage:[UIImage imageNamed:@"test3.png"]]);
}

- (void)setUpImagePickerController {
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.showsCameraControls = NO;
    _picker.navigationBarHidden = YES;
    _picker.toolbarHidden = YES;
    
    //****REMINDER*****
    //Set Overlay View
    _picker.cameraOverlayView = nil;
}

- (void)initiateCamera {
    if ([AppDelegate isCameraAvailable]) {
        [self setUpImagePickerController];
        [self presentViewController:_picker animated:YES completion:nil];
    } else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera Not Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
