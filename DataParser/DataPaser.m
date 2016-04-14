//
//  DataPaser.m
//  Ministry of culture
//
//  Created by ZhouLiang on 14-4-1.
//  Copyright (c) 2014年 fengjing. All rights reserved.
//
#import "DataPaser.h"

#import "Util.h"
#import "ToolSet.h"
#import "model.h"

#import "DataObject.h"

@implementation DataPaser

+(NSString *)returnValuableString:(NSString *)keyValue
{
    if (keyValue != nil && ![keyValue isEqual:[NSNull null]])
    {
        if ([keyValue isEqualToString:@"(null)"] || [keyValue isEqualToString:@"null"] || [keyValue isEqualToString:@"<null>"])
        {
            
            return @"";
        }
        else
        {
            return keyValue;
        }
        
    }
    else
    {
        return @"";
    }
    
}

+(NSMutableArray *)returnDataWithData:(NSData *)data
{
    
    NSError *error;
    
    id jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(error) return nil;
    
    if(jsonDataDict)
    {
        NSMutableDictionary *mdict = (NSMutableDictionary *)jsonDataDict;

        if(mdict!=nil)
        {
            NSMutableArray *mArrayData = [[NSMutableArray alloc] initWithCapacity:0];
            
            
            NSMutableDictionary *dict = (NSMutableDictionary *)mdict;
            
            
            NSInteger indexnum = [[dict valueForKey:@"index_num"] integerValue];
            
            NSInteger total = [[dict valueForKey:@"total"] integerValue];
            NSInteger result_num = [[dict valueForKey:@"result_num"] integerValue];

            NSMutableDictionary *mdict = (NSMutableDictionary *)[dict valueForKey:@"bizs"];
            
            
            if(mdict!=nil)
            {
                
                NSMutableArray *mdictArray = (NSMutableArray *)[mdict valueForKey:@"biz"];
                
                if(mdictArray!=nil && [mdictArray count]>0)
                {
                    for(int i=0;i<[mdictArray count];i++)
                    {
                        NSMutableDictionary *mdict = (NSMutableDictionary *)[mdictArray objectAtIndex:i];
                        
                        
                        if(mdict)
                        {
                            NSString *strid = [mdict valueForKey:@"id"];
                            NSString *strname = [mdict valueForKey:@"name"];
                            NSString *straddr = [mdict valueForKey:@"addr"];
                            NSString *strtel = [mdict valueForKey:@"tel"];
                            
                            
                            
                            
                            
                            NSString *strcate = [mdict valueForKey:@"cate"];
                            
                            NSString *strrate = [NSString stringWithFormat:@"%@",[mdict valueForKey:@"rate"]];
                            
                            
                            //NSString *strrate = [mdict valueForKey:@"rate"];
                            NSString *strcost = [mdict valueForKey:@"cost"];
                            NSString *strdesc = [mdict valueForKey:@"desc"];
                            NSString *strdist = [mdict valueForKey:@"dist"];
                            NSString *strlng = [mdict valueForKey:@"lng"];
                            NSString *strlat = [mdict valueForKey:@"lat"];
                            NSString *strimg_url = [mdict valueForKey:@"img_url"];
                            
                            
                            DataObjectSearch *dataSearch = [[DataObjectSearch alloc] init];
                            
                            dataSearch.index_num = indexnum;
                            dataSearch.total = total;
                            dataSearch.result_num = result_num;
                            
                            
                            dataSearch.strID = strid;
                            dataSearch.strName = strname;
                            dataSearch.addr = straddr;
                            dataSearch.tel = strtel;
                            
                            dataSearch.cate = strcate;
                            dataSearch.rate = strrate;
                            dataSearch.cost = strcost;
                            
                            dataSearch.desc = strdesc;
                            dataSearch.dist = strdist;
                            dataSearch.lng = strlng;
                            
                            dataSearch.lat = strlat;
                            
                            dataSearch.img_url = strimg_url;
                            
                            
                            [mArrayData addObject:dataSearch];
                            
                            
                        }
                    }
                }
                else
                {
                    return nil;
                }
                
                
            }
            else
            {
                return nil;
            }
            
            
            if([mArrayData count]>0)
            {
                return mArrayData;
            }
            else
            {
                return nil;
            }
            
            
        }
        else
        {
            return nil;
        }
        
    }
    
    
    return nil;
}


#pragma mark- json 解析
+(id)returnObjectWithString:(NSString *)receive withType:(jsonDataType)jType
{
    id curObject = nil;
    
    NSError *error;
    
    NSData* data=[receive dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(error) return nil;
    
    if(jsonDataDict)
    {
        
        NSMutableDictionary *mdict = (NSMutableDictionary *)jsonDataDict;
        NSLog(@"%u",jType);
#pragma mark -  获取服务器地址列表
        if(jType == jsonDataTypeGetServerURL )
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)obj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        for(int j=0;j<[array count];j++)
                        {
                            NSMutableDictionary *newDict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            NSNumber *numDeviceID = [newDict valueForKey:@"Id"];
                            NSString *strId = [Util returnValuableString:[numDeviceID stringValue]];
                            
                            NSString *strServerName= [newDict objectForKey:@"ServerName"];
                            strServerName = [Util returnValuableString:strServerName];
                            
                            NSString *strIP=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"IP"]] ;
                            strIP = [Util returnValuableString:strIP];
                            
//                            NSString *strPort=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"Port"]] ;
//                            strPort = [Util returnValuableString:strPort];

                            NSNumber *numPort = [newDict valueForKey:@"Port"];
                            NSString *strPort = [Util returnValuableString:[numPort stringValue]];
                            
                            
                            NSString *strApiDomain = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"ApiDomain"]] ;
                            strApiDomain = [Util returnValuableString:strApiDomain];
                            
                            DataObjectServerObject *serverInfo =[[DataObjectServerObject alloc]init];
                            serverInfo.strServerName = strServerName;
                            serverInfo.strApiDomain = strApiDomain;
                            serverInfo.strId = strId;
                            serverInfo.strIP = strIP;
                            serverInfo.strPort = strPort;
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
                            [tempObject.arrObjects addObject:serverInfo];
                            
                        }
                        
                        
                    }
                    else
                    {
                        return nil;
                    }
                }
                
            }
            
            
            return tempObject;
        }
        #pragma mark -  登录
        else if(jType == jsonDataTypeLogin)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            strMessage = [Util returnValuableString:strMessage];
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess !=1000)
            {
                return tempObject;
            }
            
            NSDictionary *dataDic = [mdict objectForKey:@"Data"];
            
            if (dataDic) {
                
                
                UserInfo *userInfo = [UserInfo shareInstance];
                
//                NSNumber *numApplication = [dataDic objectForKey:@"showApplication"];
//                
//                if(numApplication !=nil && [numApplication isEqual:[NSNull class]])
//                {
//                    userInfo.showApplication = [numApplication intValue];
//                }
                
                
                NSNumber *numUserID = [dataDic objectForKey:@"UserId"];
                
                NSString *strUserId = [numUserID stringValue];
                strUserId = [Util returnValuableString:strUserId];
                userInfo.strUserID = strUserId;
                
                NSString *strUserName = [dataDic objectForKey:@"UserName"];
                strUserName = [Util returnValuableString:strUserName];
                userInfo.strUserName = strUserName;
                
                NSString *strEnName = [dataDic objectForKey:@"EnName"];
                strEnName = [Util returnValuableString:strEnName];
                
                
                //此值为1时 做不同处理
                userInfo.showApplication = [strEnName intValue];
                
                
                //userInfo.strEnName = strEnName;
                
                NSString *strCnName = [dataDic objectForKey:@"CnName"];
                strCnName = [Util returnValuableString:strCnName];
                userInfo.strChName = strCnName;
                
                NSString *strPhoto = [dataDic objectForKey:@"Photo"];
                strPhoto = [Util returnValuableString:strPhoto];
                userInfo.strUserHeaderURL = strPhoto;
                
                NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
                
                [conf setObject:strPhoto forKey:@"userIconURL"];
                
            }
            
            return tempObject;
        }
