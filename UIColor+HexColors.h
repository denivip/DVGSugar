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

+(UIColor *)colorWithHexString:(NSString *)hexString;
+(NSString *)hexValuesFromUIColor:(UIColor *)color;

@end

#endif /* UIColor_HexColors_h */
