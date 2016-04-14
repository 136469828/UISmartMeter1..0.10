//
//  GoogleMapShow.m
//  GoogleMapDemo
//
//  Created by Acme on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "UISmartMeterAppDelegate.h"
//@import MapKit;
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import "EGOImageView.h"


#import "DataObject.h"
#import "GoogleMapShow.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "SubTableViewController.h"

#import "CustomSegment.h"


#define sthispan 40000


#define tagImageView        101
#define tagTitleLable       102
#define tagSubtitleLable    103
#define tagStatView         104


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]



//extern UIMobileBookAppDelegate *appdelegate;


BOOL isRetina = FALSE;

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGSize rotatedSize = self.size;
	if (isRetina) {
		rotatedSize.width *= 2;
		rotatedSize.height *= 2;
	}
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end



@interface GoogleMapShow ()

@property (nonatomic, strong) CLGeocoder *geocoder;


@end

@implementation GoogleMapShow
@synthesize map;

@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		NSLog ( @"%@" ,s);
		return s;
	}
	return nil ;
}


-(id)initWithDataSource:(NSMutableArray *)mdatasource withMapType:(MapViewType)mType
{

    
    if(self = [super init])
    {
       
        
        mapType = mType;
        
        
        
        arrayPoints = [[NSMutableArray alloc] initWithArray:mdatasource];
        
        self.geocoder = [[CLGeocoder alloc] init];
        
        
        return self;
    }
    else
    {
        return nil;
    }
}
//TODO: btnChangeToLoadRoute
-(void)btnChangeToLoadRoute
{
    
    
    
    
    
}

//TODO: btnChangeToMap
-(void)btnChangeToMap
{
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.75];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //myMapView.delegate =self;
    //_search.delegate = self;
}



#pragma mark -
#pragma mark - segment Event
#pragma mark -
#pragma mark - segment Event
-(void)CustomSegment:(id)sender
{
    CustomSegment *seg = (CustomSegment *)sender;
    
    selectIndex = seg.selectedSegmentIndex;
    
    locationInfo *location = [locationInfo shareInstance];
    
    /*
    if(mapType == mapTypeReadRouteBusiness)
    {
        switch (selectIndex) {
            case 0:
            {
                NSArray* array = [NSArray arrayWithArray:myMapView.annotations];
                [myMapView removeAnnotations:array];
                
                array = [NSArray arrayWithArray:myMapView.overlays];
                
                [myMapView removeOverlays:array];
                
                
                
                CLLocationCoordinate2D theCoordinate;
                
                theCoordinate.latitude = [location.laitude doubleValue];
                theCoordinate.longitude = [location.longtitude doubleValue];
                
                // 起点经纬度
                BMKPlanNode *start = [[BMKPlanNode alloc] init];
                start.name = location.currentCity;
                start.pt = theCoordinate;
                
                NSMutableDictionary *md = [arrayPoints objectAtIndex:0];
                
                NSString *strlng = [md valueForKey:@"jlng"];
                
                NSString *strlat = [md valueForKey:@"wlat"];
                
                
                NSLog(@"--- strlng is:%@ strlat is:%@ ----",strlng,strlat);
                
                
                CLLocationCoordinate2D endtheCoordinate;
                
                endtheCoordinate.latitude = [strlat doubleValue];
                endtheCoordinate.longitude = [strlng doubleValue];
                
                // 终点经纬度
                BMKPlanNode *end = [[BMKPlanNode alloc] init];
                end.name = location.currentCity;
                end.pt = endtheCoordinate;
                
                BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
                walkingRouteSearchOption.from = start;
                walkingRouteSearchOption.to = end;
                
                BOOL flag = [_search walkingSearch:walkingRouteSearchOption];
                
    
                if (!flag)
                {
                    NSLog(@"search failed");
                }
                
            }
                break;
            case 1:
            {
                NSArray* array = [NSArray arrayWithArray:myMapView.annotations];
                [myMapView removeAnnotations:array];
                array = [NSArray arrayWithArray:myMapView.overlays];
                [myMapView removeOverlays:array];
                
                
                CLLocationCoordinate2D theCoordinate;
                
                theCoordinate.latitude = [location.laitude doubleValue];
                theCoordinate.longitude = [location.longtitude doubleValue];
                
                // 起点经纬度
                BMKPlanNode *start = [[BMKPlanNode alloc] init];
                start.name = location.currentCity;
                start.pt = theCoordinate;
                
                
                NSMutableDictionary *md = [arrayPoints objectAtIndex:0];
                
                NSString *strlng = [md valueForKey:@"jlng"];
                
                NSString *strlat = [md valueForKey:@"wlat"];
                
                
                NSLog(@"--- strlng is:%@ strlat is:%@ ----",strlng,strlat);
                
                
                CLLocationCoordinate2D endtheCoordinate;
                
                endtheCoordinate.latitude = [strlat doubleValue];
                endtheCoordinate.longitude = [strlng doubleValue];
                
                
                // 终点经纬度
                BMKPlanNode *end = [[BMKPlanNode alloc] init];
                end.name = location.currentCity;
                end.pt = endtheCoordinate;
                
                BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
                drivingRouteSearchOption.from = start;
                drivingRouteSearchOption.to = end;
                
                BOOL flag = [_search drivingSearch:drivingRouteSearchOption];
                if (!flag) {
                    NSLog(@"search failed");
                }
                
            }
                break;
            case 2:
            {
                NSArray* array = [NSArray arrayWithArray:myMapView.annotations];
                [myMapView removeAnnotations:array];
                array = [NSArray arrayWithArray:myMapView.overlays];
                [myMapView removeOverlays:array];
                
                
                CLLocationCoordinate2D theCoordinate;
                
                theCoordinate.latitude = [location.laitude doubleValue];
                theCoordinate.longitude = [location.longtitude doubleValue];
                
                // 起点经纬度
                BMKPlanNode *start = [[BMKPlanNode alloc] init];
                start.name = location.currentCity;
                start.pt = theCoordinate;
                
                NSMutableDictionary *md = [arrayPoints objectAtIndex:0];
                
                NSString *strlng = [md valueForKey:@"jlng"];
                
                NSString *strlat = [md valueForKey:@"wlat"];
                
                
                NSLog(@"--- strlng is:%@ strlat is:%@ ----",strlng,strlat);
                
                
                CLLocationCoordinate2D endtheCoordinate;
                
                endtheCoordinate.latitude = [strlat doubleValue];
                endtheCoordinate.longitude = [strlng doubleValue];
                
                // 终点经纬度
                BMKPlanNode *end = [[BMKPlanNode alloc] init];
                end.name = location.currentCity;
                end.pt = endtheCoordinate;
                
                
                BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
                transitRouteSearchOption.city= location.currentCity;
                transitRouteSearchOption.from = start;
                transitRouteSearchOption.to = end;
                
                BOOL flag = [_search transitSearch:transitRouteSearchOption];
                
                if (!flag) {
                    NSLog(@"search failed");
                }
                
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (selectIndex) {
            case 0:
            {
                NSArray* array = [NSArray arrayWithArray:myMapView.annotations];
                [myMapView removeAnnotations:array];
                
                array = [NSArray arrayWithArray:myMapView.overlays];
                
                [myMapView removeOverlays:array];
                
                
                
                CLLocationCoordinate2D theCoordinate;
                
                theCoordinate.latitude = [location.laitude doubleValue];
                theCoordinate.longitude = [location.longtitude doubleValue];
                
                // 起点经纬度
                BMKPlanNode *start = [[BMKPlanNode alloc] init];
                start.name = location.currentCity;
                start.pt = theCoordinate;
                
                
                
                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:0];
                
                CLLocationCoordinate2D endtheCoordinate;
                
                endtheCoordinate.latitude = [data.lat doubleValue];
                endtheCoordinate.longitude = [data.lng doubleValue];
                
                // 终点经纬度
                BMKPlanNode *end = [[BMKPlanNode alloc] init];
                end.name = location.currentCity;
                end.pt = endtheCoordinate;
                
                BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
                walkingRouteSearchOption.from = start;
                walkingRouteSearchOption.to = end;
                
                BOOL flag = [_search walkingSearch:walkingRouteSearchOption];

                if (!flag)
                {
                    NSLog(@"search failed");
                }
                
            }
                break;
            case 1:
            {
                NSArray* array = [NSArray arrayWithArray:myMapView.annotations];
                [myMapView removeAnnotations:array];
                array = [NSArray arrayWithArray:myMapView.overlays];
                [myMapView removeOverlays:array];
                
                
                CLLocationCoordinate2D theCoordinate;
                
                theCoordinate.latitude = [location.laitude doubleValue];
                theCoordinate.longitude = [location.longtitude doubleValue];
                
                // 起点经纬度
                BMKPlanNode *start = [[BMKPlanNode alloc] init];
                start.name = location.currentCity;
                start.pt = theCoordinate;
                
                
                
                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:0];
                
                CLLocationCoordinate2D endtheCoordinate;
                
                endtheCoordinate.latitude = [data.lat doubleValue];
                endtheCoordinate.longitude = [data.lng doubleValue];
                
                // 终点经纬度
                BMKPlanNode *end = [[BMKPlanNode alloc] init];
                end.name = location.currentCity;
                end.pt = endtheCoordinate;
                
                BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
                drivingRouteSearchOption.from = start;
                drivingRouteSearchOption.to = end;
                
                BOOL flag = [_search drivingSearch:drivingRouteSearchOption];

                if (!flag) {
                    NSLog(@"search failed");
                }
                
            }
                break;
            case 2:
            {
                NSArray* array = [NSArray arrayWithArray:myMapView.annotations];
                [myMapView removeAnnotations:array];
                array = [NSArray arrayWithArray:myMapView.overlays];
                [myMapView removeOverlays:array];
                
                
                CLLocationCoordinate2D theCoordinate;
                
                theCoordinate.latitude = [location.laitude doubleValue];
                theCoordinate.longitude = [location.longtitude doubleValue];
                
                // 起点经纬度
                BMKPlanNode *start = [[BMKPlanNode alloc] init];
                start.name = location.currentCity;
                start.pt = theCoordinate;
                
                
                
                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:0];
                
                CLLocationCoordinate2D endtheCoordinate;
                
                endtheCoordinate.latitude = [data.lat doubleValue];
                endtheCoordinate.longitude = [data.lng doubleValue];
                
                // 终点经纬度
                BMKPlanNode *end = [[BMKPlanNode alloc] init];
                end.name = location.currentCity;
                end.pt = endtheCoordinate;
                
                BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
                transitRouteSearchOption.city= location.currentCity;
                transitRouteSearchOption.from = start;
                transitRouteSearchOption.to = end;
                BOOL flag = [_search transitSearch:transitRouteSearchOption];
                
                if (!flag) {
                    NSLog(@"search failed");
                }
                
            }
                break;
            default:
                break;
        }
    }
     */
    
    
    
}




