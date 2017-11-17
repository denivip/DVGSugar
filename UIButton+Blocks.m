//
//  UIButton+Block.m
//  BoothTag
//
//  Created by Josh Holtz on 4/22/12.
//  Copyright (c) 2012 Josh Holtz. All rights reserved.
//

#import "UIButton+Blocks.h"
#import "UIView+Utils.h"
#import <objc/runtime.h>

@implementation UIControl (Block)
static char overviewKey;
@dynamic actions;

- (void) setTapBlock:(void(^)(void))block {
    [self setAction:kUIButtonBlockTouchUpInside withBlock:block];
}

- (void) setAction:(NSString*)action withBlock:(void(^)(void))block {
    if(!block){
        return;
    }
    if ([self actions] == nil) {
        [self setActions:[[NSMutableDictionary alloc] init]];
    }
    
    [[self actions] setObject:[block copy] forKey:action];
    
    if ([kUIButtonBlockTouchUpInside isEqualToString:action]) {
        [self addTarget:self action:@selector(doTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setActions:(NSMutableDictionary*)actions {
    objc_setAssociatedObject (self, &overviewKey,actions,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary*)actions {
    return objc_getAssociatedObject(self, &overviewKey);
}

- (void)doTouchUpInside:(id)sender {
    void(^block)(void);
    block = [[self actions] objectForKey:kUIButtonBlockTouchUpInside];
    block();
}
@end

@implementation UIButton (Block)
- (void)updateTitle:(NSString*)title {
    [self setTitle:title forState:UIControlStateNormal];
    if ([self respondsToSelector:@selector(initForI18nAccents)]) {
        [UIView initForI18nAccents:self];
    }
}

- (void)updateAttributedTitle:(NSAttributedString*)title {
    [self setAttributedTitle:title forState:UIControlStateNormal];
    if ([self respondsToSelector:@selector(initForI18nAccents)]) {
        [UIView initForI18nAccents:self];
    }
}

- (void)updateTitleFont:(UIFont*)titleFont {
    self.titleLabel.font = titleFont;
}

- (void)updateTitleColor:(UIColor*)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)updateImage:(NSString*)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

+ (UIButton *)buttonWithImageNamed:(NSString *)imageName tintedWithColor:(UIColor *)tintColor {
    UIImage* icon = nil;
    if(imageName != nil){
        if(tintColor == nil){
            icon = [UIImage imageNamed:imageName];
        }else{
            icon = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:icon forState:UIControlStateNormal];
    backButton.tintColor = tintColor?:[UIColor blackColor];
    [backButton sizeToFit];
    
    backButton.frame = CGRectInset(backButton.frame, -8.f, -8.f);
    return backButton;
}
@end
