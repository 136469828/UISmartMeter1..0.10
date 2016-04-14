//
//  DetailViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-9.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


#import "MasterViewController.h"

@interface DetailViewController : MasterViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService* _locService;
    //BMKMapView* _mapView;
    
    UITableView *mTableView;
    
    NSMutableArray *mArrayMessage;
    
    NSMutableArray *mTableArray;
    
    NSMutableArray *mTableDataSource;
    
    NSMutableArray *mItemsArray;
    
    UIImageView *selectTimeBut;
    
    NSMutableArray *mPersonArray;
    
    int mSelectInxexPath;
    
    int selectIndex;
    
    BOOL isHaveScaled; // 是否已经放大
    
    UIView *menuView;
    
    int topMenuSelectIndex;
    
    UIView *historyView;
    
    UIButton *scaleButton;
    
}

-(id)initWithPersonName:(NSString *)strDeviceID;

@property (nonatomic, strong) NSString *strDeviceUserName;

@property (nonatomic, strong) NSString *strUserID;

@property (nonatomic, strong) NSString *strDeviceID;

@property (nonatomic, strong) MKMapView *mapView;

@property(nonatomic,strong)NSMutableArray *buttons;

@end
