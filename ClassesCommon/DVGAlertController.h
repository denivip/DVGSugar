#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DVGAlertControllerStyle) {
    DVGAlertControllerStyleActionSheet = 0,
    DVGAlertControllerStyleAlert
};

typedef NS_ENUM(NSInteger, DVGAlertActionStyle) {
    DVGAlertActionStyleDefault = 0,
    DVGAlertActionStyleCancel,
    DVGAlertActionStyleDestructive
};

@class DVGAlertController;

// Defines a single button/action.
@interface DVGAlertAction : NSObject
+ (instancetype)actionWithTitle:(NSString *)title style:(DVGAlertActionStyle)style handler:(void (^ __nullable)(DVGAlertAction *action))handler;
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^ __nullable)(DVGAlertAction *action))handler;
@property (nonatomic, readonly) DVGAlertActionStyle style;

@property (nonatomic, weak) DVGAlertController *alertController; // weak connection

@end

// Mashup of UIAlertController with fallback methods for iOS 7.
// @note Blocks are generally executed after the dismiss animation is completed.
@interface DVGAlertController : NSObject

// Generic initializer
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(DVGAlertControllerStyle)preferredStyle;
- (instancetype)init NS_UNAVAILABLE;

// Add action.
- (void)addAction:(DVGAlertAction *)action;

// Add block that is called after the alert controller will be dismissed (before animation).
- (void)addWillDismissBlock:(void (^)(DVGAlertAction *action))willDismissBlock;

// Add block that is called after the alert view has been dismissed (after animation).
- (void)addDidDismissBlock:(void (^)(DVGAlertAction *action))didDismissBlock;

@property (nullable, nonatomic, copy, readonly) NSArray<DVGAlertAction *> *actions;

// Text field support
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) DVGAlertControllerStyle preferredStyle;

// Presentation and dismissal
- (void)showWithSender:(nullable id)sender controller:(nullable UIViewController *)controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)showWithSender:(nullable id)sender arrowDirection:(UIPopoverArrowDirection)arrowDirection controller:(nullable UIViewController *)controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)dismissAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

+ (BOOL)hasVisibleAlertController;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

@end

@interface DVGAlertController (Convenience)

// Convenience initializers
+ (instancetype)actionSheetWithTitle:(nullable NSString *)title;
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

// Convenience. Presents a simple alert with a "Dismiss" button.
// Will use the root view controller if `controller` is nil.
+ (instancetype)presentDismissableAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message controller:(nullable UIViewController *)controller;

// Variant that will present an error.
+ (instancetype)presentDismissableAlertWithTitle:(nullable NSString *)title error:(nullable NSError *)error controller:(nullable UIViewController *)controller;

// From Apple's HIG:
// In a two-button alert that proposes a potentially risky action, the button that cancels the action should be on the right (and light-colored).
// In a two-button alert that proposes a benign action that people are likely to want, the button that cancels the action should be on the left (and dark-colored).
- (void)addCancelActionWithHandler:(void (^ __nullable)(DVGAlertAction *action))handler; // convenience

@property (nullable, nonatomic, readonly) UITextField *textField;

@end


@interface DVGAlertController (Internal)

@property (nullable, nonatomic, strong, readonly) UIAlertController *alertController;

@property (nullable, nonatomic, strong, readonly) UIActionSheet *actionSheet;
@property (nullable, nonatomic, strong, readonly) UIAlertView *alertView;

// One if the above three.
@property (nullable, nonatomic, strong, readonly) id presentedObject;

@end

NS_ASSUME_NONNULL_END
