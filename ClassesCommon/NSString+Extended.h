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
#define _NSLS(str1) (NSLocalizedString((str1),nil))
// Localization test
//#define _NSLS(str1) ([@"!" stringByAppendingString:NSLocalizedString((str1),nil)])

#define NSL_STR(str1) (_NSLS(str1))
#define NSL_STR2(str1, str2) [_NSLS(str1) stringByAppendingString:_NSLS(str2)]
#define NSL_STR3(str1, str2, str3) [[_NSLS(str1) stringByAppendingString:_NSLS(str2)] stringByAppendingString:_NSLS(str3)]
#define NSL_FRM2(str1, str2) [NSString stringWithFormat:_NSLS(str1), _NSLS(str2)]
#define NSL_FRM3(str1, str2, str3) [NSString stringWithFormat:_NSLS(str1), _NSLS(str2), _NSLS(str3)]

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
