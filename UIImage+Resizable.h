//
//  UIImage+Resizable.h
//  Together
//
//  Created by Sergey Shpygar on 06.12.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizable)

+ (UIImage *)resizableImageWithNamed:(NSString*)named;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)dv_imageAspectFillScaledToSize:(CGSize)size;
- (UIImage *)dv_imageWithNormalizedOrientation;
- (UIImage *)imageRotatedUp;
@end
