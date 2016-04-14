//
//  Copyright 2010 All rights reserved.
//

#import "DebugLog.h"

#import "CityAndCode.h"

#import "ToolSet.h"

#import "JsonService.h"

#import "FileOperation.h"

#import "Constants.h"

#import "Util.h"
#import "globalConfig.h"


@implementation JsonService

@synthesize webserviceDelegate;


static JsonService *sharedService = nil;

+ (JsonService*)sharedManager{
    @synchronized(self) {
        if (sharedService == nil) {
            [[self alloc] init];
        }
    }
    return sharedService;
}

+(id)alloc{
    @synchronized ([sharedService class])
    {
        NSAssert(sharedService == nil,@"Attempted to allocated a second instance of the sharedService singleton"); // 6
        sharedService = [super alloc];
        [sharedService loadConf];
        return sharedService;
    }
    return nil;
}

-(void)saveConf:(NSString *)key value:(id)value
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    [conf setObject:value  forKey:key  ];
    [conf synchronize];
}

-(void)loadConf
{
    
}

-(NSString*)getUserName{NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];return [conf stringForKey:@"username"];}
-(NSString*)getPassword{NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];return [conf stringForKey:@"password"];}
-(NSString*)getHost{NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];return [conf stringForKey:@"hosturl"];}
-(NSString*)getSessionID{NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];return [conf stringForKey:@"sid"];}

-(BOOL)isFirstRun{NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];return [[conf objectForKey:@"firstRun"] boolValue]; }

#pragma mark -
#pragma mark - cancelAllRequest
-(void)cancelAllRequest{
    
    [self.runningRequest cancel];
    self.runningRequest.delegate = nil;
    
}

-(void)setUserName:(NSString*)u{
    [self saveConf:@"username" value:u];
}
-(void)setSid:(NSString*)uid{
    [self saveConf:@"sid" value:uid];
}
-(void)setPassword:(NSString*)p{
    [self saveConf:@"password" value:p];
}

-(BOOL)isAutoLogin
{
    //return (username!=NULL&&password!=NULL&&host!=NULL);
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    return  [[conf objectForKey:@"autologin"] boolValue];
}

-(BOOL)enabledAutoLogin
{
    return ([self getUserName]!=NULL&&[self getPassword]!=NULL&&[self getHost]!=NULL&&[self isAutoLogin]);
}


-(NSString*)getMobile
{
    NSUserDefaults *conf = [NSUserDefaults standardUserDefaults];
    return [conf stringForKey:@"mobile"];
}

-(void)setMobile:(NSString*)m
{
    [self saveConf:@"mobile" value:m ];
    
}


#pragma mark -
#pragma mark - 天气预报
-(void)getCityWeather
{
    
    cityCodeDic = [[NSDictionary alloc] init];
    cityCodeDic = [CityAndCodeStr JSONValue];
    
    NSData* data=[CityAndCodeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    cityCodeDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSString *cityCode = [cityCodeDic objectForKey:@"深圳"];
    NSString *urlStr=[NSString stringWithFormat:@"http://m.weather.com.cn/data/cityinfo/%@.html",cityCode];
    
    urlStr = @"http://www.weather.com.cn/data/cityinfo/101280601.html";
    
    
    urlStr = @"http://api.map.baidu.com/telematics/v3/weather?location=%E5%8C%97%E4%BA%AC&output=json&ak=Dc3wflVbLL9odwg60y7HjzF4";
    
    
    NSString *urlStr1 = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"天气urlStr1 == %@",urlStr1);
    NSURL * url = [NSURL URLWithString:urlStr1];
    
    weatherRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    weatherRequest.tag = requestTagWeather;
    weatherRequest.delegate = self;
    [weatherRequest setDidFinishSelector:@selector(requestFinished:)];
    [weatherRequest setDidFailSelector:@selector(requestFailed:)];
    [weatherRequest startAsynchronous];
    
}



#pragma mark - 第三方登录
-(void)thirdLoginWithAcountID:(NSString*)strAcount
{
//    NSString *strURLnew = ThirdLogin(strAcount);
//    
//    NSString *soapMessage = [Util getSoapWithRequestService:@"OverseasExam" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
//    
//    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
//    
//    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
//    
//    //请求发送到的路径
//    
//    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
//    NSString *soapActionURL = @"http://tempuri.org/IMetenServices/OverseasExam";
//    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"OverseasExam" SoapMessage:soapMessage];
//    [request timeOutSecond:30];
//    
//    request.tag = 990;
//    [request startAsynchronous];
//    [request setDelegate:self];
//    
//    self.runningRequest = request;
    
}


#pragma mark - 获取服务器列表
-(void)getServerURLList
{
    NSString *strURLnew = GETSERVERURLLIST;
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = KGetServerAddressURL;
    
    DEBUG_NSLOG(@"\n\n --- 请求的地址为:%@ --- \n\n",url);
    
    
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 19;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
}

#pragma mark - 登录
-(void)login:(NSString*)uname pwd:(NSString*)pwd
{
    NSString *strURLnew = LOGINURL(uname, pwd);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    
    DEBUG_NSLOG(@"url:%@",url);
    
    
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 100;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
}




