//
//  NSString_Extended.h
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 13.05.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extended)

+(long long)fileCacheGetSize:(NSString*)filepath;
+(BOOL)fileCacheDelFile:(NSString*)filepath;
+(NSString *)fileCachePath:(NSString*)fullNamespace;
+(NSArray*)fileCacheListFilesAt:(NSString*)dirPath;

+(NSDictionary*)getFileDictForKey:(NSString*)key;
+(NSDictionary*)getFileDictForPath:(NSString*)filepath;

+(BOOL)putFileDict:(NSDictionary*)dict forKey:(NSString*)key;
+(BOOL)putFileDict:(NSDictionary*)dict forPath:(NSString*)filepath;
@end
