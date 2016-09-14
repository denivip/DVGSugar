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
+ (NSArray*)getAllSubviewIn:(UIView*)view;
+ (void)removeAllSubviewsIn:(UIView*)view;
+ (void)addSubview:(UIView*)v toView:(UIView*)p withAligment:(NSArray*)pWpH_xy_vWvH;
+ (void)setupConstraintsSameWHOfView:(UIView*)v inView:(UIView*)p;
+ (void)setupConstraintsInView:(UIView*)root makeView:(UIView*)v followView:(UIView*)target
                    withInsets:(UIEdgeInsets)insets withOffset:(CGPoint)offset;
+ (void)setupConstraintsInView:(UIView*)root makeView:(UIView*)v followView:(UIView*)target
              withCenterOffset:(CGPoint)offset;
+ (CGRect)distributeFlowlyViews:(NSArray*)views withWidth:(CGFloat)ww withSpacing:(CGFloat)zz;
- (void)setRoundedBackgroundWithColor:(UIColor*)bg;
@end

