//
//  ElectronicFenceViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-30.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "GCDAsyncSocket.h"


#import "MasterViewController.h"

@interface ElectronicFenceViewController : MasterViewController<MKMapViewDelegate,BMKLocationServiceDelegate,GCDAsyncSocketDelegate>
{
    NSMutableArray *mPersonArray;
    
    NSMutableArray *mTableDataSource;
    
    UIImageView *selectTimeBut;
    
    NSInteger topMenuSelectIndex;

    BMKLocationService* _locService;
    MKCircle *myCircle;
    
    GCDAsyncSocket *socket;
}

@property (nonatomic, strong) NSString *strDeviceID;

@property (nonatomic, strong) NSString *strDeviceUserName;

@property (nonatomic, strong) MKMapView *mapView;

@property(nonatomic,strong)DataObjectMyDeviceList *deviceObjet;

@property(strong)  GCDAsyncSocket *socket;
@end
