//
//  NSString_Extended.h
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 13.05.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

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
