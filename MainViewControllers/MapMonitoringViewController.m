//
//  MapMonitoringViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "CustomAnnotation.h"

#import "DetailViewController.h"
#import "HistoyLookUpViewController.h"
#import "SubEditViewController.h"
#import "MapMonitoringViewController.h"
#import "model.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@implementation MapMonitoringViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //_locService = [[BMKLocationService alloc]init];
    [self setTitleViewTitle ];
    [self showMapView];
    [self getMutableDeviceMonitoring];
    //    [self alViewShow];
    //    [self loadDemoData];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史轨迹>" style:UIBarButtonItemStylePlain target:self action:@selector(pushHistoryVC)];
//    [rightBtn setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)pushHistoryVC{
    HistoyLookUpViewController *historyVC = [[HistoyLookUpViewController alloc] init];
    historyVC.title = @"历史轨迹";
    historyVC.strDeviceID = self.strDeviceID;
    [self.navigationController pushViewController:historyVC animated:YES];
}
//- (void)alViewShow{
//    UIAlertView *alV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认是否打开了设备GPS" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//    [alV show];
//}
#pragma mark -
#pragma mark - 开始定位
-(void)startLocation
{
    [_locService startUserLocationService];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    //[_mapView viewWillAppear];
    //_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    [self setTitleViewTitle ];
    //_locService = [[BMKLocationService alloc]init];
    
    [self showMapView];
    
    [self getMutableDeviceMonitoring];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //[_mapView viewWillDisappear];
    //_mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
//    [self.mapView removeFromSuperview];
    
}

#pragma mark-
#pragma mark- 获取多人监控
-(void)getMutableDeviceMonitoring
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getMutableMonitor];
    
}
- (void)viewControllerChangeInfo:(model *)infoModel
{
    
    indexDevice = infoModel.m_name;
    
}

