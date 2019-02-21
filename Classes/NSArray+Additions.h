#import <Foundation/Foundation.h>
@interface NSArray (Additions)
- (id)objectAtIndex:(NSInteger)index or:(id)defValue;
- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end
