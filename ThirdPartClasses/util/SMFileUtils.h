//
//  SMFileUtils.h
//  ChildrenCalendar
//
//  Created by yangxi zou on 11-1-11.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"
//NSTemporaryDirectory() 临时目录
//NSHomeDirectory()      应用主目录
/*
iPhone应用程序的目录
<Application_Home>/AppName.app
这是程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动。
在iPhone OS 2.1及更高版本的系统，iTunes不对这个目录的内容进行备份。但是，iTunes会对在App Store上购买的应用程序进行一次初始的同步。
<Application_Home>/Documents/
您应该将所有的应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。有关如何取得这个目录路径的信息，请参见“获取应用程序目录的路径”部分。
iTunes会备份这个目录的内容。
<Application_Home>/Library/Preferences
这个目录包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类或CFPreferences API来取得和设置应用程序的偏好，详情请参见“添加Settings程序包”部分。
iTunes会备份这个目录的内容。
<Application_Home>/Library/Caches
这个目录用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。您的应用程序通常需要负责添加和删除这些文件，但在对设备进行完全恢复的过程中，iTunes会删除这些文件，因此，您应该能够在必要时重新创建。您可以使用“获取应用程序目录的路径” 部分描述的接口来获取该目录的路径，并对其进行访问。
在iPhone OS 2.2及更高版本，iTunes不对这个目录的内容进行备份。
<Application_Home>/tmp/
这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。当您的应用程序不再需要这些临时文件时，应该将其从这个目录中删除（系统也可能在应用程序不运行的时候清理留在这个目录下的文件）。有关如何获得这个目录路径的信息，请参见“获取应用程序目录的路径”部分。
在iPhone OS 2.1及更高版本，iTunes不对这个目录的内容进行备份。
*/

@interface SMFileUtils : NSObject {

}
//列举指定目录下的文件和目录
+(NSArray*)listFiles:(NSString *)path;
+(NSArray*)listFolder:(NSString *)path;

//创建目录
+(BOOL)createDirctoryByPath:(NSString *)path;
//取得cache目录路径
+(NSString*)getCacheDirectory;
//取得cache目录带子路径
+(NSString*)getCacheDirectoryWith:(NSString*)subpath;
//取得Documents目录路径
+(NSString*)getDocumentsDirectory;
//取得Documents目录带子路径
+(NSString*)getDocumentsDirectoryWith:(NSString*)subpath;
//保存uiimage图片到指定目录，目录不存在自动创建
+(BOOL)saveUIImage:(NSString*)path filename:(NSString*)filename image:(UIImage*)image ;

+ (NSString*) fullBundlePath:(NSString*)bundlePath;

//将数组写入到文件
+(void)writePlistToCache:(NSData*)data filename:(NSString*)filename;
//读取文件到数组
+(NSData*)readPlistFromCache:(NSString*)filename;
//判断是否需要更新 规则为文件修改日起在一天内则不更新
+(BOOL)needDownload:(NSString *)filename;

@end