-(void)addAnimationForMap
{
    
    if([arrTableViewSource count])
    {
        NSLog(@"选取第%ld设备",indexDevice);
        //        if (indexDevice == 0) {
        //            indexDevice = 1;
        //        }
//        NSLog(@"arrTableViewSource->%ld",arrTableViewSource.count);
        for (int i= 0; i< 1; i++)
        {
            DataObjectPersonMonitoriing *personObj = [arrTableViewSource objectAtIndex:indexDevice];
            //         CLLocationDegrees latitude = [electronInfo.strLat doubleValue] - 0.00328;
            //      CLLocationDegrees longitude = [electronInfo.strLon doubleValue] - 0.01185;
            
            CLLocationDegrees latitude = [personObj.strLat doubleValue];
            
            CLLocationDegrees longitude = [personObj.strLon doubleValue];
 /*火星转百度*/
//            CLLocationCoordinate2D mexicoCityLocation =CLLocationCoordinate2DMake(latitude,longitude);
//
//            CLLocationCoordinate2D coor = [self returnBDPoi:mexicoCityLocation];
//            NSLog(@"纠偏后的坐标--%.15f,%.15f", coor.longitude,coor.latitude);
//            latitude = coor.latitude;
//            longitude = coor.longitude;
  /* 百度官方转 */
//            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitudes,longitudes);//原始坐标
//            //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
//            NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
//            //转换GPS坐标至百度坐标(加密后的坐标)
//            testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
//            NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
//            //解密加密后的坐标字典
//            CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
//            CLLocationDegrees latitude = baiduCoor.latitude;
//            CLLocationDegrees longitude = baiduCoor.longitude;
//            NSLog(@"纠偏后的坐标:%.20f,%.20f",longitude,latitude);
/*  百度转火星 */
            CLLocationCoordinate2D mexicoCityLocation =CLLocationCoordinate2DMake(latitude,longitude);
            
            CLLocationCoordinate2D coor = [self returnGCJPoi:mexicoCityLocation];
            NSLog(@"--%f,%f",coor.latitude, coor.longitude);
            latitude = coor.latitude;
            longitude = coor.longitude;
            
            NSInteger statusValue = [personObj.strStatus intValue];
            NSString *strStatus =@"";
            
            if(statusValue == 1)
            {
                strStatus  =@"在线";
                
            }
            else
            {
                strStatus  =@"离线";
            }
            
            //
            BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
            annotation.title = [NSString stringWithFormat:@"%@(%@) %@",personObj.strOwnerName,personObj.strDeviceName,personObj.strCreateTime];
            annotation.subtitle = [NSString stringWithFormat:@"%@ IMEI:%@ %@",strStatus,personObj.strIMEI,personObj.strMobile];
//            NSLog(@"%@",annotation.subtitle);
            annotation.typeNum = indexDevice;
            annotation.status = statusValue;
            titleLab.text = [NSString stringWithFormat:@"%@\n%@",personObj.strCreateTime,personObj.strAddress];
            [self.mapView addAnnotation:annotation];
            //                _mapView.showsUserLocation = YES;
            
            if(i == 0)
            {
                
                CLLocationCoordinate2D theCoordinate;
                CLLocationCoordinate2D theCenter;
                
                theCoordinate.latitude = latitude;
                theCoordinate.longitude= longitude;
                
                
                MKCoordinateRegion theRegin;
                //                BMKCoordinateRegion theRegin;
                theCenter.latitude =latitude;
                theCenter.longitude = longitude;
                theRegin.center=theCenter;
                
                MKCoordinateSpan theSpan;
                //                BMKCoordinateSpan theSpan;
                theSpan.latitudeDelta = 0.01;
                theSpan.longitudeDelta = 0.01;
                theRegin.span = theSpan;
                
                
                [self.mapView setRegion:theRegin animated:YES];
                [self.mapView regionThatFits:theRegin];
            }
        }
        
        
    }
    else
    {
        NSLog(@"没有数据");
    }
}
-(CLLocationCoordinate2D)returnGCJPoi:(CLLocationCoordinate2D)PoiLocation
{
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    float x = PoiLocation.longitude - 0.0065, y = PoiLocation.latitude - 0.006;
    float z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    float theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    
    
    CLLocationCoordinate2D GCJpoi=
    CLLocationCoordinate2DMake( z * sin(theta),z * cos(theta));
    return GCJpoi;
}
-(CLLocationCoordinate2D)returnBDPoi:(CLLocationCoordinate2D)PoiLocation
{
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x=PoiLocation.longitude;
    double y=PoiLocation.latitude;
    double z=sqrtf(x*x+y*y)-0.00002*sinf(y*x_pi);
    double theta = atan2(y, x) + 0.000003 *cos(x * x_pi);
    /*
     double x = gg_lon, y = gg_lat;
     double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
     double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
     bd_lon = z * cos(theta) + 0.0065;
     bd_lat = z * sin(theta) + 0.006;
     */
    CLLocationCoordinate2D BDpoi=
    CLLocationCoordinate2DMake( z * sin(theta) + 0.006,z * cos(theta) + 0.0065);
    return BDpoi;
}
-(void)showMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    [_mapView setZoomEnabled:YES];      // 是否允许用户自己放大缩小
    [_mapView setScrollEnabled:YES];    // 是否 scroll
    
    _mapView.showsUserLocation = YES;
    
    //    [self.view addSubview:_mapView];
    self.view = _mapView;
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth-16, 65)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.numberOfLines = 0;
    [self.mapView addSubview:titleLab];
}

-(void)showDetails:(UIButton*)sender
{
    DataObjectPersonMonitoriing *personObj = [arrTableViewSource objectAtIndex:sender.tag];
    NSLog(@"%@",personObj.strID);
    DetailViewController *dt = [[DetailViewController alloc]initWithPersonName:personObj.strID];
    
    dt.title  =@"实时追踪";
    [self.navigationController pushViewController:dt animated:YES];
}


#pragma mark -
#pragma mark - mapView Delegate

