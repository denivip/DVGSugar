#ifndef SYSINFO_H
#define SYSINFO_H
#ifdef __OBJC__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define iOS9 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

#define SYSTEM_UI_LANG ([[NSLocale preferredLanguages] firstObject])

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define DEVICE_HAS_LOW_RAM ([NSProcessInfo processInfo].physicalMemory < 2ull * 1000ull * 1024ull * 1024ull)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0 && ![UIDevice isIPhone8])
#define IS_IPHONE_6_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0 && ![UIDevice isIPhone8])

// https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x/47067296
// 6p, 7, 8 has same size!!! https://i.stack.imgur.com/JcCJp.png
#define IS_IPHONE_6P_7_8 (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6P_7_8_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 736.0)


#define kDVGIPhone6P_7_8Height 736.f
#define kDVGIPhone6Height 667.f
#define kDVGIPhone5Height 568.f
#define kDVGIPhone4Height 480.f

#endif


@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) cpuCount;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;

- (BOOL) hasRetinaDisplay;

+(NSString*)deviceModel;
+(BOOL)isIPhone8;
+(BOOL)isIPhone8p;
+(BOOL)isIPhoneX;
@end

#endif


