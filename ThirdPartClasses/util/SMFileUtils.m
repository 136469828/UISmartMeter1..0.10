//
//  SMFileUtils.m
//  ChildrenCalendar
//
//  Created by yangxi zou on 11-1-11.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import "SMFileUtils.h"

#define kCacheName                  @"cacheFold"

@implementation SMFileUtils



+ (NSString*) fullBundlePath:(NSString*)bundlePath
{
	return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundlePath];
}

+(NSArray*)listFiles:(NSString *)path
{
	//NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
	
	return [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
	//return [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
	//return [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:path error:nil];
}

+(NSArray*)listFolder:(NSString *)path
{
	//NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
	return [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
	//return [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
}

+(BOOL)createDirctoryByPath:(NSString *)path
{
	return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
 }

//获得libary/caches/目录全路径
+(NSString*)getCacheDirectory
{
	//NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	//dlog(@"NSFileManager:%@",[paths objectAtIndex:0]);
	return [paths objectAtIndex:0];
}
//获得libary/caches/目录全路径+子 路径
+(NSString*)getCacheDirectoryWith:(NSString*)subpath
{
	return [[SMFileUtils getCacheDirectory ] stringByAppendingPathComponent:subpath];
}

//取得Documents目录路径
+(NSString*)getDocumentsDirectory
{
	//NSFileManager *fileManager = [NSFileManager defaultManager];
	return [NSString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//dlog(@"NSFileManager:%@",[paths objectAtIndex:0]);
	//return [paths objectAtIndex:0];
}

//取得Documents目录带子路径
+(NSString*)getDocumentsDirectoryWith:(NSString*)subpath;
{
	return [[SMFileUtils getDocumentsDirectory ] stringByAppendingPathComponent:subpath];
}

+(BOOL)saveUIImage:(NSString*)path filename:(NSString*)filename image:(UIImage*)image 
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:path]==0) {
		[SMFileUtils createDirctoryByPath:path];
	}
	return  [UIImagePNGRepresentation( image ) writeToFile:[path stringByAppendingPathComponent:filename] atomically:YES ];
}


//将数组写入到文件
+(void)writePlistToCache:(NSData*)data filename:(NSString*)filename
{
    NSString *filepath=[ [SMFileUtils getCacheDirectory] stringByAppendingPathComponent:kCacheName];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
#ifdef __IPHONE_2_0
        [[NSFileManager defaultManager] createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
#else
        [[NSFileManager defaultManager]  createDirectoryAtPath:filepath attributes: nil];
#endif

    }
    
    NSString *tmpFileName = [filepath stringByAppendingPathComponent:filename];
    
    
    //新建文件夹
	if (![[NSFileManager defaultManager] fileExistsAtPath:tmpFileName])
	{
        
		[data writeToFile:tmpFileName atomically:YES];
        
        
	}
	else //插入文件
	{
        
		[data writeToFile:tmpFileName atomically:YES];
        
	}

    
}
//读取文件到数组
+(NSData*)readPlistFromCache:(NSString*)filename
{
    
    NSString *filepath=[ [SMFileUtils getCacheDirectory] stringByAppendingPathComponent:kCacheName];
    
    NSString *tmpFileName = [filepath stringByAppendingPathComponent:filename];
    
    NSData	*datasource = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFileName])
	{
        
        datasource = [[NSData alloc] initWithContentsOfFile:tmpFileName];
        
	}
	
	return datasource;

}

