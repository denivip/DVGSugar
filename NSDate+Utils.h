#import <Foundation/Foundation.h>

@interface NSDate (DVGSUtilities)

+ (instancetype)dateWithISO8601String:(NSString *)string;
- (NSString *)ISO8601String;

@end
