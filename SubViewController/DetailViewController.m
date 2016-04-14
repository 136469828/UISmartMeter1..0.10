//
//  DetailViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-9.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "HistoyLookUpViewController.h"

#import "SubEditViewController.h"

#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "CustomAnnotation.h"

#import "GraphViewController.h"
#import "DetailViewController.h"

#import "NSDate+Helper.h"
#import "NSDate+Lunar.h"

#define MAPHEIGHT       175.0


@interface DetailViewController ()

@end

@implementation DetailViewController


-(id)initWithPersonName:(NSString *)strDeviceID
{
    if(self == [super init])
    {
        if(strDeviceID !=nil)
        {
            self.strDeviceID = strDeviceID;
        }
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectIndex = 0;
    
    isHaveScaled = NO;
    
    topMenuSelectIndex = 0;
    
    _locService = [[BMKLocationService alloc]init];

    self.view.backgroundColor = [UIColor whiteColor];
    
    mItemsArray = [NSMutableArray arrayWithObjects:@"",@"低压\nmmHg",@"高压\nmmHg",@"心率\nBPM", nil];
    
    mTableArray = [NSMutableArray arrayWithObjects:@"血糖",@"血压",@"睡眠",@"运动", nil];
    
    selectIndex = 0;
    
   // [self drawSubView];
    
    [self getMyDevicesList];
}

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
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    //[_mapView viewWillDisappear];
    //_mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}


-(void)setTitleViewTitle
{
    self.navigationItem.titleView = nil;
    
    if([mPersonArray count])
    {
        
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        
        NSString *strForTitle = device.strDeviceOwnerName;
        //标题title
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
        [self getMyDevicesList];
        //
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44)];
        tmpView.backgroundColor = [UIColor clearColor];
        
        UILabel *theTitleLab = [[UILabel alloc ]initWithFrame:CGRectMake(self.view.frame.size.width/2-45, 0.0, 64.0, 44.0)];
        theTitleLab.backgroundColor = [UIColor clearColor];
        theTitleLab.font = [UIFont boldSystemFontOfSize:18.0];
        theTitleLab.textColor = [UIColor whiteColor];
        theTitleLab.text = @"连接中";
    
        [tmpView addSubview:theTitleLab];
        
        UIActivityIndicatorView *indicatorViewGetMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] ;
        indicatorViewGetMore.frame = CGRectMake(theTitleLab.frame.origin.x+theTitleLab.frame.size.width+5, 11.0, 20.0, 20.0);
        [indicatorViewGetMore startAnimating];
        
        [tmpView addSubview:indicatorViewGetMore];
        
        self.navigationItem.titleView = tmpView;
        
    }
    
    
}


/**
 *  获取设备列表
 */
-(void)getMyDevicesList
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getMyDevice];
    
    [self showHUDViewWithString:@"加载中.." withHUDType:SVProgressHUDMaskTypeNone];
}



/**
 *  获取健康信息
 */
-(void)loadDataSource
{
    /**
     *  @开始日期:当前日期 结束时间:往后推一个月1
     */
    NSString *strEndDate = [Util dateStrWithOriginalString:[Util dateToStringFromDate:[NSDate date]] FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy-MM-dd"];
    
    NSDate *strTmpStartDate = [[NSDate date] dateAfterDay:-30];
    
    NSString *strStartDate = [Util dateStrWithOriginalString:[Util dateToStringFromDate:strTmpStartDate] FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy-MM-dd"];
#warning 时间错误
//    strStartDate = @"2015-09-01";
//    
//    strEndDate = @"2015-10-01";

    
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    NSString *strMethod = @"";
    
    strMethod =@"GetHealthBloodPressure";

    [jsonService getHealthInfoWithDeviceID:self.strDeviceID withMethodName:strMethod beginDate:strStartDate endDate:strEndDate];
    
}




#pragma mark-
#pragma mark- 获取单人监控
-(void)getSinglgPersonMonitoring
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getSingleManMonitorByDeviceID:self.strDeviceID];
    
}


#pragma mark- 获取报警信息
-(void)getAlarmInfo
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getAlarmInfomationWithUserID:self.strDeviceID Page:page pageSize:pageSize];
}


#pragma mark- 点击事件
-(void)menuButClickOn:(UIButton*)btn
{
    selectIndex = btn.tag;
    
    [self doSlideAnimatonWithIndex:btn.tag];
}

