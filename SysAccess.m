#import "SysAccess.h"
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
                [SysAccess showAccessPermissionError:@"NSPhotoLibraryUsageDescription"];
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
                [SysAccess showAccessPermissionError:@"NSCameraUsageDescription"];
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
                [SysAccess showAccessPermissionError:@"NSMicrophoneUsageDescription"];
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

+ (void)showAccessPermissionError:(NSString*)pListKey {
#ifndef COMPILE_FOR_EXTENSION
    NSString* errText = [[NSBundle mainBundle] objectForInfoDictionaryKey:pListKey];
    PSTAlertController *alert = [PSTAlertController presentDismissableAlertWithTitle:NSLocalizedString(@"Access Required", nil)
                                                                             message:errText
                                                                          controller:nil];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [alert addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"Grant Access", nil) style:PSTAlertActionStyleDefault
                                                 handler:^(PSTAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
    }
#endif
}

@end

