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

@end
