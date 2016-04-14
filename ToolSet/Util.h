//
//  Util.h
//  shuiwenOA
//
//  Created by zhao yang on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>

#define PUBSECURITY             @"ic_f_zhiandian.png"
#define GASSTATION              @"ic_f_jiayouzhan.png"
#define VISITORSERVICE          @"ic_f_youkefuwu.png"
#define MEDICINE                @"ic_f_yiwushi.png"
#define REPAST                  @"ic_r_xiuxiancanguan.png"
#define ROOM                    @"ic_h_xingjijiudian.png"
#define WCROOM                  @"ic_f_weishengjian.png"
//#define CARPARK                 @"ic_f_tingchechang.png"
#define CARPARK                 @"ic_f_tingchechang.png"
#define OTHERSERVE              @"ic_f_peitaosheshiqita.png"
#define EATSTREET               @"ic_r_tesexiaochi.png"
#define FASTFOOD                @"ic_r_kuaican.png"
#define OTHERFOOD               @"ic_r_yongcanqita.png"
#define LIVEABLETMPLE           @"ic_a_simiaodaoguan"
#define OHTHERLIVE              @"ic_h_zhusuqita.png"
#define TRAFFIC                 @"ic_f_jiaotongzhandian.png"
#define ENTERTAMENT             @"ic_a_biaoyanchangsuo.png"
#define kSCNavBarImageTag 10

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define IMGBUTTON(FILENAME, SELECTOR) [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:FILENAME] style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define showAlert(format, ...) myShowAlert(__LINE__, (char *)__FUNCTION__, format, ##__VA_ARGS__)
@interface Util : NSObject

char pinyinFirstLetter(unsigned short hanzi);;


/*
 // 时间日期函数格式换算
 @"yyyy-MM-dd"
 @"yyyy-MM-dd hh:mm:ss"
 
 */
+ (NSString *)strFormatterDate:(NSDate *)senderDate andforMat:(NSString *)sendFormat;

// 拍照或者从相册中选择照片,进行剪切,进行上传或是分享，图片出现颠倒或者旋转90度的问题.发现是忽略imageOrientation这个属性；解决方法：
+ (UIImage *)fixOrientation:(UIImage *)aImage;


+(UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size;

// 按指定宽高改变图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (UITableView *)setCustomTableView:(CGRect)rect andStyle:(UITableViewStyle *)tableStyle;


+ (NSDate *)dateFromString:(NSString *)dateString;

//+(BOOL)isValidatePhoneNumber:(NSString *)phone;

#pragma mark- 清理缓存（过滤保存用户信息：不删除）
+(BOOL)deleteFileAtPath:(NSString *)pathStr;


#pragma mark - 得到本地缓存大小
+(NSString *)getLocalCacheSize;

// 返回文件大小
+ (NSInteger)getFileSize:(NSString *)path;

+ (NSString *)userInfoFilePath;

+ (NSString *)returnSelectInfoFilePath;

void URLCacheAlertButtonTitle(NSString *tipMessage,NSString *message,NSString *cancelMessage,id delegate, NSString * otherButtonTitle);

void URLCacheAlertWithMessage(NSString *message);

#pragma mark - 剪切图片
+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size;


#pragma mark - 返回SOAP信息
+(NSString *)getSoapWithRequestService:(NSString *)requestService
                      withRequestXmlns:(NSString *)xmln
                        WithRequestMsg:(NSString *)requestMsg
                     withRequestMsgURL:(NSString *)rerequestMsgURL;

#pragma mark - 筛选上推动画
+(void)popView:(UIView *)subView withFrame:(CGRect)_frame;

#pragma mark - 随即颜色
+(UIColor *)randomColor;


#pragma mark - 注销
+(void)logOutActionWithAlertDelegate:(id)target;
+(void)saveUserInfoWhenLogout;

+(BOOL)isUserSelectFileExist;

//+ (void)writeSelectInfoToPath;

+ (void)writeUserInfoToPath;

+(void)writePlistFile:(NSString *)plistFileName setKey:(NSMutableArray *)keyName setValue:(NSMutableArray *)valueData;

+ (void)writeSingleUserInfoToPath:(NSString *)senderUserInfo andKey:(NSString *)senderKey;

+ (NSString *)dataFilePath;

+ (NSString *)getTimeNow;
// 登录
+ (void)pushLoginView:(UINavigationController *)navigationController;

+ (void)presentLoginView:(UIViewController *)viewController;


+ (void)presentLoginViewWithMemberNoLogin:(UIViewController *)viewController;

// 判断是否有网络
+ (BOOL)IsNetworkAvailable;


// 画一条直线
+ (void)drawLine:(CGFloat)firstX andlastX:(CGFloat)lastX andlineY:(CGFloat)lineY andColor:(UIColor *)lineColor;

// 自定义 label
+ (UILabel *)customLabel:(CGRect)sendRect andText:(NSString *)sendText andColor:(UIColor *)sendColor andFont:(UIFont *)sendFont andAlignment:(NSTextAlignment)textAlignmen;

// 图片
+ (UIImage *)setCustomImage:(NSString *)imageName andExt:(NSString *)extendName;

// 字符串
// 判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string;           

// 去除字符串首尾空格
+ (NSString *)stringFormat:(id)sender;

// 在串中搜索子串  str1 母串 ；str2 子串
+ (BOOL)strRangeofString:(NSString *)str1 andStr:(NSString *)str2;

// Alert
+ (void)showNetErrorAlert_1;
+ (void)showNetErrorAlert_2;

+ (void)showMsgAlert:(NSString *)msg;

+ (NSString *)pathApplicationRoot;
+ (NSString *)pathShare;
+ (NSString *)filePathWith:(NSString *)name isDirectory:(BOOL)isDirectory;
+ (BOOL)createDirectoryIfNecessaryAtPath:(NSString *)path;

+ (UIImage *)imageWithName:(NSString *)imgname;
+ (UIImage *)imageWithName:(NSString *)imgname ofType:(NSString *)imgtype;
+(BOOL)isPhoneNumber:(NSString*)string;
+(BOOL)isMobileNumber:(NSString *)string;
+(BOOL)isValidatePhoneNumber:(NSString *)phone;
+(void)alertButtonShowMsg:(NSString *)msg;
+(UIAlertView *)showProgressAlert:(NSString*)title delegates:(id)sender cancelTitle:(NSString*)cancel otherTitle:(NSString*)orther;


/* show alert with title msg delegate */
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg delegate:(id)dgt tag:(NSInteger)tag cancelTitle:(NSString*)cTitle otherTitle:(NSString*)oTitle;




+(void)removeLoadingViews:(UIAlertView *)alertViewLoad;
+(BOOL)isNotSpecial:(NSString*)string;
+(BOOL)isEmailString:(NSString*)email;

+ (UIButton *)newButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector frame:(CGRect)frame image:(UIImage *)image imagePressed:(UIImage *)imagePressed darkTextColor:(BOOL)darkTextColor;


//输入框失去焦点，隐藏键盘
+ (void)resignKeyboard:(UIView *)resignView;

// 验证手机号
+ (BOOL)checkMobile:(NSString *)sender;
// 验证邮箱
+ (BOOL)checkEmail:(NSString *)sender;
// 订票验证姓名
+ (BOOL)checkUsername:(NSString *)sender;
// 订票验证用户证件号 // 有且等于 16 位， 只能输入数字以及大写的 X 
+ (BOOL)checkUserCode:(NSString *)sender;
// 昵称
+ (BOOL)checkNickname:(NSString *)sendStr;

void myShowAlert(int line, char *functname, id formatstring,...);


// 其他


+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;


+ (void)setCustomItemBar:(UINavigationBar *)sendNavBar;
+ (void)setCustomItemBar:(UINavigationBar *)sendNavBar andImage:(UIImage *)image;
+ (UILabel *)setItemBarTitleView:(NSString *)sendText andShadowColor:(UIColor *)shadowColor;

+ (NSString *)ohterInfoFilePath;

+(void)saveUserName:(NSString *)Name;

+(NSString *)returnValuableString:(NSString *)keyValue;

+(void)showAlertWithTitle:(NSString *)strTitle withMessage:(NSString *)strMessage withType:(int) type;
+(void)showAlertWithTitle:(NSString *)strTitle withMessage:(NSString *)strMessage withType:(int) type withDelay:(NSTimeInterval)delays;
+(void)dismissAlertview:(UIAlertView *)alertView;

+(NSDate*)getCurrentDate;

+(NSString *)dateToStringFromDate:(NSDate*)date;


+ (NSString *)getCurrentShortDate;


+(NSString *)currentDateToString;


#pragma mark -
#pragma mark - 得到前一个月 日期
+(NSDate *)getPreDaysInNewMonthWithDate:(NSDate *)mydate;


#pragma mark -
#pragma mark - 得到后一个月 日期
+(NSDate *)getNextDaysInNewMonthWithDate:(NSDate *)mydate;


#pragma mark - 得到当前周 星期一 和星期天 的日期
+(NSString *)returnCurrentDateIsEndDate:(BOOL)isEnd withDate:(NSDate *)thisDate;
#pragma mark- 返回当前周 星期一 到 星期天 的数据
+(NSMutableArray*)returnWeekDayArrayWithDate:(NSDate*)thisDate;


#pragma mark - 得到某个日期 属于星期几
+ (NSString *)getWeekdayFromDate:(NSDate*)date;

//日期格式转化
+(NSString *)dateStrWithOriginalString:(NSString *)originalDateString FromFormatter:(NSString *)originalFormat  toFormatter:(NSString *)toFormat;
+(NSDate *)dateWithOriginalString:(NSString *)originalDateString FromFormatter:(NSString *)originalFormat  toFormatter:(NSString *)toFormat;
//计算天数
+(NSInteger)getLiveDay:(NSDate *)begainDay leaveIn:(NSDate *)endDay;

//计算两个日期天数 （貌似只有 00:00:00时有效）
+(NSString *)datesCountFromeDate:(NSDate *)beginDate toDate:(NSDate *)toDate withDateFormat:(NSString *)strFormatter;

// 计算两个日期之间的天数
+(NSInteger)daysFromStartDate:(NSString *)startDateStr andToDate:(NSString *)endDateStr andForMat:(NSString *)sendFormat;

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDa;

@end