#pragma mark - 用户头像
-(void)updateUserIconWithPicType:(NSString*)strType picBase64:(NSString*)strBase64 deivceId:(NSString*)strDeviceId
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = UPDAREUSERICON(userInfo.strUserID,strDeviceId,strType,strBase64);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 98;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
}

#pragma mark-
#pragma mark- 获取用户信息
-(void)getUserInfo
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = GetUserInfo(userInfo.strUserID);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"OverseasExam" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL = @"http://tempuri.org/IMetenServices/OverseasExam";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"OverseasExam" SoapMessage:soapMessage];
    [request timeOutSecond:30];
    
    request.tag = 99;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}

#pragma mark-
#pragma mark- 我的设备列表
-(void)getMyDevice
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = MyDeviceList(userInfo.strUserID);
//    NSLog(@"%@",strURLnew);
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 101;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 设备列表
-(void)getDeviceList
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = getDeviceList(userInfo.strUserID);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 102;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 删除设备
-(void)deleteMyDeviceWithDeviceID:(NSString*)strDeviceID
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = deleteDevice(userInfo.strUserID, strDeviceID);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 1011;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 添加设备
-(void)getAddMyDeviceWithDeviceObj:(DataObjectMyDeviceList*)devObj
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    devObj.strAge = [Util returnValuableString:devObj.strAge];
    devObj.strCommonlyUseDrugs = [Util returnValuableString:devObj.strCommonlyUseDrugs];
    
    NSString *strURLnew = addDeviceForPerson(userInfo.strUserID,devObj.strDeviceMobile, @"0", devObj.strCheckCode, devObj.strNickName, devObj.strHealthInfo,devObj.strAge,devObj.strCommonlyUseDrugs);
    
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    NSLog(@"参数:%@ - %@",strURLnew,soapMessage);
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 102;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}



