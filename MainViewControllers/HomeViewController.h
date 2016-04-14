//
//  HomeViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-4-7.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

//#import "AibangApi.h"
#import "CustomLocationManager.h"


#import "BaseTableViewController.h"

@interface HomeViewController : BaseTableViewController<CustomLocationDelegate>
{
//    AibangApi* api;
    
    CustomLocationManager *mLocationManager;

    
}


@property(nonatomic,strong)NSString *strCity;

@end