#pragma mark -  添加监护人、吃药提醒 、修改密码、上传图片
        else if(jType == jsonDataTypeAddPerson || jType == jsonDataTypeAddTakeMedicineRemind || jType == jsonDataTypeAddElectronic || jType == jsonDataTypeUpdatePwd || jType == jsonDataTypeUploadIcon)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            DEBUG_NSLOG(@"success :%d",success);
            return tempObject;
        }
#pragma mark -  经纬度转地址
        else if(jType == jsonDataTypeCoordinateToAddress)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            strMessage = [Util returnValuableString:strMessage];
            
            NSString *strData= [mdict valueForKey:@"Data"];
            strData = [Util returnValuableString:strData];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            if(strData !=nil && [strData length])
            {
                [locationInfo shareInstance].detailAddress = strData;
            }
            DEBUG_NSLOG(@"success :%d",success);
            return tempObject;
        }
#pragma mark -  获取验证码
        else if(jType == jsonDataTypeCheckCode)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            // strMessage为空
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
//            NSLog(@"%d %@",tempObject.intSuccess,tempObject.strMessage);
            DEBUG_NSLOG(@"success :%d",success);
            
            if (tempObject.intSuccess != 1000) {
                
                return tempObject;
            }
            
            NSString *strCode = [mdict valueForKey:@"Data"];
            
            strCode = [Util returnValuableString:strCode];

            NSLog(@"%@ ",strCode);
            if([strCode length])
            {
                [UserInfo shareInstance].strCheckCode = strCode;
            }
////            //JCK改
            id obj = [mdict objectForKey:@"Data"];
            if (obj) {
                if (obj!=nil && [obj isKindOfClass:[NSMutableDictionary class]]) {
                    NSMutableDictionary *subDic = (NSMutableDictionary *)obj;
                    NSNumber *numSecond =[subDic valueForKey:@""];
                    NSString *srrSecindValue =[numSecond stringValue];
                    srrSecindValue = [Util returnValuableString:srrSecindValue];
                    
                    DataObjectMyDeviceList *device = [[DataObjectMyDeviceList alloc] init];
                    device.strMessage = srrSecindValue;
                    if (tempObject.arrObjects == nil) {
                        tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [tempObject.arrObjects addObject:device];
                }
            }
            
            
            return tempObject;

            
        }
#pragma mark -  检查更新
        else if(jType == jsonDataTypeCheckVersion)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            DEBUG_NSLOG(@"success :%d",success);
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableDictionary class]])
                {
                    NSMutableDictionary *newDict = (NSMutableDictionary *)obj;
                    
                    NSString *strVersion = [newDict objectForKey:@"VersionName"];
                    strVersion = [Util returnValuableString:strVersion];
                    
                    NSString *strIsForcedUpdate= [newDict objectForKey:@"IsForcedUpdate"];
                    strIsForcedUpdate = [Util returnValuableString:strIsForcedUpdate];
                    
                    NSString *strFilePath = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"FilePath"]] ;
                    strFilePath = [Util returnValuableString:strFilePath];
                    
                    NSString *strContents=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"Contents"]] ;
                    strContents = [Util returnValuableString:strContents];
                    
                    DataObjectCheckUpdate *tmpcheckUpdate  = [[DataObjectCheckUpdate alloc] init];
                    tmpcheckUpdate.strVersion = strVersion;
                    tmpcheckUpdate.strUpdateContent = strContents;
                    tmpcheckUpdate.forceUpdateTag = [strIsForcedUpdate integerValue];
                    tmpcheckUpdate.strDownlaodURL = strFilePath;
                    
                    if(tempObject.arrObjects == nil)
                    {
                        tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [tempObject.arrObjects addObject:tmpcheckUpdate];
                }
            }
            
            return tempObject;
        }
#pragma mark -  设备类别
        else if(jType == jsonDataTypeMyDeviceList )
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
 
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)obj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        
                        for(int j=0;j<[array count];j++)
                        {
                        
                            NSMutableDictionary *newDict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            NSNumber *numDeviceID = [newDict valueForKey:@"Id"];

                            NSNumber *numType = [newDict valueForKey:@"DeviceType"];
                            
                            NSString *strDeviceName= [newDict objectForKey:@"DeviceName"];
                            strDeviceName = [Util returnValuableString:strDeviceName];
                            
                            NSString *strDeviceIMEI=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"IMEI"]] ;
                            strDeviceIMEI = [Util returnValuableString:strDeviceIMEI];
                            
                            NSString *strDeviceMobile=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"Mobile"]] ;
                            strDeviceMobile = [Util returnValuableString:strDeviceMobile];
                            
                            NSString *strDeviceOwnerName = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"OwnerName"]] ;
                            strDeviceOwnerName = [Util returnValuableString:strDeviceOwnerName];
                            
                            NSNumber *numStatus = [newDict valueForKey:@"Status"];
                            
                            NSNumber *numUserID = [newDict valueForKey:@"UserId"];
                        
                            
                            NSString *strCreateTime = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"CreateTime"]] ;
                            strCreateTime = [Util returnValuableString:strCreateTime];
                            
                            NSString *strSocketLastIP=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"SocketLastIP"]] ;
                            strSocketLastIP = [Util returnValuableString:strSocketLastIP];
                            
                            NSString *strValidityDate = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"ValidityDate"]] ;
                            strValidityDate = [Util returnValuableString:strValidityDate];
                            
                            NSString *strHealthInfo = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"HealthInfo"]] ;
                            strHealthInfo = [Util returnValuableString:strHealthInfo];
                            
                            
                            DataObjectMyDeviceList *deviceInfo =[[DataObjectMyDeviceList alloc]init];
                            deviceInfo.strDeviceId = [numDeviceID stringValue];
                            deviceInfo.strDeviceType = [numType stringValue];
                            deviceInfo.strDeviceName  =strDeviceName;
                            deviceInfo.strDeviceIMEI = strDeviceIMEI;
                            deviceInfo.strDeviceMobile = strDeviceMobile;
                            deviceInfo.strDeviceOwnerName = strDeviceOwnerName;
                            deviceInfo.strStatus = [numStatus stringValue];
                            deviceInfo.strUserId = [numUserID stringValue];
                            deviceInfo.strCreateTime = strCreateTime;
                            deviceInfo.strSocketLastIP  = strSocketLastIP;
                            deviceInfo.strValidityDate = strValidityDate;
                            deviceInfo.strHealthInfo = strHealthInfo;
                            
                            id objPerson= [newDict objectForKey:@"Guardians"];
                            
                            if(objPerson !=nil && [objPerson isKindOfClass:[NSArray class]])
                            {
                                NSMutableArray *tmpPersonAy = (NSMutableArray*)objPerson;
                                
                                if([tmpPersonAy count] && tmpPersonAy !=nil)
                                {
                                    for(int j=0;j<[tmpPersonAy count];j++)
                                    {
                                        NSMutableDictionary *newDict = (NSMutableDictionary *)[tmpPersonAy objectAtIndex:j];
                                        
                                        NSString *strGuardianName = [newDict objectForKey:@"GuardianName"];
                                        strGuardianName = [Util returnValuableString:strGuardianName];
                                        
                                        NSString *strGuardianMobile = [newDict objectForKey:@"GuardianMobile"];
                                        strGuardianMobile = [Util returnValuableString:strGuardianMobile];
                                        
                                        NSString *strGuardianPhoto = [newDict objectForKey:@"Photo"];
                                        strGuardianPhoto = [Util returnValuableString:strGuardianPhoto];
                                        
                                        NSNumber *numID = [newDict valueForKey:@"Id"];
                                        
                                        NSNumber *numDeviceId = [newDict valueForKey:@"DeviceId"];
                                        
                                        NSNumber *numGuardianId = [newDict valueForKey:@"GuardianId"];
                                        
                                        NSString *strNickName= [newDict objectForKey:@"NickName"];
                                        strDeviceName = [Util returnValuableString:strDeviceName];
                                        
                                        NSString *strCreateTime=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"CreateTime"]] ;
                                        strCreateTime = [Util returnValuableString:strCreateTime];
                                        
                                        DataObjectMyDeviceList *subObj = [[DataObjectMyDeviceList alloc]init];
                                        subObj.strGuardianName  =strGuardianName;
                                        subObj.strGuardianManMobile  =strGuardianMobile;
                                        subObj.strGuardianManPhoto = strGuardianPhoto;
                                        subObj.strGuardianId = [numID stringValue];
                                        
                                        subObj.strGuardianManDeviceId = [numDeviceId stringValue];
                                        
                                        subObj.strGuardianId = [numGuardianId stringValue];
                                        
                                        subObj.strNickName = strNickName;
                                        subObj.strGuardManCreateTime = strCreateTime;
                                        
                                        if(deviceInfo.subArrayObject == nil)
                                        {
                                            deviceInfo.subArrayObject = [[NSMutableArray alloc]init];
                                        }
                                        
                                        
                                        [deviceInfo.subArrayObject addObject:subObj];
                                        
                                    }
                                }
                                
                            }
                            
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
                            [tempObject.arrObjects addObject:deviceInfo];
                            
                        }
                        
                        
                    }
                    else
                    {
                        return nil;
                    }
                }
                
            }
            
            
            return tempObject;
        }