#pragma mark - animation
-(void)doSlideAnimatonWithIndex:(int)paramIndex
{
    
    for(int i=0;i<[self.buttons count];i++)
    {
        UIButton *btn = [self.buttons objectAtIndex:i];
        
        if(btn.tag == paramIndex)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnSelect@2x"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:125./255. green:179./255. blue:64./255. alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnUnSelect@2x"] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        
    }
    
    
    if(paramIndex == 0)
    {
        mTableArray = [NSMutableArray arrayWithObjects:@"血糖",@"血压",@"饮食",@"运动",@"体重", nil];
        
        mTableView.hidden = NO;
        
        [mTableView setTableFooterView:nil];
        
        [mTableView reloadData];
        

        
    }
    else if(paramIndex == 1)
    {
        mTableArray = [NSMutableArray arrayWithObjects:@"过去三天",@"过去一星期",@"全部", nil];
        
        [self setTableFooterView];
        
        mTableView.hidden = NO;
        
        [mTableView reloadData];
        
    }
    else
    {
        if([mArrayMessage count])
        {
            
        }
        else
        {
            [self getAlarmInfo];
        }
        
        
        [mTableView setTableFooterView:nil];
        
        mTableView.hidden = NO;
        
        [mTableView reloadData];

    }
    
}

-(void)btnKeep
{
    HistoyLookUpViewController *history = [[HistoyLookUpViewController alloc]initWithDeviceId:self.strDeviceID];
    history.title = @"历史回放";
    [self.navigationController pushViewController:history animated:YES];
    
    
}


#pragma mark -
#pragma mark - Draw TableView
-(void)setTableFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0.0, mTableView.frame.origin.y+mTableView.frame.size.height, self.view.frame.size.width, 64.0)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled =YES ;
    
    mTableView.tableFooterView = footView;
    UIButton *bookBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 20.0,mTableView.frame.size.width-20 ,40.0)];
    [bookBut addTarget:self  action:@selector(btnKeep) forControlEvents:UIControlEventTouchUpInside];
    [bookBut setTitle:@"查看" forState:UIControlStateNormal];
    [bookBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBut.layer.cornerRadius = 3.0;
    bookBut.titleLabel.font = [UIFont systemFontOfSize:20.0];
    bookBut.showsTouchWhenHighlighted = YES;
    [bookBut setBackgroundColor:[UIColor colorWithRed:158.0/255.0 green:205.0/255.0 blue:85.0/255.0 alpha:1.0]];
    [footView addSubview:bookBut];
    
    
}



#pragma mark -
#pragma mark - 选择button事件
-(void)selectTimeButClickOn
{
    if([mPersonArray count])
    {
        // 下拉设备菜单
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        
        SubEditViewController *subEdit = [[SubEditViewController alloc] initWithEditType:editTypeSelectPersonHealth withDelegate:self withDataSource:mPersonArray selectValue:self.strDeviceUserName selectIndex:topMenuSelectIndex withObject:device];
        subEdit.title = @"选择设备";
        
        subEdit.selectSectionIndex = -100;
        
        UINavigationController *navlogin = [[UINavigationController alloc] initWithRootViewController:subEdit];
        
        [self presentViewController:navlogin animated:YES completion:nil];

    }
    
    
}


#pragma mark- 地图放大 按键
-(void)btnScaleClicked
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDelay:0.45];
//    
//    if(isHaveScaled == NO)
//    {
//        _mapView.frame = CGRectMake(_mapView.frame.origin.x, _mapView.frame.origin.y, _mapView.frame.size.width, self.view.frame.size.height-(menuView.frame.size.height));
//    }
//    else
//    {
//        _mapView.frame = CGRectMake(_mapView.frame.origin.x, _mapView.frame.origin.y, _mapView.frame.size.width, MAPHEIGHT);
//    }
//    
//    
//    menuView.frame = CGRectMake(menuView.frame.origin.x, _mapView.frame.origin.y+_mapView.frame.size.height, menuView.frame.size.width, menuView.frame.size.height);
//    CGFloat height = self.view.frame.size.height-(menuView.frame.origin.y+menuView.frame.size.height);
//    
//    mTableView.frame = CGRectMake(0.0, menuView.frame.origin.y+menuView.frame.size.height, self.view.frame.size.width, height);
//    
//    [mTableView reloadData];
//    
//    UIImage *img = [UIImage imageNamed:@"iconScaleMax"];
//
//    scaleButton.frame = CGRectMake(_mapView.frame.size.width-(img.size.height*0.9+10), _mapView.frame.origin.y+_mapView.frame.size.height-(scaleButton.frame.size.height+15), scaleButton.frame.size.width, scaleButton.frame.size.height);
//    
//    [UIView commitAnimations];
//    
//    [self.view setNeedsDisplay];
//    
//    isHaveScaled = !isHaveScaled;
}



