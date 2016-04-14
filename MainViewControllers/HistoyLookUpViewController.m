//
//  HistoyLookUpViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-2-1.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "CustomAnnotation.h"
#import "HistoryViewController.h"

#import "HistoyLookUpViewController.h"

@interface HistoyLookUpViewController ()<UITextFieldDelegate>
{
    NSString *fromTimeStr;
    NSString *toTimeStr;
}
@end

@implementation HistoyLookUpViewController

-(id)initWithDeviceId:(NSString*)strID
{
    self = [super init];
    if (self) {
    
        self.strDeviceID = strID;
        
    }
    return self;
}


#pragma mark- 根据经纬度得到地址
-(void)getMyDevicesList
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getHistoryWithID:self.strDeviceID];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(pushHistoryVC)];
//    //    [rightBtn setTintColor:[UIColor blackColor]];
//    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMyDevicesList];
    [self drawSubView];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(clickSeachBtn)];
    //    [rightBtn setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMapKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [_mapView addGestureRecognizer:gestureRecognizer];
}

-(void)drawSubView
{
    if(self.mapView == nil)
    {
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        _mapView.delegate = self;
        [_mapView setZoomEnabled:YES];      // 是否允许用户自己放大缩小
        [_mapView setScrollEnabled:YES];    // 是否 scroll
        //_mapView.showsUserLocation = YES;
        [self.view addSubview:_mapView];
        
        NSArray *placeholderArr = @[@"年",@"月",@"日",@"时",@"分"];
        UIView *textFildView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 48)];
        textFildView.backgroundColor = [UIColor whiteColor];
        [_mapView addSubview:textFildView];
        for (int i = 0; i<6; i++) {

            if (i == 5) {
                UILabel *fromTimeLab = [[UILabel alloc] initWithFrame:CGRectMake((i*ScreenWidth/6)+2, 2, ScreenWidth/6-5, 20)];
                fromTimeLab.text = @"起始时间";
                fromTimeLab.font = [UIFont systemFontOfSize:11];
                fromTimeLab.textColor = [UIColor redColor];
                [textFildView addSubview:fromTimeLab];
            }
            else
            {
                UITextField *textflid = [[UITextField alloc] initWithFrame:CGRectMake((i*ScreenWidth/6)+2, 2, ScreenWidth/6-5, 20)];
                textflid.tag = 4000+i;
                textflid.placeholder = placeholderArr[i];
                textflid.layer.borderColor = [UIColor lightGrayColor].CGColor;
                textflid.layer.borderWidth = 1;
                textflid.layer.cornerRadius = 2;
                textflid.delegate = self;
                textflid.keyboardType = UIKeyboardTypeNumberPad;
                textflid.textAlignment = NSTextAlignmentCenter;
                [textFildView addSubview:textflid];
            }
        }
        for (int i = 0; i<6; i++) {

            if (i == 5) {
                UILabel *toTimeLab = [[UILabel alloc] initWithFrame:CGRectMake((i*ScreenWidth/6)+2, 25, ScreenWidth/6-5, 20)];
                toTimeLab.text = @"终止时间";
                toTimeLab.font = [UIFont systemFontOfSize:11];
                toTimeLab.textColor = [UIColor greenColor];
                [textFildView addSubview:toTimeLab];
            }
            else
            {
                UITextField *textflid = [[UITextField alloc] initWithFrame:CGRectMake((i*ScreenWidth/6)+2, 25, ScreenWidth/6-5, 20)];
                textflid.tag = 5000+i;
                textflid.layer.borderColor = [UIColor lightGrayColor].CGColor;
                textflid.layer.borderWidth = 1;
                textflid.layer.cornerRadius = 2;
                textflid.delegate = self;
                textflid.keyboardType = UIKeyboardTypeNumberPad;
                textflid.placeholder = placeholderArr[i];
                textflid.textAlignment = NSTextAlignmentCenter;
                [textFildView addSubview:textflid];
            }
        }
        


    }
    
    
    if([mTableDataSource count])
    {
        CLLocationCoordinate2D coords[mTableDataSource.count];//声明一个数组  用来存放画线的点
        [self.mapView removeOverlays:self.mapView.overlays];
        for (int i= 0; i<[mTableDataSource count]; i++)
        {
            DataObjectMyDeviceList *personObj = [mTableDataSource objectAtIndex:i];
            
            CLLocationDegrees latitude = [personObj.strLat doubleValue];
            CLLocationDegrees longitude = [personObj.strLon doubleValue];
            
            CLLocationCoordinate2D annotationCoord;
            
            annotationCoord.latitude = latitude;
            annotationCoord.longitude = longitude;
            coords[i] = annotationCoord;
//            annotation.typeNum = i;
            NSString *toTime = toTimeStr;// 止
            NSString *fromTime = fromTimeStr;// 起
            NSString *currTime = personObj.strCreateTime;
//            NSLog(@"from:%@ to:%@",fromTimeStr,toTimeStr);
            
            BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
            annotation.title = [NSString stringWithFormat:@"%@",personObj.strAddress];
            annotation.subtitle = [NSString stringWithFormat:@"%@",personObj.strCreateTime];
//            if ([fromTime compare:currTime]<=0) {
//                if ([toTime compare:currTime] >= 0) {
//                    [self.mapView addAnnotation:annotation];
//                }
//                else
//                {
//                    NSArray *annArray = [[NSArray alloc]initWithArray:_mapView.annotations];
//                    [_mapView removeAnnotations: annArray];
//                }
//                
//            }
            int fromTimeInt    = [self compareDate:toTime withDate:currTime];
            int toTimeInt      = [self compareDate:fromTime withDate:currTime];
//            if ([fromTime isEqualToString:nil] || [toTime isEqualToString:nil]) {

//            }
            if (toTimeInt>0) {
                if (fromTimeInt < 0) {
                    [self.mapView addAnnotation:annotation];
                }
                else
                {
                    NSArray *annArray = [[NSArray alloc]initWithArray:_mapView.annotations];
                    [_mapView removeAnnotations: annArray];
                }
                
            }
            if (toTime.length == 0 || fromTime.length == 0 || [toTime isEqualToString:@"-00-00 00:00"] || [fromTime isEqualToString:@"-00-00 00:00"]) {
                if (i <10) {
                    
                    [self.mapView addAnnotation:annotation];
                    
                }
            }



//                [self.mapView addAnnotation:annotation];
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
                theSpan.latitudeDelta = 0.01;
                theSpan.longitudeDelta = 0.01;
                theRegin.span = theSpan;
                
                
                [self.mapView setRegion:theRegin animated:YES];
                [self.mapView regionThatFits:theRegin];
            }
            
//            i++;
        }
        
        
