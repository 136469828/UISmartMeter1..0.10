//
//  CustomLocationManager.h
//  Ministry of culture
//
//  Created by ZhouLiang on 14-4-8.
//  Copyright (c) 2014年 fengjing. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import <CoreLocation/CoreLocation.h>

#import <MapKit/MapKit.h>

@protocol CustomLocationDelegate;


@interface CustomLocationManager : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch* _geocodesearch;

    BMKLocationService* _locService;
    
    int gpsCount;
    
	id <CustomLocationDelegate> delegate;
    CLLocationManager *lm;
	NSString *longitude;
	NSString *latitude;
	double longitudeValue;
	double latitudeValue;
	//BOOL GPSReturnFlag; // 使GPS 只返回一次；
	BOOL mIsAutoShutOffGPS;
    BOOL mIsPopConfirmAlert;
    
    CLLocation *CurLocation;

    
    //MKPlacemark *placemark;
}
//@property(nonatomic,retain)MKPlacemark *placemark;; // 位置

@property(nonatomic,retain)NSString *longitude; // 经度
@property(nonatomic,retain)NSString *latitude; // 纬度
@property(retain, nonatomic)id <CustomLocationDelegate> delegate;
@property(retain,nonatomic)CLLocationManager *lm;
@property(retain,nonatomic)CLLocation *CurLocation;


@property     double longitudeValue;
@property     double latitudeValue;

- (id)init:(id<CustomLocationDelegate>)myDelegate;


-(void) stopCLLocationManager;
-(BOOL) startCLLocationManager:(BOOL)isAutoShutOffGPS needPopConfirmAlert:(BOOL)isPopConfirmAlert;
-(BOOL) authorizationStatus;

@end



@protocol CustomLocationDelegate<NSObject>
- (void)locationValue:(CustomLocationManager *)location;
@optional
- (void)unLocationValue:(CustomLocationManager *)location;

@optional
-(void)didGetGeoDetailAddress:(CustomLocationManager*)location;

@end

