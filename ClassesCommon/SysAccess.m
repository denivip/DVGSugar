#import "SysAccess.h"
#import <DVGAlertController.h>

#ifdef ENVIRONMENT_AppExtension
#define COMPILE_FOR_EXTENSION
#endif

@implementation SysAccess

+ (BOOL)isPhotoLibraryAccessible {
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkPhotoLibraryAccessWithCompletion:(dispatch_block_t)onOk {
    if([SysAccess isPhotoLibraryAccessible]){
        if(onOk){
            dispatch_async(dispatch_get_main_queue(), ^{
                onOk();
            });
            return YES;
        }
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([SysAccess isPhotoLibraryAccessible]){
                if(onOk){
                    onOk();
                }
                return;
            }else{
                [SysAccess showAccessPermissionError:@"NSPhotoLibraryUsageDescription" title:nil];
            }
        });
    }];
    return NO;
}

+ (BOOL)isCameraAccessible {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status != AVAuthorizationStatusAuthorized) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkCameraAccessWithCompletion:(dispatch_block_t)onOk {
    if([SysAccess isCameraAccessible]){
        if(onOk){
            dispatch_async(dispatch_get_main_queue(), ^{
                onOk();
            });
            return YES;
        }
    }
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([SysAccess isCameraAccessible]){
                if(onOk){
                    onOk();
                }
                return;
            }else{
                [SysAccess showAccessPermissionError:@"NSCameraUsageDescription" title:nil];
            }
        });
    }];
    return NO;
}

+ (BOOL)isMicrophoneAccessible {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status != AVAuthorizationStatusAuthorized) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkMicrophoneAccessWithCompletion:(dispatch_block_t)onOk {
    if([SysAccess isMicrophoneAccessible]){
        if(onOk){
            dispatch_async(dispatch_get_main_queue(), ^{
                onOk();
            });
            return YES;
        }
    }
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([SysAccess isMicrophoneAccessible]){
                if(onOk){
                    onOk();
                }
                return;
            }else{
                [SysAccess showAccessPermissionError:@"NSMicrophoneUsageDescription" title:nil];
            }
        });
    }];
    return NO;
}

+ (BOOL)checkCaptureAccessWithCompletion:(dispatch_block_t)onOk {
    if([SysAccess isCameraAccessible] && [SysAccess isMicrophoneAccessible]){
        if(onOk){
            dispatch_async(dispatch_get_main_queue(), ^{
                onOk();
            });
            return YES;
        }
    }
    [SysAccess checkCameraAccessWithCompletion:^{
        [SysAccess checkMicrophoneAccessWithCompletion:onOk];
    }];
    return NO;
};

+ (BOOL)checkLocationInUseAccessWithCompletion:(dispatch_block_t)onOk {
    return [SysAccess checkLocationInUseAccessSilent:0 withCompletion:onOk];
}

+ (BOOL)checkLocationInUseAccessSilent:(BOOL)silent withCompletion:(dispatch_block_t)onOk {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        if(onOk){
            dispatch_async(dispatch_get_main_queue(), ^{
                onOk();
            });
        }
        return YES;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        static int maxSecs2wait = 60;
        static CLLocationManager *manager = nil;
        maxSecs2wait--;
        if(manager == nil){
            manager = [CLLocationManager new];
            [manager requestWhenInUseAuthorization];
        }
        if(maxSecs2wait>0){
            // Pinging self (no need to setup delegates, etc)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SysAccess checkLocationInUseAccessSilent:silent withCompletion:onOk];
            });
        }
    }else{
        if(!silent){
            [SysAccess showAccessPermissionError:@"NSLocationWhenInUseUsageDescription" title:NSLocalizedString(@"Location Access Required", nil)];
        }
    }
    return NO;
}

+ (BOOL)checkLocationAlwaysAccessWithCompletion:(dispatch_block_t)onOk {
    return [SysAccess checkLocationAlwaysAccessSilent:0 withCompletion:onOk];
}

+ (BOOL)checkLocationAlwaysAccessSilent:(BOOL)silent withCompletion:(dispatch_block_t)onOk{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
        if(onOk){
            dispatch_async(dispatch_get_main_queue(), ^{
                onOk();
            });
        }
        return YES;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        static int maxSecs2wait = 60;
        static CLLocationManager *manager = nil;
        maxSecs2wait--;
        if(manager == nil){
            manager = [CLLocationManager new];
            [manager requestAlwaysAuthorization];
        }
        if(maxSecs2wait>0){
            // Pinging self (no need to setup delegates, etc)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SysAccess checkLocationAlwaysAccessSilent:silent withCompletion:onOk];
            });
        }
    }else{
        if(!silent){
            [SysAccess showAccessPermissionError:@"NSLocationAlwaysUsageDescription" title:NSLocalizedString(@"Location Access Required", nil)];
        }
    }
    return NO;
}


+ (void)showAccessPermissionError:(NSString*)pListKey title:(NSString*)title {
#ifndef COMPILE_FOR_EXTENSION
    if(title == nil){
        title = NSLocalizedString(@"Access Required", nil);
    }
    NSString* errText = [[NSBundle mainBundle] objectForInfoDictionaryKey:pListKey];
    DVGAlertController *alert = [DVGAlertController presentDismissableAlertWithTitle:title
                                                                             message:errText
                                                                          controller:nil];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [alert addAction:[DVGAlertAction actionWithTitle:NSLocalizedString(@"Grant Access", nil) style:0
                                                 handler:^(DVGAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
    }
#endif
}

@end