//        MKPolyline *cc = [MKPolyline polylineWithCoordinates:coords count:mTableDataSource.count];//执行画线方法
//        
//        [self.mapView addOverlay:cc];
        
    }
    

    
}

#pragma mark - 时间比较
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1 ; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    
    return ci;
}
#pragma mark - mapView Delegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    if(mapView.isUserLocationVisible == YES)
    //    {
    //        return;
    //    }
    //
    //    if([mTableDataSource count])
    //    {
    //        return;
    //    }
    //
    //    CLLocationCoordinate2D theCoordinate;
    //    CLLocationCoordinate2D theCenter;
    //
    //    theCoordinate.latitude = userLocation.location.coordinate.latitude;
    //    theCoordinate.longitude= userLocation.location.coordinate.longitude;
    //
    //
    //    MKCoordinateRegion theRegin;
    //    theCenter.latitude =userLocation.location.coordinate.latitude;
    //    theCenter.longitude = userLocation.location.coordinate.longitude;
    //    theRegin.center=theCenter;
    //
    //    MKCoordinateSpan theSpan;
    //    theSpan.latitudeDelta = 0.1;
    //    theSpan.longitudeDelta = 0.1;
    //    theRegin.span = theSpan;
    //
    //
    //    [self.mapView setRegion:theRegin animated:YES];
    //    [self.mapView regionThatFits:theRegin];
    
    
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
        
        lineview.lineDashPhase = 2;
        NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:6], nil];
        lineview.lineDashPattern = array;
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    //if (annotation != self.mapView.userLocation)
    if ([annotation isKindOfClass:[MKAnnotationView class]])
    {
        static NSString *defaultPinID = @"tianxy.pin";
        pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        else
            pinView.annotation = annotation;
        
        pinView.animatesDrop  =YES;
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.canShowCallout = YES;
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        [self.mapView.userLocation setTitle:@"当前位置..."];
    }
    else
    {
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"] ;
            annotationView.canShowCallout = YES;
            
            UIImage *image = [Util setCustomImage:@"status_Online" andExt:@"png"];
            UIImage *images = [Util scaleToSize:image size:CGSizeMake(15.0, 25.0)];
            annotationView.image = images;
            annotationView.canShowCallout = YES;
            
            //            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //            [rightButton addTarget:self
            //                            action:@selector(showDetails:)
            //                  forControlEvents:UIControlEventTouchUpInside];
            //            rightButton.tag = annotationView.tag;
            //            rightButton.frame = CGRectMake(0.0, 0.0, 28.0, 24.0);
            //            
            //            annotationView.rightCalloutAccessoryView = rightButton;
        }
        
        return annotationView;
        
    }
    
    
    return pinView;
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
    
    id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeHistoryPlayBack];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        
        [SVProgressHUD dismiss];
        
        if([tempObject.arrObjects count])
        {
            if(mTableDataSource == nil)
            {
                mTableDataSource = [[NSMutableArray alloc ]init];
                
            }
            else
            {
                [mTableDataSource removeAllObjects];
            }
            
            [mTableDataSource addObjectsFromArray:tempObject.arrObjects];
            
            [self drawSubView];
            
            
        }
        else
        {
            if (tempObject.strMessage == nil || [tempObject.strMessage isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"抱歉,无相关历史轨迹数据"];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
            }
            //   [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
          
        }
       
    }
    
}
//#pragma mark - fromBtn
- (void)clickSeachBtn{
    [self viewWillAppear:YES];
}
- (void)hideMapKeyboard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    NSString *toYearStr;
    NSString *toMoonStr;
    NSString *todayStr;
    NSString *toHourStr;
    NSString *toMinStr;
    
    NSString *fromYearStr;
    NSString *fromMoonStr;
    NSString *fromDayStr;
    NSString *fromHourStr;
    NSString *fromMinStr;
    UITextField *textFlid = (UITextField *)[self.view viewWithTag:4000];
    fromYearStr = textFlid.text;
    NSLog(@"%@",fromYearStr);
    
    UITextField *textFlid2 = (UITextField *)[self.view viewWithTag:4001];
    fromMoonStr = textFlid2.text;
    NSLog(@"%@",fromMoonStr);
    
    UITextField *textFlid3 = (UITextField *)[self.view viewWithTag:4002];
    fromDayStr = textFlid3.text;
    NSLog(@"%@",fromDayStr);
    
    UITextField *textFlid4 = (UITextField *)[self.view viewWithTag:4003];
    fromHourStr = textFlid4.text;
    NSLog(@"%@",fromHourStr);
    
    UITextField *textFlid5 = (UITextField *)[self.view viewWithTag:4004];
    fromMinStr = textFlid5.text;
    NSLog(@"%@",fromMinStr);
    fromTimeStr = [NSString stringWithFormat:@"%@-%02ld-%02ld %02ld:%02ld",fromYearStr,[fromMoonStr integerValue],[fromDayStr integerValue],[fromHourStr integerValue],[fromMinStr integerValue]];
    NSLog(@"%@",fromTimeStr);
    
    
    UITextField *textFlid6 = (UITextField *)[self.view viewWithTag:5000];
    toYearStr = textFlid6.text;
//    NSLog(@"%@",fromYearStr);
    
    UITextField *textFlid7 = (UITextField *)[self.view viewWithTag:5001];
    toMoonStr = textFlid7.text;
//    NSLog(@"%@",fromMoonStr);
    
    UITextField *textFlid8 = (UITextField *)[self.view viewWithTag:5002];
    todayStr = textFlid8.text;
//    NSLog(@"%@",fromDayStr);
    
    UITextField *textFlid9 = (UITextField *)[self.view viewWithTag:5003];
    toHourStr = textFlid9.text;
    NSLog(@"%@",fromHourStr);
    
    UITextField *textFlid0 = (UITextField *)[self.view viewWithTag:5004];
    toMinStr = textFlid0.text;
//    NSLog(@"%@",fromMinStr);
    toTimeStr = [NSString stringWithFormat:@"%@-%02ld-%02ld %02ld:%02ld",toYearStr,(long)[toMoonStr integerValue],[todayStr integerValue],[toHourStr integerValue],[toMinStr integerValue]];
    NSLog(@"%@",toTimeStr);
    
}
//#pragma mark - UITextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    switch (textField.tag) {
//        case 4000:
//        {
//            NSLog(@"%@",textField.text);
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
