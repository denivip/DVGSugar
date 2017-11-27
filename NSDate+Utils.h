#import <Foundation/Foundation.h>

@interface NSDate (DVGSUtilities)

+ (instancetype)dateWithISO8601String:(NSString *)string;
+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2;
- (NSString *)ISO8601String;

@end