#pragma mark -
#pragma mark - 画TableView
/**
 *  画TableView
 *
 *  @return
 */
-(void)drawTableView
{
    if(mTableView == nil)
    {
        mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        mTableView.dataSource = self;
        mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        mTableView.delegate = self;
        mTableView.backgroundColor = [UIColor clearColor];
        mTableView.backgroundView = nil;
        
        [self.view addSubview:mTableView];
    }
    else
    {
        [mTableView reloadData];
    }
    
    
    [ToolSet setExtraCellLineHidden:mTableView];
}


#pragma mark -
#pragma mark - drawSubView
-(void)drawSubView
{
    
//    if(_mapView == nil)
//    {
//        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, MAPHEIGHT)];
//        _mapView.delegate = self;
//        [_mapView setZoomEnabled:YES];      // 是否允许用户自己放大缩小
//        [_mapView setScrollEnabled:YES];    // 是否 scroll
//        
//        [self.view addSubview:_mapView];
//        
//        UIImage *img = [UIImage imageNamed:@"iconScaleMax"];
//        
//        scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        scaleButton.frame = CGRectMake(_mapView.frame.size.width-(img.size.height*0.9+10), _mapView.frame.origin.y+_mapView.frame.size.height-(img.size.height+15), img.size.width*0.9, img.size.height*0.9);
//        [scaleButton setBackgroundImage:img forState:UIControlStateNormal];
//        [scaleButton setShowsTouchWhenHighlighted:YES];
//        [scaleButton addTarget:self action:@selector(btnScaleClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_mapView addSubview:scaleButton];
//        
//        [_mapView bringSubviewToFront:scaleButton];
//        
//        
//        CGFloat ypostion = _mapView.frame.origin.y+_mapView.frame.size.height;
//        
//        menuView = [[UIView alloc ]initWithFrame:CGRectMake(0.0, ypostion, self.view.frame.size.width, 40.0)];
//        menuView.backgroundColor = [UIColor clearColor];
//        menuView.userInteractionEnabled = YES;
//        [self.view addSubview:menuView];
//        
//        CGFloat x = 0.0;
//        
//        for (int i = 0; i<[mItemsArray count]; i++)
//        {
//            
//            CGFloat buttonWidth = self.view.frame.size.width/mItemsArray.count;
//            
//            UIButton *menuBut = [[UIButton alloc] initWithFrame:CGRectMake(x, 0.0, buttonWidth, menuView.frame.size.height)];
//            menuBut.tag = i;
//            [menuBut addTarget:self action:@selector(menuButClickOn:) forControlEvents:UIControlEventTouchUpInside];
//            [menuBut setTitle:[mItemsArray objectAtIndex:i] forState:UIControlStateNormal];
//            
//            menuBut.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
//            [menuView addSubview:menuBut];
//            menuBut.titleLabel.textAlignment = kUITextAlignmentCenter;
//            [menuBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            
//            x += buttonWidth;
//            
//            if (i == 0)
//            {
//                [menuBut setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnSelect@2x"] forState:UIControlStateNormal];
//                [menuBut setTitleColor:[UIColor colorWithRed:125./255. green:179./255. blue:64./255. alpha:1.0] forState:UIControlStateNormal];
//            }
//            else
//            {
//                [menuBut setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnUnSelect@2x"] forState:UIControlStateNormal];
//                
//            }
//            
//            if(self.buttons == nil)
//            {
//                self.buttons = [[NSMutableArray alloc] initWithCapacity:0];
//            }
//            
//            [self.buttons addObject:menuBut];
//            
//        }
//        
//        
//        CGFloat height = self.view.frame.size.height-(menuView.frame.origin.y+menuView.frame.size.height);
//        
//        if(mTableView == nil)
//        {
//            mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, menuView.frame.origin.y+menuView.frame.size.height, self.view.frame.size.width, height) style:UITableViewStylePlain];
//            mTableView.dataSource = self;
//            mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            mTableView.delegate = self;
//            mTableView.backgroundColor = [UIColor clearColor];
//            mTableView.backgroundView = nil;
//            
//            [self.view addSubview:mTableView];
//        }
//        else
//        {
//            [mTableView reloadData];
//        }
//        
//        if(selectIndex == 0)
//        {
//            
//        }
//        else if(selectIndex == 1)
//        {
//            [self setTableFooterView];
//        }
//    }
//    
//    [self addAnimationForMap];

}