#pragma mark -  我的报警消息
        else if(jType == jsonDataTypeAlarmInfo)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)obj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        
                        for(int j=0;j<[array count];j++)
                        {
                            NSMutableDictionary *newDict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            NSString *strDeviceName = [newDict objectForKey:@"DeviceName"];
                            strDeviceName = [Util returnValuableString:strDeviceName];

                            NSNumber *numType = [newDict valueForKey:@"DeviceType"];
                            
                            NSString *strMobile=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"Mobile"]] ;
                            strMobile = [Util returnValuableString:strMobile];
                            
                            NSString *strOwnerName=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"OwnerName"]] ;
                            strOwnerName = [Util returnValuableString:strOwnerName];
                            
                            NSNumber *numID = [newDict valueForKey:@"Id"];
                            
                            NSNumber *numDeviceId = [newDict valueForKey:@"DeviceId"];
                            
                            NSNumber *numAlarmType = [newDict valueForKey:@"AlarmType"];
                            
                            
                            NSString *strAlarmContent = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"AlarmContent"]] ;
                            strAlarmContent = [Util returnValuableString:strAlarmContent];
                            
                            NSString *strCreateTime = [newDict objectForKey:@"CreateTime"] ;
                            strCreateTime = [Util returnValuableString:strCreateTime];
                            NSLog(@"CreateTime%@ %@",[newDict objectForKey:@"CreateTime"],strCreateTime);
                            
                            DataObjectAlarmInfo *alarmInfo = [[DataObjectAlarmInfo alloc] init];
                            alarmInfo.strDeviceName = strDeviceName;
                            alarmInfo.strDeviceType = [numType stringValue];
                            alarmInfo.strMobile = strMobile;
                            alarmInfo.strOwnerName = strOwnerName;
                            
                            alarmInfo.strId = [numID stringValue];
                            alarmInfo.strDeviceId = [numDeviceId stringValue];
                            alarmInfo.strAlarmType = [numAlarmType stringValue];
                            alarmInfo.strAlarmContent = strAlarmContent;
                            
                            alarmInfo.strCreateTime = strCreateTime;
                            
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
                            [tempObject.arrObjects addObject:alarmInfo];

                        }
                        
                        
                    }
                    else
                    {
                        return nil;
                    }
                }
                
            }
            
            
            return tempObject;
        }
#pragma mark -  我的提醒列表
        else if(jType == jsonDataTypeMyRemindInfo)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)obj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        
                        for(int j=0;j<[array count];j++)
                        {
                            NSMutableDictionary *newDict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            NSNumber *numID = [newDict valueForKey:@"Id"];
                            
                            //NSNumber *numGuardianId = [newDict valueForKey:@"GuardianId"];
                            
                            //NSNumber *numDeviceId = [newDict valueForKey:@"DeviceId"];
                            
                            NSString *strOwnerName = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"OwnerName"]] ;
                            strOwnerName = [Util returnValuableString:strOwnerName];
                            
                            NSString *strMobile = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"Mobile"]] ;
                            strMobile = [Util returnValuableString:strMobile];

                            NSString *strTipTime = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"TipTime"]] ;
                            strTipTime = [Util returnValuableString:strTipTime];
                            
                            NSString *strWarnTip = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"WarnTip"]] ;
                            strWarnTip = [Util returnValuableString:strWarnTip];
                            
                            NSString *strCreateTime = [NSString stringWithFormat:@"%@",[newDict objectForKey:@"CreateTime"]] ;
                            //strCreateTime = [Util returnValuableString:strCreateTime];
                            
                            DataObjectAlarmInfo *alarmInfo = [[DataObjectAlarmInfo alloc] init];
                            alarmInfo.strOwnerName = strOwnerName;
                            alarmInfo.strMobile = strMobile;
                            alarmInfo.strId = [numID stringValue];
                            alarmInfo.strAlarmContent = strWarnTip;
                            
                            alarmInfo.strCreateTime = strCreateTime;
                            
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
                            [tempObject.arrObjects addObject:alarmInfo];
                            
                        }
                        
                        
                    }
                    else
                    {
                        return nil;
                    }
                }
                
            }
            
            
            return tempObject;
        }
#pragma mark -  多人监控
        else if(jType == jsonDataTypePersonMonitoring)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)obj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        
                        for(int j=0;j<[array count];j++)
                        {
                            NSMutableDictionary *mdict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            DataObjectPersonMonitoriing *personObj = [[DataObjectPersonMonitoriing alloc]init];
                            
                            id objLocation = [mdict valueForKey:@"locations"];
                            if(objLocation!=nil && [objLocation isKindOfClass:[NSArray class]])
                            {
                                NSArray *tmpArray = (NSArray*)objLocation;
                                
                                if(tmpArray !=nil && [tmpArray count])
                                {
                                    NSDictionary *locationDict = (NSDictionary*)[tmpArray objectAtIndex:0];
                                    
                                    NSNumber *lat = [locationDict valueForKey:@"Lat"];
                                    
                                    NSNumber *lon = [locationDict valueForKey:@"Lon"];
                                    
                                    NSString *strLat = [Util returnValuableString:[lat stringValue]];
                                    
                                    NSString *strLon = [Util returnValuableString:[lon stringValue]];
                                    NSString *strCreateTime = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"CreateTime"]] ;
                                    strCreateTime = [Util returnValuableString:strCreateTime];
                                    personObj.strCreateTime = strCreateTime;
                                    
                                    personObj.strLat = strLat;
                                    personObj.strLon = strLon;
                                    NSString *strAddressDate = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"Address"]];
                                    strAddressDate = [Util returnValuableString:strAddressDate];
