#import "SysInfo.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/utsname.h>

@implementation UIDevice (Hardware)

+ (SKComparisonResult)comparePointSeparatedVersionNumber:(NSString *)vOne withPointSeparatedVersionNumber:(NSString *)vTwo {
  if (!vOne || !vTwo || [vOne length] < 1 || [vTwo length] < 1 || [vOne rangeOfString:@".."].location != NSNotFound ||
    [vTwo rangeOfString:@".."].location != NSNotFound) {
    return SKOrderedNotOrdered;
  }
  NSCharacterSet *numericalCharSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
  NSString *vOneTrimmed = [vOne stringByTrimmingCharactersInSet:numericalCharSet];
  NSString *vTwoTrimmed = [vTwo stringByTrimmingCharactersInSet:numericalCharSet];
  if ([vOneTrimmed length] > 0 || [vTwoTrimmed length] > 0) {
    return SKOrderedNotOrdered;
  }
  NSArray *vOneArray = [vOne componentsSeparatedByString:@"."];
  NSArray *vTwoArray = [vTwo componentsSeparatedByString:@"."];
  for (NSUInteger i = 0; i < MIN([vOneArray count], [vTwoArray count]); i++) {
    NSInteger vOneInt = [[vOneArray objectAtIndex:i] intValue];
    NSInteger vTwoInt = [[vTwoArray objectAtIndex:i] intValue];
    if (vOneInt > vTwoInt) {
      return kSKOrderedDescending;
    } else if (vOneInt < vTwoInt) {
      return kSKOrderedAscending;
    }
  }
  if ([vOneArray count] > [vTwoArray count]) {
    for (NSUInteger i = [vTwoArray count]; i < [vOneArray count]; i++) {
      if ([[vOneArray objectAtIndex:i] intValue] > 0) {
        return kSKOrderedDescending;
      }
    }
  } else if ([vOneArray count] < [vTwoArray count]) {
    for (NSUInteger i = [vOneArray count]; i < [vTwoArray count]; i++) {
      if ([[vTwoArray objectAtIndex:i] intValue] > 0) {
        return kSKOrderedAscending;
      }
    }
  }
  return kSKOrderedSame;
}


/*
 Platforms
 
 iFPGA ->        ??
 
 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 4S/GSM), TBD
 iPhone4,2 ->    (iPhone 4S/CDMA), TBD
 iPhone4,3 ->    (iPhone 4S/???)
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 
 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, WiFi)
 iPad3,2   ->    (iPad 3G, GSM)
 iPad3,3   ->    (iPad 3G, CDMA)
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)
 
 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??
 
 i386, x86_64 -> iPhone Simulator
 */


// https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x)
+(NSString*)deviceModel
{
    static dispatch_once_t onceToken;
    static NSString *strModelID = nil;
    
    dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
        strModelID = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
        struct utsname systemInfo;
        uname(&systemInfo);
        strModelID = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
#endif
    });
    return strModelID;
}

+(BOOL)isIPhone8
{
    if([[UIDevice deviceModel] isEqualToString:@"iPhone10,1"] || [[UIDevice deviceModel] isEqualToString:@"iPhone10,4"]){
        return YES;
    }
    return NO;
}

+(BOOL)isIPhone8p
{
    if([[UIDevice deviceModel] isEqualToString:@"iPhone10,2"] || [[UIDevice deviceModel] isEqualToString:@"iPhone10,5"]){
        return YES;
    }
    return NO;
}

+(BOOL)isIPhoneX
{
    if([[UIDevice deviceModel] isEqualToString:@"iPhone10,3"] || [[UIDevice deviceModel] isEqualToString:@"iPhone10,6"]){
        return YES; // iPhone X
    }
    if([[UIDevice deviceModel] isEqualToString:@"iPhone11,2"] || [[UIDevice deviceModel] isEqualToString:@"iPhone11,4"] || [[UIDevice deviceModel] isEqualToString:@"iPhone11,6"]){
        return YES; // iPhone XS (Max)
    }
    if([[UIDevice deviceModel] isEqualToString:@"iPhone11,8"] || [[UIDevice deviceModel] isEqualToString:@"iPhone10,6"]){
        return YES;  // iPhone XR
    }
    return NO;
}

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

// Illicit Bluetooth check -- cannot be used in App Store
/*
 Class  btclass = NSClassFromString(@"GKBluetoothSupport");
 if ([btclass respondsToSelector:@selector(bluetoothStatus)])
 {
 printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
 bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
 printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
 }
 */
@end