#pragma mark -
#pragma mark - mapView Delegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    if(_mapView.isUserLocationVisible == YES)
    {
        return;
    }
    
    
    CLLocationCoordinate2D theCoordinate;
    CLLocationCoordinate2D theCenter;
    
    theCoordinate.latitude = userLocation.location.coordinate.latitude;
    theCoordinate.longitude= userLocation.location.coordinate.longitude;
    
    
    MKCoordinateRegion theRegin;
    //    BMKCoordinateRegion theRegin;
    
    theCenter.latitude =userLocation.location.coordinate.latitude;
    theCenter.longitude = userLocation.location.coordinate.longitude;
    theRegin.center=theCenter;
    
    MKCoordinateSpan theSpan;
    //    BMKCoordinateSpan theSpan;
    
    //    theSpan.latitudeDelta = 0.05;
    //    theSpan.longitudeDelta = 0.05;
    theRegin.span = theSpan;
    
    
    [self.mapView setRegion:theRegin animated:YES];
    [self.mapView regionThatFits:theRegin];
    
    //[self.mapView updateLocationData:userLocation];
}

// ios 7 之前
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview = [[MKPolylineView alloc] initWithOverlay:overlay];
        UIColor *color = [UIColor colorWithRed:70.0/255.0f green:178.0/255.0f blue:255.0/255.0f alpha:1.0];
        lineview.strokeColor = [color colorWithAlphaComponent:1.0];
        lineview.lineWidth = 4.0;
        
        return lineview;
    }
    else if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
        
        UIColor *color = [UIColor colorWithRed:70.0/255.0f green:178.0/255.0f blue:255.0/255.0f alpha:1.0];
        circleView.strokeColor = [color colorWithAlphaComponent:1.0];
        circleView.lineWidth = 2.5;
        
        //circleView.lineWidth    = 5.f;
        //circleView.strokeColor  = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        //circleView.fillColor    = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        
        
        //circleView.lineDashPhase     = YES;
        
        return circleView;
    }
    return nil;
}

// ios 7 之后
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    NSLog(@"7777777777");
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *lineview = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        UIColor *color = [UIColor colorWithRed:70.0/255.0f green:178.0/255.0f blue:255.0/255.0f alpha:1.0];
        lineview.strokeColor = [color colorWithAlphaComponent:1.0];
        lineview.lineWidth = 2.5;
        
        lineview.lineDashPhase = 2;
        NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:6], nil];
        lineview.lineDashPattern = array;
        return lineview;
    }
    else if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer *lineview = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        UIColor *color = [UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0];
        lineview.strokeColor = [color colorWithAlphaComponent:1.0];
        lineview.lineWidth = 2.5;
        
        lineview.lineDashPhase = 2;
        //NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:6], nil];
        //lineview.lineDashPattern = array;
        return lineview;
        
        ;
        
        // 是否在该范围内
        
        //MKMapRectContainsPoint(lineview.circle.boundingMapRect, MKMapPointForCoordinate(<#CLLocationCoordinate2D coordinate#>))
        
        //MKMapRectContainsRect(<#MKMapRect rect1#>, <#MKMapRect rect2#>)
        
        
        //        MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
        //
        //        circleView.lineWidth    = 5.f;
        //        circleView.strokeColor  = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        //        circleView.fillColor    = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        //        //circleView.lineDashPhase     = YES;
        //
        //        return circleView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        NSLog(@"MKUserLocation");
    }
    else
    {
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"] ;
            annotationView.canShowCallout = YES;
            
            BasicMapAnnotation *Mapannotation = annotation;
            
            UIImage *image = nil;
            UIImage *images = nil;
            
            if(Mapannotation.status == 1)
            {
                image = [Util setCustomImage:@"status_Online" andExt:@"png"];
                
                images = [Util scaleToSize:image size:CGSizeMake(40, 55)];
            }
            else
            {
                image = [Util setCustomImage:@"status_Offline" andExt:@"png"];
                images = [Util scaleToSize:image size:CGSizeMake(40, 55)];
            }
            
            annotationView.image = images;
            /*
             UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
             [rightButton addTarget:self
             action:@selector(showDetails:)
             forControlEvents:UIControlEventTouchUpInside];
             rightButton.tag = annotationView.tag;
             rightButton.frame = CGRectMake(0.0, 0.0, 28.0, 24.0);
             annotationView.canShowCallout = YES;
             annotationView.rightCalloutAccessoryView = rightButton;
             */
        }
        
        return annotationView;
        
    }
    
    
    return nil;
}



