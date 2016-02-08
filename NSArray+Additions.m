#import "NSArray+Additions.h"
@implementation NSArray (Additions)

- (id)objectAtIndex:(NSInteger)index or:(id)defValue {
    if(index < 0 || index >= [self count]){
        return defValue;
    }
    id res = [self objectAtIndex:index];
    if(res == nil || res == [NSNull null]){
        res = defValue;
    }
    return res;
}

@end
