

#import <Foundation/Foundation.h>
#import "NSString+Helpers.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SMFileUtils.h"

#import "DataObject.h"

#import "NetWebServiceRequest.h"


//定义协议
@protocol pushDataDelegate
- (void)dataCallBack:(NSString *)str1 other:(NSString*)str2 third:(NSNumber*)str3; //回调传值
@end

@protocol pushArrayDataDelegate
-(void)arrayDataCallBack:(NSArray*)arr;
@end

@protocol pushmerArrayDataDelegate 
-(void) merarrayDataCallBack:(NSArray*)arr;
@end


@protocol webServiceNetWorkDelegate <NSObject>


@optional
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request;

@optional
-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString*)requestStr;
@optional
-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString*)requestStr;

@end


@interface JsonService :  NSObject<NetWebServiceRequestDelegate>{
    
    
    NSDictionary *cityCodeDic;
    
    ASIHTTPRequest *weatherRequest;
    
    id <ASIHTTPRequestDelegate> delegate;

    id<webServiceNetWorkDelegate> webserviceDelegate;
        
}
+ (JsonService*)sharedManager;

@property(nonatomic,retain) NetWebServiceRequest *runningRequest;
@property (nonatomic,retain)id webserviceDelegate;

@property (nonatomic,retain) id delegate;


-(NSString*)getUserName;//用户名
-(NSString*)getPassword;//密码
-(NSString*)getSessionID;//用户ID
-(NSString*)getMobile;//用户ID
-(BOOL)isFirstRun;
-(BOOL)isAutoLogin;
-(BOOL)enabledAutoLogin;


-(void)setMobile:(NSString*)m;
-(void)setUserName:(NSString*)u;
-(void)setPassword:(NSString*)p;

-(void)cancelAllRequest;

-(void)loadConf;

#pragma mark -
#pragma mark - 天气预报
-(void)getCityWeather;

#pragma mark - 检查更新
-(void)checkVersion;


#pragma mark - 获取服务器列表
-(void)getServerURLList;

//登录
#pragma mark - 登录
-(void)login:(NSString*)uname pwd:(NSString*)pwd;


#pragma mark - 第三方登录
-(void)thirdLoginWithAcountID:(NSString*)strAcount;

#pragma mark - 用户头像
-(void)updateUserIconWithPicType:(NSString*)strType picBase64:(NSString*)strBase64 deivceId:(NSString*)strDeviceId;

#pragma mark-
#pragma mark- 获取用户信息
-(void)getUserInfo;

#pragma mark-
#pragma mark- 我的设备列表
-(void)getMyDevice;


#pragma mark-
#pragma mark- 设备列表
-(void)getDeviceList;

#pragma mark-
#pragma mark- 吃药提醒
-(void)takeMedicineRemindWithObj:(DataObjectMedicineRemind*)medicineObj;

#pragma mark-
#pragma mark- 删除设备
-(void)deleteMyDeviceWithDeviceID:(NSString*)strDeviceID;

#pragma mark-
#pragma mark- 添加设备
-(void)getAddMyDeviceWithDeviceObj:(DataObjectMyDeviceList*)devObj;


#pragma mark-
#pragma mark- 添加监护人
-(void)addGuardiianPersonWithObj:(DataObjectMyDeviceList*)obj;

#pragma mark-
#pragma mark- 获取报警信息
-(void)getAlarmInfomationWithPage:(int)page pageSize:(int)pageSize;

#pragma mark-
#pragma mark- 获取报警信息
-(void)getAlarmInfomationWithUserID:(NSString*)userID Page:(int)page pageSize:(int)pageSize;

#pragma mark-
#pragma mark- 获取我的提醒信息列表
-(void)getMyReminderListWithPage:(int)page pageSize:(int)pageSize;


#pragma mark-
#pragma mark- 获取单人监控
-(void)getSingleManMonitorByDeviceID:(NSString*)strDeviceID;

#pragma mark-
#pragma mark- 获取多人监控
-(void)getMutableMonitor;


#pragma mark-
#pragma mark- 添加电子围栏
-(void)addElectronicFenceWithObj:(DataObjectMyDeviceList*)obj;

#pragma mark-
#pragma mark- 获取电子围栏
-(void)getElectronicFenceWithID:(NSString*)strDeviceID;

#pragma mark-
#pragma mark- 获取历史回放
-(void)getHistoryWithID:(NSString*)strDeviceID;


#pragma mark-
#pragma mark- 经纬度获取地址
-(void)getAddressFromCoordinate:(NSString*)strLatLon;

#pragma mark-
#pragma mark- 获取健康信息
-(void)getHealthInfoWithDeviceID:(NSString*)strDeviceID withMethodName:(NSString*)strMethod beginDate:(NSString*)strBeginDate endDate:(NSString*)strEndDate;


#pragma mark - 获取验证码
-(void)getCodeWithPhoneNumber:(NSString *)str;

#pragma mark - 修改密码
-(void)resetPassWordWithNewPwd:(NSString*)newPwd oldPwd:(NSString*)strOld;

//TODO:获取gsp上传时间
-(void)getGPSUploadTimeWithDeviceID:(NSString*)strID;

#pragma mark -
#pragma mark - 获取SOS号码信息
-(void)getSOSNumberWithDeviceID:(NSString*)strID;

#pragma mark -
#pragma mark - 获取联系人
-(void)getLinkManWithDeviceID:(NSString*)strID page:(int)page pageSize:(int)pageSize;


#pragma mark -
#pragma mark - 获取吃药提醒
-(void)getMedicineRemindWithDeviceID:(NSString*)strID page:(int)page pageSize:(int)pageSize;
#pragma mark - 获取常见药物
-(void)getCommonlyDrugsWithDeviceID:(NSString*)strID page:(int)page pageSize:(int)pageSize;



@end