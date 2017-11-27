#import "NSDate+Utils.h"

@implementation NSDate (DVGSUtilities)

+ (NSDateFormatter *)ISO8601DateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ss.SSSZ";
    }
    
    return dateFormatter;
}

+ (instancetype)dateWithISO8601String:(NSString *)string
{
    if (!string
        || (id)string == [NSNull null]
        || [[string lowercaseString] rangeOfString:@"null"].location != NSNotFound){
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [self ISO8601DateFormatter];
    
    return [dateFormatter dateFromString:string];
}

- (NSString *)ISO8601String
{
    NSDateFormatter *dateFormatter = [[self class] ISO8601DateFormatter];
    
    return [dateFormatter stringFromDate:self];
}


+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
@end