//-(void)laodSubviews
//{
//    
//    locationInfo *location = [locationInfo shareInstance];
//
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    if(mapType == mapTypePoints)
//    {
//        myMapView= [[BMKMapView alloc] initWithFrame:rect];
//        
//        if(cusSegment == nil)
//        {
//            cusSegment = [[CustomSegment alloc] initWithItems:[NSArray arrayWithObjects:@"步行",@"驾车",@"公交",nil]];
//            cusSegment.backgroundColor = [UIColor clearColor];
//            
//            cusSegment.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:231.0/255.0 blue:224.0/255.0 alpha:0.75];
//            cusSegment.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
//            [cusSegment addTarget:self action:@selector(CustomSegment:) forControlEvents:UIControlEventValueChanged];
//            selectIndex = cusSegment.selectedSegmentIndex;
//            [myMapView addSubview:cusSegment];
//            
//        }
//
//    }
//    else
//    {
//        
//        myMapView= [[BMKMapView alloc] initWithFrame:rect];
//        
//        _search = [[BMKRouteSearch alloc]init];
//        
//        
//        
//        // 起点经纬度
//        BMKPlanNode *start = [[BMKPlanNode alloc] init];
//        start.name = location.currentCity;
//        //start.pt.latitude = delegate.strcurrentLat;
//        
//        
//        CLLocationCoordinate2D theCoordinate;
//        
//        theCoordinate.latitude = [location.laitude doubleValue];
//        theCoordinate.longitude = [location.longtitude doubleValue];
//        
//        start.pt = theCoordinate;
//        
//        
//        NSLog(@" ------  appdelegate.strcurrentLat is:%@ appdelegate.strcurrentLng is:%@ -------",location.laitude,location.longtitude);
//        
//        // 终点经纬度
//        BMKPlanNode *end = [[BMKPlanNode alloc] init];
//        end.name = location.currentCity;
//        //start.pt.latitude = delegate.strcurrentLat;
//        
//        
//        if(mapType == mapTypeReadRouteBusiness)
//        {
//            //DataObjectDetail *data = (DataObjectDetail *)[arrayPoints objectAtIndex:0];
//            
//            CLLocationCoordinate2D endtheCoordinate;
//            
//            NSMutableDictionary *md = [arrayPoints objectAtIndex:0];
//            
//            NSString *strlng = [md valueForKey:@"jlng"];
//            
//            NSString *strlat = [md valueForKey:@"wlat"];
//  
//            NSLog(@"strlng is:%@ strlat is:%@ ",strlng,strlat);
//            
//            endtheCoordinate.latitude = [strlat doubleValue];
//            endtheCoordinate.longitude = [strlng doubleValue];
//            
//            end.pt = endtheCoordinate;
//
//            NSLog(@"appdelegate.currentCity :%@",location.currentCity);
//            
//            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
//            walkingRouteSearchOption.from = start;
//            walkingRouteSearchOption.to = end;
//            [_search walkingSearch:walkingRouteSearchOption];
//            
//        }
//        else
//        {
//            DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:0];
//            
//            CLLocationCoordinate2D endtheCoordinate;
//            
//            endtheCoordinate.latitude = [data.lat doubleValue];
//            endtheCoordinate.longitude = [data.lng doubleValue];
//            
//            end.pt = endtheCoordinate;
//            
//            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
//            walkingRouteSearchOption.from = start;
//            walkingRouteSearchOption.to = end;
//            [_search walkingSearch:walkingRouteSearchOption];
//            
//        }
//
//    }
//    
//    
//    [myMapView setMapType:BMKMapTypeStandard];
//    // 设置mapView的Delegate
//    myMapView.delegate = self;
//    
//    //myMapView.showsUserLocation=YES;
//    
//    [self.view addSubview:myMapView];
//    
//    if(cusSegment == nil)
//    {
//        cusSegment = [[CustomSegment alloc] initWithItems:[NSArray arrayWithObjects:@"步行",@"驾车",@"公交",nil]];
//        cusSegment.backgroundColor = [UIColor clearColor];
//        cusSegment.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
//        cusSegment.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:231.0/255.0 blue:224.0/255.0 alpha:0.75];
//        cusSegment.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0);
//        [cusSegment addTarget:self action:@selector(CustomSegment:) forControlEvents:UIControlEventValueChanged];
//        selectIndex = cusSegment.selectedSegmentIndex;
//        [self.view addSubview:cusSegment];
//        
//    }
//    
//    
//    NSString *slong = [NSString stringWithFormat:@"%@",location.longtitude];
//    
//    NSString *slati = [NSString stringWithFormat:@"%@",location.laitude];
//    
//    
//    CLLocationCoordinate2D theCoordinate;
//    CLLocationCoordinate2D theCenter;
//    
//    theCoordinate.latitude = [slati doubleValue];
//    theCoordinate.longitude= [slong doubleValue];
//    
//    BMKCoordinateRegion theRegin;
//    theCenter.latitude =[slati doubleValue];;
//    theCenter.longitude = [slong doubleValue];
//    theRegin.center=theCenter;
//    
//    BMKCoordinateSpan theSpan;
//    theSpan.latitudeDelta = 0.1;
//    theSpan.longitudeDelta = 0.1;
//    theRegin.span = theSpan;
//    
//    
//    [myMapView setRegion:theRegin];
//    [myMapView regionThatFits:theRegin];
//    myMapView.showsUserLocation=YES;
//    
//    
//    
//    
//    if(arrayPoints!=nil && [arrayPoints count]>0)
//    {
//        
//        
//        NSLog(@"\r\r come in [arrayPoints count]>0 \t\t");
//        
//        for(int i=0;i<[arrayPoints count];i++)
//        {
//            
//            if(mapType == mapTypePoints)
//            {
//                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:i];
//                
//                CLLocationDegrees latitude=[[data lat] doubleValue];
//                CLLocationDegrees longitude=[[data lng] doubleValue];
//                //            CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
//                //
//                //            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,sthispan ,sthispan );
//                //            MKCoordinateRegion adjustedRegion = [map regionThatFits:region];
//                //            [map setRegion:adjustedRegion animated:YES];
//                
//                NewBasicMapAnnotation *  annotation=[[NewBasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
//                [myMapView   addAnnotation:annotation];
//                
//            }
//            
//            if(mapType == mapTypeRoadRoute)
//            {
//                
//                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:i];
//                
//                CLLocationDegrees latitude=[[data lat] doubleValue];
//                CLLocationDegrees longitude=[[data lng] doubleValue];
//                
//                NewBasicMapAnnotation *  annotation=[[NewBasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
//                //[map   addAnnotation:annotation];
//                
//                
//                [myMapView   addAnnotation:annotation];
//                //22.5348944,114.114505
//                
//                /*
//                 routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, map.frame.size.width, map.frame.size.height)];
//                 routeView.userInteractionEnabled = NO;
//                 [map addSubview:routeView];
//                 
//                 lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//                 
//                 Place* home = [[Place alloc] init];
//                 home.name = @"Home";
//                 home.description = @"Sweet home";
//                 home.latitude = lat;
//                 home.longitude = lon;
//                 
//                 Place* office = [[Place alloc] init];
//                 office.name = @"Office";
//                 office.description = @"Bad office";
//                 office.latitude = latitude;
//                 office.longitude = longitude;
//                 
//                 [self showRouteFrom:home to:office];
//                 */
//            }
//            
//            /*
//             else if(mapType == mapTypeReadRouteBusiness)
//             {
//             
//             
//             NSMutableDictionary *md = [arrayPoints objectAtIndex:0];
//             
//             NSString *strlng = [md valueForKey:@"jlng"];
//             
//             NSString *strlat = [md valueForKey:@"wlat"];
//             
//             
//             NSLog(@"strlng is:%@ strlat is:%@ ",strlng,strlat);
//             
//             
//             CLLocationDegrees latitude=[strlat doubleValue];
//             CLLocationDegrees longitude=[strlng doubleValue];
//             
//             BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
//             //[map   addAnnotation:annotation];
//             
//             
//             [myMapView   addAnnotation:annotation];
//             //22.5348944,114.114505
//             }
//             */
//            
//            
//            
//        }
//    }
//
//    
//    
////    if(location.currentCity!=nil && [location.currentCity length]>0 && location.laitude!=nil && [location.laitude length]>0 && location.longtitude!=nil && [location.longtitude length]>0)
////    {
////
////    }
////    else
////    {
////        mLocationManager = [[CustomLocationManager alloc] init:self];
////
////        [mLocationManager startCLLocationManager:YES needPopConfirmAlert:YES];
////    }
//}



