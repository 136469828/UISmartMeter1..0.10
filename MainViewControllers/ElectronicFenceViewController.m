//
//  ElectronicFenceViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-30.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "CustomAnnotation.h"

#import "AddViewController.h"

#import "SubEditViewController.h"

#import "ElectronicFenceViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "JSON.h"
#import "UUDatePicker.h"
#import "MyTimePickerView.h"
#import "model.h"
@interface ElectronicFenceViewController ()
{
    CGFloat _latitude;
    CGFloat _longitude;
}
@property (nonatomic,strong) LXActionSheet *actionSheet;


@end

@implementation ElectronicFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    [self drawSubView];
    
    [self getMyDevicesLists];
    
}

#pragma mark -
#pragma mark - 开始定位
-(void)startLocation
{
    [_locService startUserLocationService];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

    
    //[_mapView viewWillAppear];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[_mapView viewWillDisappear];
    //_mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}


#pragma mark -  添加
-(void)rightButton
{
    if([mPersonArray count])
    {
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        
        AddViewController *addViewController = [[AddViewController alloc] initWithAddViewType:addTypeElectronic withObj:device];
        addViewController.title = @"添加围栏";
        addViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:addViewController animated:YES];
        
    }
    
    
}


#pragma mark-
-(void)setTitleViewTitle
{
    self.navigationItem.titleView = nil;
    
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
        [citySelceBut addTarget:self action:@selector(selectTimeButClickOn) forControlEvents:UIControlEventTouchUpInside];
        [citySelceBut addSubview:selectTimeBut];
        [citySelceBut addSubview:theTitleLab];
        
        self.navigationItem.titleView = citySelceBut;
    }
    else
    {
        [self getMyDevicesLists];
        
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


-(void)drawSubView
{
    if(self.mapView == nil)
    {
        [self openSocketConnect];
        
        self.mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _mapView.delegate = self;
        [_mapView setZoomEnabled:YES];      // 是否允许用户自己放大缩小
        [_mapView setScrollEnabled:YES];    // 是否 scroll
        //_mapView.showsUserLocation = YES;
        [self.view addSubview:_mapView];
        // 此处添加关闭按钮
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-125, ScreenWidth, 69)];
        btnView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:btnView];
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 1) {
                [btn setTitle:@"关闭电子围栏" forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:@"打开电子围栏" forState:UIControlStateNormal];
            }
            
            btn.tag = 4000+i;
            btn.backgroundColor = RGB(139, 190, 73);
            btn.frame = CGRectMake(ScreenWidth*0.45*i+30, 10, ScreenWidth*0.4, 28);
            [btn setTintColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(openAndClose:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:btn];
        }
        
    }
    
    
    if([mTableDataSource count])
    {
        NSLog(@"%ld",mTableDataSource.count);
        DataObjectElectronicInfo *electronInfo = [mTableDataSource objectAtIndex:0];
        
//        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([electronInfo.strLat doubleValue],[electronInfo.strLon doubleValue]);//原始坐标
//        //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
//        NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
//        //转换GPS坐标至百度坐标(加密后的坐标)
//        testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
//        NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
//        //解密加密后的坐标字典
//        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
//        CLLocationDegrees latitude = baiduCoor.latitude;
//        CLLocationDegrees longitude = baiduCoor.longitude;
        
        // 地图偏移 lng + 0.0065 lat + 0.0060 0.0143，-0.014 -0.01185，-0.00328
        // lng 0.01282  lat 0.0086
      
        CLLocationDegrees latitude = [electronInfo.strLat doubleValue] - 0.00328;
        CLLocationDegrees longitude = [electronInfo.strLon doubleValue] - 0.01185;

//        NSLog(@"地理位置坐标:%f %f",latitude,longitude);
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
        annotation.title = @"最近位置";
        
        annotation.subtitle = electronInfo.strAddress;
//        NSLog(@"%@",annotation.subtitle);
        [self.mapView addAnnotation:annotation];
        
        /*
        if([electronInfo.subPointArray count])
        {
            for (int i= 0; i<[electronInfo.subPointArray count]; i++)
            {
                DataObjectElectronicInfo *personObj = [electronInfo.subPointArray objectAtIndex:i];
                
                CLLocationDegrees latitude = [personObj.strLat doubleValue];
                CLLocationDegrees longitude = [personObj.strLon doubleValue];
                
                BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
                
                if(i == 0)
                {
                    annotation.title = [NSString stringWithFormat:@"%@(最新坐标记录)",self.strDeviceUserName];
                }
                else
                {
                    annotation.title = [NSString stringWithFormat:@"%@",self.strDeviceUserName];
                }
                
                
                annotation.subtitle = [NSString stringWithFormat:@"%@",personObj.strAddress];;
                annotation.typeNum = i;
                [self.mapView addAnnotation:annotation];
                
                
            }
        }
        */
        
        [self.mapView removeOverlays:self.mapView.overlays];
        
        CLLocationCoordinate2D mexicoCityLocation =CLLocationCoordinate2DMake(latitude,longitude);
        _latitude = latitude;
        _longitude = longitude;
#pragma mark - 电子围栏围栏半径

        myCircle = [MKCircle circleWithCenterCoordinate:mexicoCityLocation radius:[electronInfo.strRadius floatValue]];
        [self.mapView addOverlay: myCircle];

        
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
    
}


