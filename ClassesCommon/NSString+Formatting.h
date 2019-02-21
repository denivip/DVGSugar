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


#endif
