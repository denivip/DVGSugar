#import "NSUserDefaults+Utils.h"
#define DVGSUGAR_SHAREDDEFAULTS @"dvg.shared.userdefaults"

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
    return [NSUserDefaults getFileDictForPath:file];
}

+(NSDictionary*)getFileDictForPath:(NSString*)filepath {
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    if(data == nil){
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return dict;
}

+(BOOL)putFileDict:(NSDictionary*)dict forKey:(NSString*)key {
    if (key == nil || dict == nil){
        return NO;
    }
    NSString* file = [[NSUserDefaults fileCachePath:@"fc"] stringByAppendingPathComponent:key];
    return [NSUserDefaults putFileDict:dict forPath:file];
}

+(BOOL)putFileDict:(NSDictionary*)dict forPath:(NSString*)filepath {
    BOOL success = NO;
    if (filepath == nil || dict == nil){
        return NO;
    }
    
    NSError *err = nil;
    NSData *plistData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    if (err) {
        NSLog(@"saving dictionary error %@", err);
    } else {
        success = [plistData writeToFile:filepath atomically:NO];
    }
    
    return success;
}

+(long long)fileCacheGetSize:(NSString*)filepath {
    NSError *attributesError = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:&attributesError];
    if(attributesError != nil){
        return -1;
    }
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    return fileSize;
}

+(NSDate*)fileCacheGetDate:(NSString*)filepath {
    NSError *attributesError = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:&attributesError];
    if(attributesError != nil){
        return nil;
    }
    NSDate *fileDate = [fileAttributes objectForKey:NSFileModificationDate];
    return fileDate;
}

+(BOOL)fileCacheDelFile:(NSString*)filepath {
    if([filepath length] == 0){
        return NO;
    }
    NSError* error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
        if(error == nil){
            return YES;
        }
    }
    return NO;
}

+(NSArray*)fileCacheListFilesAt:(NSString*)dirPath {
    NSMutableArray* files = @[].mutableCopy;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:dirPath];
    NSString *file;
    while ((file = [enumerator nextObject])) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:file];
        [files addObject:filePath];
    }
    return files;
}


+(BOOL)sharedPutKey:(NSString*)key withValue:(id)value suite:(NSString*)sname
{
    NSUserDefaults* sharedDefs = [[NSUserDefaults alloc] initWithSuiteName: sname?:DVGSUGAR_SHAREDDEFAULTS];
    if(!sharedDefs || [key length] == 0){
        return NO;
    }
    //NSError *err = nil;
    //NSData *plistData = [NSJSONSerialization dataWithJSONObject:value options:0 error:&err];
    [sharedDefs setObject:value forKey:key];
    [sharedDefs synchronize];
    return YES;
}

+(id)sharedGetKey:(NSString*)key withDefault:(id)defl suite:(NSString*)sname
{
    NSUserDefaults* sharedDefs = [[NSUserDefaults alloc] initWithSuiteName: sname?:DVGSUGAR_SHAREDDEFAULTS];
    if(!sharedDefs || [key length] == 0){
        return defl;
    }
    id result = [sharedDefs objectForKey:key];
    if(result == nil || result == (id)[NSNull null]){
        return defl;
    }
    return result;
}

@end
