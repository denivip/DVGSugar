//
//  UIView+FindAndResignFirstResponder.h
//  Together
//
//  Created by Ilya on 05.10.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "PSTAlertController.h"
#import "SysInfo.h"
@import Photos;

@interface SysAccess: NSObject

+ (void)showAccessPermissionError:(NSString*)pListKey;

+ (BOOL)isPhotoLibraryAccessible;
+ (BOOL)checkPhotoLibraryAccessWithCompletion:(dispatch_block_t)onOk;

+ (BOOL)isMicrophoneAccessible;
+ (BOOL)checkMicrophoneAccessWithCompletion:(dispatch_block_t)onOk;

+ (BOOL)isCameraAccessible;
+ (BOOL)checkCameraAccessWithCompletion:(dispatch_block_t)onOk;
+ (BOOL)checkCaptureAccessWithCompletion:(dispatch_block_t)onOk;

@end
