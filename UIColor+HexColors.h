//
//  UIColor+HexColors.h
//  VieLoco
//
//  Created by IPv6 on 03/08/15.
//  Copyright © 2015 DENIVIP Group. All rights reserved.
//

#ifndef UIColor_HexColors_h
#define UIColor_HexColors_h

#import <UIKit/UIKit.h>

@interface UIColor (HexColors)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

+ (NSString *)hexValuesFromUIColor:(UIColor *)color;
+ (UIColor *)colorWithHexString2:(NSString *)hexString;
@end

#endif /* UIColor_HexColors_h */
