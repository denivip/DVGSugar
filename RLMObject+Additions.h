//
//  NSDictionary+Additions.h
//  Together
//
//  Created by Ilya Puchka on 20.12.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RLMObject (Additions)

@end

@interface RLMArray (ArrayAdditions)

- (NSArray *)convertToNSArray;

@end