//                                    NSLog(@"strAddressDate%@",strAddressDate);
                                    personObj.strAddress = strAddressDate;
                                    
                                }
                                
                            }
                            
                            NSNumber *numID = [mdict objectForKey:@"Id"];
                            
                            NSString *strId = @"";
                            strId = [Util returnValuableString:[numID stringValue]];
                            
                            NSNumber *numType = [mdict objectForKey:@"DeviceType"];
                            
                            NSString *strDeviceType= @"";
                            strDeviceType = [Util returnValuableString:[numType stringValue]];
                            
                            NSString *strDeviceName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"DeviceName"]] ;
                            strDeviceName = [Util returnValuableString:strDeviceName];
                            
                            NSString *strIMEI = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"IMEI"]] ;
                            strIMEI = [Util returnValuableString:strIMEI];
                            
                            NSString *strMobile = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Mobile"]] ;
                            strMobile = [Util returnValuableString:strMobile];
                            
                            NSString *strOwnerName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"OwnerName"]] ;
                            strOwnerName = [Util returnValuableString:strOwnerName];
                            
                            NSNumber *numStatus = [mdict objectForKey:@"GPSStatus"]; //Status
                            
                            NSString *strStatus= @"";
                            strStatus = [Util returnValuableString:[numStatus stringValue]];
                            
                            NSNumber *numUId = [mdict objectForKey:@"UserId"];
                            
                            NSString *strUserId= @"";
                            strUserId = [Util returnValuableString:[numUId stringValue]];
                            
                            NSString *strSocketLastIP = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"SocketLastIP"]] ;
                            strSocketLastIP = [Util returnValuableString:strSocketLastIP];
                            
                            NSString *strSocketLastTime = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"SocketLastTime"]] ;
                            strSocketLastTime = [Util returnValuableString:strSocketLastTime];
                            
                            NSString *strValidityDate = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"ValidityDate"]] ;
                            strValidityDate = [Util returnValuableString:strValidityDate];
                            
                            personObj.strID =strId;
                            personObj.strDeviceType = strDeviceType;
                            personObj.strDeviceName = strDeviceName;
                            personObj.strIMEI = strIMEI;
                            personObj.strMobile = strMobile;
                            personObj.strOwnerName = strOwnerName;
                            personObj.strStatus = strStatus;
                            personObj.strUserId = strUserId;
                            personObj.strSocketLastIP = strSocketLastIP;
                            personObj.strSocketLastTime = strSocketLastTime;
                            personObj.strValidityDate = strValidityDate;
                            
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
                            [tempObject.arrObjects addObject:personObj];
                            
                        }
                        
                    }
                    else
                    {
                        return nil;
                    }
                }
                else if (obj!=nil && [obj isKindOfClass:[NSMutableDictionary class]])
                {
                    NSDictionary *mdict = (NSDictionary*)obj;
                    
                    DataObjectPersonMonitoriing *personObj = [[DataObjectPersonMonitoriing alloc]init];
                    
                    id objLocation = [mdict valueForKey:@"locations"];
                    if(objLocation!=nil && [objLocation isKindOfClass:[NSArray class]])
                    {
                        NSArray *tmpArray = (NSArray*)objLocation;
                        
                        if(tmpArray !=nil && [tmpArray count])
                        {
                            NSDictionary *locationDict = (NSDictionary*)[tmpArray objectAtIndex:0];
                            
                            NSNumber *lat = [locationDict valueForKey:@"Lat"];
                            
                            NSNumber *lon = [locationDict valueForKey:@"Lon"];
                            
                            NSString *strLat = [Util returnValuableString:[lat stringValue]];
                            
                            NSString *strLon = [Util returnValuableString:[lon stringValue]];
                            
                            personObj.strLat = strLat;
                            personObj.strLon = strLon;
                        }
                        
                    }
                    
                    NSNumber *numID = [mdict objectForKey:@"Id"];
                    
                    NSString *strId = @"";
                    strId = [Util returnValuableString:[numID stringValue]];
                    
                    NSNumber *numType = [mdict objectForKey:@"DeviceType"];
                    
                    NSString *strDeviceType= @"";
                    strDeviceType = [Util returnValuableString:[numType stringValue]];
                    
                    NSString *strDeviceName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"DeviceName"]] ;
                    strDeviceName = [Util returnValuableString:strDeviceName];
                    
                    NSString *strIMEI = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"IMEI"]] ;
                    strIMEI = [Util returnValuableString:strIMEI];
                    
                    NSString *strMobile = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Mobile"]] ;
                    strMobile = [Util returnValuableString:strMobile];
                    
                    NSString *strOwnerName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"OwnerName"]] ;
                    strOwnerName = [Util returnValuableString:strOwnerName];
                    
                    NSNumber *numStatus = [mdict objectForKey:@"Status"];
                    
                    NSString *strStatus= @"";
                    strStatus = [Util returnValuableString:[numStatus stringValue]];
                    
                    NSNumber *numUId = [mdict objectForKey:@"UserId"];
                    
                    NSString *strUserId= @"";
                    strUserId = [Util returnValuableString:[numUId stringValue]];
                    
                    NSString *strCreateTime = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"CreateTime"]] ;
                    strCreateTime = [Util returnValuableString:strCreateTime];
                    
                    NSString *strSocketLastIP = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"SocketLastIP"]] ;
                    strSocketLastIP = [Util returnValuableString:strSocketLastIP];
                    
                    NSString *strSocketLastTime = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"SocketLastTime"]] ;
                    strSocketLastTime = [Util returnValuableString:strSocketLastTime];
                    
                    NSString *strValidityDate = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"ValidityDate"]] ;
                    strValidityDate = [Util returnValuableString:strValidityDate];
                    
                    personObj.strID =strId;
                    personObj.strDeviceType = strDeviceType;
                    personObj.strDeviceName = strDeviceName;
                    personObj.strIMEI = strIMEI;
                    personObj.strMobile = strMobile;
                    personObj.strOwnerName = strOwnerName;
                    personObj.strStatus = strStatus;
                    personObj.strUserId = strUserId;
                    personObj.strCreateTime = strCreateTime;
                    personObj.strSocketLastIP = strSocketLastIP;
                    personObj.strSocketLastTime = strSocketLastTime;
                    personObj.strValidityDate = strValidityDate;
                    
                    if(tempObject.arrObjects == nil)
                    {
                        tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [tempObject.arrObjects addObject:personObj];
                    
                }
                
                
            }
            
            
            return tempObject;
        }