#pragma mark - 获取设备
-(void)getMyDevicesLists
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getMyDevice];
}


#pragma mark - 获取电子围栏
-(void)getElectronicFenceWithDeviceId:(NSString*)strDeviceID
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getElectronicFenceWithID:strDeviceID];
}

#pragma mark -
#pragma mark - 选择button事件
- (void)openAndClose:(UIButton *)sender
{
    NSString *isGPS;
    if (sender.tag == 4000) {
        isGPS = strOpenGPS;
    }
    else if(sender.tag == 4001)
    {
        isGPS = strCloseGPS;
    }
    NSLog(@"%ld %@",sender.tag,isGPS);
    NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
    [mdict setObject:isGPS forKey:@"TaskType"];
    [mdict setObject:@"" forKey:@"Content"];
    [mdict setObject:self.strDeviceID forKey:@"SendTo"];
    [mdict setObject:@"APP" forKey:@"ClientType"];
    
    NSString *strJason = [mdict JSONRepresentation];
    
    DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
    
    if([socket isDisconnected]) return;
    
    [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [socket readDataWithTimeout:-1 tag:0];
    
}

-(void)selectTimeButClickOn
{
    if([mPersonArray count])
    {
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        
        SubEditViewController *subEdit = [[SubEditViewController alloc] initWithEditType:editTypeSelectPersonHealth withDelegate:self withDataSource:mPersonArray   selectValue:self.strDeviceUserName selectIndex:topMenuSelectIndex withObject:device];
        subEdit.title = @"选择设备";
        
        subEdit.selectSectionIndex = -100;
        
        UINavigationController *navlogin = [[UINavigationController alloc] initWithRootViewController:subEdit];
        
        [self presentViewController:navlogin animated:YES completion:nil];
        
        
    }
    
    
}

#pragma mark-
#pragma mark -收到选中的项通知
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
    
    [self getElectronicFenceWithDeviceId:self.strDeviceID];
    
    
}



#pragma mark -
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
    else if ([annotation isKindOfClass:[BMKUserLocation class]])
    {
       
    }
    else
    {
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"] ;
            annotationView.canShowCallout = YES;
            
            UIImage *image = [Util setCustomImage:@"poi_3" andExt:@"png"];
            UIImage *images = [Util scaleToSize:image size:CGSizeMake(image.size.width, image.size.height)];
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
                        
                        [self setRightButtonWithTitle:@"" textFont:15 withBackGroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] withBackImage:img withFrame:CGRectMake(0.0, 0.0, img.size.width, img.size.height) isRightButton:YES];
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
                        
                        [self getElectronicFenceWithDeviceId:self.strDeviceID];
                        
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
    else // 围栏信息
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeElectronic];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
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
                
                
            }
            else
            {
                if([tempObject.strMessage length])
                {
                    [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                }
                else
                {
                    [Util showMsgAlert:@"没有围栏信息～"];

                }
                
                [self.mapView removeOverlays:self.mapView.overlays];
                
            }
        }

    }
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}

#pragma socket
#pragma mark -
#pragma mark - 开始socket连接
-(void)openSocketConnect
{
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    if(![socket connectToHost:[FileOperation getServerIP] onPort:[[FileOperation getServerPort] intValue] error:&err])
    {
        NSLog(@"socket:%@",err);
    }
    else
    {
        DEBUG_NSLOG(@"ok  打开端口");
    }
}

#pragma mark -
#pragma mark - 关闭连接
-(void)closeSocketConnect
{
    if(socket)
    {
        [socket disconnect];
    }
    
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag

{
    
    NSLog(@"thread(%),onSocket:%p didWriteDataWithTag:%d",[[NSThread currentThread] name],
          
          sock,tag);
    
    if([socket isConnected])
    {
        DEBUG_NSLOG(@"\n\n connnected \n\n");
    }
}


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    DEBUG_NSLOG(@"%@",[NSString stringWithFormat:@"连接到:%@",host]);
    
    //用于验证socket 登录用户
    
    NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
    [mdict setObject:@"0" forKey:@"TaskType"]; // 第一次传0
    [mdict setObject:@"" forKey:@"Content"];
    [mdict setObject:@"" forKey:@"SendTo"];
    [mdict setObject:@"APP" forKey:@"ClientType"];
    
    NSString *strJason = [mdict JSONRepresentation];
    
    DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
    
    if([socket isDisconnected]) return;
    
    [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    [socket readDataWithTimeout:-1 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    DEBUG_NSLOG(@"\n\n 关闭了socket连接 \n\n");
    
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    DEBUG_NSLOG(@"读取数据:%@",newMessage);
    
    id jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if(jsonDataDict)
    {
        NSMutableDictionary *mdict = (NSMutableDictionary *)jsonDataDict;
        
        NSNumber *flag = [mdict valueForKey:@"Code"];
        
        int success = [flag intValue];
        
        NSString *strMessage = [mdict valueForKey:@"message"];
        strMessage = [Util returnValuableString:strMessage];
        
        if(success != 1)
        {
            [SVProgressHUD showErrorWithStatus:strMessage duration:1.0];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:strMessage duration:1.0];
        }
        
    }
    
    
}
#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
