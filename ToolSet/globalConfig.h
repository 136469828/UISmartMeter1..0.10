

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark - 所有API请求URL



// 检查更新
#define CHECKVERSION    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"ClientType\":0,\"Module\":\"system\",\"Method\":\"getVersoin\",\"Data\":{\"clienttype\":1}}"]

/**
 *  获取服务器列表
 */
#define GETSERVERURLLIST    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"System\",\"Method\":\"getservers\"}"]

// 登录
#define LOGINURL(USERNAME,PWD)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"user\",\"Method\":\"login\",\"Data\":{\"UserName\":\"%@\",\"Pwd\":\"%@\"}}",USERNAME,PWD]

// 第三方登录
#define ThirdLogin(AcountID)    [NSString stringWithFormat:@"{\"RCode\":\"Meten$OverseasExam$2014\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"user\",\"Method\":\"loginbythird\",\"Data\":{\"accountid\":\"%@\"}}",AcountID]


// 修改用户头像
#define UPDAREUSERICON(USERID,deviceId,Type,contet)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"user\",\"Method\":\"UploadPictoWatch\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\",\"suffix\":\"%@\",\"content\":\"%@\"}}",USERID,deviceId,Type,contet]


// 获取用户信息
#define GetUserInfo(stuid)    [NSString stringWithFormat:@"{\"RCode\":\"Meten$OverseasExam$2014\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"student\",\"Method\":\"getstucontractcourse\",\"Data\":{\"userid\":\"%@\"}}",stuid]


#pragma mark - 添加吃药提醒

#define takeMedicineRemind(userid,deviceid,warntip,types,tiptime)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"DeviceWarnSet\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\",\"warntip\":\"%@\",\"types\":\"%@\",\"tiptime\":\"%@\"}}",userid,deviceid,warntip,types,tiptime]

#pragma mark - 添加监护人

#define addGuardianPerson(userid,deviceid,mobile,nickname)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GuardianAdd\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\",\"mobile\":\"%@\",\"nickname\":\"%@\"}}",userid,deviceid,mobile,nickname]


#pragma mark - 添加监护人设备

#define addDeviceForPerson(userid,mobile,deviceid,validatecode,nickname,healthinfo,age,medicine)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GuardianDeviceAdd\",\"Data\":{\"userid\":\"%@\",\"mobile\":\"%@\",\"deviceid\":\"%@\",\"validatecode\":\"%@\",\"nickname\":\"%@\",\"healthinfo\":\"%@\",\"age\":\"%@\",\"medicine\":\"%@\"}}",userid,mobile,deviceid,validatecode,nickname,healthinfo,age,medicine]

#pragma mark - 添加电子围栏

#define addElectronicFence(userid,deviceid,forall,Lat,Lon,Radius)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"EnclosureSet\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\",\"forall\":\"%@\",\"Lat\":\"%@\",\"Lon\":\"%@\",\"Radius\":\"%@\"}}",userid,deviceid,forall,Lat,Lon,Radius]


#pragma mark - 获取电子围栏

#define getElectronicFence(userid,deviceid)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GetEnclosure\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\"}}",userid,deviceid]


#pragma mark - 删除设备

#define deleteDevice(userid,deviceid)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GuardianDeviceDel\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\"}}",userid,deviceid]


#pragma mark - 获取历史回放

#define getHistoryPlayBack(deviceid)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"HistoryLocus\",\"Data\":{\"deviceid\":\"%@\"}}",deviceid]


#pragma mark - 经纬度解析

#define getAddressFromLatLon(locationLatLon)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"System\",\"Method\":\"GetAddressByLocation\",\"Data\":{\"location\":\"%@\"}}",locationLatLon]


#pragma mark - 我的监护设备
#define MyDeviceList(UserId)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"getmydevices\",\"Data\":{\"userid\":\"%@\"}}",UserId]


#pragma mark - 所有监护设备
#define getDeviceList(UserId)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"getdeviceslist\",\"Data\":{\"userid\":\"%@\"}}",UserId]


#pragma mark - 获取报警信息
#define getAlarmInfo(page,pageSize,userId)  [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GetDeviceAlarm\",\"Data\":{\"userid\":\"%@\"},\"PageIndex\":\"%d\",\"PageSize\":\"%d\"}",userId,page,pageSize]