#pragma mark -  电子围栏
        else if(jType == jsonDataTypeElectronic)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                /****/
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    
//                }
                NSMutableArray *array = (NSMutableArray *)obj[@"locations"];//大类Arr
                if(array!=nil && [array count]>0)
                {
//                    int i = 0;
                    for(int j=0;j<[array count];j++)
                    {
//                        i ++;
//                        for (NSDictionary *dic in array)
//                        {
//                            NSLog(@"JCK -- %@ %@ %d",dic[@"Address"],dic[@"CreateTime"],i);
////                            model *m = [[model alloc] init];
////                            m.Address = dic[@"Address"];
////                            m.CreateTime = dic[@"CreateTime"];
//                        }
//                        
////                        [self.buttonDatas addObject:buttonModel];
//                        if (i > 20 ) {
//                            break ;
//                        }
//
//                        NSMutableDictionary *mdict = (NSMutableDictionary *)[array objectAtIndex:j];
//                        
//                        DataObjectPersonMonitoriing *personObj = [[DataObjectPersonMonitoriing alloc]init];
//                        
//                        id objLocation = [mdict valueForKey:@"locations"];
//                        if(objLocation!=nil && [objLocation isKindOfClass:[NSArray class]])
//                        {
//                            NSArray *tmpArray = (NSArray*)objLocation;
//                            
//                            if(tmpArray !=nil && [tmpArray count])
//                            {
//                                NSDictionary *locationDict = (NSDictionary*)[tmpArray objectAtIndex:0];
//                                
//                                NSNumber *lat = [locationDict valueForKey:@"Lat"];
//                                
//                                NSNumber *lon = [locationDict valueForKey:@"Lon"];
//                                
//                                NSString *strLat = [Util returnValuableString:[lat stringValue]];
//                                
//                                NSString *strLon = [Util returnValuableString:[lon stringValue]];
//                                
//                                personObj.strLat = strLat;
//                                personObj.strLon = strLon;
//                                
//                                NSString *strAddress = [locationDict valueForKey:@"Address"];
//                                NSLog(@"JCK -- %@",strAddress);
//                            }
//                            
//                        }
//                        
//                        NSNumber *numID = [mdict objectForKey:@"Id"];
//                        
//                        NSString *strId = @"";
//                        strId = [Util returnValuableString:[numID stringValue]];
//                        
//                        NSNumber *numType = [mdict objectForKey:@"DeviceType"];
//                        
//                        NSString *strDeviceType= @"";
//                        strDeviceType = [Util returnValuableString:[numType stringValue]];
//                        
//                        NSString *strDeviceName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"DeviceName"]] ;
//                        strDeviceName = [Util returnValuableString:strDeviceName];
//                        
//                        NSString *strIMEI = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"IMEI"]] ;
//                        strIMEI = [Util returnValuableString:strIMEI];
//                        
//                        NSString *strMobile = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Mobile"]] ;
//                        strMobile = [Util returnValuableString:strMobile];
//                        
//                        NSString *strOwnerName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"OwnerName"]] ;
//                        strOwnerName = [Util returnValuableString:strOwnerName];
//                        
//                        NSNumber *numStatus = [mdict objectForKey:@"Status"];
//                        
//                        NSString *strStatus= @"";
//                        strStatus = [Util returnValuableString:[numStatus stringValue]];
//                        
//                        NSNumber *numUId = [mdict objectForKey:@"UserId"];
//                        
//                        NSString *strUserId= @"";
//                        strUserId = [Util returnValuableString:[numUId stringValue]];
//                        
//                        NSString *strCreateTime = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"CreateTime"]] ;
//                        strCreateTime = [Util returnValuableString:strCreateTime];
//                        
//                        NSString *strSocketLastIP = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"SocketLastIP"]] ;
//                        strSocketLastIP = [Util returnValuableString:strSocketLastIP];
//                        
//                        NSString *strSocketLastTime = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"SocketLastTime"]] ;
//                        strSocketLastTime = [Util returnValuableString:strSocketLastTime];
//                        
//                        NSString *strValidityDate = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"ValidityDate"]] ;
//                        strValidityDate = [Util returnValuableString:strValidityDate];
//                        
//                        personObj.strID =strId;
//                        personObj.strDeviceType = strDeviceType;
//                        personObj.strDeviceName = strDeviceName;
//                        personObj.strIMEI = strIMEI;
//                        personObj.strMobile = strMobile;
//                        personObj.strOwnerName = strOwnerName;
//                        personObj.strStatus = strStatus;
//                        personObj.strUserId = strUserId;
//                        personObj.strCreateTime = strCreateTime;
//                        personObj.strSocketLastIP = strSocketLastIP;
//                        personObj.strSocketLastTime = strSocketLastTime;
//                        personObj.strValidityDate = strValidityDate;
//                        
//                        if(tempObject.arrObjects == nil)
//                        {
//                            tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
//                        }
//                        [tempObject.arrObjects addObject:personObj];
                        
                    }
                    
                }
                else
                {
                    return nil;
                }
                /****/
                if(obj!=nil && [obj isKindOfClass:[NSArray class]])
                {

                }
                else if (obj!=nil && [obj isKindOfClass:[NSMutableDictionary class]])
                {
                    NSDictionary *mdict = (NSDictionary*)obj;
                    
                    DataObjectElectronicInfo *personObj = [[DataObjectElectronicInfo alloc]init];
                    NSNumber *numID = [mdict objectForKey:@"Id"];
                    
                    NSString *strId = @"";
                    strId = [Util returnValuableString:[numID stringValue]];
                    
                    NSNumber *numDeviceID = [mdict objectForKey:@"DeviceId"];
                    
                    NSString *strDeviceID= @"";
                    strDeviceID = [Util returnValuableString:[numDeviceID stringValue]];
                    
                    NSNumber *numLat= [mdict objectForKey:@"Lat"];
                    
                    NSString *strLat= @"";
                    strLat = [Util returnValuableString:[numLat stringValue]];
                    
                    NSNumber *numLon= [mdict objectForKey:@"Lon"];
                    
                    NSString *strLon= @"";
                    strLon = [Util returnValuableString:[numLon stringValue]];
                    
                    NSNumber *numRadius = [mdict objectForKey:@"Radius"];
                    
                    NSString *strRadius= @"";
                    strRadius = [Util returnValuableString:[numRadius stringValue]];
                    
                    NSString *strCreateTime = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"CreateTime"]] ;
                    strCreateTime = [Util returnValuableString:strCreateTime];
                    
                    NSString *strAddress = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Address"]] ;
                    strAddress = [Util returnValuableString:strAddress];
                    
                    personObj.strId =strId;
                    personObj.strDeviceId = strDeviceID;
                    personObj.strLat = strLat;
                    personObj.strLon = strLon;
                    personObj.strRadius = strRadius;
                    NSLog(@"%@",strRadius);
                    personObj.strCreateTime = strCreateTime;
                    personObj.strAddress = strAddress;
                    
                    id objLocation = [mdict valueForKey:@"locations"];
                    if(objLocation!=nil && [objLocation isKindOfClass:[NSArray class]])
                    {
                        NSArray *tmpArray = (NSArray*)objLocation;
                        
                        if(tmpArray !=nil && [tmpArray count])
                        {
                            for(int i=0;i<[tmpArray count];i++)
                            {
                                NSDictionary *locationDict = (NSDictionary*)[tmpArray objectAtIndex:i];
                                
                                NSNumber *lat = [locationDict valueForKey:@"Lat"];
                                
                                NSNumber *lon = [locationDict valueForKey:@"Lon"];
                                
                                NSString *strLat = [Util returnValuableString:[lat stringValue]];
                                
                                NSString *strLon = [Util returnValuableString:[lon stringValue]];
                                
                                NSString *strAddress = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"Address"]] ;
                                strAddress = [Util returnValuableString:strAddress];
                                
                                DataObjectElectronicInfo *subObj = [[DataObjectElectronicInfo alloc]init];
                                
                                subObj.strLat = strLat;
                                subObj.strLon = strLon;
                                subObj.strAddress = strAddress;
                                
                                if(personObj.subPointArray== nil)
                                {
                                    personObj.subPointArray = [[NSMutableArray alloc]init];
                                    
                                }
                                
                                [personObj.subPointArray addObject:subObj];
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    if(tempObject.arrObjects == nil)
                    {
                        tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [tempObject.arrObjects addObject:personObj];
                    
                }
                
                
            }
            
            
            return tempObject;
        }
#pragma mark -  历史回放
        else if(jType == jsonDataTypeHistoryPlayBack )
        {

            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)obj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        
                        for(int j=0;j<[array count];j++)
                        {
//                            int i = 0;
//                            i++;

                            NSMutableDictionary *newDict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            
                            NSNumber *numDeviceId = [newDict valueForKey:@"DeviceId"];
                            
                            NSNumber *numLon = [newDict valueForKey:@"Lon"];
                            
                            NSNumber *numLat = [newDict valueForKey:@"Lat"];
                            
                            NSString *strDeviceMobile=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"CreateTime"]] ;
                            strDeviceMobile = [Util returnValuableString:strDeviceMobile];
                            
                            NSString *strAddress=  [NSString stringWithFormat:@"%@",[newDict objectForKey:@"Address"]] ;
                            strAddress = [Util returnValuableString:strAddress];
                            
                            
                            DataObjectMyDeviceList *deviceInfo =[[DataObjectMyDeviceList alloc]init];
                            deviceInfo.strDeviceId = [numDeviceId stringValue];
                            deviceInfo.strLat = [numLat stringValue];
                            deviceInfo.strLon = [numLon stringValue];
                            deviceInfo.strAddress = strAddress;
                            deviceInfo.strCreateTime = strDeviceMobile;
                            
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
//                            if ([strDeviceMobile hasSuffix:@":00"]) {
                                [tempObject.arrObjects addObject:deviceInfo];
//                            }
                           
                            
                        }
                        
                        
                    }
                    else
                    {
                        return nil;
                    }
                }
                
            }
            
            
            return tempObject;
        }
