//
//  UIView+FindAndResignFirstResponder.m
//  Together
//
//  Created by Ilya on 05.10.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (UIViewUtils)

+ (NSArray*)getAllSubviewIn:(UIView*)view {
    NSMutableArray* allSubViews = @[].mutableCopy;
    NSArray* subvs = [view subviews];
    for(UIView* subview in subvs){
        NSArray* subview_insubv = [UIView getAllSubviewIn:subview];
        [allSubViews addObjectsFromArray:subview_insubv];
    }
    [allSubViews addObjectsFromArray:subvs];
    return allSubViews;
}

+ (CGRect)distributeFlowlyViews:(NSArray*)views withWidth:(CGFloat)ww withSpacing:(CGFloat)zz
{
    CGFloat b_x = 0;
    CGFloat b_y = 0;
    CGFloat b_w = 0.0;
    CGFloat b_h = 0.0;
    for(UIView* v in views){
        CGRect f = v.frame;
        if(b_x + f.size.width >= ww){
            b_x = 0;
            b_y += f.size.height+zz;
        }
        
        f.origin = CGPointMake(b_x, b_y);
        v.frame = f;
        if(f.origin.x+f.size.width > b_w){
            b_w = f.origin.x+f.size.width;
        }
        if(f.origin.y+f.size.height > b_h){
            b_h = f.origin.y+f.size.height;
        }
        b_x += f.size.width + zz;
    }
    return CGRectMake(0,0,b_w,b_h);
}

+ (void)setupConstraintsInView:(UIView*)root makeView:(UIView*)v followView:(UIView*)target withInsets:(UIEdgeInsets)insets withOffset:(CGPoint)offset {
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [root addConstraints:@[
                       [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:target
                                                    attribute:NSLayoutAttributeLeft
                                                   multiplier:1.0 constant:insets.left + offset.x],
                       [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:target
                                                    attribute:NSLayoutAttributeRight
                                                   multiplier:1.0 constant:-insets.right + offset.x],
                       [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:target
                                                    attribute:NSLayoutAttributeTop
                                                   multiplier:1.0 constant:insets.top + offset.y],
                       [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:target
                                                    attribute:NSLayoutAttributeBottom
                                                   multiplier:1.0 constant:-insets.bottom + offset.y]
     ]];
}

+ (void)setupConstraintsSameWHOfView:(UIView*)v inView:(UIView*)p {
    v.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{
                            @"subview":v,
                            @"parent":p
                            };
    [p addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [p addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
}

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

+ (void)addSubview:(UIView*)v toView:(UIView*)p withAligment:(NSArray*)xy_rwh
{
    // xy_rwh -> [p width percentage, p height percentage, x offset,y offset,v width percentage, v height percentage]
    // Example: [0.5,0.5,0,0,0.5,0.5] -> center to center
    CGRect vf = v.frame;
    CGRect pf = p.frame;
    CGFloat new_x = pf.size.width*[xy_rwh[0] floatValue] + [xy_rwh[2] floatValue] - vf.size.width*[xy_rwh[4] floatValue];
    CGFloat new_y = pf.size.height*[xy_rwh[1] floatValue] + [xy_rwh[3] floatValue] - vf.size.height*[xy_rwh[5] floatValue];
    v.frame = CGRectMake(new_x, new_y, vf.size.width, vf.size.height);
    [p addSubview:v];
}


@end
