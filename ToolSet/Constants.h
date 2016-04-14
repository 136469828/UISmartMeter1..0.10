//
//  Constants.h

//
//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//


#ifndef UITradeFair_Constants_h
#define UITradeFair_Constants_h



#define TIPSCELL_BACKGROUND [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1]
#define MSGCELL_BACKGROUND [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1]
#define MAILCELL_BACKGROUND [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1]
#define WFCELL_BACKGROUND [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1]
#define MSGDETAILSCELL_BACKGROUND [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f]
#define TIPSCELLLINE_BACKGROUND [UIColor colorWithRed:203.0f/255.0f green:203.0f/255.0f blue:203.0f/255.0f alpha:1].CGColor
#define WFELLLINE_BACKGROUND [UIColor colorWithRed:203.0f/255.0f green:203.0f/255.0f blue:203.0f/255.0f alpha:1].CGColor
#define MAILLLINE_BACKGROUND [UIColor colorWithRed:203.0f/255.0f green:203.0f/255.0f blue:203.0f/255.0f alpha:1].CGColor
#define DETAILPAGE_BG [UIColor colorWithRed:221.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1.0]

#define ColorRGB(R,G,B,AL) [UIColor colorWithRed:R /255.0 green:G /255.0 blue:B /255.0 alpha:AL]

#define screenWidth   [UIApplication sharedApplication].keyWindow.frame.size.width


#define screenHeight  [UIApplication sharedApplication].keyWindow.frame.size.height

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO

#define dataForCurrent (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit)


#define CHATUSERLIST                  @"ChatUserList"



// ****     wei bo
#define     DID_GET_TOKEN_IN_WEB_VIEW @"didGetTokenInWebView"

#define     kTextViewPadding            16.0



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

#define kUILineBreakModeWordWrap            NSLineBreakByWordWrapping
#define kUITextAlignmentCenter              NSTextAlignmentCenter
#define kUITextAlignmentLeft                NSTextAlignmentLeft
#define kUITextAlignmentRight               NSTextAlignmentRight
#define kUILineBreakModeTailTruncation      NSLineBreakByTruncatingTail
#else

#define kUILineBreakModeWordWrap            UILineBreakModeWordWrap
#define kUITextAlignmentCenter              UITextAlignmentCenter
#define kUITextAlignmentLeft                UITextAlignmentLeft
#define kUITextAlignmentRight               UITextAlignmentRight
#define kUILineBreakModeTailTruncation      UILineBreakModeTailTruncation
#endif


// 配置URL

#define kApplicationDistributionURL


#define KGetServerAddressURL        @"http://watch.meidp.com/WatchServices.svc"

// -----------------------------------------------------------

#ifdef  kApplicationDistributionURL

#define kApplicationRequestURL(ServerAddress)   [NSString stringWithFormat:@"http://%@/WatchServices.svc",ServerAddress]

//@"http://gxapi.meidp.com/WatchServices.svc"

#define kUseHekpRequestURL(ServerAddress)       [NSString stringWithFormat:@"http://%@/Wap/Help",ServerAddress]


//@"http://gxapi.meidp.com/Wap/Help"


#define kSocketServerIP                    @"SocketServerIP"
#define kSokectServerPort                  @"SocketServerIpPort"

//#define kSocketServerIP                    @"182.92.150.211"
//#define kSokectServerPort                  6600


#endif



#define SERVERURLADDRESS                   @"serverURLAddress"


/*
public static final int SetLinkman=5;  //设置联系人
public static final int SOS=2;//SOS
public static final int Medicine=3;//吃药提醒
public static final int GPSTime=6;//GPS时间间隔
public static final int Connect=0;//Socket连接
public static final int SendTxt=7;//发送文本
public static final int GetValidateCode=10;//获取验证码

 添加提醒
 
 {"ClientType":"APP","Content":"sdgg@^_^@2015-06-30 14:03","SendTo":"1,","UserId":"140","TaskType":7}
 
 */
 
 
static NSString *strSetLinkman = @"5";
static NSString *strSOS = @"2";
static NSString *strMedicine = @"3";
static NSString *strGPSTime = @"6"; // 6
static NSString *strConnect = @"0"; //0
static NSString *strSendTxt = @"7";
static NSString *strGetValidateCode = @"10";
static NSString *strOpenGPS = @"18";
static NSString *strCloseGPS = @"19"; //关闭GPS 18开 19关

static NSString *strErrorTest = @"100"; // 错误测试

#define softWareName                            @"iPhone版"

#define softVersion                             @"1.0.10"



#define userInfoFilePath_login                  @"login"
#define userInfoFilePath_autoLogging            @"autoLogging"
#define userInfoFilePath_userName               @"userName"

#define userLoginType                           @"userLoginType"

#define userThirdAcount                         @"userThirdAcount"

#define userLoginName                           @"userLoginName"
#define userLoginPassword                       @"userLoginPassword"
#define userHeaderURL                           @"userHeaderURL"

#define userInfoData                            @"userInfoData"


#define TOOLBAR_HIGH_DEFAULT                    44.0f
#define TOOLBAR_HIGH_ROTATE                     40.0F


#define NAVIGATION_BUTTON_HEIGHT                54	//54      60
#define NAVIGATION_BUTTON_WIDTH                 54	//54  150

#define BianMin_BUTTON_WIDTH                    100.0
#define BianMin_BUTTON_HEIGHT                   100.0

#define NAVIGATION_LABEL_HEIGHT                 15



#define TextFont_9     [UIFont systemFontOfSize:9.0]
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


#define     MSSDIDDELETEIMAGEVIEW           @"DeleteImageView"

#define     KUserWeiBoFileName              @"userWeiBoInfo.plist"

#define     KUserSina                       @"IsAuthorizeSina"
// ****     end wei bo
#define     BACKBUTTONRECRSIZE              CGRectMake(5.0, 7.0, 40, 30)


#define     MENU_BUTTON_HEIGHT              147.0
#define     MENU_BUTTON_WIDTH				174.0




// color
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXCOLOR2(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]



#define     foo4random() (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)

#define KUserInfoFilename                   @"userInfo.plist"

#define KUserNetSetFilename                 @"netSetInfo.plist"


#define KUserSina                           @"IsAuthorizeSina"
#define KKeychaindentifier                  @"PSTAccountNumber"

#define kUserName                           @"userName"
#define kUserPassWord                       @"userPassWord"
#define kSoftWareVersion                    @"softversion"
#define kVisitorCityID                      @"visiTorCityID"
#define kVisitorCityName                    @"visiTorCityName"
#define kUsesNickName                       @"userNickName"
#define kUserIdentity                       @"userIdentity"  // 用户身份

#define KUserNetWorkSetting                 @"userNetWorkSet"//网络设置

#define kConnectURL                         @"netWorURRL"



#define keepFolder                        @"keepInfoFolder"
#define KhaveKeepedItems                  @"keepInfo.plist"

#define kweiGuanDianFolder                @"weiGuandianFolder"
#define KWeiGuanDianLoginItems            @"weiGuanDianUser.plist"
#define	ZTTABLEVIEW_TITLE_GET_MORE		  @"加载更多"



#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001
#define requestTagWeather                 1001





#endif


















