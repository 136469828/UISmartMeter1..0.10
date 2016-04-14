//
//  MapMonitoringViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@import MapKit;
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import "MasterViewController.h"

#import <UIKit/UIKit.h>
#import "SubEditViewController.h"
//  SubEditViewController;
@interface MapMonitoringViewController : MasterViewController<BMKLocationServiceDelegate,TwoViewControllerDelegate,BMKMapViewDelegate,MKMapViewDelegate>
{
    BMKLocationService* _locService;
    
    NSMutableArray *arrTableViewSource;
    
    /*************/
    NSMutableArray *mPersonArray;
    
    NSMutableArray *mTableDataSource;
    
    UIImageView *selectTimeBut;
    
    NSInteger topMenuSelectIndex;
    
    MKCircle *myCircle;
    
    NSMutableArray *singelDatas;
    
    NSInteger indexDevice;
    
    UILabel *titleLab;
}

@property (nonatomic, strong) MKMapView *mapView;
//@property (nonatomic, strong) BMKMapView *mapView;
/********/

@property (nonatomic, strong) NSString *strDeviceID;

@property (nonatomic, strong) NSString *strDeviceUserName;


@property(nonatomic,strong)DataObjectMyDeviceList *deviceObjet;

@end