#pragma mark - 实时监控
#define getSingelPersonMonitoring(deviceID)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"RealTimeTracking\",\"Data\":{\"DeviceId\":\"%@\"}}",deviceID]

#pragma mark - 多人监控
#define getMutablePersonMonitoring(userID)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"mydeviceslocation\",\"Data\":{\"userid\":\"%@\"}}",userID]

#pragma mark - 获取健康信息
#define getHealthInfo(methodName,userID,deviceID,beginDate,endDate)  [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Health\",\"Method\":\"%@\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\",\"datebeg\":\"%@\",\"dateend\":\"%@\"}}",methodName,userID,deviceID,beginDate,endDate]


#pragma mark - 获取我的设置提醒
#define getMySettingRemind(userID,page,pageSize)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GetDeviceWarnList\",\"Data\":{\"userid\":\"%@\",\"PageIndex\":\"%d\",\"PageSize\":\"%d\"}}",userID,page,pageSize]

#pragma mark - 获取验证码
#define getCheckCode(mobile,stype)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"User\",\"Method\":\"GetValidateCode\",\"Data\":{\"mobile\":\"%@\",\"stype\":\"%@\"}}",mobile,stype]

#pragma mark - 修改密码
#define modifyPwd(userID,password,oldpassword)    [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"user\",\"Method\":\"ModifyPwd\",\"Data\":{\"userid\":\"%@\",\"password\":\"%@\",\"oldpassword\":\"%@\"}}",userID,password,oldpassword]

#pragma mark - 获取GPS上传时间
#define getGPSUploadTime(userID,deviceID)  [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GetDeviceModel\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\"}}",userID,deviceID]

#pragma mark - 获取SOS设置信息
#define getSOSInfo(userID,deviceID)  [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"getsos\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\"}}",userID,deviceID]

#pragma mark - 获取联系人信息
#define getLinkManInfo(userID,deviceID,PageIndex,PageSize)  [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GetLinkMan\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\"},\"PageIndex\":\"%d\",\"PageSize\":\"%d\"}",userID,deviceID,PageIndex,PageSize]

#pragma mark - 获取吃药提醒信息
#define getMedicineRemindInfo(userID,deviceID,PageIndex,PageSize)  [NSString stringWithFormat:@"{\"RCode\":\"Watch$Socket$App$2015\",\"UserSign\":\"""\",\"ClientType\":0,\"Module\":\"Device\",\"Method\":\"GetTakePillsWarn\",\"Data\":{\"userid\":\"%@\",\"deviceid\":\"%@\"},\"PageIndex\":\"%d\",\"PageSize\":\"%d\"}",userID,deviceID,PageIndex,PageSize]



#define screenWidth   [UIApplication sharedApplication].keyWindow.frame.size.width


#define screenHeight  [UIApplication sharedApplication].keyWindow.frame.size.height

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

#define kUILineBreakModeWordWrap          NSLineBreakByWordWrapping
#define kUITextAlignmentCenter            NSTextAlignmentCenter
#define kUITextAlignmentLeft              NSTextAlignmentLeft
#define kUITextAlignmentRight             NSTextAlignmentRight
#define kUILineBreakModeTailTruncation    NSLineBreakByTruncatingTail
#define kUILineBreakModeClip              NSLineBreakByClipping
#define kUITextAlignment                  NSTextAlignment
#else

#define kUILineBreakModeWordWrap          UILineBreakModeWordWrap
#define kUITextAlignmentCenter            UITextAlignmentCenter
#define kUITextAlignmentLeft              UITextAlignmentLeft
#define kUITextAlignmentRight             UITextAlignmentRight
#define kUILineBreakModeTailTruncation    UILineBreakModeTailTruncation
#define kUILineBreakModeClip              UILineBreakModeClip
#define kUITextAlignment                  UITextAlignment

#endif


// ------------

#define NOTICE_NOGPS @"定位失败，请开启“设置->通用->定位服务”中的相关选项。"
#define NOTICE_NOAuthorizedGPS @"定位失败，请在“设置->通用->定位服务”中允许“风景网”使用定位"