-(void)addAnimationForMap
{
    if([arrayPoints count])
    {
        for (int i= 0; i<[arrayPoints count]; i++)
        {
            DataObjectSearch *dsearch = [arrayPoints objectAtIndex:i];
            
            CLLocationDegrees latitude = [dsearch.lat doubleValue];
            CLLocationDegrees longitude = [dsearch.lng doubleValue];
            

            BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
            annotation.title = [NSString stringWithFormat:@"%@",dsearch.strName];
            annotation.subtitle = [NSString stringWithFormat:@"%@",dsearch.cate];;
            annotation.typeNum = i;
            [self.map addAnnotation:annotation];

            
            if(i == 0)
            {
                
                CLLocationCoordinate2D theCoordinate;
                CLLocationCoordinate2D theCenter;
                
                theCoordinate.latitude = latitude;
                theCoordinate.longitude= longitude;
                
                
                MKCoordinateRegion theRegin;
                theCenter.latitude =latitude;
                theCenter.longitude = longitude;
                theRegin.center=theCenter;
                
                MKCoordinateSpan theSpan;
                theSpan.latitudeDelta = 0.1;
                theSpan.longitudeDelta = 0.1;
                theRegin.span = theSpan;
                
                
                [self.map setRegion:theRegin animated:YES];
                [self.map regionThatFits:theRegin];
            }
        }
        
    }
}

#pragma mark - 多人模式画地图
-(void)showMapView
{
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.map.delegate = self;
    [self.map setZoomEnabled:YES];      // 是否允许用户自己放大缩小
    [self.map setScrollEnabled:YES];    // 是否 scroll
    self.map.showsUserLocation = YES;
    
    [self.view addSubview:self.map];
    
    
    [self addAnimationForMap];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    
    [super viewDidLoad];

    UIBarButtonItem *barbutton = nil;

    if(mapType == mapTypePoints)
    {
        barbutton = [[UIBarButtonItem alloc] initWithTitle:@"列表模式" style:UIBarButtonItemStylePlain target:self action:@selector(btnChangeToMap)];
        
        barbutton.tintColor = [UIColor colorWithRed:248.0/255.0 green:167.0/255.0 blue:0.0 alpha:1];
        [self.navigationItem setRightBarButtonItem:barbutton];
    }
    else
    {
        //barbutton = [[UIBarButtonItem alloc] initWithTitle:@"查看路线" style:UIBarButtonItemStylePlain target:self action:@selector(btnChangeToLoadRoute)];
    }

    
    [self showMapView];
    
    //[self laodSubviews];
    
    
}


#pragma mark start GPS delegate
- (void)unLocationValue:(CustomLocationManager *)location
{
    NSLog(@"获取了 GPS 信息失败");
    
    
    
}

- (void)locationValue:(CustomLocationManager *)location
{
    
    NSLog(@"成功获取了 GPS 信息");
    
    
    //[self laodSubviews];
    
}


