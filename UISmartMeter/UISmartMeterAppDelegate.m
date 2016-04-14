
//
//  UISmartMeterAppDelegate.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "NSData-Base64.h"

#import "Constants.h"
#import "CityAndCode.h"
#import "JSON.h"
#import "JsonService.h"

#import "DataPaser.h"
#import "DataObject.h"

#import "UIHomeViewController.h"

#import "ServerListViewController.h"

#import "LoginViewController.h"

#import "CusomTabBarViewController.h"

#import "UISmartMeterAppDelegate.h"

//#import "AibangApi.h"

#import "APService.h"


UISmartMeterAppDelegate *appDelegate;

BMKMapManager* _mapManager;


@implementation UISmartMeterAppDelegate

#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [AibangApi setAppkey:@"cb0132ea313acfaa16d475792e28a5fa"];

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"lUb29jXUwvmykOH5yYFEq55B" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    [self configShareSDkAndPushWithlaunchOptions:launchOptions];
    
    appDelegate = (UISmartMeterAppDelegate*)self;
    
    //[self getWeatherData];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /**
     判断是否有选择服务器地址，如果已经选择，则直接进入登录界面
     */
    
    UIViewController *viewController = nil;
    
    if([[FileOperation getServerURL] length] >0 && ([FileOperation getServerURL] !=nil))
    {
        viewController = [[LoginViewController alloc] init];
    }
    else
    {
        viewController = [[ServerListViewController alloc] init];
    }
    

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    CusomTabBarViewController *tabbar = [[CusomTabBarViewController alloc] init];
//    
//    self.window.rootViewController = tabbar;
//    
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    
    //[[UITabBar appearance] setTintColor:[UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0]];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}


#pragma mark - 设置 推送
-(void)configShareSDkAndPushWithlaunchOptions:(NSDictionary*)launchOptions
{
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    [APService setupWithOption:launchOptions];
    
}


#pragma mark -
#pragma mark -
- (void)locationValue:(CustomLocationManager *)location;
{
    
    DEBUG_NSLOG(@"\n\n appdelegate did get location \n\n");
    
}
- (void)unLocationValue:(CustomLocationManager *)location;
{
    DEBUG_NSLOG(@"\n\n appdelegate did not get location \n\n");
}

-(void)didGetGeoDetailAddress:(CustomLocationManager *)location
{
    
}



#pragma mark- 注销
-(void)resetRootViewIsLoginOut:(BOOL)isloginOut
{
    if(isloginOut == YES)
    {
        LoginViewController *log = [[LoginViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:log];
        
        [self.window setRootViewController:nav];
    }
    else
    {
        UserInfo *info = [UserInfo shareInstance];
        
        if(info.showApplication == 1) // handle diffrent role
        {
            CusomTabBarViewController *custom = [[CusomTabBarViewController alloc]init];
            
            [self.window setRootViewController:custom];
        }
        else
        {
            UIHomeViewController *custom = [[UIHomeViewController alloc]init];
            custom.title = @"贵宾孝心通";
            custom.navigationItem.title = @"贵宾孝心通";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:custom];
            
            [self.window setRootViewController:nav];
        }
        
        
        
    }
    
    
    
}

#pragma mark- 解析push串 做相应处理
-(void)handlePushJsonWithDict:(NSDictionary*)dict
{
    if(dict != nil)
    {
        if(dict)
        {
            NSString *strCustomMsg = [dict valueForKey:@"pushval"];
            
            NSData *data = [NSData dataWithBase64EncodedString:strCustomMsg];
            
            strCustomMsg = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            
            DEBUG_NSLOG(@"strCustomMsg:%@", strCustomMsg);
            
            id jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableDictionary *mdict = (NSMutableDictionary *)jsonDataDict;
            
            NSString *strType = [mdict valueForKey:@"PushType"];
            strType = [Util returnValuableString:strType];
            
            if(strType !=nil && [strType length]>0)
            {
                
                id obj = [mdict valueForKey:@"data"];
                
                if(obj !=nil && [obj isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *subDict = (NSMutableDictionary *)obj;
                    
                    NSString *strDetailID = [subDict valueForKey:@"Id"];
                    
                    DEBUG_NSLOG(@"strDetailID :%@",strDetailID);
                    
                    switch ([strType intValue]) {
                        case 1: //SA的反馈
                        {
                            
                            
                            return;
                            
                        }
                            break;
                        case 2: //老师的反馈 （课表详情反馈）
                        case 6: //放课
                        {
                            
                            
                            return;
                        }
                            break;
                        case 3:
                        {
                            
                        }
                            break;
                        case 4:
                        {
                            
                        }
                            break;
                        case 5:
                        {
                            
                        }
                            break;
                        case 7: // 批量放课
                        {
                            
                            
                            return;
                        }
                            break;
                        case 8: // 取消课程
                        {
                            
                            
                            return;
                        }
                            break;
                        default:
                            break;
                    }
                    
                }
            }
            
        }
    }
}


#pragma mark- deveice tokon
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DEBUG_NSLOG(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

 

 
#pragma mark-
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];
    
    DEBUG_NSLOG(@"Default 收到通知:%@", userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
    [UserInfo shareInstance].unReadMessageCount++;
    
    if(self.jPushDict == nil)
    {
        self.jPushDict = [[NSDictionary alloc] init];
    }
    
    self.jPushDict = userInfo;
    
    
    if (application.applicationState == UIApplicationStateActive)
    {
        NSString *str = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        [Util showAlertWithTitle:@"新消息" message:str delegate:self tag:1 cancelTitle:@"查看" otherTitle:@"等下再说"];
    }
    else
    {
        //[self handlePushJsonWithDict:userInfo];
    }
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    [APService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    DEBUG_NSLOG(@"Default 收到通知:%@", userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
    [UserInfo shareInstance].unReadMessageCount++;
    
    if(self.jPushDict == nil)
    {
        self.jPushDict = [[NSDictionary alloc] init];
    }
    
    self.jPushDict = userInfo;
    
    if (application.applicationState == UIApplicationStateActive)
    {
//        NSString *str = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        
//        [Util showAlertWithTitle:@"新消息" message:str delegate:self tag:1 cancelTitle:@"查看" otherTitle:@"等下再说"];
        
    }
    else
    {
        //[self handlePushJsonWithDict:userInfo];
    }
    
}

#pragma mark-
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
    DEBUG_NSLOG(@"前台推送 接收消息:%@",notification.userInfo);
    
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self handlePushJsonWithDict:self.jPushDict];
    }
    
}


#pragma mark-
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    UIApplication *app = [UIApplication sharedApplication];
    _bgIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"time:%f", app.backgroundTimeRemaining);
        [app endBackgroundTask:_bgIdentifier];
        _bgIdentifier = UIBackgroundTaskInvalid;
    }];
    
    if (_bgIdentifier == UIBackgroundTaskInvalid) {
        NSLog(@"background error!");
        return;
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    if(mLocationManager)
//    {
//        [mLocationManager startCLLocationManager:YES needPopConfirmAlert:NO];
//    }
//    else
//    {
//        mLocationManager = [[CustomLocationManager alloc] init:self];
//        [mLocationManager startCLLocationManager:YES needPopConfirmAlert:NO];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