#define NOTICE_CANCEL_SWITCHCITY_MAPVIEW @"不,谢谢"
#define NOTICE_SUMMIT_SWITCHCITY_MAPVIEW @"好的,我知道了~"
#define NOTICE_NOGPS_MYSIDE @"定位失败，不能进入方圆三公里。"
#define NOTICE_NOGPS_LOCATION @"暂时无法获取您的位置。"
#define NOTICE_CANCEL_NOGPS_MYSIDE @"我知道了"

// ------     ----

//---------------------------------//

#define CheckLogin      ([UserInfo shareInstance].strUserID && ![Util isEmptyString:[UserInfo shareInstance].strUserID])?YES:NO

#define CheckNoLogin    (![UserInfo shareInstance].UserId || [Util isEmptyString:[UserInfo shareInstance].UserId])

#define CheckNoTelePhone    (![TelePhoneInfo shareInstance].phoneNum || [Util isEmptyString:[TelePhoneInfo shareInstance].phoneNum])

#define CheckNoServicesHotline   (![TelePhoneInfo shareInstance].servicesHotline || [Util isEmptyString:[TelePhoneInfo shareInstance].servicesHotline])


// userInfoFilePath key值
#define userInfoFilePath_login          @"login"
#define userInfoFilePath_autoLogging    @"autoLogging"
#define userInfoFilePath_userName       @"userName"
#define userInfoFilePath_userPSW       @"userPassword"
#define userInfoFilePath_SignContent       @"SignContent"


#define userInfoFilePath_token          @"token"
#define userInfoFilePath_userID         @"userID"

#define userInfoFilePath_userMemberID   @"userMemberID"

#define userInfoFilePath_userRealName   @"userRealName"
#define userInfoFilePath_userPhone      @"userPhone"
#define userInfoFilePath_userEmail      @"userEmail"
#define userInfoFilePath_userHeadImgUrl @"userHeadImgUrl"
#define userInfoFilePath_userSex        @"userSex"
#define userInfoFilePath_userAge        @"userAge"
#define userInfoFilePath_userNick       @"userNick"
#define userInfoFilePath_isCheckPhone   @"isCheckPhone"
#define userInfoFilePath_isCheckEmail   @"isCheckEmail"
#define userInfoFilePath_whyCid         @"whyCid"
#define userInfoFilePath_userLocal      @"userLocal"
#define userInfoFilePath_userMapSet     @"userMapSet"
#define userInfoFilePath_isUpload       @"isUpload"
#define userInfoFilePath_guid           @"guid"
#define userInfoFilePath_signContent    @"signContent"

// key 值 电话号码
#define kPhone_Num              @"orderTelePhone"
#define kServicesHotline_Num    @"servicesHotline"

// num
#define PAGECOUNT           8
#define NumberOfWords       140

// Tag
#define ShareFloatingView_TAG           1009

// margin
#define Margin_x    10.0
#define Margin_y    10.0
#define Margin_11   11.0
#define Margin_2    2.0
#define View_Width_320          320.0

#define submitBtn_300_Width     300.0
#define submitBtn_37_Height     40.0

#define starView_Width          85.0
#define starView_Height         20.0
//---------------------------------//

// 计算高度
#define kTextViewPadding            16.0
#define kLineBreakMode              UILineBreakModeWordWrap

// font
#define BarFontName       @"MicrosoftYaHei"
//#define BarFontName       @"default"

#define TextFont_Holiday    [UIFont fontWithName:BarFontName size:13]


#define TextFont_9     [UIFont systemFontOfSize:9]
#define TextFont_10    [UIFont systemFontOfSize:10.0]
#define TextFont_11    [UIFont systemFontOfSize:11.0]
#define TextFont_12    [UIFont systemFontOfSize:12.0]
#define TextFont_13    [UIFont systemFontOfSize:13.0]
#define TextFont_14    [UIFont systemFontOfSize:14.0]
#define TextFont_15    [UIFont systemFontOfSize:15.0]
#define TextFont_16    [UIFont systemFontOfSize:16.0]
#define TextFont_17    [UIFont systemFontOfSize:17.0]
#define TextFont_18    [UIFont systemFontOfSize:18.0]
#define TextFont_19    [UIFont systemFontOfSize:19.0]
#define TextFont_20    [UIFont systemFontOfSize:20.0]

#define TextFont_24    [UIFont systemFontOfSize:24.0]
//---------------------------------//

// color
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXCOLOR2(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
//mNavBarTitleLabel.textColor = HEXCOLOR(0xFFEC72);