-(void)addAnimationForMap
{
//    if([mTableDataSource count])
//    {
//        for (int i= 0; i<[mTableDataSource count]; i++)
//        {
//            DataObjectPersonMonitoriing *personObj = [mTableDataSource objectAtIndex:i];
//            
//            if([personObj.strLat length] && [personObj.strLon length])
//            {
//                CLLocationDegrees latitude = [personObj.strLat doubleValue];
//                CLLocationDegrees longitude = [personObj.strLon doubleValue];
//                
//                NSInteger statusValue = [personObj.strStatus intValue];
//                NSString *strStatus =@"";
//                
//                if(statusValue == 1)
//                {
//                    strStatus  =@"在线";
//                    
//                }
//                else
//                {
//                    strStatus  =@"离线";
//                }
//                
//                
//                BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
//                annotation.title = [NSString stringWithFormat:@"%@(%@)",personObj.strOwnerName,personObj.strDeviceName];
//                annotation.subtitle = [NSString stringWithFormat:@"%@ IMEI:%@ %@",strStatus,personObj.strIMEI,personObj.strMobile];;
//                annotation.typeNum = i;
//                [_mapView addAnnotation:annotation];
//                
//                CLLocationCoordinate2D theCoordinate;
//                CLLocationCoordinate2D theCenter;
//                
//                theCoordinate.latitude = latitude;
//                theCoordinate.longitude= longitude;
//                
//                
//                BMKCoordinateRegion theRegin;
//                theCenter.latitude =latitude;
//                theCenter.longitude = longitude;
//                theRegin.center=theCenter;
//                
//                BMKCoordinateSpan theSpan;
//                theSpan.latitudeDelta = 0.01;
//                theSpan.longitudeDelta = 0.01;
//                theRegin.span = theSpan;
//                
//                
//                [_mapView setRegion:theRegin animated:YES];
//                [_mapView regionThatFits:theRegin];
//
//            }
//            else
//            {
//                [SVProgressHUD showSuccessWithStatus:@"暂无经纬度信息~"];
//                
//                break;
//            }
//            
//        }
//
//    }
//    else
//    {
//        [_mapView removeOverlays:_mapView.annotations];
//    }
}


#pragma mark-
#pragma mark -收到选中的项通知
-(void)didFinishedEditWithValue:(id)objValue withIndex:(NSInteger)index
{
    
    //[_mapView removeAnnotations:_mapView.annotations];
    
    topMenuSelectIndex = index;
    
    if([mPersonArray count])
    {
        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
        
        self.strDeviceUserName = device.strDeviceOwnerName;
        self.strDeviceID = device.strDeviceId;
    }

    [self setTitleViewTitle];
    
    [self loadDataSource];
    
    //[self getSinglgPersonMonitoring];
    
    
}


#pragma mark -
#pragma mark - mapView Delegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //[_mapView updateLocationData:userLocation];
}


//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    if(mapView.isUserLocationVisible == YES)
//    {
//        return;
//    }
//    
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
//    
//    
//}
// ios 7 之前
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview = [[MKPolylineView alloc] initWithOverlay:overlay];
        UIColor *color = [UIColor colorWithRed:70.0/255.0f green:178.0/255.0f blue:255.0/255.0f alpha:1.0];
        lineview.strokeColor = [color colorWithAlphaComponent:1.0];
        lineview.lineWidth = 4.0;
        
        lineview.lineWidth = 2;
        return lineview;
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
        pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
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
        
    }
    else
    {
        MKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"] ;
            annotationView.canShowCallout = YES;
            
            UIImage *image = [Util setCustomImage:@"poi_3" andExt:@"png"];
            UIImage *images = [Util scaleToSize:image size:CGSizeMake(image.size.width, image.size.height)];
            annotationView.image = images;
            annotationView.canShowCallout = NO;
        
        }
        
        return annotationView;
    }
    
    return pinView;
}


