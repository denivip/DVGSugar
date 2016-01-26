//
//  UIImageView+Utils.h
//  NineHundredSeconds
//
//  Created by IPv6 on 10/08/15.
//  Copyright © 2015 DENIVIP Group. All rights reserved.
//

#ifndef UIImageView_Utils_h
#define UIImageView_Utils_h

#import <UIKit/UIKit.h>

@interface UIImageView (Utils)

+ (NSMutableArray*)animatedImageWithImageNameFormat:(NSString *)imgformat animseqFrom:(int)val_b animseqTo:(int)val_t;
+ (UIImageView *)imageViewWithImageNameFormat:(NSString *)imgformat animseqFrom:(int)val_b animseqTo:(int)val_t;

@end

#endif /* UIImageView_Utils_h */
