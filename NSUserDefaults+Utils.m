//
//  NSString_Extended.m
//  NineHundredSeconds
//
//  Created by Sergey Shpygar on 13.05.15.
//  Copyright (c) 2015 DENIVIP Group. All rights reserved.
//

#import "NSUserDefaults+Utils.h"

@implementation NSUserDefaults (Extended)


+(NSString *)fileCachePath:(NSString*)fullNamespace {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* directory = [paths[0] stringByAppendingPathComponent:fullNamespace];
    NSFileManager *fileManager= [NSFileManager defaultManager];
    BOOL isDir;
    if(![fileManager fileExistsAtPath:directory isDirectory:&isDir]){
        if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL]){
            return nil;
        }
    }
    return directory;
}

+(NSDictionary*)getFileDictForKey:(NSString*)key {
    NSString* file = [[NSUserDefaults fileCachePath:@"fc"] stringByAppendingPathComponent:key];
    NSData *data = [NSData dataWithContentsOfFile:file];
    if(data == nil){
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return dict;
}

+(BOOL)putFileDict:(NSDictionary*)dict forKey:(NSString*)key {
    BOOL success = NO;
    if (key == nil || dict == nil){
        return NO;
    }
    
    NSError *err = nil;
    NSData *plistData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    if (err) {
        // Darn.
        NSLog(@"saving dictionary error %@", err);
    } else {
        NSString* file = [[NSUserDefaults fileCachePath:@"fc"] stringByAppendingPathComponent:key];
        success = [plistData writeToFile:file atomically:NO];
    }
    
    return success;
}

@end
