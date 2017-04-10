//
//  UIButton+Block.m
//  BoothTag
//
//  Created by Josh Holtz on 4/22/12.
//  Copyright (c) 2012 Josh Holtz. All rights reserved.
//

#import "UIButton+Blocks.h"
#import <objc/runtime.h>

@implementation UIControl (Block)
static char overviewKey;
@dynamic actions;

- (void) setTapBlock:(void(^)())block {
    [self setAction:kUIButtonBlockTouchUpInside withBlock:block];
}

- (void) setAction:(NSString*)action withBlock:(void(^)())block {
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
    void(^block)();
    block = [[self actions] objectForKey:kUIButtonBlockTouchUpInside];
    block();
}
@end

@implementation UIButton (Block)
- (void)updateTitle:(NSString*)title {
    [self setTitle:title forState:UIControlStateNormal];
    [UIView initForI18nAccents:self];
}

- (void)updateAttributedTitle:(NSAttributedString*)title {
    [self setAttributedTitle:title forState:UIControlStateNormal];
    [UIView initForI18nAccents:self];
}

- (void)updateTitleFont:(UIFont*)titleFont {
    self.titleLabel.font = titleFont;
}

- (void)updateTitleColor:(UIColor*)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
@end
