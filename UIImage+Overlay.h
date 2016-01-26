//
//  UIImage+Overlay.h
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 03.04.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Overlay)

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

- (UIImage *)dvg_imageOverlayedWithColor:(UIColor *)color;

@end