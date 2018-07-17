#import <Foundation/Foundation.h>

@interface NSDate (DVGSUtilities)

+ (instancetype)dateWithISO8601String:(NSString *)string;
+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2;
- (NSString *)ISO8601String;

@end

@interface NSDate (Formatting)

+ (NSDateFormatter *)dvg_dateFormatter;
+ (NSDateFormatter *)dvg_dateTimeFormatter;
+ (NSString*)dvg_DateSince:(NSDate *)dt;
+ (NSString*)dvg_NiceDatestampSince:(NSDate*)dt;
+ (NSString*)dvg_NiceTimestampWithDate:(NSDate *)date;
+ (NSString*)dvg_NiceTimesinceWithDate:(NSDate *)date short:(BOOL)isShort;

@end