#pragma mark -  健康五大类
        else if(jType == jsonDataTypeHealthItems)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)obj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        for(int j=0;j<[array count];j++)
                        {
                            NSMutableDictionary *newDict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            NSNumber *numId = [newDict valueForKey:@"Id"];
                            
                            NSNumber *numDeviceId = [newDict valueForKey:@"DeviceId"];
                            
                            NSString *strMadeTime= [newDict objectForKey:@"MadeTime"];
                            
                            NSNumber *numHeartTimes = [newDict valueForKey:@"HeartTimes"];
                            
                            NSNumber *numLowPressure = [newDict valueForKey:@"LowPressure"];
                            
                            NSNumber *numHighPressure = [newDict valueForKey:@"HighPressure"];
                            NSLog(@"%@",numHighPressure);
                            NSNumber *numSugarValue = [newDict valueForKey:@"SugarValue"];
                            
                            NSNumber *numSeconds = [newDict valueForKey:@"Second"];
                            
                            NSNumber *numSportValue = [newDict valueForKey:@"SportValue"];
                            
                            NSNumber *numPluseTimes = [newDict valueForKey:@"PulseTimes"];
                            
                            DataObjectHealth *healthInfo = [[DataObjectHealth alloc] init];
                            healthInfo.strID = [numId stringValue];
                            healthInfo.strDeviceID = [numDeviceId stringValue];
                            healthInfo.strCreateTime = strMadeTime;
                            //NSLog(@"%@",healthInfo.strCreateTime);
                            healthInfo.strHeartTimes = [numHeartTimes stringValue];
                            healthInfo.strLowPressure = [numLowPressure stringValue];
                            healthInfo.strHighPressure = [numHighPressure stringValue];
                            healthInfo.strSugarValue = [numSugarValue stringValue];
                            
                            healthInfo.strSecconds = [numSeconds stringValue];
                            healthInfo.strSoportValue = [numSportValue stringValue];
                            healthInfo.strPlusTimes = [numPluseTimes stringValue];
                            
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
                            NSLog(@"%@",healthInfo.strHighPressure);
                            [tempObject.arrObjects addObject:healthInfo];
                            
                        }
                        
                        
                    }
                    else
                    {
                        return nil;
                    }
                }
                
            }
            
            return tempObject;
        }
#pragma mark -  GPS上传时间
        else if(jType == jsonDataTypeGPSUploadTime)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableDictionary class]])
                {
                    NSMutableDictionary *subDict = (NSMutableDictionary *)obj;
                    
                    NSNumber *numSecond = [subDict valueForKey:@"GPSSecond"];
                    
                    NSString *strSecondValue= [numSecond stringValue];
                    strSecondValue = [Util returnValuableString:strSecondValue];
                
                    
                    DataObjectMyDeviceList *device =[[DataObjectMyDeviceList alloc] init];
                    
                    device.strGPSSecond = strSecondValue;
                    
                    if(tempObject.arrObjects == nil)
                    {
                        tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [tempObject.arrObjects addObject:device];

                }
                
            }
            
            return tempObject;
        }
#pragma mark -  SOS号码设置
        else if(jType == jsonDataTypeSOSSetting)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id obj = [mdict objectForKey:@"Data"];
            
            if (obj) {
                
                if(obj!=nil && [obj isKindOfClass:[NSMutableDictionary class]])
                {
                    NSMutableDictionary *subDict = (NSMutableDictionary *)obj;
                    
                    NSString *strMobile1= [subDict valueForKey:@"Mobile1"];
                    strMobile1 = [Util returnValuableString:strMobile1];
                    
                    NSString *strMobile2= [subDict valueForKey:@"Mobile2"];
                    strMobile2 = [Util returnValuableString:strMobile2];
                    
                    NSString *strMobile3= [subDict valueForKey:@"Mobile3"];
                    strMobile3 = [Util returnValuableString:strMobile3];
                    
                    NSString *strMobile4= [subDict valueForKey:@"Mobile4"];
                    strMobile4 = [Util returnValuableString:strMobile4];
                    
                    NSNumber *numId = [subDict valueForKey:@"Id"];
                    
                    NSString *strId= [numId stringValue];
                    strId = [Util returnValuableString:strId];
                    
                    DataObjectSOS *sosObj =[[DataObjectSOS alloc] init];
                    
                    sosObj.strMobile1 = strMobile1;
                    sosObj.strMobile2 = strMobile2;
                    sosObj.strMobile3 = strMobile3;
                    sosObj.strMobile4 = strMobile4;

                    sosObj.strId = strId;
 
                    if(tempObject.arrObjects == nil)
                    {
                        tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [tempObject.arrObjects addObject:sosObj];
                    
                }
                
            }
            
            return tempObject;
        }
#pragma mark -  联系人
        else if(jType == jsonDataTypeLinkManInfo)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            
            id subObj = [mdict objectForKey:@"Data"];
            
            if(subObj != nil && [subObj isKindOfClass:[NSArray class]])
            {
                NSMutableArray *array = (NSMutableArray *)subObj;//大类Arr
                if(array!=nil && [array count]>0)
                {
                    
                    for(int j=0;j<[array count];j++)
                    {
                        NSMutableDictionary *subDict = (NSMutableDictionary *)[array objectAtIndex:j];

                        NSString *strLinkName=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"LinkName"]] ;
                        strLinkName = [Util returnValuableString:strLinkName];
                        
                        NSString *strMobile=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"Mobile"]] ;
                        strMobile = [Util returnValuableString:strMobile];
                        
                        DataObjectLinkMan *linkInfo = [[DataObjectLinkMan alloc] init];
                        
                        linkInfo.strLinkName = strLinkName;
                        linkInfo.strLinkMobile = strMobile;
                        
                        if(tempObject.arrObjects == nil)
                        {
                            tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                        }
                        [tempObject.arrObjects addObject:linkInfo];

                    }
                }
            }
            
            
            return tempObject;
        }
#pragma mark -  吃药提醒
        else if(jType == jsonDataTypeMedicineRemind)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id subObj = [mdict objectForKey:@"Data"];
            
            if(subObj != nil && [subObj isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *subDict = (NSMutableDictionary *)subObj;//大类Arr
                if(subDict!=nil)
                {
                    NSString *strTimeList=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"TimeList"]] ;
                    strTimeList = [Util returnValuableString:strTimeList];
                    
                    NSString *strWeekDayList=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"WeekDayList"]] ;
                    strWeekDayList = [Util returnValuableString:strWeekDayList];
                    
                    DataObjectMedicineRemind *medicineRemind = [[DataObjectMedicineRemind alloc] init];
                    
                    medicineRemind.strTimeList = strTimeList;
                    medicineRemind.strWeekDayList = strWeekDayList;
                    
                    if(tempObject.arrObjects == nil)
                    {
                        tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [tempObject.arrObjects addObject:medicineRemind];

                }
            }
            
            
            return tempObject;
        }
#pragma mark -  提交反馈信息给SA
        else if(jType == jsonDataTypePostFeedBackToSA)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            return tempObject;
        }