#pragma mark-
#pragma mark- 添加监护人
-(void)addGuardiianPersonWithObj:(DataObjectMyDeviceList*)obj
{
    UserInfo *userInfo = [UserInfo shareInstance];

    NSString *strURLnew = addGuardianPerson(userInfo.strUserID,obj.strDeviceId,obj.strGuardianManMobile,obj.strNickName);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 121;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 吃药提醒
-(void)takeMedicineRemindWithObj:(DataObjectMedicineRemind*)medicineObj
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = takeMedicineRemind(userInfo.strUserID,medicineObj.strDeviceID,medicineObj.strRemindContent,@"1",medicineObj.strRemindTime);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    request.tag = 104;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 获取报警信息
-(void)getAlarmInfomationWithPage:(int)page pageSize:(int)pageSize
{
    UserInfo *userInfo = [UserInfo shareInstance];
 
    
    NSString *strURLnew = getAlarmInfo(page,pageSize,userInfo.strUserID);
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 108;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 获取报警信息
-(void)getAlarmInfomationWithUserID:(NSString*)userID Page:(int)page pageSize:(int)pageSize
{

    NSString *strURLnew = getAlarmInfo(page,pageSize,userID);
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 108;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}

#pragma mark-
#pragma mark- 获取我的提醒信息列表
-(void)getMyReminderListWithPage:(int)page pageSize:(int)pageSize
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = getMySettingRemind(userInfo.strUserID, page, pageSize);
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 1088;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 获取单人监控
-(void)getSingleManMonitorByDeviceID:(NSString*)strDeviceID
{
    NSString *strURLnew = getSingelPersonMonitoring(strDeviceID);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 105;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 获取多人监控
-(void)getMutableMonitor
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = getMutablePersonMonitoring(userInfo.strUserID);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 106;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 添加电子围栏
-(void)addElectronicFenceWithObj:(DataObjectMyDeviceList*)obj
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = addElectronicFence(userInfo.strUserID, obj.strDeviceId, @"1", obj.strLat, obj.strLon, obj.strRadius);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 107;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 获取电子围栏
-(void)getElectronicFenceWithID:(NSString*)strDeviceID
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSString *strURLnew = getElectronicFence(userInfo.strUserID, strDeviceID);
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 108;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 经纬度获取地址
-(void)getAddressFromCoordinate:(NSString*)strLatLon
{
    NSString *strURLnew = getAddressFromLatLon(strLatLon);
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 109;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}

#pragma mark-
#pragma mark- 获取健康信息
-(void)getHealthInfoWithDeviceID:(NSString*)strDeviceID withMethodName:(NSString*)strMethod beginDate:(NSString*)strBeginDate endDate:(NSString*)strEndDate
{
    UserInfo *userInfo = [UserInfo shareInstance];
    NSLog(@"%@",strBeginDate);
    NSString *strURLnew = getHealthInfo(strMethod,userInfo.strUserID,strDeviceID,strBeginDate,strEndDate);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 110;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark-
#pragma mark- 获取历史回放
-(void)getHistoryWithID:(NSString*)strDeviceID
{
    NSString *strURLnew = getHistoryPlayBack(strDeviceID);
    

    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    //[request timeOutSecond:30];
    
    request.tag = 108;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
    
}


#pragma mark - 获取验证码
-(void)getCodeWithPhoneNumber:(NSString *)strPhone
{
    // type:2  bind watch device
    NSString *strURLnew = getCheckCode(strPhone,@"2");
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 1212;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
    
}

#pragma mark - 修改密码
-(void)resetPassWordWithNewPwd:(NSString*)newPwd oldPwd:(NSString*)strOld
{
    
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = modifyPwd(userInfo.strUserID,newPwd,strOld);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 123;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
}



#pragma mark - 检查更新
-(void)checkVersion
{
    NSString *strURLnew = CHECKVERSION;
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    NSLog(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    NSLog(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 90;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
}

#pragma mark -
#pragma mark - 手表设置接口
//TODO:获取gsp上传时间
-(void)getGPSUploadTimeWithDeviceID:(NSString*)strID
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = getGPSUploadTime(userInfo.strUserID, strID);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 124;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
}

#pragma mark -
#pragma mark - 获取SOS号码信息
-(void)getSOSNumberWithDeviceID:(NSString*)strID
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = getSOSInfo(userInfo.strUserID, strID);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 125;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
}


#pragma mark -
#pragma mark - 获取联系人
-(void)getLinkManWithDeviceID:(NSString*)strID page:(int)page pageSize:(int)pageSize
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = getLinkManInfo(userInfo.strUserID, strID, page, pageSize);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 126;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
}


#pragma mark -
#pragma mark - 获取吃药提醒
-(void)getMedicineRemindWithDeviceID:(NSString*)strID page:(int)page pageSize:(int)pageSize
{
    UserInfo *userInfo = [UserInfo shareInstance];
    
    NSString *strURLnew = getMedicineRemindInfo(userInfo.strUserID, strID, page, pageSize);
    
    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
    
    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
    
    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
    
    //请求发送到的路径
    
    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
    
    request.tag = 127;
    [request startAsynchronous];
    [request setDelegate:self];
    
    self.runningRequest = request;
}
#pragma mark -
#pragma mark - 获取常见药物
-(void)getCommonlyDrugsWithDeviceID:(NSString*)strID page:(int)page pageSize:(int)pageSize
{
//    UserInfo *userInfo = [UserInfo shareInstance];
//    
//    NSString *strURLnew = getMedicineRemindInfo(userInfo.strUserID, strID, page, pageSize);// getMedicineRemindInfo没有
//    
//    NSString *soapMessage = [Util getSoapWithRequestService:@"EntryRequest" withRequestXmlns:@"http://tempuri.org/" WithRequestMsg:@"requestJson" withRequestMsgURL:strURLnew];
//    
//    DEBUG_NSLOG(@" \n\n\n strURL :%@ \n\n\n",strURLnew);
//    
//    DEBUG_NSLOG(@" \n\n\n soapMessage :%@ \n\n\n",soapMessage);
//    
//    //请求发送到的路径
//    
//    NSString *url = kApplicationRequestURL([FileOperation getServerURL]);
//    NSString *soapActionURL =@"http://tempuri.org/IWatchServices/EntryRequest";
//    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"EntryRequest" SoapMessage:soapMessage];
//    
//    request.tag = 127;
//    [request startAsynchronous];
//    [request setDelegate:self];
//    
//    self.runningRequest = request;
}


#pragma mark -
#pragma mark NetWebServiceRequestDelegate Methods
- (void)netRequestStarted:(NetWebServiceRequest *)request
{
    DEBUG_NSLOG(@"Start");
    
    if([self.webserviceDelegate respondsToSelector:@selector(webServicDidStartWithRequest:)])
    {
        [self.webserviceDelegate webServicDidStartWithRequest:request];
    }
}


- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSData *)requestData{
    DEBUG_NSLOG(@" net finished \n\n\n %@  \n\n\n\n",result);
    
    if([self.webserviceDelegate respondsToSelector:@selector(webServicDidFinishedWithRequest:requetString:)])
    {
        [self.webserviceDelegate webServicDidFinishedWithRequest:request requetString:result];
    }
    
    
}


- (void)netRequestFailed:(NetWebServiceRequest *)request didRequestError:(NSError *)error{
    DEBUG_NSLOG(@"%@",error);
    
    
    if([self.webserviceDelegate respondsToSelector:@selector(webServicDidFailedWithRequest:requetString:)])
    {
        [self.webserviceDelegate webServicDidFailedWithRequest:request requetString:[error localizedDescription]];
    }
    
    //[Util showMsgAlert:@"网络有误,请重试~"];
    
    //[HUD hide:YES afterDelay:0.0];
}


#pragma mark -requestFinished
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    DEBUG_NSLOG(@"responseString=%@",responseString);
    //id myData = [responseString JSONValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDataFinished:) ]) {
		[self.delegate performSelector:@selector(requestDataFinished:) withObject:request];
	}
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate performSelector:@selector(requestFailed:) withObject:request];
	}
}

@end
