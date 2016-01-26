//
//  UIImageView+Utils.m
//  NineHundredSeconds
//
//  Created by IPv6 on 10/08/15.
//  Copyright © 2015 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+Utils.h"

@implementation UIImageView(Utils)

+ (NSMutableArray*)animatedImageWithImageNameFormat:(NSString *)imgformat animseqFrom:(int)val_b animseqTo:(int)val_t
{
    NSMutableArray* images = @[].mutableCopy;
    UIImage* img;
    for(int i=val_b;i<=val_t;i++){
        NSString* imgname = [NSString stringWithFormat:imgformat, i];
        img = [UIImage imageNamed:imgname];
        [images addObject:img];
    }
    return images;
}

+ (UIImageView *)imageViewWithImageNameFormat:(NSString *)imgformat animseqFrom:(int)val_b animseqTo:(int)val_t
{
    NSMutableArray* images = [UIImageView animatedImageWithImageNameFormat:imgformat animseqFrom:val_b animseqTo:val_t];
    UIImage* img = [images firstObject];
    //Position the explosion image view somewhere in the middle of your current view. In my case, I want it to take the whole view.Try to make the png to mach the view size, don't stretch it
    UIImageView* _out = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    _out.animationImages =  images;
    //_out.animationDuration = 0.5;
    _out.animationRepeatCount = 0;
    return _out;
}

@end