#pragma mark -  学员课程考勤
        else if(jType == jsonDataTypeScheduleAttendance)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            
            id subObj = [mdict objectForKey:@"Data"];
            
            if(subObj != nil && [subObj isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *mdict = (NSMutableDictionary*)subObj;
                
                NSString *strStuId= [mdict objectForKey:@"StuId"];
                strStuId = [Util returnValuableString:strStuId];
                
                NSString *strAreaId= [mdict objectForKey:@"AreaId"];
                strAreaId = [Util returnValuableString:strAreaId];
                
                NSString *strAreaName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"AreaName"]] ;
                strAreaName = [Util returnValuableString:strAreaName];
                
                NSString *strChuQing= [mdict objectForKey:@"ChuQing"];
                strChuQing = [Util returnValuableString:strChuQing];
                
                NSString *strChiDao= [mdict objectForKey:@"ChiDao"];
                strChiDao = [Util returnValuableString:strChiDao];
                
                NSString *strZaoTui = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"ZaoTui"]] ;
                strZaoTui = [Util returnValuableString:strZaoTui];
                
                NSString *strKuangKe = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"KuangKe"]] ;
                strKuangKe = [Util returnValuableString:strKuangKe];
                
                id dictObj = [mdict objectForKey:@"Info"];
                
                if(dictObj != nil && [dictObj isKindOfClass:[NSArray class]])
                {
                    NSMutableArray *array = (NSMutableArray *)dictObj;//大类Arr
                    if(array!=nil && [array count]>0)
                    {
                        
                        for(int j=0;j<[array count];j++)
                        {
                            NSMutableDictionary *subDict = (NSMutableDictionary *)[array objectAtIndex:j];
                            
                            NSString *strDayNum= [subDict objectForKey:@"DayNum"];
                            strDayNum = [Util returnValuableString:strDayNum];
                            
                            NSString *strCourseId= [subDict objectForKey:@"CourseId"];
                            strCourseId = [Util returnValuableString:strCourseId];
                            
                            NSString *strCourseName=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"CourseName"]] ;
                            strCourseName = [Util returnValuableString:strCourseName];
                            
                            NSString *strStartTime=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"StartTime"]] ;
                            strStartTime = [Util returnValuableString:strStartTime];
                            
                            NSString *strEndTime=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"EndTime"]] ;
                            strEndTime = [Util returnValuableString:strEndTime];
                            
                            NSString *strCourseDate=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"CourseDate"]] ;
                            strCourseDate = [Util returnValuableString:strCourseDate];
                            
                            NSString *strTeacherId=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"TeacherId"]] ;
                            strTeacherId = [Util returnValuableString:strTeacherId];
                            
                            NSString *strTeacherCnName=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"TeacherCnName"]] ;
                            strTeacherCnName = [Util returnValuableString:strTeacherCnName];
                            
                            NSString *strTeacherEnName= [subDict objectForKey:@"TeacherEnName"];
                            strTeacherEnName = [Util returnValuableString:strTeacherEnName];
                            
                            NSString *strAttendence = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"Attendence"]] ;
                            strAttendence = [Util returnValuableString:strAttendence];
                            
                            NSString *strSchoolId = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"SchoolId"]] ;
                            strSchoolId = [Util returnValuableString:strSchoolId];
                            
                            NSString *strSchoolName = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"SchoolName"]] ;
                            strSchoolName = [Util returnValuableString:strSchoolName];
                            
                            
                            NSString *strArrangeCourseId = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"ArrangeCourseId"]] ;
                            strArrangeCourseId = [Util returnValuableString:strArrangeCourseId];
                            
                            DataObjectAttendance *attendance = [[DataObjectAttendance alloc] init];
                            
                            attendance.strChuqinCount = strChuQing;
                            attendance.strChiDaoCount = strChiDao;
                            attendance.strZaoTuiCount = strZaoTui;
                            attendance.strKuangKeCount = strKuangKe;
                            
                            attendance.strDayNum = strDayNum;
                            attendance.strCourseId = strCourseId;
                            attendance.strCourseName = strCourseName;
                            attendance.strStartTime = strStartTime;
                            
                            attendance.strEndTime = strEndTime;
                            attendance.strCourseDate = strCourseDate;
                            attendance.strTeacherId = strTeacherId;
                            attendance.strTeacherCnName = strTeacherCnName;
                            attendance.strTeacherEnName = strTeacherEnName;
                            attendance.strAttendence = strAttendence;
                            attendance.strSchoolId = strSchoolId;
                            
                            attendance.strSchoolName = strSchoolName;
                            
                            attendance.strArrangeCourseId = strArrangeCourseId;
                            
                            if(tempObject.arrObjects == nil)
                            {
                                tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                            }
                            [tempObject.arrObjects addObject:attendance];
                            
                        }
                    }
                }
                
            }
            
            
            return tempObject;
        }
#pragma mark -  已结课时类别名称
        else if(jType == jsonDataTypeFinishedCourseName)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            DEBUG_NSLOG(@"success :%d",success);
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id dictObj = [mdict objectForKey:@"Data"];
            
            if(dictObj != nil && [dictObj isKindOfClass:[NSArray class]])
            {
                NSMutableArray *array = (NSMutableArray *)dictObj;//大类Arr
                if(array!=nil && [array count]>0)
                {
                    for(int j=0;j<[array count];j++)
                    {
                        NSString *strName = (NSString *)[array objectAtIndex:j];
                        
                        if(tempObject.arrObjects == nil)
                        {
                            tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                        }
                        
                        [tempObject.arrObjects addObject:strName];

                    }
                }
            }
            
            return tempObject;
        }
#pragma mark -  已结课时信息
        else if(jType == jsonDataTypeFinishedCourseInfo)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *stCode = [mdict valueForKey:@"Code"];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = [stCode intValue];
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            
            id subObj = [mdict objectForKey:@"Data"];
            
            if(subObj != nil && [subObj isKindOfClass:[NSArray class]])
            {
                NSMutableArray *array = (NSMutableArray *)subObj;//大类Arr
                if(array!=nil && [array count]>0)
                {
                    
                    for(int j=0;j<[array count];j++)
                    {
                        NSMutableDictionary *subDict = (NSMutableDictionary *)[array objectAtIndex:j];
                        
                        NSString *strStudentId= [subDict objectForKey:@"StudentId"];
                        strStudentId = [Util returnValuableString:strStudentId];
                        
                        NSString *strTeacherId= [subDict objectForKey:@"TeacherId"];
                        strTeacherId = [Util returnValuableString:strTeacherId];
                        
                        NSString *strTeacherCnName=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"TeacherCnName"]] ;
                        strTeacherCnName = [Util returnValuableString:strTeacherCnName];
                        
                        NSString *strTeacherEnName=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"TeacherEnName"]] ;
                        strTeacherEnName = [Util returnValuableString:strTeacherEnName];
                        
                        NSString *strCourseDate=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"CourseDate"]] ;
                        strCourseDate = [Util returnValuableString:strCourseDate];
                        
                        NSString *strStartTime=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"StartTime"]] ;
                        strStartTime = [Util returnValuableString:strStartTime];
                        
                        NSString *strEndTime=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"EndTime"]] ;
                        strEndTime = [Util returnValuableString:strEndTime];
                        
                        NSString *strCourseId=  [NSString stringWithFormat:@"%@",[subDict objectForKey:@"CourseId"]] ;
                        strCourseId = [Util returnValuableString:strCourseId];
                        
                        NSString *strCourseName= [subDict objectForKey:@"CourseName"];
                        strCourseName = [Util returnValuableString:strCourseName];
                        
                        NSString *strSchoolId = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"SchoolId"]] ;
                        strSchoolId = [Util returnValuableString:strSchoolId];
                        
                        NSString *strSchoolName = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"SchoolName"]] ;
                        strSchoolName = [Util returnValuableString:strSchoolName];
                        
                        NSString *strCourseStatus = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"CourseStatus"]] ;
                        strCourseStatus = [Util returnValuableString:strCourseStatus];
                        
                        NSString *strArrangeCourseId = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"ArrangeCourseId"]] ;
                        strArrangeCourseId = [Util returnValuableString:strArrangeCourseId];

                        NSString *strIsFinish = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"IsFinish"]] ;
                        strIsFinish = [Util returnValuableString:strIsFinish];
                        
                        NSString *strStatus = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"Status"]] ;
                        strStatus = [Util returnValuableString:strStatus];
                        
                        NSString *strTheCourseNum = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"TheCourseNum"]] ;
                        strTheCourseNum = [Util returnValuableString:strTheCourseNum];
                        
                        DataObjectFinishedCourseInfo *courseInfo = [[DataObjectFinishedCourseInfo alloc] init];
                        courseInfo.strStudentId = strStudentId;
                        courseInfo.strTeacherId = strTeacherId;
                        courseInfo.strTeacherEnName = strTeacherEnName;
                        courseInfo.strTeacherCnName = strTeacherCnName;
                        courseInfo.strCourseDate = strCourseDate;
                        courseInfo.strStartTime  = strStartTime;
                        courseInfo.strEndTime = strEndTime;
                        courseInfo.strCourseId = strCourseId;
                        courseInfo.strCourseName  = strCourseName;
                        courseInfo.strSchoolId = strSchoolId;
                        courseInfo.strSchoolName  = strSchoolName;
                        
                        courseInfo.strCourseStatus = strCourseStatus;
                        courseInfo.strArrangeCourseId  = strArrangeCourseId;
                        
                        courseInfo.strIsFinish = strIsFinish;
                        courseInfo.strStatus  = strStatus;
                        courseInfo.strTheCourseNum = strTheCourseNum;
                        
                        if(tempObject.arrObjects == nil)
                        {
                            tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                        }
                        [tempObject.arrObjects addObject:courseInfo];
                        
                    }
                }
            }
            
            
            return tempObject;
        }