#pragma mark- tableView delegate method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    
    return [mTableArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        return 4*64;
    }
    return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTable = @"customTableView";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strTable];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTable];
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    if(indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.text = [mTableArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
 
    }
    else
    {
        CGFloat height = 64;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        for(int i=0;i<4;i++)
        {
            CGFloat y = i*64+12;
            // 数据标题显示
            UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 64.0, 42)];
            lableTitle.backgroundColor = [UIColor clearColor];
            lableTitle.textColor  =[UIColor darkGrayColor];
            lableTitle.text = [mItemsArray objectAtIndex:i];
            
            lableTitle.lineBreakMode = kUILineBreakModeWordWrap;
            lableTitle.numberOfLines = 0;
            lableTitle.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:lableTitle];
            // 数据数指
            UILabel *lableTmpValue = [[UILabel alloc] initWithFrame:CGRectMake(lableTitle.frame.origin.x+lableTitle.frame.size.width+10, y, 100, 42)];
            lableTmpValue.textAlignment = kUITextAlignmentLeft;
            lableTmpValue.backgroundColor = [UIColor clearColor];
            lableTmpValue.textColor  =[UIColor blackColor];
            lableTmpValue.font = [UIFont boldSystemFontOfSize:17];
            

            [cell.contentView addSubview:lableTmpValue];
            // 线
            if(i !=3)
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, lableTmpValue.frame.origin.y+lableTmpValue.frame.size.height+12, tableView.frame.size.width/1.8, 0.35)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:lineView];
            }
            
            if([mTableDataSource count])
            {
//                for (NSDictionary *dic in mTableDataSource) {
//                    NSLog(@"%@",dic[@"strHighPressure"]);
//                }
                
                DataObjectHealth *healthInfo = [mTableDataSource objectAtIndex:mTableDataSource.count-1];
//                NSLog(@"%@",healthInfo);
                
                switch (i) {
                    case 0:
                        [lableTitle removeFromSuperview];
                        lableTmpValue.font = [UIFont systemFontOfSize:14];
                        lableTmpValue.frame = CGRectMake(15, y, tableView.frame.size.width/2.0, 42);
                        lableTmpValue.text = healthInfo.strCreateTime;
                        break;
                    case 1:
                        lableTmpValue.text = healthInfo.strLowPressure;
                        break;
                    case 2:
                        lableTmpValue.text = healthInfo.strHighPressure;
                        

                        break;
                    case 3:
                        lableTmpValue.text = healthInfo.strHeartTimes;
                        
                        height = lableTmpValue.frame.origin.y+lableTmpValue.frame.size.height+10;
                        break;
                    default:
                        break;
                }
                
                //右边的图片
                
                UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
                imgv.backgroundColor = [UIColor clearColor];
                
                if ([healthInfo.strHighPressure integerValue]<90 || [healthInfo.strLowPressure integerValue]<60)
                {//血压偏底
                    
                    imgv.image = [UIImage imageNamed:@"xueya"];
                }
                else if ([healthInfo.strHighPressure integerValue]>160 || [healthInfo.strLowPressure integerValue]>105)
                {//中度、重度高血压
                    imgv.image = [UIImage imageNamed:@"zhongdu"];
                }
                else if([healthInfo.strHighPressure integerValue]>140 || [healthInfo.strLowPressure integerValue]>90)
                {//轻度高血压
                    imgv.image = [UIImage imageNamed:@"qingdu"];
                }
                else
                {
                    imgv.image = [UIImage imageNamed:@"zhengchang"];
                }
                imgv.frame = CGRectMake(tableView.frame.size.width/1.8+20, 64.0, 110,140);
                [cell.contentView addSubview:imgv];
                
            }
        }
        
        
    
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, height);
        
    }
    /*
    else if (selectIndex == 1)
    {
        if(mSelectInxexPath == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text =[mTableArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text  =@"";
    }
    else if(selectIndex == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;;
        
        if([mArrayMessage count])
        {
            DataObjectAlarmInfo *alarmInfo  =[mArrayMessage objectAtIndex:indexPath.row];
            
            NSString *tmpStr = [NSString stringWithFormat:@"【%@】%@%@",alarmInfo.strDeviceName,alarmInfo.strOwnerName,alarmInfo.strAlarmContent];
            cell.textLabel.text = tmpStr;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = kUILineBreakModeWordWrap;
            
            cell.detailTextLabel.text = alarmInfo.strCreateTime;
            
        }
    }
    */
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1)
    {
        if(selectIndex == 0)
        {
            NSString *strtitle = [mTableArray objectAtIndex:indexPath.row];
            
            if([mTableArray count])
            {
                healthViewType healthType = healthTypeBloodPressure;
                
                switch (indexPath.row) {
                    case 0:
                    {
                        healthType = healthTypeBloodSugar;
                    }
                        break;
                    case 1:
                    {
                        healthType = healthTypeBloodPressure;
                    }
                        break;
                    case 2:
                    {
                        healthType = healthTypeHealthPlus;//睡眠
                    }
                        break;
                    case 3:
                    {
                        healthType = healthTypeHealthSport;
                    }
                        break;
                    default:
                        break;
                }
                
                GraphViewController *graph = [[GraphViewController alloc] initWithViewType:healthType withDeviceID:self.strDeviceID];
                graph.title = strtitle;
                [self.navigationController pushViewController:graph animated:YES];
            }
            
        }
        else
        {
            mSelectInxexPath = indexPath.row;
            
            [mTableView reloadData];
        }
    }
    
    
    

    
}



