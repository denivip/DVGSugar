#import <Foundation/Foundation.h>

#import <Realm/Realm.h>
@interface RLMObject (Additions)

@end

@interface RLMArray (ArrayAdditions)
- (NSArray *)convertToNSArray;
@end


@interface DVGRealmServicing : NSObject
+ (void)safeExecInTransaction:(dispatch_block_t)block;
+(NSArray*)convertRLMResults2NSArray:(RLMResults*)r;
+(NSArray*)convertRLMArray2NSArray:(RLMArray*)r;
@end
