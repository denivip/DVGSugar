//
//  UIView+FindAndResignFirstResponder.h
//  Together
//
//  Created by Ilya on 05.10.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewUtils)

- (BOOL)findAndResignFirstResponder;
+ (void)addSubview:(UIView*)v toView:(UIView*)p withAligment:(NSArray*)xy_rwh;
+ (void)setupConstraintsSameWHOfView:(UIView*)v inView:(UIView*)p;
+ (void)setupConstraintsInView:(UIView*)root makeView:(UIView*)v followView:(UIView*)p withInsets:(UIEdgeInsets)insets withOffset:(CGPoint)offset;
@end
