//
//  GoogleMapShow.h
//  GoogleMapDemo
//
//  Created by Acme on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKAnnotationView.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKPointAnnotation.h>

#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"

#import "NewBasicMapAnnotation.h"

//#import "RegexKitLite.h"
#import "CustomLocationManager.h"


typedef enum
{
    mapTypeRoadRoute = 0,
    mapTypeReadRouteBusiness,
    mapTypePoints
    
}MapViewType;

@class CustomSegment;

@protocol MapViewControllerDidSelectDelegate; 

@interface GoogleMapShow : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,BMKRouteSearchDelegate,CustomLocationDelegate,BMKMapViewDelegate,BMKAnnotation> {
    
    CalloutMapAnnotation *_calloutAnnotation;
	CalloutMapAnnotation *_previousdAnnotation;
    
    NSMutableString *strCurrentAdress;
    
    CustomLocationManager		*mLocationManager;
    
    int selectIndex;
    
    CustomSegment *cusSegment;
    
    BMKRouteSearch *_search;
    
    MapViewType mapType;
    
    //BMKMapView *myMapView;
    
    
    //MKPlacemark *placemark;
    
    __unsafe_unretained   id<MapViewControllerDidSelectDelegate> delegate;
    
	MKMapView			*map;
	CLLocationManager   *locmanager; 
	float lat,lon;
    
    NSMutableArray *arrayPoints;
    
    
    UIImageView* routeView;
	
	NSArray* routes;
	
	UIColor* lineColor;
}

@property(assign)  __unsafe_unretained  id<MapViewControllerDidSelectDelegate> delegate;

@property (nonatomic,retain) MKMapView *map;


-(id)initWithDataSource:(NSMutableArray *)mdatasource withMapType:(MapViewType)mType;

@end

@protocol MapViewControllerDidSelectDelegate <NSObject>

@optional
- (void)customMKMapViewDidSelectedWithInfo:(id)info;

@end