#pragma mark -
#pragma mark - webService delegate
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request
{
    DEBUG_NSLOG(@"\n\n start request \n\n ");

    [SVProgressHUD showWithStatus:@"加载中..."];
}

-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    
    if(request.tag == 101) //获取设备列表
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
                    
                    [self setTitleViewTitle];
                    
                    if([mPersonArray count])
                    {
                        DataObjectMyDeviceList *device =[mPersonArray objectAtIndex:topMenuSelectIndex];
                        
                        self.strDeviceID = device.strDeviceId;
                        
                        self.strDeviceUserName = device.strDeviceOwnerName;
                        
                        [self loadDataSource];
                        
                    }
                }
                
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                
                
            }
        }
    }
    else if (request.tag == 110) //获取健康信息
    {
        NSLog(@"%@",request);
       id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeHealthItems];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                if([tempObject.arrObjects count])
                {
                    [SVProgressHUD dismiss];
                    
                    if(mTableDataSource == nil)
                    {
                        mTableDataSource = [[NSMutableArray alloc ]init];
                    }
                    else
                    {
                        [mTableDataSource removeAllObjects];
                    }
                    
                    [mTableDataSource addObjectsFromArray:tempObject.arrObjects];
                    
                    
                    [self drawTableView];
                    
                }
                else
                {
                    [SVProgressHUD dismissWithSuccess:@"暂无健康信息哦~"];
                }
                
            }
            else
            {
            
                if(tempObject.intSuccess == 1001)
                {
                    [SVProgressHUD dismissWithError:NODATA];
                }
                else
                {
                    [SVProgressHUD dismissWithError:@"请求异常，请重试~"];
                    
                }
                
                [mTableDataSource removeAllObjects];
                
                [self drawTableView];
            }
        }
    }
    
    
    /*
    else if (request.tag == 108)
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeAlarmInfo];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                [SVProgressHUD dismiss];
                
                if([tempObject.arrObjects count])
                {
                    if(netWorkType == netTypeDefult)
                    {
                        if(mArrayMessage == nil)
                        {
                            mArrayMessage = [[NSMutableArray alloc ]init];
                        }
                        else
                        {
                            [mArrayMessage removeAllObjects];
                        }
                        
                        [mArrayMessage addObjectsFromArray:tempObject.arrObjects];
                    }
                    else
                    {
                        if(mArrayMessage == nil)
                        {
                            mArrayMessage = [[NSMutableArray alloc ]init];
                        }
                        
                        [mArrayMessage addObjectsFromArray:tempObject.arrObjects];
                    }
                    
                    [mTableView reloadData];
                    
                }
                
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                
                
            }
        }
    }
    else
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
                [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                
                
            }
            
            
            if([mTableDataSource count])
            {
                
            }
            else
            {
                _mapView.showsUserLocation = YES;
            }
        }
    }
    */
    
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}

#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