/*
#pragma mark -
#pragma mark decodePolyLine custom method
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl];
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}

-(void) centerMap {
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < routes.count; idx++)
	{
		CLLocation* currentLocation = [routes objectAtIndex:idx];
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat;
	region.span.longitudeDelta = maxLon - minLon;
	
	[map setRegion:region animated:YES];
}


 */
 
-(void) updateRouteView {
	CGContextRef context = 	CGBitmapContextCreate(nil,
												  routeView.frame.size.width,
												  routeView.frame.size.height,
												  8,
												  4 * routeView.frame.size.width,
												  CGColorSpaceCreateDeviceRGB(),
												  kCGImageAlphaPremultipliedLast);
	
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
	
	for(int i = 0; i < routes.count; i++) {
		CLLocation* location = [routes objectAtIndex:i];
		CGPoint point = [map convertCoordinate:location.coordinate toPointToView:routeView];
		
		if(i == 0) {
			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
		} else {
			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
		}
	}
	
	CGContextStrokePath(context);
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	UIImage* img = [UIImage imageWithCGImage:image];
	
	routeView.image = img;
	CGContextRelease(context);
    
}


#pragma mark -
#pragma mark -
// TODO: 百度地图搜索 委托

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}



- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}


#pragma mark -
#pragma mark MKMapViewDelegate
/*
#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	routeView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	[self updateRouteView];
	routeView.hidden = NO;
	[routeView setNeedsDisplay];
}
*/

- (void)showDetails:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    
    
    NSLog(@"btn tag:%d",btn.tag);
    
    

    
    
}





/*
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView;
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error;
*/
// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    
    [manager stopUpdatingLocation];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//	//map = [[MKMapView alloc] initWithFrame:rect];
//    
//    CLLocationCoordinate2D loc = [newLocation coordinate];
//	lat = loc.latitude;
//	lon	= loc.longitude;
//	NSLog(@"lat %f",lat);
//	NSLog(@"lon %f",lon);
//	CLLocationCoordinate2D theCoordinate;
//	CLLocationCoordinate2D theCenter;
//	
//	theCoordinate.latitude =lat;
//	theCoordinate.longitude=lon;
//	[map setDelegate: self];
//	//[map setCenter:CGPointMake(160, 240)] ;
//	[map setMapType: MKMapTypeStandard];
//	
//	MKCoordinateRegion theRegin;
//	theCenter.latitude =lat;
//	theCenter.longitude = lon;
//	theRegin.center=theCenter;
//	
//	MKCoordinateSpan theSpan;
//	theSpan.latitudeDelta = 0.1;
//	theSpan.longitudeDelta = 0.1;
//	theRegin.span = theSpan;
//	[map setRegion:theRegin];
//	[map regionThatFits:theRegin];
//	map.showsUserLocation=YES;
//    
//	[self.view addSubview:map];
    
    
    
    
    //百度地图
    self.map= [[MKMapView alloc] initWithFrame:rect];
    [self.map setMapType:MKMapTypeStandard];
    // 设置mapView的Delegate
    self.map.delegate = self;
    
    [self.view addSubview:self.map];
    CLLocationCoordinate2D loc = [newLocation coordinate];
	lat = loc.latitude;
	lon	= loc.longitude;
    
    
    
    
	NSLog(@"lat %f",lat);
	NSLog(@"lon %f",lon);
	CLLocationCoordinate2D theCoordinate;
	CLLocationCoordinate2D theCenter;
	
	theCoordinate.latitude =lat;
	theCoordinate.longitude=lon;
    
	MKCoordinateRegion theRegin;
	theCenter.latitude =lat;
	theCenter.longitude = lon;
	theRegin.center=theCenter;
	
	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 0.1;
	theSpan.longitudeDelta = 0.1;
	theRegin.span = theSpan;
    
    
	[self.map setRegion:theRegin];
	[self.map regionThatFits:theRegin];
	self.map.showsUserLocation=YES;
    
	//[self.view addSubview:myMapView];
    
    if(mapType == mapTypePoints)
    {
        [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             //_placemark = [placemarks objectAtIndex:0];
             
             
             MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
             
             //placemark = [placemarks objectAtIndex:0];
             
             NSString *str = [NSString stringWithFormat:@"%@%@%@",placemark.administrativeArea,placemark.locality,placemark.subLocality/*placemark.thoroughfare*/];
             
             NSLog(@"str is:%@",str);
             
             if(strCurrentAdress!=nil)
             {
                 [strCurrentAdress setString:str];
             }
             else
             {
                 strCurrentAdress = [[NSMutableString alloc] initWithString:str];
             }
             
             //myMapView.userLocation.title = str;
             
             NSLog(@"成功获取当前城市名");
             NSLog(@"当前所在城市:%@",placemark.locality);
             
             self.map.showsUserLocation = YES;
             
         }];
    }
    
    
    
    
    
    
    
	
    
    
    
    
    //[mapan release];
    
    
    
    if(arrayPoints!=nil && [arrayPoints count]>0)
    {
        
        
        NSLog(@"\r\r come in [arrayPoints count]>0 \t\t");
        
        for(int i=0;i<[arrayPoints count];i++)
        {
            
            if(mapType == mapTypePoints)
            {
                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:i];
                
                CLLocationDegrees latitude=[[data lat] doubleValue];
                CLLocationDegrees longitude=[[data lng] doubleValue];
                //            CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
                //
                //            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,sthispan ,sthispan );
                //            MKCoordinateRegion adjustedRegion = [map regionThatFits:region];
                //            [map setRegion:adjustedRegion animated:YES];
                
                NewBasicMapAnnotation *  annotation=[[NewBasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
                [self.map   addAnnotation:annotation];
                
              
            }
            else if(mapType == mapTypeRoadRoute)
            {
                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:i];
                
                CLLocationDegrees latitude=[[data lat] doubleValue];
                CLLocationDegrees longitude=[[data lng] doubleValue];
                //            CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
                //
                //            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,sthispan ,sthispan );
                //            MKCoordinateRegion adjustedRegion = [map regionThatFits:region];
                //            [map setRegion:adjustedRegion animated:YES];
                
                NewBasicMapAnnotation *  annotation=[[NewBasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
                //[map   addAnnotation:annotation];
                
                
                [self.map   addAnnotation:annotation];
                //22.5348944,114.114505
                
                /*
                routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, map.frame.size.width, map.frame.size.height)];
                routeView.userInteractionEnabled = NO;
                [map addSubview:routeView];
                
                lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];
                
                Place* home = [[Place alloc] init];
                home.name = @"Home";
                home.description = @"Sweet home";
                home.latitude = lat;
                home.longitude = lon;
                
                Place* office = [[Place alloc] init];
                office.name = @"Office";
                office.description = @"Bad office";
                office.latitude = latitude;
                office.longitude = longitude;
                
                [self showRouteFrom:home to:office];
                */
            }
            
            
            
            
            
            
        }
    }
    
    
    
    
    
    //    
    //    CLLocationDegrees
    
}




//- (void)locationManager:(CLLocationManager *)manager
//	didUpdateToLocation:(CLLocation *)newLocation
//		   fromLocation:(CLLocation *)oldLocation
//{
//    
//    [manager stopUpdatingLocation];
//    
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//	map = [[MKMapView alloc] initWithFrame:rect];
//    
//    if(mapType == mapTypePoints)
//    {
//        [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
//         {
//             //_placemark = [placemarks objectAtIndex:0];
//             
//             
//             MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
//             
//             //placemark = [placemarks objectAtIndex:0];
//             
//             NSString *str = [NSString stringWithFormat:@"%@%@%@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
//             
//             NSLog(@"str is:%@",str);
//             
//             if(strCurrentAdress!=nil)
//             {
//                 [strCurrentAdress setString:str];
//             }
//             else
//             {
//                 strCurrentAdress = [[NSMutableString alloc] initWithString:str];
//             }
//             
//             map.userLocation.title = str;
//             
//             NSLog(@"成功获取当前城市名");
//             NSLog(@"当前所在城市:%@",placemark.locality);
//             
//             
//            
//         }];
//    }
//    
//
//
//    
//    
//    
//    
//	CLLocationCoordinate2D loc = [newLocation coordinate];
//	lat = loc.latitude;
//	lon	= loc.longitude;
//	NSLog(@"lat %f",lat);
//	NSLog(@"lon %f",lon);
//	CLLocationCoordinate2D theCoordinate;
//	CLLocationCoordinate2D theCenter;
//	
//	theCoordinate.latitude =lat;
//	theCoordinate.longitude=lon;
//	[map setDelegate: self];
//	//[map setCenter:CGPointMake(160, 240)] ;
//	[map setMapType: MKMapTypeStandard];
//	
//	MKCoordinateRegion theRegin;
//	theCenter.latitude =lat; 
//	theCenter.longitude = lon;
//	theRegin.center=theCenter;
//	
//	MKCoordinateSpan theSpan;
//	theSpan.latitudeDelta = 0.1;
//	theSpan.longitudeDelta = 0.1;
//	theRegin.span = theSpan;
//	[map setRegion:theRegin];
//	[map regionThatFits:theRegin];
//	map.showsUserLocation=YES;
//	//	map.mapType =MKMapTypeHybrid;
//	/*
//	 MKMapView * aMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//	 self.map = aMapView;
//	 [aMapView release];
//	 [map setDelegate:self];
//	 map.scrollEnabled = YES; 
//	 map.zoomEnabled = YES; 
//	 [map setShowsUserLocation:YES];
//	 map.userLocation.subtitle = @"You are here";
//	 */
//	[self.view addSubview:map];
//    
//    
//
//    
//    //[mapan release];
//    
//    
//    
//    if(arrayPoints!=nil && [arrayPoints count]>0)
//    {
//        
//        
//        NSLog(@"\r\r come in [arrayPoints count]>0 \t\t");
//        
//        for(int i=0;i<[arrayPoints count];i++)
//        {
//            
//            if(mapType == mapTypePoints)
//            {
//                DataObjectSearch *data = (DataObjectSearch *)[arrayPoints objectAtIndex:i];
//                
//                CLLocationDegrees latitude=[[data lat] doubleValue];
//                CLLocationDegrees longitude=[[data lng] doubleValue];
//                //            CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
//                //
//                //            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,sthispan ,sthispan );
//                //            MKCoordinateRegion adjustedRegion = [map regionThatFits:region];
//                //            [map setRegion:adjustedRegion animated:YES];
//                
//                BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
//                [map   addAnnotation:annotation];
//            }
//            else if(mapType == mapTypeRoadRoute)
//            {
//                DataObjectDetail *data = (DataObjectDetail *)[arrayPoints objectAtIndex:i];
//                
//                CLLocationDegrees latitude=[[data lat] doubleValue];
//                CLLocationDegrees longitude=[[data lng] doubleValue];
//                //            CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
//                //
//                //            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,sthispan ,sthispan );
//                //            MKCoordinateRegion adjustedRegion = [map regionThatFits:region];
//                //            [map setRegion:adjustedRegion animated:YES];
//                
//                BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
//                [map   addAnnotation:annotation];
//                
//                
//                
//                //22.5348944,114.114505
//                
//                
//                
//                
//            }
//
//            
//
//            
//            
//            
//        }
//    }
//    
//    
//    
//    
//
////    
////    CLLocationDegrees
//    
//}




// TODO:- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view


#pragma mark -
#pragma mark - mapView Delegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(mapView.isUserLocationVisible == YES)
    {
        return;
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        NSLog(@"MKUserLocation");
    }
    else
    {
        MKAnnotationView *annotationView = [self.map dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"] ;
            annotationView.canShowCallout = YES;
            
            UIImage *image = [UIImage imageNamed:@"pinPurple"];
            annotationView.image = image;

        }
        
        return annotationView;
        
    }
    
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    
    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else
    {
        NSLog(@"\r\r\r dismiss annotation view \r\r");
        
        
        
        
        /*
         if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)])
         {
         [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
         }
         */
    }
}

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    
    
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else
    {
        NSLog(@"\r\r\r dismiss annotation view \r\r");
        
        
        
        
        
//        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)])
//        {
//            [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
//        }
 
    }
}

 

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]])
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

