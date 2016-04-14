//
//  FileOperation.m
//  TableSearch
//
//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//
#import "SMFileUtils.h"

#import "DataObject.h"

#import "DataPaser.h"

#import "Constants.h"
#import "FileOperation.h"

#import "UISmartMeterAppDelegate.h"

#import "DebugLog.h"


extern UISmartMeterAppDelegate *appDelegate;

@implementation FileOperation



+(void)saveConfigKey:(NSString *)key value:(id)value
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    [conf setObject:value  forKey:key];
    [conf synchronize];
}


/**
 *  获取服务器地址
 */
+(NSString *)getServerURL
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    
    DEBUG_NSLOG(@"服务器地址:%@",[conf valueForKey:SERVERURLADDRESS]);
    
    
    return [conf valueForKey:SERVERURLADDRESS];
}

/**
 *  获取服务器IP端口
 */
+(NSString *)getServerPort
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    // 端口为空
    NSLog(@"端口号:%@",[conf valueForKey:kSokectServerPort]);
    return [conf valueForKey:kSokectServerPort];
}

/**
 *  获取服务器IP
 */
+(NSString *)getServerIP
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    return [conf valueForKey:kSocketServerIP];
}



+(NSString*)getUserName
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    return [conf valueForKey:userLoginName];
}
+(NSString*)getPassword
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    return [conf valueForKey:userLoginPassword];
}


+(void)removeValueForKey:(NSString*)strKey
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    
    [conf removeObjectForKey:strKey];
    
    [conf synchronize];

}


#pragma mark --
#pragma marlk --
#pragma mark --利用正则表达式验证是否为手机号

+(BOOL)isValidatePhoneNumber:(NSString *)phone
{
    //NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSString *emailRegex = @"\\b(1)[358][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b"; 
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:phone];
}

#pragma mark --
#pragma marlk --
#pragma mark --利用正则表达式验证是否为邮箱
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

#pragma mark --
#pragma marlk --
#pragma mark --利用正则表达式验证是否为联通号
+(BOOL)isValidateUniNumber:(NSString *)uniNumber
{
    NSString *emailRegex = @"^(13[0-2]|15[5|6]|18[5|6])\\d{8}$"; 
    
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:uniNumber];
}

#pragma mark --
#pragma marlk --
#pragma mark --利用正则表达式验证是否为中文汉字
+(BOOL)chineseJudgeWithString:(NSString *)realname
{
    //NSString *realnameFilter = @"^[\u4e00-\u9fa5]";
    
    NSString *realnameFilter = @"[\u2E80-\u9FFF]+$";
    NSPredicate *fliter = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realnameFilter];
    return [fliter evaluateWithObject:realname];
}

#pragma mark -
#pragma mark 删除指定文件夹
+(BOOL)deleteFileFolderByPath:(NSString *)pathName
{
	BOOL OK = [[NSFileManager defaultManager]removeItemAtPath:pathName error:nil];
	
	if (OK) 
		return YES;
	return NO;
	
}


#pragma mark - ReturnFilePath
+(NSString *)ReturnFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	return documentsDirectory;
}


+(NSString *)ReturnUserinfoFilePath
{
	NSString *documentsDirectory=[self ReturnFilePath];
	return [documentsDirectory stringByAppendingPathComponent:KUserInfoFilename];
}

+(NSString *)ReturnNetSetinfoFilePath
{
	NSString *documentsDirectory=[self ReturnFilePath];
	return [documentsDirectory stringByAppendingPathComponent:KUserNetSetFilename];
}


// TODO: 图片
+ (UIImage *)setCustomImage:(NSString *)imageName andImageType:(NSString *)imageType
{
    NSString *imageComName = [NSString stringWithFormat:@"%@.%@", imageName, imageType];
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:extendName];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageComName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}


#pragma mark -
#pragma mark -
// TODO:检查网络类型
+(NetworkStatus)checknetWorkType
{
   Reachability* hostReach;
    
   hostReach = [[Reachability reachabilityWithHostName: @"www.baidu.com"] retain];
    
   NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    
   return netStatus;
}


+(BOOL)checkIsFileExistWithFolderName:(NSString *)strFolderName
{
    NSString* document=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString* folderPath=[document stringByAppendingPathComponent:strFolderName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        return YES;
    }
    
    return NO;
    
}


+(void)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSError *error = nil;
    
    [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error];
    
}


#pragma mark -
+(void)CreateFolderWithPath:(NSString *)folderPath //传入新建文件夹名字
{
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
	{
		////DEBUG_NSLOG(@"%@",folderPath);
#ifdef __IPHONE_2_0
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
#else
		[[NSFileManager defaultManager]  createDirectoryAtPath:folderPath attributes: nil];
#endif
		
	}	
}


//自动新增新的字典
+(void)writePlistFile:(NSString *)plistFileName setKey:(NSMutableArray *)keyName setValue:(NSMutableArray *)valueData 
{
	NSString *ValueStr;
	NSString *KeyStr;
	NSMutableDictionary  *dictionary;	
	NSString *documentsDirectory=plistFileName;
	
	if([[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory]) 
		dictionary=[[NSMutableDictionary alloc]initWithContentsOfFile:documentsDirectory];		
	else
		dictionary=[[NSMutableDictionary alloc]init];
	
	for (int i = 0; i<[keyName count]; i++)
	{
		ValueStr = [[NSString alloc] initWithFormat:@"%@",[valueData objectAtIndex:i]];
		KeyStr = [[NSString alloc] initWithFormat:@"%@",[keyName objectAtIndex:i]];
		
		[dictionary setValue:ValueStr forKey:KeyStr];	
		
		[ValueStr release];
		[KeyStr release];
	}
	
	[dictionary writeToFile:documentsDirectory atomically:YES];	
	[dictionary release];	
	dictionary = nil;
	
	
	
}


@end
