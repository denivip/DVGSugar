//
//  UIImage+Overlay.m
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 03.04.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import "UIImage+Overlay.h"

@implementation UIImage(Overlay)

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    static NSMutableDictionary* imageCaches = nil;
    if(imageCaches == nil){
        imageCaches = @{}.mutableCopy;
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString* cachekey = [NSString stringWithFormat:@"%f-%f-%f-%f-%f-%f",components[0],components[1],components[2],components[3],size.width,size.height];
    UIImage *image = [imageCaches objectForKey:cachekey];
    if(image != nil){
        return image;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageCaches setObject:image forKey:cachekey];
    return image;
}

- (UIImage *)dvg_imageOverlayedWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color setFill];
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

@end