#pragma mark -
#pragma mark - webService delegate
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request
{
    DEBUG_NSLOG(@"\n\n start request \n\n ");
    
    [self showHUDViewWithString:@"加载中.." withHUDType:SVProgressHUDMaskTypeNone];
    
    
}

-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    
    id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypePersonMonitoring];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            [SVProgressHUD dismiss];
            
            if([tempObject.arrObjects count])
            {
                if(arrTableViewSource == nil)
                {
                    arrTableViewSource = [[NSMutableArray alloc ]init];
                    
                }
                else
                {
                    [arrTableViewSource removeAllObjects];
                }
                
                [arrTableViewSource addObjectsFromArray:tempObject.arrObjects];
                
                self.mapView.showsUserLocation = NO;
                
                [self addAnimationForMap];
                
                
            }
            
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
            
            
        }
    }
    
    
    if(request.tag == 101) // 获取设备
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeMyDeviceList];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                
                
                if([tempObject.arrObjects count])
                {
                    if(mPersonArray == nil)
                    {
                        mPersonArray = [[NSMutableArray alloc ]init];
                        
                    }
                    else
                    {
                        [mPersonArray removeAllObjects];
                    }
                    
                    [mPersonArray addObjectsFromArray:tempObject.arrObjects];
                    
                    if([mPersonArray count])
                    {
                        [self setTitleViewTitle];
                        
                        UIImage *img = [UIImage imageNamed:@"barbuttonicon_add"];
                        
                        //                        [self setRightButtonWithTitle:@"" textFont:15 withBackGroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] withBackImage:img withFrame:CGRectMake(0.0, 0.0, img.size.width, img.size.height) isRightButton:YES];
                        //
                        //                        UIView *barRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 90, 40)];
                        //                        barRightView.backgroundColor = [UIColor clearColor];
                        //
                        //                        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        //                        closeButton.frame = CGRectMake(0, 0, 40, 40);
                        //                        [closeButton addTarget:self action:@selector(closeMonitng) forControlEvents:UIControlEventTouchDown];
                        //                        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
                        //                        [barRightView addSubview:closeButton];
                        //
                        //
                        //
                        //                        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        //                        addButton.frame = CGRectMake(50, 0, 40, 40);
                        //                        [addButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchDown];
                        //                        [addButton setImage:[UIImage imageNamed:@"barbuttonicon_add"]forState:UIControlStateNormal];
                        //                        [barRightView addSubview:addButton];
                        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
                        //                        UIBarButtonItem *rView = [[UIBarButtonItem alloc] initWithCustomView:barRightView];
                        //                        self.navigationItem.rightBarButtonItem = rView;
                        //
                        
                        self.strDeviceID = device.strDeviceId;
                        
                        self.strDeviceUserName = device.strDeviceOwnerName;
                        
                        //                        [self getElectronicFenceWithDeviceId:self.strDeviceID];
                        
                    }
                }
                
                
            }
            else
            {
                [Util showMsgAlert:@"你还没有添加被监护人哦～"];
                
                
            }
            
            [SVProgressHUD dismiss];
        }
    }
    
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}
#pragma mark - JCK改
#pragma mark-
-(void)didFinishedEditWithValue:(id)objValue withIndex:(NSInteger)index
{
    
    topMenuSelectIndex = index;
    
    if([mPersonArray count])
    {
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        
        self.strDeviceUserName = device.strDeviceOwnerName;
        self.strDeviceID = device.strDeviceId;
        
    }
    
    
    [self setTitleViewTitle];
    
    //    [self getElectronicFenceWithDeviceId:self.strDeviceID];
    
    
}

