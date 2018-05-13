//
//  UIView+FindAndResignFirstResponder.m
//  Together
//
//  Created by Ilya on 05.10.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

#import "UIView+Utils.h"
#import <objc/runtime.h>
#import <zlib.h>

CALayer *uiv_effectLayerInPanel(UIVisualEffectView *panel) {
    NSArray *layers = panel.layer.sublayers;
    return layers.firstObject;
}

@implementation UIView (UIViewUtils)
+ (CGRect)rectFromRelcenter:(CGPoint)centerAsFractions relSize:(CGPoint)sizeAsFractions parent:(UIView*)v {
    CGFloat w = v.frame.size.width*sizeAsFractions.x;
    CGFloat h = v.frame.size.height*sizeAsFractions.y;
    CGFloat x = v.frame.origin.x+v.frame.size.width*centerAsFractions.x-w*0.5;
    CGFloat y = v.frame.origin.y+v.frame.size.height*centerAsFractions.y-h*0.5;
    return CGRectMake(x, y, w, h);
}


+ (UIView*)addHorizontalStrokeTo:(UIView *)parent edge:(UIRectEdge)edge {
    const CGFloat kOnePixel = 1.0 / [UIScreen mainScreen].scale;
    CGRect frame = parent.bounds;
    UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth;
    if (edge & UIRectEdgeBottom) {
        frame.origin.y += frame.size.height - kOnePixel;
        mask |= UIViewAutoresizingFlexibleTopMargin;
    }
    else {
        mask |= UIViewAutoresizingFlexibleBottomMargin;
    }
    frame.size.height = kOnePixel;
    
    UIView *stroke = [[UIView alloc] initWithFrame:frame];
    stroke.autoresizingMask = mask;
    [parent addSubview:stroke];
    return stroke;
}

+ (UIView*)findSubviewIn:(UIView*)v withPredicate:(BOOL (^)(UIView* v))testingCondition {
    if(testingCondition(v)){
        return v;
    }
    for(UIView* sv in v.subviews){
        UIView* subv_fo9und = [UIView findSubviewIn:sv withPredicate:testingCondition];
        if(subv_fo9und){
            return subv_fo9und;
        }
    }
    return nil;
}

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

+ (void)removeAllSubviewsIn:(UIView*)view {
    NSArray* subvs = [view subviews];
    for(UIView* subview in subvs){
        [subview removeFromSuperview];
    }
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

+ (void)setupConstraintsInView:(UIView*)root makeView:(UIView*)v followView:(UIView*)target withCenterOffset:(CGPoint)offset {
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [root addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:target
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0 constant:offset.x],
                           [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:target
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0 constant:offset.y]
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
    [self endEditing:YES];
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

+ (void)addSubview:(UIView*)v toView:(UIView*)p withAligment:(NSArray*)pWpH_xy_vWvH
{
    // xy_rwh -> [p width percentage, p height percentage, x offset,y offset,v width percentage, v height percentage]
    // Example: @[@(0.5),@(0.5),@(0),@(0),@(0.5),@(0.5)] -> center to center
    CGRect vf = v.frame;
    CGRect pf = p.frame;
    CGFloat new_x = pf.size.width*[pWpH_xy_vWvH[0] floatValue] + [pWpH_xy_vWvH[2] floatValue] - vf.size.width*[pWpH_xy_vWvH[4] floatValue];
    CGFloat new_y = pf.size.height*[pWpH_xy_vWvH[1] floatValue] + [pWpH_xy_vWvH[3] floatValue] - vf.size.height*[pWpH_xy_vWvH[5] floatValue];
    v.frame = CGRectMake(new_x, new_y, vf.size.width, vf.size.height);
    [p addSubview:v];
}

- (void)setRoundedBackgroundWithColor:(UIColor*)bg
{
    self.backgroundColor = bg;
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
}

+ (void)initForI18nAccents:(UIView*)v {
    // Important for ES accents!
    // http://stackoverflow.com/questions/13225761/custom-font-on-uibutton-title-clipped-on-top-of-word
    if([v isKindOfClass:[UIButton class]]){
        [((UIButton*)v) setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        return;
    }
    if([v isKindOfClass:[UILabel class]]){
        UILabel* vlbl = (UILabel*)v;
        NSString* details = vlbl.text;
        if (details.length > 0) {
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.lineHeightMultiple = 1.1f;
            style.alignment = vlbl.textAlignment;
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:details
                                                                                  attributes:@{NSParagraphStyleAttributeName : style.copy}];
            vlbl.attributedText = attributedTitle;
        }else{
            vlbl.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
}


- (void)setAssocValue:(id)value forKey:(NSString*)key {
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger keyHash = crc32(0, keyData.bytes, (int)keyData.length);
    objc_setAssociatedObject (self, (const void*)keyHash, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)getAssocValueForKey:(NSString*)key {
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger keyHash = crc32(0, keyData.bytes, (int)keyData.length);
    id res = objc_getAssociatedObject(self, (const void*)keyHash);
    return res;
}

@end

