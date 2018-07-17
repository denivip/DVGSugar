//
//  NSString+Metrics.m
//  NineHundredSeconds
//
//  Created by IPv6 on 20/05/15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Formatting.h"


@implementation NSString (Formatting)
+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSString *)niceNumbFromCount:(NSUInteger)count {
//    - Hundred and below: ones 5, 28, 923
//    - Thousands: Ks with one decimal 12.2K, 29K
//    - 100 thousands: 123K, 200K, 987K with no decimals
//    - Millions: ones with one decimal 1.7M, 2M, 12.5M
//    NSLog(@"TEST: %d %@",3,[NSString niceNumbFromCount:3]);
//    NSLog(@"TEST: %d %@",99,[NSString niceNumbFromCount:9]);
//    NSLog(@"TEST: %d %@",888,[NSString niceNumbFromCount:888]);
//    NSLog(@"TEST: %d %@",10034,[NSString niceNumbFromCount:10034]);
//    NSLog(@"TEST: %d %@",10334,[NSString niceNumbFromCount:10334]);
//    NSLog(@"TEST: %d %@",100034,[NSString niceNumbFromCount:100034]);
//    NSLog(@"TEST: %d %@",1022034,[NSString niceNumbFromCount:1022034]);
//    NSLog(@"TEST: %d %@",1122034,[NSString niceNumbFromCount:1122034]);
//    2015-07-06 17:18:14.764 NineHundredSeconds[3171:853480] TEST: 3 3
//    2015-07-06 17:18:14.764 NineHundredSeconds[3171:853480] TEST: 99 9
//    2015-07-06 17:18:14.765 NineHundredSeconds[3171:853480] TEST: 888 888
//    2015-07-06 17:18:14.765 NineHundredSeconds[3171:853480] TEST: 10034 10K
//    2015-07-06 17:18:14.765 NineHundredSeconds[3171:853480] TEST: 10334 10.3K
//    2015-07-06 17:18:14.766 NineHundredSeconds[3171:853480] TEST: 100034 100K
//    2015-07-06 17:18:14.766 NineHundredSeconds[3171:853480] TEST: 1022034 1M
//    2015-07-06 17:18:14.766 NineHundredSeconds[3171:853480] TEST: 1122034 1.1M
    
    if(count < 1000){
        return [NSString stringWithFormat:@"%lu", (unsigned long)count];
    }
    if(count < 100000){
        if((count%1000)<(1000/10)){
            return [NSString stringWithFormat:@"%luK", (unsigned long)(count/1000.0f)];
        }
        return [NSString stringWithFormat:@"%.01fK", (double)(count/1000.0f)];
    }
    if(count < 1000000.0f){
        return [NSString stringWithFormat:@"%luK", (unsigned long)(count/1000.0f)];
    }
    if((count%1000000)<(1000000/10)){
        return [NSString stringWithFormat:@"%luM", (unsigned long)(count/1000000.0f)];
    }
    return [NSString stringWithFormat:@"%.01fM", (double)(count/1000000.0f)];
}

+(NSString*)plurlFromCount:(NSUInteger)count with:(NSArray*)pluralforms
{
    return [NSString stringWithFormat:@"%@ %@", [NSString niceNumbFromCount:count], (count==1)?[pluralforms objectAtIndex:0]:[pluralforms objectAtIndex:0]];
}

+(NSString *)durationFromSeconds:(NSUInteger)seconds{
    NSUInteger durationInHours = seconds / 3600;
    NSUInteger durationInMinutes = (seconds % 3600) / 60;
    NSUInteger durationInRemainder = seconds % 60;
    if (durationInHours > 24) {
        NSUInteger days = durationInHours/24;
        return [NSString stringWithFormat:@"%lu %@", (unsigned long)days, (days==1)?NSLocalizedString(@"day", nil):NSLocalizedString(@"days", nil)];
    }else if (durationInHours > 0) {
        return [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)durationInHours, (unsigned long)durationInMinutes, (unsigned long)durationInRemainder];
    }
    else{
        return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)durationInMinutes, (unsigned long)durationInRemainder];
    }
}

+(NSString *)lengthFromMeters:(NSUInteger)meters{
    NSUInteger lengthInKilometers = meters / 1000;
    NSUInteger lengthInRemainder = meters % 1000;
    if (lengthInKilometers > 0) {
        return [NSString stringWithFormat:@"%lu km %lu m", (unsigned long)lengthInKilometers, (unsigned long)lengthInRemainder];
    }
    else{
        return [NSString stringWithFormat:@"%lu m", (unsigned long)meters];
    }
}

+(NSString *)timediffFromSeconds:(NSUInteger)seconds {
    NSUInteger mins = seconds/60;
    if(mins < 1){
        mins = 1;
    }
    if(mins < 60){
        return [NSString stringWithFormat:@"%lum", (unsigned long)mins];
    }else if(mins < 24*60){
        return [NSString stringWithFormat:@"%luh", (unsigned long)mins/60];
    }else{
        NSUInteger hours = mins/60;
        NSUInteger days = hours/24;
        if(days < 31){
            return [NSString stringWithFormat:@"%lud", (unsigned long)days];
        }
        return [NSString stringWithFormat:@"%luw", (unsigned long)days/7];
    }
    return @"";
}

@end


