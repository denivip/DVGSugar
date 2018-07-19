//
//  NSString_Extended.m
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 13.05.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import <objc/runtime.h>
#import "NSString+Extended.h"

@implementation NSData (NSString_Extended)

- (NSString *)dvg_hexadecimalString
{
    const unsigned char *dataBuffer = (const unsigned char *)(self.bytes);
    if (!dataBuffer) return [NSString string];
    
    NSUInteger dataLength  = [self length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end

@implementation NSString (Extended)
+ (NSString *)stringWithBigNumber:(NSInteger)number {
    NSMutableString* res = [[NSMutableString alloc] init];
    if(number > 1000){
        [res appendFormat:@"%lu,",(NSInteger)number/1000];
        [res appendFormat:@"%03lu",(NSInteger)number%1000];
    }else{
        [res appendFormat:@"%lu",(NSInteger)number];
    }
    return res;
}

+ (NSString *)generateMD5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString
            stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

- (NSString *)URLEncode {
    return [self URLEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+-$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)URLDecode {
    return [self URLDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)convertFromHtmlEntites {
    NSString* repl1 = [self stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    NSString* repl2 = [repl1 stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    NSString* repl3 = [repl2 stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return repl3;
}

- (NSString *) dvg_SHA512HashString {
    NSData *keyData = [self dataUsingEncoding:NSASCIIStringEncoding];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = { 0 };
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *hashData = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    NSString *signature = [hashData dvg_hexadecimalString];
    
    return signature;
}

- (NSString *)trimWhitespace {
    NSString *newString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return newString;
}
@end


static const char _bundle=0;
@interface BundleEx : NSBundle
@end

@implementation BundleEx
-(NSString*)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle* bundle=objc_getAssociatedObject(self, &_bundle);
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}
@end

@implementation NSBundle (Language)

//+(NSBundle*)getLocalizationBundleForLang:(NSString*)l {
//    NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
//    bundle = [NSBundle bundleWithPath:path];
//    return bundle;
//}

+(void)setLanguage:(NSString*)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      object_setClass([NSBundle mainBundle],[BundleEx class]);
                  });
    objc_setAssociatedObject([NSBundle mainBundle], &_bundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
