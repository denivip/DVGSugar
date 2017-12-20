//
//  UIButton+Block.h
//  BoothTag
//
//  Created by Josh Holtz on 4/22/12.
//  Copyright (c) 2012 Josh Holtz. All rights reserved.
//

#define kUIButtonBlockTouchUpInside @"TouchInside"

#import <UIKit/UIKit.h>

@interface UIControl (Block)

@property (nonatomic, strong) NSMutableDictionary *actions;
- (void)setTapBlock:(void(^)(void))block;
- (void)setAction:(NSString*)action withBlock:(void(^)(void))block;
- (void)triggerTapBlock;
@end

@interface UIButton (Block)
- (void)updateTitle:(NSString*)title;
- (void)updateTitleFont:(UIFont*)titleFont;
- (void)updateTitleColor:(UIColor*)titleColor;
- (void)updateAttributedTitle:(NSAttributedString*)title;
- (void)updateImage:(NSString*)imageName;
+ (UIButton *)buttonWithImageNamed:(NSString *)imageName tintedWithColor:(UIColor *)tintColor;
@end
