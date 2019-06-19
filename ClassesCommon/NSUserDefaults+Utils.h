#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extended)

+(long long)fileCacheGetSize:(NSString*)filepath;
+(NSDate*)fileCacheGetDate:(NSString*)filepath;
+(BOOL)fileCacheDelFile:(NSString*)filepath;
+(NSString *)fileCachePath:(NSString*)fullNamespace;
+(NSArray*)fileCacheListFilesAt:(NSString*)dirPath;

+(NSDictionary*)getFileDictForKey:(NSString*)key;
+(NSDictionary*)getFileDictForPath:(NSString*)filepath;

+(BOOL)putFileDict:(NSDictionary*)dict forKey:(NSString*)key;
+(BOOL)putFileDict:(NSDictionary*)dict forPath:(NSString*)filepath;


+(BOOL)sharedPutKey:(NSString*)key withValue:(id)value suite:(NSString*)sname;
+(id)sharedGetKey:(NSString*)key withDefault:(id)defl suite:(NSString*)sname;
@end