-(void)setTitleViewTitle
{
    self.navigationItem.titleView = nil;
    //    a = 1;
    if([mPersonArray count])
    {
        
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        
        NSString *strForTitle = device.strDeviceOwnerName;
        
        UILabel *theTitleLab = [[UILabel alloc ]initWithFrame:CGRectMake(0.0, 0.0, 30.0, 44.0)];
        theTitleLab.backgroundColor = [UIColor clearColor];
        theTitleLab.font = [UIFont boldSystemFontOfSize:16.0];
        theTitleLab.numberOfLines = 0;
        theTitleLab.textColor = [UIColor whiteColor];
        theTitleLab.text = strForTitle;
        theTitleLab.textAlignment = kUITextAlignmentCenter;
        
        theTitleLab.font = [UIFont systemFontOfSize:18];
        
        theTitleLab.text = strForTitle;
        
        CGSize labelSize = [theTitleLab.text sizeWithFont:theTitleLab.font constrainedToSize:CGSizeMake(200.0, 25.0) lineBreakMode:kUILineBreakModeWordWrap];
        theTitleLab.frame = CGRectMake(theTitleLab.frame.origin.x, theTitleLab.frame.origin.y,labelSize.width, theTitleLab.frame.size.height);
        
        selectTimeBut = [[UIImageView alloc] initWithFrame:CGRectMake(theTitleLab.frame.origin.x + theTitleLab.frame.size.width + 5, 17.5, 12.0, 8.5)];
        [selectTimeBut setImage:[UIImage imageNamed:@"oderListViewTitleImage0"]];
        
        
        UIButton *citySelceBut = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0,18 + theTitleLab.frame.size.width , 44.0)];
        citySelceBut.backgroundColor = [UIColor clearColor];
        [citySelceBut addTarget:self action:@selector(selectTimeButClickOns) forControlEvents:UIControlEventTouchUpInside];
        [citySelceBut addSubview:selectTimeBut];
        [citySelceBut addSubview:theTitleLab];
        
        self.navigationItem.titleView = citySelceBut;
    }
    else
    {
        [self getMyDevicesList];
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44)];
        tmpView.backgroundColor = [UIColor clearColor];
        
        UILabel *theTitleLab = [[UILabel alloc ]initWithFrame:CGRectMake(self.view.frame.size.width/2-45, 0.0, 64.0, 44.0)];
        theTitleLab.backgroundColor = [UIColor clearColor];
        theTitleLab.font = [UIFont boldSystemFontOfSize:18.0];
        theTitleLab.textColor = [UIColor whiteColor];
        theTitleLab.text = @"连接中";
        
        
        CGSize labelSize = [theTitleLab.text sizeWithFont:theTitleLab.font constrainedToSize:CGSizeMake(200.0, 25.0) lineBreakMode:kUILineBreakModeWordWrap];
        theTitleLab.frame = CGRectMake(theTitleLab.frame.origin.x, theTitleLab.frame.origin.y,labelSize.width, theTitleLab.frame.size.height);
        [tmpView addSubview:theTitleLab];
        
        UIActivityIndicatorView *indicatorViewGetMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
        indicatorViewGetMore.frame = CGRectMake(theTitleLab.frame.origin.x+theTitleLab.frame.size.width+5, 11.0, 20.0, 20.0);
        [indicatorViewGetMore startAnimating];
        
        [tmpView addSubview:indicatorViewGetMore];
        
        self.navigationItem.titleView = tmpView;
        
    }
    
    
}
#pragma mark - 获取设备
-(void)getMyDevicesList
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getMyDevice];
}
#pragma mark - 选择button事件
-(void)selectTimeButClickOns
{
    if([mPersonArray count])
    {
        // 下拉设备菜单
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        NSLog(@"%ld %ld",arrTableViewSource.count,mPersonArray.count);
        
        
        SubEditViewController *subEdit = [[SubEditViewController alloc] initWithEditType:editTypeSelectPersonHealth withDelegate:self withDataSource:mPersonArray selectValue:self.strDeviceUserName selectIndex:topMenuSelectIndex withObject:device];
        subEdit.indexDelegate = self;
        subEdit.title = @"选择设备";
        
        subEdit.selectSectionIndex = -100;
        
        UINavigationController *navlogin = [[UINavigationController alloc] initWithRootViewController:subEdit];
        
        [self presentViewController:navlogin animated:YES completion:nil];
        
    }
    
    
}


@end
