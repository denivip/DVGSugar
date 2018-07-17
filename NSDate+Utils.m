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



@implementation NSDate (Formatting)

+ (NSDateFormatter *)dvg_dateFormatter {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd MMMM, yyyy";
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)dvg_relativeDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = kCFDateFormatterNoStyle;
        dateFormatter.doesRelativeDateFormatting = YES;
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)dvg_dateTimeFormatter
{
    static NSDateFormatter *dateTimeFormatter;
    if (!dateTimeFormatter) {
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        dateTimeFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateTimeFormatter.timeStyle = NSDateFormatterShortStyle;
        dateTimeFormatter.doesRelativeDateFormatting = YES;
    }
    
    return dateTimeFormatter;
}

+ (NSString *)dvg_DateSince:(NSDate *)dt {
    return [[NSDate dvg_dateFormatter] stringFromDate:dt];
}

+ (NSString*)dvg_NiceDatestampSince:(NSDate*)dt
{
    if(dt == nil || [dt timeIntervalSince1970] < 365*24*60*60){
        return @"";
    }
    NSDate* now = [NSDate date];
    if([NSDate isSameDayWithDate1:now date2:dt]){
        return NSLocalizedString(@"Today", nil);
    }
    return [[NSDate dvg_relativeDateFormatter] stringFromDate:dt];
}

+ (NSString *)dvg_NiceTimesinceWithDate:(NSDate *)date short:(BOOL)isShort{
    if (!date) {
        return @"";
    }
    NSDate* ts = [NSDate date];
    NSTimeInterval secs = [ts timeIntervalSinceDate:date];
    int minutes = (int)[ts timeIntervalSinceDate:date]/60;
    int hours = (int)[ts timeIntervalSinceDate:date]/(60*60);
    int days = (int)[ts timeIntervalSinceDate:date]/(24*60*60);
    if(secs < 2*60){
        return isShort?@"min ago":@"a minute ago";
    }else if(secs < 30*60){
        return [NSString stringWithFormat:isShort?@"%im ago":@"%i minutes ago", minutes];
    }else if(secs < 60*60){
        return isShort?@"1h ago":@"an hour ago";
    }else if(secs < 24*60*60){
        return isShort?[NSString stringWithFormat:@"%ih ago", hours]:[NSString stringWithFormat:@"%ih %im ago", hours, minutes%60];
    }else if(secs < 365*24*60*60){
        return isShort?[NSString stringWithFormat:@"%id ago", days]:[NSString stringWithFormat:@"%id %ih %im ago", days, hours%24, minutes%60];
    }
    return [NSDate dvg_NiceTimestampWithDate:date];
}

+ (NSString *)dvg_NiceTimestampWithDate:(NSDate *)date {
    if (!date) {
        return @"";
    }
    
    NSString *dateString = [NSDate dvg_NiceDatestampSince:date];
    
    
    NSDateFormatterStyle dateStyle = [NSDate dvg_dateTimeFormatter].dateStyle;
    [NSDate dvg_dateTimeFormatter].dateStyle = NSDateFormatterNoStyle;
    [NSDate dvg_dateTimeFormatter].doesRelativeDateFormatting = NO;
    [NSDate dvg_dateTimeFormatter].dateFormat = @"h:mm";
    NSString *timeString = [[NSDate dvg_dateTimeFormatter] stringFromDate:date];
    
    [NSDate dvg_dateTimeFormatter].dateFormat = @"a";
    NSString *periodString = [[NSDate dvg_dateTimeFormatter] stringFromDate:date];
    
    [NSDate dvg_dateTimeFormatter].dateFormat = nil;
    [NSDate dvg_dateTimeFormatter].dateStyle = dateStyle;
    [NSDate dvg_dateTimeFormatter].doesRelativeDateFormatting = YES;
    
    return [NSString stringWithFormat:@"%@, %@%@", dateString, timeString, [periodString uppercaseString]];
}

@end
