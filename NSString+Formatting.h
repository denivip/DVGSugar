//
//  NSString+Metrics.h
//  NineHundredSeconds
//
//  Created by IPv6 on 20/05/15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#ifndef NSStringFormatting_h
#define NSStringFormatting_h

@interface NSString (Formatting)
+(NSString *)timediffFromSeconds:(NSUInteger)seconds;
+(NSString *)durationFromSeconds:(NSUInteger)seconds;
+(NSString *)lengthFromMeters:(NSUInteger)meters;
+(NSString *)niceNumbFromCount:(NSUInteger)count;
+(NSString*)plurlFromCount:(NSUInteger)count with:(NSArray*)pluralforms;
+(BOOL)validateEmailWithString:(NSString*)email;
@end

@interface NSDate (Formatting)

+ (NSDateFormatter *)dvg_dateFormatter;
+ (NSDateFormatter *)dvg_dateTimeFormatter;
+ (NSString*)dvg_DateSince:(NSDate *)dt;
+ (NSString*)dvg_NiceDatestampSince:(NSDate*)dt;
+ (NSString*)dvg_NiceTimestampWithDate:(NSDate *)date;
+ (NSString*)dvg_NiceTimesinceWithDate:(NSDate *)date short:(BOOL)isShort;
+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2;

@end

#endif
