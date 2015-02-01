//
//  FlashlightButton.m
//  AddressOCR
//
//  Created by Aadesh Patel on 12/24/14.
//  Copyright (c) 2014 Aadesh Patel. All rights reserved.
//

#import "FlashlightButton.h"
#import <AVFoundation/AVFoundation.h>

@implementation FlashlightButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView* flashlightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        //SET IMAGE
        [self addSubview:flashlightIcon];
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 25.0f;
        
        [self addTarget:self action:@selector(toggleFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (IBAction)toggleFlashlight:(id)sender {
    AVCaptureDevice *flashlight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([flashlight isTorchAvailable] && [flashlight isTorchModeSupported:AVCaptureTorchModeOn]) {
        if ([flashlight lockForConfiguration:nil]) {
            if ([flashlight isTorchActive])
                [flashlight setTorchMode:AVCaptureTorchModeOn];
            else
                [flashlight setTorchMode:AVCaptureTorchModeOff];
        }
    }
}

@end