*/

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]])
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        
        if(mapType == mapTypePoints)
        {
            if(strCurrentAdress!=nil && [strCurrentAdress length]>0)
            {
                ((MKUserLocation *)annotation).title = strCurrentAdress;
            }
            else
            {
                ((MKUserLocation *)annotation).title = @"当前位置";
            }
        }
        else
        {
            ((MKUserLocation *)annotation).title = @"当前位置";
        }
        
        
        return nil;
    }  
    
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        
        if(mapType == mapTypePoints)
        {
            CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
            
            if (!annotationView)
            {
                
                
            }
            
            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            
            
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            
            for(id v in cell.subviews)
            {
                [v removeFromSuperview];
            }
            
            
            
            CalloutMapAnnotation *ba = (CalloutMapAnnotation *)annotation;
            
            
            NSLog(@"s is:%f",ba._latitude);
            
            DataObjectSearch *ds = nil;
            
            int i =0;
            
            
            if(arrayPoints!=nil && [arrayPoints count]>0)
            {
                for(;i<[arrayPoints count];i++)
                {
                    ds = [arrayPoints objectAtIndex:i];
                    
                    NSString *ss = [NSString stringWithFormat:@"%f",[ds.lat doubleValue]];
                    NSLog(@"ss is:%@",ss);
                    
                    NSString *s = [NSString stringWithFormat:@"%f",ba._latitude];
                    
                    NSLog(@"s is:%@",s);
                    
                    if([ss localizedCompare:s] == NSOrderedSame)
                    {
                        NSLog(@"\n\n\n now this two value is equl\n\n\n");
                        
                        
                        
                        break;
                        
                        
                    }
                    
                }
                
                
                
                if(ds!=nil)
                {
                    NSLog(@" and now is right");
                    //x 44 y 41 w 68 h 62
                    
                    if([cell viewWithTag:tagImageView])
                    {
                        [[cell viewWithTag:tagImageView] removeFromSuperview];
                    }
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 68.0, 68.0)];
                    imageView.image = [UIImage imageNamed:@"admob-money"];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    imageView.tag = tagImageView;
                    
                    if(ds.img_url!=nil && [ds.img_url length]>0)
                    {
                        
                        
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadWithURL:[NSURL URLWithString:ds.img_url]
                                        delegate:self
                                         options:0
                                         success:^(UIImage *image, BOOL cached)
                         {
                             
                             
                             imageView.image = image;
                             
                             
                         }
                                         failure:^(NSError *error){
                                             
                                             imageView.image = [UIImage imageNamed:@"admob-money"];
                                         }];
                    }
                    
                    [cell addSubview:imageView];
                    
               
                    
                    
                    if([cell viewWithTag:tagTitleLable])
                    {
                        [[cell viewWithTag:tagTitleLable] removeFromSuperview];
                    }
                    
                    
                    UILabel *titile = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+5, 10, cell.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+15), 15)];
                    titile.tag = tagTitleLable;
                    titile.textColor = [UIColor colorWithRed:18.0/255.0 green:150.0/255.0 blue:195.0/255.0 alpha:1.0];
                    
                    titile.backgroundColor = [UIColor clearColor];
                    
                    
                    
                    if(ds.strName!=nil && [ds.strName length]>0)
                    {
                        titile.text = ds.strName;
                    }
                    else
                    {
                        titile.text = @"暂无";
                    }
                    titile.font = [UIFont systemFontOfSize:14.0];
                    [cell addSubview:titile];
                   
                    
                    
                    if([cell viewWithTag:tagStatView])
                    {
                        [[cell viewWithTag:tagStatView] removeFromSuperview];
                    }
                    
                    Star *star2 = [[Star alloc] initWithFrame:CGRectZero];
                    star2.tag = tagStatView;
                    
                    if([ds.rate isEqualToString:@"0.5"])
                    {
                        
                        star2.show_star = 10;
                    }
                    else if([ds.rate isEqualToString:@"1"])
                    {
                        star2.show_star = 20;
                    }
                    else if([ds.rate isEqualToString:@"1.5"])
                    {
                        star2.show_star = 30;
                    }
                    else if([ds.rate isEqualToString:@"2"])
                    {
                        star2.show_star = 40;
                    }
                    else if([ds.rate isEqualToString:@"2.5"])
                    {
                        star2.show_star = 50;
                    }
                    else if([ds.rate isEqualToString:@"3"])
                    {
                        star2.show_star = 60;
                    }
                    else if([ds.rate isEqualToString:@"3.5"])
                    {
                        star2.show_star = 70;
                    }
                    else if([ds.rate isEqualToString:@"4"])
                    {
                        star2.show_star = 80;
                    }
                    else if([ds.rate isEqualToString:@"4.5"])
                    {
                        star2.show_star = 90;
                    }
                    else if([ds.rate isEqualToString:@"5"])
                    {
                        star2.show_star = 100;
                    }
                    // 评分控件  20每星 10半星
                    
                    
                    star2.frame = CGRectMake(titile.frame.origin.x, titile.frame.size.height+titile.frame.origin.y+5, titile.frame.size.width, 15.0f);
                    
                    star2.show_star = 10;
                    
                    star2.userInteractionEnabled = NO;
                    star2.font_size = 14;
                    star2.empty_color = [UIColor lightGrayColor];
                    star2.full_color = [UIColor orangeColor];
                    [cell addSubview:star2];
                    
                    
                    
                    if([cell viewWithTag:tagSubtitleLable])
                    {
                        [[cell viewWithTag:tagSubtitleLable] removeFromSuperview];
                    }
                    
                    
                    UILabel *subtitile = [[UILabel alloc] initWithFrame:CGRectMake(titile.frame.origin.x, star2.frame.origin.y+star2.frame.size.height+5, titile.frame.size.width, 15)];
                    subtitile.tag = tagSubtitleLable;
                    subtitile.textColor = [UIColor colorWithRed:248.0/255.0 green:99.0/255.0 blue:0.0/255.0 alpha:1.0];
                    
                    subtitile.backgroundColor = [UIColor clearColor];
                    subtitile.font = [UIFont systemFontOfSize:12.0];
                    
                    if(ds.cate!=nil && [ds.cate length]>0)
                    {
                        subtitile.text = ds.cate;
                    }
                    else
                    {
                        subtitile.text = @"暂无";
                    }
                    
                    [cell addSubview:subtitile];
                    
                    
                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    [rightButton addTarget:self
                                    action:@selector(showDetails:)
                          forControlEvents:UIControlEventTouchUpInside];
                    rightButton.frame = CGRectMake(210, 20, 35, 35);
                    
                    
                    NSLog(@"ds.strID :%@",ds.strID);
                    
                    rightButton.tag = i;
                    
                    NSLog(@"rightButton.tag :%d",rightButton.tag);
                    
                    [cell addSubview:rightButton];
                    
                    [annotationView.contentView addSubview:cell];
                    
                    
                }
                
            }
            
            return annotationView;

        }
        else
        {
            CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
            
            if (!annotationView)
            {
                
                
                
            }
            
            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            
            
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            
            for(id v in cell.subviews)
            {
                [v removeFromSuperview];
               
            }
            
            
            
            CalloutMapAnnotation *ba = (CalloutMapAnnotation *)annotation;
            
            
            NSLog(@"s is:%f",ba._latitude);
            
            DataObjectSearch *ds = nil;
            
            int i =0;
            
            
            if(arrayPoints!=nil && [arrayPoints count]>0)
            {
                for(;i<[arrayPoints count];i++)
                {
                    ds = [arrayPoints objectAtIndex:i];
                    
                    NSString *ss = [NSString stringWithFormat:@"%f",[ds.lat doubleValue]];
                    NSLog(@"ss is:%@",ss);
                    
                    NSString *s = [NSString stringWithFormat:@"%f",ba._latitude];
                    
                    NSLog(@"s is:%@",s);
                    
                    if([ss localizedCompare:s] == NSOrderedSame)
                    {
                        NSLog(@"\n\n\n now this two value is equl\n\n\n");
                        
                        
                        
                        break;
                        
                        
                    }
                    
                }
                
                
                
                if(ds!=nil)
                {
                    NSLog(@" and now is right");
                    //x 44 y 41 w 68 h 62
                    
                    if([cell viewWithTag:tagImageView])
                    {
                        [[cell viewWithTag:tagImageView] removeFromSuperview];
                    }
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 68.0, 68.0)];
                    imageView.image = [UIImage imageNamed:@"admob-money"];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    imageView.tag = tagImageView;
                    
                    if(ds.img_url!=nil && [ds.img_url length]>0)
                    {
                        
                        
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadWithURL:[NSURL URLWithString:ds.img_url]
                                        delegate:self
                                         options:0
                                         success:^(UIImage *image, BOOL cached)
                         {
                             
                             
                             imageView.image = image;
                             
                             
                         }
                                         failure:^(NSError *error){
                                             
                                             imageView.image = [UIImage imageNamed:@"admob-money"];
                                         }];
                    }
                    
                    [cell addSubview:imageView];
                    
                    
                    
                    if([cell viewWithTag:tagTitleLable])
                    {
                        [[cell viewWithTag:tagTitleLable] removeFromSuperview];
                    }
                    
                    
                    UILabel *titile = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+5, 10, cell.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+15), 15)];
                    titile.tag = tagTitleLable;
                    titile.textColor = [UIColor colorWithRed:18.0/255.0 green:150.0/255.0 blue:195.0/255.0 alpha:1.0];
                    
                    titile.backgroundColor = [UIColor clearColor];
                    
                    
                    
                    if(ds.strName!=nil && [ds.strName length]>0)
                    {
                        titile.text = ds.strName;
                    }
                    else
                    {
                        titile.text = @"暂无";
                    }
                    titile.font = [UIFont systemFontOfSize:14.0];
                    [cell addSubview:titile];
                   
                    
                    
                    if([cell viewWithTag:tagStatView])
                    {
                        [[cell viewWithTag:tagStatView] removeFromSuperview];
                    }
                    
                    Star *star2 = [[Star alloc] initWithFrame:CGRectZero];
                    star2.tag = tagStatView;
                    
                    if([ds.rate isEqualToString:@"0.5"])
                    {
                        
                        star2.show_star = 10;
                    }
                    else if([ds.rate isEqualToString:@"1"])
                    {
                        star2.show_star = 20;
                    }
                    else if([ds.rate isEqualToString:@"1.5"])
                    {
                        star2.show_star = 30;
                    }
                    else if([ds.rate isEqualToString:@"2"])
                    {
                        star2.show_star = 40;
                    }
                    else if([ds.rate isEqualToString:@"2.5"])
                    {
                        star2.show_star = 50;
                    }
                    else if([ds.rate isEqualToString:@"3"])
                    {
                        star2.show_star = 60;
                    }
                    else if([ds.rate isEqualToString:@"3.5"])
                    {
                        star2.show_star = 70;
                    }
                    else if([ds.rate isEqualToString:@"4"])
                    {
                        star2.show_star = 80;
                    }
                    else if([ds.rate isEqualToString:@"4.5"])
                    {
                        star2.show_star = 90;
                    }
                    else if([ds.rate isEqualToString:@"5"])
                    {
                        star2.show_star = 100;
                    }
                    // 评分控件  20每星 10半星
                    
                    
                    star2.frame = CGRectMake(titile.frame.origin.x, titile.frame.size.height+titile.frame.origin.y+5, titile.frame.size.width, 15.0f);
                    
                    star2.show_star = 10;
                    
                    star2.userInteractionEnabled = NO;
                    star2.font_size = 14;
                    star2.empty_color = [UIColor lightGrayColor];
                    star2.full_color = [UIColor orangeColor];
                    [cell addSubview:star2];
                    
                    
                    
                    if([cell viewWithTag:tagSubtitleLable])
                    {
                        [[cell viewWithTag:tagSubtitleLable] removeFromSuperview];
                    }
                    
                    
                    UILabel *subtitile = [[UILabel alloc] initWithFrame:CGRectMake(titile.frame.origin.x, star2.frame.origin.y+star2.frame.size.height+5, titile.frame.size.width, 15)];
                    subtitile.tag = tagSubtitleLable;
                    subtitile.textColor = [UIColor colorWithRed:248.0/255.0 green:99.0/255.0 blue:0.0/255.0 alpha:1.0];
                    
                    subtitile.backgroundColor = [UIColor clearColor];
                    subtitile.font = [UIFont systemFontOfSize:12.0];
                    
                    if(ds.cate!=nil && [ds.cate length]>0)
                    {
                        subtitile.text = ds.cate;
                    }
                    else
                    {
                        subtitile.text = @"暂无";
                    }
                    
                    [cell addSubview:subtitile];
                   
                    
                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    [rightButton addTarget:self
                                    action:@selector(showDetails:)
                          forControlEvents:UIControlEventTouchUpInside];
                    rightButton.frame = CGRectMake(210, 20, 35, 35);
                    
                    
                    NSLog(@"ds.strID :%@",ds.strID);
                    
                    rightButton.tag = i;
                    
                    NSLog(@"rightButton.tag :%d",rightButton.tag);
                    
                    //[cell addSubview:rightButton];
                    
                    [annotationView.contentView addSubview:cell];
                    
                    
                }
                
            }
            
            return annotationView;
        }

        
        
        
	}
    else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        
        
        
        MKAnnotationView *annotationView =[map dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        
        
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"mapicon"];
            
        }
		
		return annotationView;
    }
	return nil;
}


 */