+(BOOL)needDownload:(NSString *)filename
{
     NSString *filepath=[ [SMFileUtils getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.plist",filename ]]; 
     //文件不存在返回YES
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if(![fileManager fileExistsAtPath:filepath])return YES;
     NSDictionary  *attrs = [fileManager attributesOfItemAtPath: filepath error: NULL];
    if (attrs != nil) {        
        NSDate *filemoddate=[attrs fileModificationDate];
        if ([filemoddate isToday ]) {
            return  NO;
        }
        return YES;
        //NSNumber *fileSize;
        //NSString *fileOwner, *creationDate;
        //NSDate *fileModDate;
        //NSString *NSFileCreationDate
        
        //NSDate *modificationDate = (NSDate*)[fileAttributes objectForKey: NSFileModificationDate];
        /*
        //文件大小
        if (fileSize = [fileAttributes objectForKey:NSFileSize]) {
            NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
        }
        
        //文件创建日期
        if (creationDate = [fileAttributes objectForKey:NSFileCreationDate]) {
            NSLog(@"File creationDate: %@\n", creationDate);
            //textField.text=NSFileCreationDate;
        }
        
        //文件所有者
        if (fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName]) {
            NSLog(@"Owner: %@\n", fileOwner);
        }
        
        //文件修改日期
        if (fileModDate = [fileAttributes objectForKey:NSFileModificationDate]) {
            NSLog(@"Modification date: %@\n", fileModDate);
        }
    }
    else {
        NSLog(@"Path (%@) is invalid.", filepath);*/
    }
    return YES;
}

/*
 创建与删除：
 //创建文件管理器
 NSFileManager *fileManager = [NSFileManager defaultManager];
 //获取路径
 //参数NSDocumentDirectory要获取那种路径
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
 
 //更改到待操作的目录下
 [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
 
 //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
 [fileManager createFileAtPath:@"fileName" contents:nil attributes:nil];
 
 //删除待删除的文件
 [fileManager removeItemAtPath:@"createdNewFile" error:nil];
 
 写入数据：
 //获取文件路径
 NSString *path = [documentsDirectory stringByAppendingPathComponent:@"fileName"];
 
 //待写入的数据
 NSString *temp = @"Hello friend";
 int data0 = 100000;
 float data1 = 23.45f;
 
 //创建数据缓冲
 NSMutableData *writer = [[NSMutableData alloc] init];
 
 //将字符串添加到缓冲中
 [writer appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
 
 //将其他数据添加到缓冲中
 [writer appendBytes:&data0 length:sizeof(data0)];
 [writer appendBytes:&data1 length:sizeof(data1)];
 
 
 //将缓冲的数据写入到文件中
 [writer writeToFile:path atomically:YES];
 [writer release];
 
 
 读取数据：
 int gData0;
 float gData1;
 NSString *gData2;
 
 NSData *reader = [NSData dataWithContentsOfFile:path];
 gData2 = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, [temp length])]
 encoding:NSUTF8StringEncoding];
 [reader getBytes:&gData0 range:NSMakeRange([temp length], sizeof(gData0))];
 [reader getBytes:&gData2 range:NSMakeRange([temp length] + sizeof(gData0), sizeof(gData1))];
 
 NSLog(@"gData0:%@  gData1:%i gData2:%f", gData0, gData1, gData2);
 
 
 读取工程中的文件：
 读取数据时，要看待读取的文件原有的文件格式，是字节码还是文本，我经常需要重文件中读取字节码，所以我写的是读取字节文件的方式。
 //用于存放数据的变量，因为是字节，所以是ＵInt8
 UInt8 b = 0;
 
 //获取文件路径
 NSString *path = [[NSBundle mainBundle] pathForResource:@"fileName" ofType:@""];
 
 //获取数据 
 NSData *reader = [NSData dataWithContentsOfFile:path];
 
 //获取字节的个数
 int length = [reader length];
 NSLog(@"------->bytesLength:%d", length);
 for(int i = 0; i < length; i++)
 {
 //读取数据
 [reader getBytes:&b range:NSMakeRange(i, sizeof(b))];
 NSLog(@"-------->data%d:%d", i, b);    
 
 }
 
 */

/*
 BOOL isDir = NO;
 NSError *error = nil;
 NSString *documentDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"templates.bundle"];
 NSArray * fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
 for (NSString *file in fileList) {
 NSString *path = [documentDir stringByAppendingPathComponent:file];
 [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
 if (isDir) {
 //[dirArray addObject:file];
 dlog(@"file:%@",file);
 }
 //isDir = NO;
 }*/
/* NSTemporaryDirectory NSHomeDirectory
 NSString* cachedtemplatesdir=[NSString stringWithFormat:@"%@/%@", NSCachesDirectory, @"10001"];
 if([[NSFileManager defaultManager] fileExistsAtPath:cachedtemplatesdir])
 {
 dlog(@"NSFileManager:");
 }*/ 	

@end
