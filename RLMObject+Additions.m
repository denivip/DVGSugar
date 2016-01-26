//
//  NSDictionary+Additions.m
//  Together
//
//  Created by Ilya Puchka on 20.12.12.
//  Copyright (c) 2012 DENIVIP Group. All rights reserved.
//

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