//// Override
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//
//    locationInfo *location = [locationInfo shareInstance];
//    
//    if ([annotation isKindOfClass:[BMKUserLocation class]])
//    {
//        
//        if(mapType == mapTypePoints)
//        {
//            
//            
//            if(location.detailAddress!=nil && [location.detailAddress length]>0)
//            {
//                ((BMKUserLocation *)annotation).title = location.detailAddress;
//            }
//            else
//            {
//                ((BMKUserLocation *)annotation).title = @"当前位置";
//            }
//        }
//        else
//        {
//            ((BMKUserLocation *)annotation).title = @"当前位置";
//        }
//        
//        
//        return nil;
//    }
//    
//    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
//    {
//        
//        if(mapType == mapTypePoints)
//        {
//            CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
//            
//            if (!annotationView)
//            {
//                
//                
//            }
//            
//            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
//            
//            
//            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
//            
//            for(id v in cell.subviews)
//            {
//                [v removeFromSuperview];
//            }
//            
//            
//            
//            CalloutMapAnnotation *ba = (CalloutMapAnnotation *)annotation;
//            
//            
//            NSLog(@"s is:%f",ba._latitude);
//            
//            DataObjectSearch *ds = nil;
//            
//            int i =0;
//            
//            
//            if(arrayPoints!=nil && [arrayPoints count]>0)
//            {
//                for(;i<[arrayPoints count];i++)
//                {
//                    ds = [arrayPoints objectAtIndex:i];
//                    
//                    NSString *ss = [NSString stringWithFormat:@"%f",[ds.lat doubleValue]];
//                    NSLog(@"ss is:%@",ss);
//                    
//                    NSString *s = [NSString stringWithFormat:@"%f",ba._latitude];
//                    
//                    NSLog(@"s is:%@",s);
//                    
//                    if([ss localizedCompare:s] == NSOrderedSame)
//                    {
//                        NSLog(@"\n\n\n now this two value is equl\n\n\n");
//                        
//                        
//                        
//                        break;
//                        
//                        
//                    }
//                    
//                }
//                
//                
//                
//                if(ds!=nil)
//                {
//                    NSLog(@" and now is right");
//                    //x 44 y 41 w 68 h 62
//                    
//                    if([cell viewWithTag:tagImageView])
//                    {
//                        [[cell viewWithTag:tagImageView] removeFromSuperview];
//                    }
//                    
//                    EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 68.0, 68.0)];
//                    imageView.placeholderImage = [UIImage imageNamed:@"admob-money"];
//                    imageView.contentMode = UIViewContentModeScaleAspectFit;
//                    imageView.tag = tagImageView;
//                    
//                    if(ds.img_url!=nil && [ds.img_url length]>0)
//                    {
//                        
//                        
//                        imageView.imageURL = [NSURL URLWithString:ds.img_url];
//                        
// 
//                    }
//                    
//                    [cell addSubview:imageView];
//                    
//                    
//                    
//                    if([cell viewWithTag:tagTitleLable])
//                    {
//                        [[cell viewWithTag:tagTitleLable] removeFromSuperview];
//                    }
//                    
//                    
//                    UILabel *titile = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+5, 10, cell.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+15), 15)];
//                    titile.tag = tagTitleLable;
//                    titile.textColor = [UIColor colorWithRed:18.0/255.0 green:150.0/255.0 blue:195.0/255.0 alpha:1.0];
//                    
//                    titile.backgroundColor = [UIColor clearColor];
//                    
//                    
//                    
//                    if(ds.strName!=nil && [ds.strName length]>0)
//                    {
//                        titile.text = ds.strName;
//                    }
//                    else
//                    {
//                        titile.text = @"暂无";
//                    }
//                    titile.font = [UIFont systemFontOfSize:14.0];
//                    [cell addSubview:titile];
//                    
//                    
//                    if([cell viewWithTag:tagStatView])
//                    {
//                        [[cell viewWithTag:tagStatView] removeFromSuperview];
//                    }
//                    
//               
//                    
//                    if([cell viewWithTag:tagSubtitleLable])
//                    {
//                        [[cell viewWithTag:tagSubtitleLable] removeFromSuperview];
//                    }
//                    
//                    
//                    UILabel *subtitile = [[UILabel alloc] initWithFrame:CGRectMake(titile.frame.origin.x, titile.frame.origin.y+titile.frame.size.height+15, titile.frame.size.width, 15)];
//                    subtitile.tag = tagSubtitleLable;
//                    subtitile.textColor = [UIColor colorWithRed:248.0/255.0 green:99.0/255.0 blue:0.0/255.0 alpha:1.0];
//                    
//                    subtitile.backgroundColor = [UIColor clearColor];
//                    subtitile.font = [UIFont systemFontOfSize:12.0];
//                    
//                    if(ds.cate!=nil && [ds.cate length]>0)
//                    {
//                        subtitile.text = ds.cate;
//                    }
//                    else
//                    {
//                        subtitile.text = @"暂无";
//                    }
//                    
//                    [cell addSubview:subtitile];
//                    /*
//                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//                    [rightButton addTarget:self
//                                    action:@selector(showDetails:)
//                          forControlEvents:UIControlEventTouchUpInside];
//                    rightButton.frame = CGRectMake(210, 20, 35, 35);
//                    
//                    
//                    NSLog(@"ds.strID :%@",ds.strID);
//                    
//                    rightButton.tag = i;
//                    
//                    NSLog(@"rightButton.tag :%d",rightButton.tag);
//                    
//                    [cell addSubview:rightButton];
//                     */
//                     
//                    [annotationView.contentView addSubview:cell];
//                    
//                   
//                }
//                
//            }
//            
//            return annotationView;
//            
//        }
//        else
//        {
//            CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
//            
//            if (!annotationView)
//            {
//                
//                
//                
//            }
//            
//            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
//            
//            
//            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
//            
//            for(id v in cell.subviews)
//            {
//                [v removeFromSuperview];
//                
//            }
//            
//            
//            
//            CalloutMapAnnotation *ba = (CalloutMapAnnotation *)annotation;
//            
//            
//            NSLog(@"s is:%f",ba._latitude);
//            
//            DataObjectSearch *ds = nil;
//            
//            int i =0;
//            
//            
//            if(arrayPoints!=nil && [arrayPoints count]>0)
//            {
//                for(;i<[arrayPoints count];i++)
//                {
//                    ds = [arrayPoints objectAtIndex:i];
//                    
//                    NSString *ss = [NSString stringWithFormat:@"%f",[ds.lat doubleValue]];
//                    NSLog(@"ss is:%@",ss);
//                    
//                    NSString *s = [NSString stringWithFormat:@"%f",ba._latitude];
//                    
//                    NSLog(@"s is:%@",s);
//                    
//                    if([ss localizedCompare:s] == NSOrderedSame)
//                    {
//                        NSLog(@"\n\n\n now this two value is equl\n\n\n");
//                        
//                        
//                        
//                        break;
//                        
//                        
//                    }
//                    
//                }
//                
//                
//                
//                if(ds!=nil)
//                {
//                    NSLog(@" and now is right");
//                    //x 44 y 41 w 68 h 62
//                    
//                    if([cell viewWithTag:tagImageView])
//                    {
//                        [[cell viewWithTag:tagImageView] removeFromSuperview];
//                    }
//                    
//                    EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 68.0, 68.0)];
//                    imageView.placeholderImage = [UIImage imageNamed:@"admob-money"];
//                    imageView.contentMode = UIViewContentModeScaleAspectFit;
//                    imageView.tag = tagImageView;
//                    
//                    if(ds.img_url!=nil && [ds.img_url length]>0)
//                    {
//                        imageView.imageURL = [NSURL URLWithString:ds.img_url];
//                        
//                        
//                    }
//                    
//                    [cell addSubview:imageView];
//                    
//                    
//                    if([cell viewWithTag:tagTitleLable])
//                    {
//                        [[cell viewWithTag:tagTitleLable] removeFromSuperview];
//                    }
//                    
//                    
//                    UILabel *titile = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+5, 10, cell.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+15), 15)];
//                    titile.tag = tagTitleLable;
//                    titile.textColor = [UIColor colorWithRed:18.0/255.0 green:150.0/255.0 blue:195.0/255.0 alpha:1.0];
//                    
//                    titile.backgroundColor = [UIColor clearColor];
//                    
//                    
//                    
//                    if(ds.strName!=nil && [ds.strName length]>0)
//                    {
//                        titile.text = ds.strName;
//                    }
//                    else
//                    {
//                        titile.text = @"暂无";
//                    }
//                    titile.font = [UIFont systemFontOfSize:14.0];
//                    [cell addSubview:titile];
//                    
//                    if([cell viewWithTag:tagSubtitleLable])
//                    {
//                        [[cell viewWithTag:tagSubtitleLable] removeFromSuperview];
//                    }
//                    
//                    
//                    UILabel *subtitile = [[UILabel alloc] initWithFrame:CGRectMake(titile.frame.origin.x, titile.frame.origin.y+titile.frame.size.height+15, titile.frame.size.width, 15)];
//                    subtitile.tag = tagSubtitleLable;
//                    subtitile.textColor = [UIColor colorWithRed:248.0/255.0 green:99.0/255.0 blue:0.0/255.0 alpha:1.0];
//                    
//                    subtitile.backgroundColor = [UIColor clearColor];
//                    subtitile.font = [UIFont systemFontOfSize:14.0];
//                    
//                    if(ds.cate!=nil && [ds.cate length]>0)
//                    {
//                        subtitile.text = ds.cate;
//                    }
//                    else
//                    {
//                        subtitile.text = @"暂无";
//                    }
//                    
//                    [cell addSubview:subtitile];
//                    
//                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//                    [rightButton addTarget:self
//                                    action:@selector(showDetails:)
//                          forControlEvents:UIControlEventTouchUpInside];
//                    rightButton.frame = CGRectMake(210, 20, 35, 35);
//                    
//                    
//                    NSLog(@"ds.strID :%@",ds.strID);
//                    
//                    rightButton.tag = i;
//                    
//                    NSLog(@"rightButton.tag :%d",rightButton.tag);
//                    
//                    //[cell addSubview:rightButton];
//                    
//                    [annotationView.contentView addSubview:cell];
//                    
//                    
//                }
//                
//            }
//            
//            return annotationView;
//        }
//        
//        
//        
//        
//	}
//    
//    else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
//    {
//        
//        
////        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
////        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
////        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
////        return newAnnotationView;
//        
//        
//        BMKAnnotationView *annotationView =[myMapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
//        
//        
//        
//        if (!annotationView)
//        {
//            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:@"CustomAnnotation"];
//            annotationView.canShowCallout = NO;
//            
//            annotationView.image = [UIImage imageNamed:@"pin_purple"];
//            
//        }
//		
//		return annotationView;
//    }
//    else if ([annotation isKindOfClass:[RouteAnnotation class]]) {
//		return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
//	}
//    
//    return nil;
//}




//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//	//method one：using default pin as a PlaceMarker to display on map
//	NSLog(@"creatview");
//	MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
//	//newAnnotation.pinColor = MKPinAnnotationColorGreen;
//	//newAnnotation.animatesDrop = YES;
//	//canShowCallout: to display the callout view by touch the pin
//	newAnnotation.canShowCallout=YES;
//	return newAnnotation;
//}

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{	}
//
//// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{	}
//#pragma mark CLLocationManagerDelegate
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    
    
    
}


@end
