//
//  AppDelegate.m
//  AddressOCR
//
//  Created by Aadesh Patel on 12/23/14.
//  Copyright (c) 2014 Aadesh Patel. All rights reserved.
//

#import "AppDelegate.h"
#import <TesseractOCR/TesseractOCR.h>

@interface AppDelegate ()

@property (nonatomic, strong) Tesseract *tesseract;
- (void)storeEnglishLanguageFile;

@end

@implementation AppDelegate

static AppDelegate *sharedDelegate;
+ (AppDelegate *)sharedDelegate {
    if (!sharedDelegate)
        sharedDelegate = [[AppDelegate alloc] init];
    
    return sharedDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    sharedDelegate = [AppDelegate sharedDelegate];
    [sharedDelegate setUpTesseractOCR];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Getters

+ (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (NSString *)getTextFromImage:(UIImage *)image {
    if (image) {
        _tesseract.image = [image blackAndWhite];
        [_tesseract recognize];
        
        return [_tesseract recognizedText];
    }
    
    return nil;
}

- (void)progressImageRecognitionForTesseract:(Tesseract *)tesseract {
    NSLog(@"Progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract *)tesseract {
    return NO;
}

//Setters

- (void)storeEnglishLanguageFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDirectory stringByAppendingPathComponent:@"/tessdata/eng.traineddata"];
    if(![fileManager fileExistsAtPath:path])
    {
        NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/tessdata/eng.traineddata"]];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:[docsDirectory stringByAppendingPathComponent:@"/tessdata"] withIntermediateDirectories:YES attributes:nil error:&error];
        [data writeToFile:path atomically:YES];
    }
}

- (void)setUpTesseractOCR {
    [self storeEnglishLanguageFile];
    
    _tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
    _tesseract.delegate = self;
    [_tesseract setVariableValue:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,:;" forKey:@"tessedit_char_whitelist"];
    //[_tesseract setVariableValue:@".,:;'" forKey:@"tessedit_char_blacklist"];

}

@end
