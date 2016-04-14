//
//  HistoyLookUpViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-2-1.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import <MapKit/MapKit.h>


#import "MasterViewController.h"

@interface HistoyLookUpViewController : MasterViewController<MKMapViewDelegate>
{
    NSMutableArray *mTableDataSource;
}


@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) NSString *strDeviceID;
-(id)initWithDeviceId:(NSString*)strID;

@end
