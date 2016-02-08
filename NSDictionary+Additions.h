#import <Foundation/Foundation.h>
@interface NSDictionary (Additions)
- (NSDictionary *)dictionaryWithValuesForKeysSkippingNonexistent:(NSArray *)keys;
- (NSDictionary *)dictionaryWithValuesForKeysSkippingNonexistent:(NSArray *)keys withAliases:(NSDictionary *)aliases;
- (NSString *)descriptionWithoutEscapes;
- (id)objectForKey:(id)aKey or:(id)defValue;

@end