#pragma mark -  获取倒计时列表
        else if(jType == jsonDataTypeMyCountDown)
        {
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            DEBUG_NSLOG(@"success :%d",success);
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id dictObj = [mdict objectForKey:@"Data"];
            
            if(dictObj != nil && [dictObj isKindOfClass:[NSArray class]])
            {
                NSMutableArray *array = (NSMutableArray *)dictObj;//大类Arr
                if(array!=nil && [array count]>0)
                {
                    for(int j=0;j<[array count];j++)
                    {
                        NSMutableDictionary *mdict = [array objectAtIndex:j];
                        
                        NSString *strID= [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Id"]] ;
                        strID = [Util returnValuableString:strID];
                        
                        NSString *strStudentId = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"StudentId"]] ;
                        strStudentId = [Util returnValuableString:strStudentId];
                        
                        NSString *strCnName=  [NSString stringWithFormat:@"%@",[mdict objectForKey:@"CnName"]] ;
                        strCnName = [Util returnValuableString:strCnName];
                        
                        NSString *strEnName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"EnName"]] ;
                        strEnName = [Util returnValuableString:strEnName];
                        
                        
                        NSString *strPhoto=  [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Photo"]] ;
                        strPhoto = [Util returnValuableString:strPhoto];
                        
                        NSString *strSubject = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Subject"]] ;
                        strSubject = [Util returnValuableString:strSubject];
                        
                        NSString *strExamDateTime=  [NSString stringWithFormat:@"%@",[mdict objectForKey:@"ExamDateTime"]] ;
                        strExamDateTime = [Util returnValuableString:strExamDateTime];
                        
                        NSString *strExamAddress = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"ExamAddress"]] ;
                        strExamAddress = [Util returnValuableString:strExamAddress];
                        
                        DataObjectCountDown *countDown = [[DataObjectCountDown alloc] init];
                        countDown.strCountDownID = strID;
                        countDown.strStudentID = strStudentId;
                        countDown.strCnName = strCnName;
                        countDown.strEnName = strEnName;
                        countDown.strPhoto = strPhoto;
                        countDown.strSubject = strSubject;
                        countDown.strExamDateTime = strExamDateTime;
                        
                        countDown.strExamAddress = strExamAddress;
                        
                        if(tempObject.arrObjects == nil)
                        {
                            tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                        }
                        
                        [tempObject.arrObjects addObject:countDown];

                    }
                }
            }
            
            return tempObject;
        }
#pragma mark -  获取我的投诉列表
        else if (jType == jsonDataTypeMyComplints)
        {
            
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            id dictObj = [mdict objectForKey:@"Data"];
            
            if(dictObj != nil && [dictObj isKindOfClass:[NSArray class]])
            {
                NSMutableArray *array = (NSMutableArray *)dictObj;//大类Arr
                if(array!=nil && [array count]>0)
                {
                    for(int j=0;j<[array count];j++)
                    {
                        NSMutableDictionary *mdict = [array objectAtIndex:j];
                        
                        NSString *strStuId= [NSString stringWithFormat:@"%@",[mdict objectForKey:@"StuId"]] ;
                        strStuId = [Util returnValuableString:strStuId];
                        
                        NSString *strCompainId = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"CompainId"]] ;
                        strCompainId = [Util returnValuableString:strCompainId];
                        
                        NSString *strCompainTime=  [NSString stringWithFormat:@"%@",[mdict objectForKey:@"CompainTime"]] ;
                        strCompainTime = [Util returnValuableString:strCompainTime];
                        
                        NSString *strContent = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Content"]] ;
                        strContent = [Util returnValuableString:strContent];
                        
                        
                        NSString *strStatus=  [NSString stringWithFormat:@"%@",[mdict objectForKey:@"Status"]] ;
                        strStatus = [Util returnValuableString:strStatus];
                        
                        NSString *strStatusName = [NSString stringWithFormat:@"%@",[mdict objectForKey:@"StatusName"]] ;
                        strStatusName = [Util returnValuableString:strStatusName];
                        
                        DataObjectComplaint *complaint = [[DataObjectComplaint alloc] init];
                        complaint.strStuId = strStuId;
                        complaint.strCompainId = strCompainId;
                        complaint.strCompainTime = strCompainTime;
                        complaint.strContent = strContent;
                        complaint.strStatus = strStatus;
                        complaint.strStatusName = strStatusName;
                        
                        if(tempObject.arrObjects == nil)
                        {
                            tempObject.arrObjects = [[NSMutableArray alloc] initWithCapacity:0];
                        }
                        
                        [tempObject.arrObjects addObject:complaint];
                        
                    }
                }
            }
        
            return tempObject;
            
        }
#pragma mark -  第三方绑定状态
        else if (jType == jsonDataTypeThirdPartBindStatus)
        {
            
            SampleDataObject *tempObject=  [[SampleDataObject alloc] init];
            
            NSNumber *flag = [mdict valueForKey:@"Code"];
            int success = [flag intValue];
            
            NSString *strMessage = [mdict valueForKey:@"Message"];
            
            strMessage = [Util returnValuableString:strMessage];
            
            tempObject.intSuccess = success;
            tempObject.strMessage = strMessage;
            
            if(tempObject.intSuccess != 1000)
            {
                return tempObject;
            }
            
            NSString *strStatus = [mdict objectForKey:@"Data"];
            
            strStatus = [Util returnValuableString:strStatus];
            
            tempObject.strStatusNo = strStatus;
            
            return tempObject;
            
        }

        
    }
    
    
    return curObject;
}

#pragma mark-
#pragma mark- 解析天气预报
+(id)returnDataSourceWithData:(NSData *)receive withType:(jsonDataType)jType
{
    
    NSString *result = [[NSString alloc] initWithData:receive encoding:NSUTF8StringEncoding];
    
    NSLog(@"\n\n result : %@ \n\n",result);
    
    NSError *error;
   
    id mdict = [NSJSONSerialization JSONObjectWithData:receive options:NSJSONReadingAllowFragments error:&error];
    
    if(error) return nil;
    
    if(mdict)
    {
    
        NSMutableArray *dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
        
#pragma mark -  天气信息
        if(jType == jsonTypeWeather)
        {
            
            if (result.length > 0) {
                
                NSMutableDictionary *tmpDict = (NSMutableDictionary *)mdict;
                if (tmpDict != nil) {
                    
                    
                    NSArray *keyArray = [tmpDict allKeys];
                    
                    if( keyArray != nil &&[keyArray count]>0)
                    {
                        
                        NSDictionary *secondDic = [[NSDictionary alloc] initWithDictionary:[tmpDict objectForKey:@"weatherinfo"]];
                        NSArray *secKeyArray = [secondDic allKeys];
                        if ( secKeyArray !=nil &&[secKeyArray count] > 0  )
                        {
                            
                            DataObjectWeather *weatherObject = [[DataObjectWeather alloc] init];
                            
                            //
                            NSString *strCity = [secondDic objectForKey:@"city"];
                            NSString *strCityid = [secondDic objectForKey:@"cityid"];
                            
                            weatherObject.strCity = strCity;
                            weatherObject.strCityid = strCityid;
                            
                            
                            //
                            NSString *strTemp1 = [secondDic objectForKey:@"temp1"];
                            NSString *strTemp2 = [secondDic objectForKey:@"temp2"];
                            
                            weatherObject.strTemp1 = strTemp1;
                            weatherObject.strTemp2 = strTemp2;
                            
                            //
                            NSString *strWeather1 = [secondDic objectForKey:@"weather"];
                            
                            weatherObject.strWeather1 = strWeather1;
                            //
                            NSString *strImg1 = [secondDic objectForKey:@"img1"];
                            NSString *strImg2 = [secondDic objectForKey:@"img2"];
                            
                            weatherObject.strImg1 = strImg1;
                            weatherObject.strImg2 = strImg2;
                            
                            
                            [dataSourceArray addObject:weatherObject];
                            
                            
                        }
                        else
                        {
                            return nil;
                        }
                        
                    }
                    else
                    {
                        return nil;
                    }
                    
                }else{
                    
                    return nil;
                }
                
                
            }
            else
            {
                return nil;
            }
            
        }
        
        if([dataSourceArray count]>0)
        {
            return dataSourceArray;
        }
    }
    
    
    
    return nil;
}


@end



