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

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

@end
