//
//  FileOperation.h
//  TableSearch
//
//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//


#import "Reachability.h"

#import <Foundation/Foundation.h>

typedef enum
{
    fileTypeOfLogin = 0,
    fileTypeOfGetTopImage,
    fileTypeOfGetMyCommission,
    fileTypeOfGetBusinessRecommend,
    fileTypfOfGetBusinessRecommendDetail,
    fileTypeOfHome,
    fileTypeOfChuangfuRank,
    fileTypeOfPrsonalRank,
    fileTypeOfWangDianRank,
    fileTypeOfOpenProduct,
    fileTypeOfSearchProduct,
    fileTypeOfSubCategory,
    fileTypeOfUserInfo,
    fileTypeOfModifyPwd,
    fileTypeOfCategory
}fileOperationType;



@interface FileOperation : NSObject
{
    fileOperationType fType;
}


+(void)saveConfigKey:(NSString *)key value:(id)value;

/**
 *  获取服务器地址
 */
+(NSString *)getServerURL;

/**
 *  获取服务器IP端口
 */
+(NSString *)getServerPort;

/**
 *  获取服务器IP
 */
+(NSString *)getServerIP;

+(NSString*)getUserName;

+(NSString*)getPassword;


/**
 *  根据key删除保存的value
 *
 *  @param strKey 删除的关键字
 */
+(void)removeValueForKey:(NSString*)strKey;

+(BOOL)deleteFileFolderByPath:(NSString *)pathNam;

+(BOOL)isValidatePhoneNumber:(NSString *)phone;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidateUniNumber:(NSString *)uniNumber;
//+(void) checkUserInfo;

+(BOOL)chineseJudgeWithString:(NSString *)realname;


+(NSString *)ReturnFilePath;

+(NSString *)ReturnUserinfoFilePath;

+(NSString *)ReturnNetSetinfoFilePath;

+(NetworkStatus)checknetWorkType;

+ (UIImage *)setCustomImage:(NSString *)imageName andImageType:(NSString *)imageType;


#pragma mark - 从本地读取职员信息
+(NSMutableArray *)returnClientInfoListFromLocal;

#pragma mark - 从本地 根据id  获取name
+(NSString *)returnEmployNameWithID:(NSString *)strClienID;

+(void)CreateFolderWithPath:(NSString *)folderPath;

+(BOOL)checkIsFileExistWithFolderName:(NSString *)strFolderName;


+(void)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

+(void)writePlistFile:(NSString *)plistFileName setKey:(NSMutableArray *)keyName setValue:(NSMutableArray *)valueData;


@end
