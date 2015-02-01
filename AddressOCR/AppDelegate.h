//
//  AppDelegate.h
//  AddressOCR
//
//  Created by Aadesh Patel on 12/23/14.
//  Copyright (c) 2014 Aadesh Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, TesseractDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)sharedDelegate;

+ (BOOL)isCameraAvailable;

- (void)setUpTesseractOCR;
- (NSString *)getTextFromImage:(UIImage *)image;

@end

