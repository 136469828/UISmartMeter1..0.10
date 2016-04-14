//
//  UISmartMeterAppDelegate.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "DataObject.h"

#import "CustomLocationManager.h"


#import <UIKit/UIKit.h>

@interface UISmartMeterAppDelegate : UIResponder <UIApplicationDelegate,CustomLocationDelegate>
{
    NSDictionary *cityCodeDic;
    
    CustomLocationManager *mLocationManager;

}

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgIdentifier;
@property (strong, nonatomic) NSDictionary *jPushDict;


-(void)resetRootViewIsLoginOut:(BOOL)isloginOut;

@property (strong, nonatomic) UIWindow *window;

@end
