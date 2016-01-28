//
//  NSString_Extended.h
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 13.05.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extended)

+(NSString *)fileCachePath:(NSString*)fullNamespace;
+(NSDictionary*)getFileDictForKey:(NSString*)key;
+(BOOL)putFileDict:(NSDictionary*)dict forKey:(NSString*)key;

@end
