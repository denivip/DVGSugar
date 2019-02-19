//
//  NSString_Extended.h
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 13.05.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

// Commoly used Localization shortcuts
#define NSL_STR(str1) (NSLocalizedString((str1),nil))
#define NSL_STR2(str1, str2) [NSLocalizedString(str1,nil) stringByAppendingString:NSLocalizedString(str2,nil)]
#define NSL_STR3(str1, str2, str3) [[NSLocalizedString(str1,nil) stringByAppendingString:NSLocalizedString(str2,nil)] stringByAppendingString:NSLocalizedString(str3,nil)]
#define NSL_FRM2(str1, str2) [NSString stringWithFormat:NSLocalizedString(str1,nil), NSLocalizedString(str2,nil)]
#define NSL_FRM3(str1, str2, str3) [NSString stringWithFormat:NSLocalizedString(str1,nil), NSLocalizedString(str2,nil), NSLocalizedString(str3,nil)]

@interface NSData (NSString_Extended)
- (NSString *)dvg_hexadecimalString;
@end

@interface NSString (Extended)
+ (NSString *)generateMD5:(NSString *)string;
+ (NSString *)stringWithBigNumber:(NSInteger)number;

- (NSString *)URLEncode;
- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)URLDecode;
- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)convertFromHtmlEntites;

- (NSString *)dvg_SHA512HashString;

- (NSString *)trimWhitespace;
@end

@interface NSBundle (Language)
//+(NSBundle*)getLocalizationBundleForLang:(NSString*)l;
+(void)setLanguage:(NSString*)language;
@end
