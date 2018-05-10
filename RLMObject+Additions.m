#import "RLMObject+Additions.h"
@implementation RLMObject (Additions)

@end

@implementation RLMArray (ArrayAdditions)

- (NSArray *)convertToNSArray {
    NSMutableArray* res = @[].mutableCopy;
    for(id object in self){
        [res addObject:object];
    }
    return res;
}

@end

@implementation DVGRealmServicing
+ (void)safeExecInTransaction:(dispatch_block_t)block {
    if([[RLMRealm defaultRealm] inWriteTransaction]){
        block();
        return;
    }
    [[RLMRealm defaultRealm] transactionWithBlock:block];
}


+(NSArray*)convertRLMResults2NSArray:(RLMResults*)r {
    NSMutableArray* res = @[].mutableCopy;
    for(RLMObject* ob in r){
        [res addObject:ob];
    }
    return res;
}

+(NSArray*)convertRLMArray2NSArray:(RLMArray*)r {
    NSMutableArray* res = @[].mutableCopy;
    for(RLMObject* ob in r){
        [res addObject:ob];
    }
    return res;
}
@end
