#import "NSDictionary+Additions.h"
@implementation NSDictionary (Additions)

- (NSDictionary *)dictionaryWithValuesForKeysSkippingNonexistent:(NSArray *)keys
{
    NSMutableSet *filteredKeys = [NSMutableSet setWithArray:[self allKeys]];
    [filteredKeys intersectSet:[NSSet setWithArray:keys]];
    NSDictionary *values = [self dictionaryWithValuesForKeys:[filteredKeys allObjects]];
    
    return values;
}

- (NSDictionary *)dictionaryWithValuesForKeysSkippingNonexistent:(NSArray *)keys withAliases:(NSDictionary *)aliases {
    NSMutableSet *filteredKeys = [NSMutableSet setWithArray:[self allKeys]];
    NSMutableArray *keyesWithAliases = @[].mutableCopy;
    
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([[aliases allKeys] containsObject:key]) {
            [keyesWithAliases addObject:aliases[key]];
        } else {
            [keyesWithAliases addObject:key];
        }
    }];
    
    [filteredKeys intersectSet:[NSSet setWithArray:keyesWithAliases]];
    NSDictionary *values = [self dictionaryWithValuesForKeys:[filteredKeys allObjects]];
    
    return values;
}

- (NSString *)descriptionWithoutEscapes
{
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:[self count]];
    for (id key in [self allKeys]) {
        id object = self[key];
        NSString *description;
        if ([object isKindOfClass:[NSData class]]) {
            description = [NSString stringWithFormat:@"%lu bytes of data", (unsigned long)[(NSData *)object length]];
        }
        else {
            description = [object description];
            if ([description length] > 1024) {
                description = [description substringWithRange:NSMakeRange(0, 1024)];
            }
        }
        [strings addObject:[NSString stringWithFormat:@"%@ = %@", key, description]];
    }

    return [strings componentsJoinedByString:@"\n"];
}

- (id)objectForKey:(id)aKey or:(id)defValue {
    id res = [self objectForKey:aKey];
    if(res == nil || res == [NSNull null]){
        res = defValue;
    }
    return res;
}

- (id)objectForNestedKeys:(NSArray*)aKeys or:(id)defValue {
    id node = self;
    for(NSString* key in aKeys){
        id n = [(NSDictionary*)node objectForKey:key];
        if(n == nil || n == [NSNull null]){
            return defValue;
        }
        node = n;
    }
    return node?:defValue;
}
@end
