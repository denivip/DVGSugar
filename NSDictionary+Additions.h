//
//  NSDictionary+Additions.h
//  Together
//
//  Created by Ilya Puchka on 20.12.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (NSDictionary *)dictionaryWithValuesForKeysSkippingNonexistent:(NSArray *)keys;

- (NSDictionary *)dictionaryWithValuesForKeysSkippingNonexistent:(NSArray *)keys withAliases:(NSDictionary *)aliases;

- (NSString *)descriptionWithoutEscapes;

- (id)objectForKey:(id)aKey or:(id)defValue;

@end
