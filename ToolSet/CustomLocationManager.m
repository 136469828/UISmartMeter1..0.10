//
//  CustomLocationManager.m
//  Ministry of culture
//
//  Created by ZhouLiang on 14-4-8.
//  Copyright (c) 2014年 fengjing. All rights reserved.
//

#import "Util.h"

#import "UISmartMeterAppDelegate.h"

#import "ToolSet.h"

#import "Warning.h"
#import "DebugLog.h"
#import "CustomLocationManager.h"
#import "JSON.h"



extern UISmartMeterAppDelegate *appDelegate;

@interface CustomLocationManager ()

@property (nonatomic, strong) CLGeocoder *geocoder;

@end


@implementation CustomLocationManager
@synthesize latitude;
@synthesize longitude;
@synthesize delegate;
@synthesize lm;
@synthesize CurLocation;

@synthesize latitudeValue,longitudeValue;


//@synthesize placemark;

- (id)init:(id<CustomLocationDelegate>)myDelegate
{
	if(self =  [super init])
	{
		self.delegate = myDelegate;
		
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;

        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        
        [_locService startUserLocationService];
        
        gpsCount = 1;
        
		longitude = NULL;
		latitude = NULL;
        
        mIsAutoShutOffGPS = YES;
        mIsPopConfirmAlert = NO;
        
	}
	return self;
}


-(void) stopCLLocationManager
{
	if (lm != nil) {
		
		[lm stopUpdatingLocation];
	}
}


#pragma 有权限的返回YES
-(BOOL)authorizationStatus
{
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 4.2)
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            URLCacheAlertWithMessage(NOTICE_NOGPS);
            
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) startCLLocationManager:(BOOL)isAutoShutOffGPS needPopConfirmAlert:(BOOL)isPopConfirmAlert
{
	
    BOOL boolReurn = YES;
    
    mIsAutoShutOffGPS = isAutoShutOffGPS;
    
    mIsPopConfirmAlert = isPopConfirmAlert;
    
    if ([CLLocationManager locationServicesEnabled])
        
    {
        if ([self authorizationStatus])
        {
            [_locService startUserLocationService];

        }
        else
        {
            boolReurn = NO;

        }
        
        
    }
    else
    {
        URLCacheAlertWithMessage(NOTICE_NOGPS);
        
    }
    
    return boolReurn;
    
}


#pragma mark -
#pragma mark -
// TODO:3分钟 重新获取一次GPS信息

-(void)getCurrentLocation
{
    if(lm)
    {
        [lm startUpdatingLocation];
    }
    else
    {
        [self startCLLocationManager:YES needPopConfirmAlert:YES];
    }
    DEBUG_NSLOG(@"\n\n 重新获取了GSP 信息\n\n");
    
}


#pragma mark -
#pragma mark - BMKGeoCodeSearch
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        DEBUG_NSLOG(@"current location:%@",titleStr);
        
        // 当前位置信息
        [locationInfo shareInstance].detailAddress = showmeg;
    }
}


#pragma mark -
#pragma mark - location delegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if([locationInfo shareInstance].laitude == nil)
    {
        [locationInfo shareInstance].laitude = [[NSString alloc] init];
    }
    
    
    if([locationInfo shareInstance].longtitude == nil)
    {
        [locationInfo shareInstance].longtitude = [[NSString alloc] init];
    }
    
    [locationInfo shareInstance].laitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    [locationInfo shareInstance].longtitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    [self reverseGeocodeWithCLLocationCoordinate2D:pt];
    
    [_locService stopUserLocationService];
    
}


- (void)didFailToLocateUserWithError:(NSError *)error;
{
    gpsCount ++;
    
    if(gpsCount >3)
    {
        return;
    }
    
    
    if(_locService)
    {
        [_locService startUserLocationService];
    }
    
    
}

#pragma mark-
#pragma mark - 反地理位置解析
-(void)reverseGeocodeWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D
{
    CLLocationCoordinate2D pt = coordinate2D;
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


- (void) dealloc{
    
}

@end
