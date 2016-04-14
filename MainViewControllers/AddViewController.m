//
//  AddViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 14-10-11.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "SZTextView.h"

#import "JSON.h"
#import "UUDatePicker.h"


#import "ToolSet.h"

#import "PAImageView.h"

#import "SubEditViewController.h"

#import "AddViewController.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface AddViewController ()<UUDatePickerDelegate>

@property (nonatomic, strong) SZTextView *textView;


@end

@implementation AddViewController

@synthesize socket;

-(id)initWithAddViewType:(addViewType)aType withObj:(DataObjectMyDeviceList*)obj
{
    self = [super init];
    if (self) {
        
        self.deviceObjet = obj;
        
        currentViewType = aType;
        
        if(currentViewType == addTypeTakeMedicineRemind)
        {
            [self openSocketConnect];
        }
        
    }
    return self;
}


-(id)initWithAddViewType:(addViewType)aType
{
    self = [super init];
    if (self) {
        
        currentViewType = aType;
        
        
    }
    return self;
}

#pragma mark -
#pragma mark - 开始定位
-(void)startLocation
{
    //[_locService startUserLocationService];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self drawTableView];
    [self openSocketConnect];
    //_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    //[_mapView viewWillAppear];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[_mapView viewWillDisappear];
    //_mapView.delegate = nil; // 不用时，置nil
    //_locService.delegate = nil;
    
    self.deviceObjet.strLat = @"";
    self.deviceObjet.strLon = @"";
    self.deviceObjet.strRadius = @"";
    [locationInfo shareInstance].detailAddress = @"";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isNeedShow = YES;
    
    //_locService = [[BMKLocationService alloc]init];
    //_locService.delegate = self;
    
    [self startLocation];
    
    if(mUserPhone == nil)
    {
        mUserPhone = [[NSMutableString alloc] initWithCapacity:0];
    }
    
    if(mUserName == nil)
    {
        mUserName = [[NSMutableString alloc] initWithCapacity:0];
        
    }
    
    if(self.deviceObjet == nil)
    {
        self.deviceObjet = [[DataObjectMyDeviceList alloc]init];
    }
    
    if(self.medicineRmindObject == nil)
    {
        self.medicineRmindObject = [[DataObjectMedicineRemind alloc]init];
    }
    
    self.medicineRmindObject.strRemindTime = [Util dateToStringFromDate:[NSDate date]];
    
    [self loadDataSource];
    
}



-(void)addNotification
{
    
    // 是否需要刷新 服务界面  登录成功后 刷新 店员列表、预约服务列表等
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishedEditWithValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishedEditWithValue:)
                                                 name: @"didFinishedEditWithValue"
                                               object: nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didAddPersonSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddPersonSuccess:)
                                                 name: @"didAddPersonSuccess"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didAddDeviceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddDeviceSuccess:)
                                                 name: @"didAddDeviceSuccess"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didAddMedicineRemindSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddMedicineRemindSuccess:)
                                                 name: @"didAddMedicineRemindSuccess"
                                               object: nil];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishedEditWithValue" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didAddPersonSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didAddDeviceSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didAddMedicineRemindSuccess" object:nil];
    
}


-(void)didAddPersonSuccess:(NSNotification*)notification
{
    
}

-(void)didAddDeviceSuccess:(NSNotification*)notification
{
    
}

-(void)didAddMedicineRemindSuccess:(NSNotification*)notification
{
    
}



#pragma mark-
#pragma mark -收到选中的项
-(void)didFinishedEditWithValue:(id)objValue
{
    
    if(currentViewType == addTypePeson )
    {
        if(selectSectionIndex == 0)
        {
            
        }
        
        [mTableView reloadData];
    }
    else if(currentViewType == addTypeTakeMedicineRemind)
    {
        if(selectSectionIndex == 0)
        {
            
        }

        
        [mTableView reloadData];
    }
    else if(currentViewType == addTypeDeviceForPerson)
    {
        if(selectSectionIndex == 1)
        {
            NSString *str = [Util returnValuableString:objValue];
            
            if(selectRowIndex == 1)
            {
                self.deviceObjet.strHealthInfo = str;
            }
            else if (selectRowIndex == 2)
            {
                self.deviceObjet.strCommonlyUseDrugs = str;
            }
            
        }
        
        [mTableView reloadData];
    }
 
}


#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    DEBUG_NSLOG(@"%d",(int)buttonIndex);
    
    NSString *strRadius = @"";
    
    if(buttonIndex == 0)
    {
        strRadius = @"500";
    }
    else if ((int)buttonIndex == 1)
    {
        strRadius = @"800";
    }
    else if ((int)buttonIndex == 2)
    {
        strRadius = @"1000";
    }
    else if ((int)buttonIndex == 3)
    {
        strRadius = @"2000";
        //[NSString stringWithFormat:@"%d", INT_MAX];
    }
    
    
    
    self.deviceObjet.strRadius = strRadius;

    if(self.deviceObjet.strLat !=nil && self.deviceObjet.strLon !=nil && [strRadius isEqualToString:@"9999999"] == 0)
    {
        CLLocationCoordinate2D mexicoCityLocation =CLLocationCoordinate2DMake([self.deviceObjet.strLat floatValue],[self.deviceObjet.strLon floatValue]);
        
        MKCircle *myCircle = [MKCircle circleWithCenterCoordinate:mexicoCityLocation radius:[self.deviceObjet.strRadius floatValue]];
        
        [self.mapView removeOverlays:self.mapView.overlays];
        
        [self.mapView addOverlay: myCircle];
    }
    
    [mTableView reloadData];
    
}

- (void)didClickOnDestructiveButton
{
    DEBUG_NSLOG(@"destructuctive");
}

- (void)didClickOnCancelButton
{
    DEBUG_NSLOG(@"cancelButton");
}


#pragma mark-
-(void)loadDataSource
{
    if(currentViewType == addTypePeson)
    {
        
        mTableviewSection1 = [[NSMutableArray alloc] initWithObjects:@"选择设备",@"监护人号码",nil];
        mTableviewSection2 = [[NSMutableArray alloc] initWithObjects:@"监护人昵称",nil];
    
    }
    else if (currentViewType == addTypeTakeMedicineRemind)
    {
        mTableviewSection1 = [[NSMutableArray alloc] initWithObjects:@"提醒设备",@"提醒时间",nil];
        mTableviewSection2 = [[NSMutableArray alloc] initWithObjects:@"提醒内容",nil];
    }
    else if (currentViewType == addTypeElectronic)
    {
        mTableviewSection1 = [[NSMutableArray alloc] initWithObjects:@"经纬度",@"半径范围",@"位置信息",nil];
        mTableviewSection2 = [[NSMutableArray alloc] initWithObjects:@"位置信息",nil];
        NSLog(@"%@",mTableviewSection1);
    }
    else if (currentViewType == addTypeDeviceForPerson)
    {
        mTableviewSection1 = [[NSMutableArray alloc] initWithObjects:@"手机号",@"昵称",@"验证码",nil];
        mTableviewSection2 = [[NSMutableArray alloc] initWithObjects:@"年龄",@"健康状况",@"常用药品",nil];
    }
    
}


-(void)drawMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, mTableView.frame.origin.y+mTableView.frame.size.height+15, self.view.frame.size.width, self.view.frame.size.height-(mTableView.frame.origin.y+mTableView.frame.size.height-15))];
    _mapView.delegate = self;
    [_mapView setZoomEnabled:YES];      // 是否允许用户自己放大缩小
    [_mapView setScrollEnabled:YES];    // 是否 scroll
    
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
    
    
    if([[locationInfo shareInstance].longtitude length] && [[locationInfo shareInstance].laitude length])
    {
        
        
        CLLocationCoordinate2D theCoordinate;
        CLLocationCoordinate2D theCenter;
        
        theCoordinate.latitude = [[locationInfo shareInstance].laitude doubleValue];
        theCoordinate.longitude= [[locationInfo shareInstance].longtitude doubleValue];
        
        
        MKCoordinateRegion theRegin;
        theCenter.latitude =[[locationInfo shareInstance].laitude doubleValue];
        theCenter.longitude = [[locationInfo shareInstance].longtitude doubleValue];
        theRegin.center=theCenter;
        
        MKCoordinateSpan theSpan;
        theSpan.latitudeDelta = 0.01;
        theSpan.longitudeDelta = 0.01;
        theRegin.span = theSpan;
        
        
        [self.mapView setRegion:theRegin animated:YES];
        [self.mapView regionThatFits:theRegin];
    }
    
    
    
//    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress1:)];
//    longTap.minimumPressDuration = 1.5;
    
//    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress1:)];
    [self.mapView addGestureRecognizer:mTap];
    
}


#pragma mark -
#pragma mark - mapView Delegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D theCoordinate;
    CLLocationCoordinate2D theCenter;
    
    [locationInfo shareInstance].longtitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    [locationInfo shareInstance].laitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    
    theCoordinate.latitude = userLocation.location.coordinate.latitude;
    theCoordinate.longitude= userLocation.location.coordinate.longitude;
    
    
    MKCoordinateRegion theRegin;
    theCenter.latitude =userLocation.location.coordinate.latitude;
    theCenter.longitude = userLocation.location.coordinate.longitude;
    theRegin.center=theCenter;
    
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.01;
    theSpan.longitudeDelta = 0.01;
    theRegin.span = theSpan;
    
    
    [self.mapView setRegion:theRegin animated:YES];
    [self.mapView regionThatFits:theRegin];
}

#pragma mark- 根据经纬度得到地址
-(void)getMyDevicesList
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getMyDevice];
}


#pragma mark - tap选地点
- (void)tapPress1:(UIGestureRecognizer*)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    _touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %.10f,%.10f", _touchMapCoordinate.latitude, _touchMapCoordinate.longitude);
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_touchMapCoordinate.latitude, _touchMapCoordinate.longitude);//原始坐标
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
    //转换GPS坐标至百度坐标(加密后的坐标)
    testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    //解密加密后的坐标字典
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
    
    
    NSLog(@"转换百度后经纬度 %f,%f", baiduCoor.latitude, baiduCoor.longitude);
    
    
    self.deviceObjet.strLat = [NSString stringWithFormat:@"%f",baiduCoor.latitude];
    
    self.deviceObjet.strLon = [NSString stringWithFormat:@"%f",baiduCoor.longitude];
//    /***********/
//    self.deviceObjet.strLat = [NSString stringWithFormat:@"%f",coor.latitude];
//
//    self.deviceObjet.strLon = [NSString stringWithFormat:@"%f",coor.longitude];
    
    [mTableView reloadData];
    
    if (call) {
        [self.mapView removeAnnotation:call];
    }
 
    call = [[BasicMapAnnotation alloc]initWithLatitude:_touchMapCoordinate.latitude andLongitude:_touchMapCoordinate.longitude];
    
    //BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
    
    self.mapView.showsUserLocation = NO;
    
    [self.mapView addAnnotation:call];

    [self getDetailAddress];
    
}


-(void)getDetailAddress
{
    isNeedShow = NO;
    
    NSString *strlocation = [NSString stringWithFormat:@"%@,%@",self.deviceObjet.strLat,self.deviceObjet.strLon];
    NSLog(@"%@",strlocation);
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getAddressFromCoordinate:strlocation];
}

#pragma mark - drawTableView
-(void)drawTableView
{
    if(currentViewType == addTypeElectronic)
    {
        if(mTableView == nil)
        {
            mTableView = [[UITableView alloc]  initWithFrame:CGRectMake(0,0, self.view.frame.size.width ,235) style: UITableViewStylePlain];
            [mTableView setDelegate:self];
            [mTableView setDataSource:self];
            mTableView.scrollEnabled =NO;
            mTableView.backgroundColor = [UIColor clearColor];
            mTableView.backgroundView = nil;
            
            [self.view addSubview:mTableView];
            
        }
        else
        {
            [mTableView reloadData];
        }
    }
    else
    {
        if(mTableView == nil)
        {
            mTableView = [[UITableView alloc]  initWithFrame:CGRectMake(0,0, self.view.frame.size.width ,self.view.frame.size.height) style: UITableViewStyleGrouped];
            [mTableView setDelegate:self];
            [mTableView setDataSource:self];
            
            mTableView.backgroundColor = [UIColor clearColor];
            mTableView.backgroundView = nil;
            
            [self.view addSubview:mTableView];
            
        }
        else
        {
            [mTableView reloadData];
        }
    }
    
    
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [mTableView addGestureRecognizer:gestureRecognizer];
    
    if(currentViewType == addTypePeson)
    {
        [self setTableFooterViewWithTitle:@"添  加"];
    }
    if(currentViewType == addTypeElectronic)
    {
        [self setTableFooterViewWithTitle:@"保  存"];
	
        
        [self drawMapView];
    }

    else
    {
        [self setTableFooterViewWithTitle:@"保  存"];
    }
    

    
}




#pragma mark -
#pragma mark - Draw TableView
-(void)setTableFooterViewWithTitle:(NSString *)strTitle
{
 
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0.0, mTableView.frame.origin.y+mTableView.frame.size.height, self.view.frame.size.width, 64.0)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled =YES ;
    
    mTableView.tableFooterView = footView;
    
    UIButton *bookBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 20.0,mTableView.frame.size.width-20 ,40.0)];
    [bookBut addTarget:self  action:@selector(btnKeep) forControlEvents:UIControlEventTouchUpInside];
    [bookBut setTitle:strTitle forState:UIControlStateNormal];
    [bookBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBut.layer.cornerRadius = 3.0;
    bookBut.titleLabel.font = [UIFont systemFontOfSize:20.0];
    bookBut.showsTouchWhenHighlighted = YES;
    [bookBut setBackgroundColor:[UIColor colorWithRed:158.0/255.0 green:205.0/255.0 blue:85.0/255.0 alpha:1.0]];
    [footView addSubview:bookBut];
    
    
}


#pragma mark - 保存  添加
-(void)btnKeep
{
    NSLog(@"test");
    if(mTextField)[mTextField resignFirstResponder];
    
    isNeedShow = YES;
    
    if(currentViewType == addTypePeson) //添加监护人
    {
        if(![self.deviceObjet.strDeviceId length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请选择设备！" withType:2];
            return;
        }
        
        if(![self.deviceObjet.strGuardianManMobile length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请填写亲友号码！" withType:2];
            return;
        }
        
        if(![self.deviceObjet.strNickName length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请填写亲友昵称！" withType:2];
            return;
        }
        
        JsonService *jsonService = [JsonService sharedManager];
        
        [jsonService setWebserviceDelegate:self];
        
        [jsonService addGuardiianPersonWithObj:self.deviceObjet];
        
        
    }
    else if (currentViewType == addTypeTakeMedicineRemind)//添加吃药提醒
    {
        if(![self.medicineRmindObject.strDeviceID length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请选择提醒设备！" withType:2];
            return;
        }
        
        if(![self.medicineRmindObject.strRemindTime length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请选择提醒时间！" withType:2];
            return;
        }
        
        if(![self.medicineRmindObject.strRemindContent length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请填写提醒内容!" withType:2];
            return;
        }
        
        
        
        NSString *strFormat = [NSString stringWithFormat:@"%@@^_^@%@",self.medicineRmindObject.strRemindContent,self.medicineRmindObject.strRemindTime];
        
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
        [mdict setObject:strSendTxt forKey:@"TaskType"];
        [mdict setObject:strFormat forKey:@"Content"];
        [mdict setObject:self.medicineRmindObject.strDeviceID forKey:@"SendTo"];
        [mdict setObject:@"APP" forKey:@"ClientType"];
        
        NSString *strJason = [mdict JSONRepresentation];
        
        DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
        
        [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        
        [socket readDataWithTimeout:-1 tag:0];

        /** 
         
         之前的webservice请求不再使用
         
        JsonService *jsonService = [JsonService sharedManager];
        
        [jsonService setWebserviceDelegate:self];
        
        [jsonService takeMedicineRemindWithObj:self.medicineRmindObject];
         */
        
    }
    else if (currentViewType == addTypeElectronic)//添加bee围栏
    {
        NSLog(@"JCKdeviceObjet:%lu",(unsigned long)[self.deviceObjet.strLon length]);
        NSLog(@"%@", self.deviceObjet.strRadius);
        if(![self.deviceObjet.strLon length])
        {
            // JCK围栏（不走）
            [Util showAlertWithTitle:@"提示" withMessage:@"请选择位置！" withType:2];
            return;
        }
        
        if(![self.deviceObjet.strRadius length])
        {
            // JCK围栏（不走）
            [Util showAlertWithTitle:@"提示" withMessage:@"请选择半径！" withType:2];
            return;
        }
        
        // 围栏网络请求
        JsonService *jsonService = [JsonService sharedManager];
        
        [jsonService setWebserviceDelegate:self];
        
        [jsonService addElectronicFenceWithObj:self.deviceObjet];
        
        
    }
    else if (currentViewType == addTypeDeviceForPerson) // 添加设备
    {
//        if(![self.deviceObjet.strDeviceId length])
//        {
//            [Util showAlertWithTitle:@"提示" withMessage:@"请选择手表！" withType:2];
//            return;
//        }
        
        if(![self.deviceObjet.strDeviceMobile length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请添加监护人手机号！" withType:2];
            return;
        }
        
        if(![self.deviceObjet.strNickName length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请添加监护人昵称！" withType:2];
            return;
        }
        
        if(![self.deviceObjet.strCheckCode length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请输入验证码！" withType:2];
            return;
        }
        
    
        if(self.deviceObjet.strCheckCode  != nil)
        {
            JsonService *jsonService = [JsonService sharedManager];
            
            [jsonService setWebserviceDelegate:self];
            
            [jsonService getAddMyDeviceWithDeviceObj:self.deviceObjet];
        }
        else
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请输入正确的验证码！" withType:2];
            return;
        }
        
        
    }
}



-(void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:0.35];
    
    [UIView setAnimationDelegate:self];
    
    mTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


-(void)adressBookButClick
{
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
#ifdef __IPHONE_6_0
    [self presentViewController:picker animated:YES completion:nil];
#else
    [self presentModalViewController:picker animated:YES];
#endif
    
    
    picker.topViewController.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    //picker.topViewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:241.0/255.0 green:144.0/255.0 blue:58.0/255.0 alpha:1.0];
    picker.searchDisplayController.searchBar.tintColor = [UIColor orangeColor];
    
}



#pragma mark -
#pragma mark checkInputFormat
-(BOOL)checkInputFormat
{
    if(mUserName != nil && [mUserName length] >0 && mUserPhone !=nil && [mUserPhone length]>0)
    {
        return YES;
        
        
    }
    else
    {
        [Util showAlertWithTitle:@"温馨提示" withMessage:@"手机号码或昵称不能为空！" withType:2 withDelay:2.0];
        return NO;
    }
    
}



#pragma mark- 获取验证码
-(void)btnGetCode
{
//    [self openSocketConnect];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    
    if(self.mTextFieldBeingEdited)
    {
        //
        NSLog(@"mTextField:%@",self.mTextFieldBeingEdited.text);
        [self.mTextFieldBeingEdited resignFirstResponder];
        

    }
    
    if(self.deviceObjet.strDeviceMobile!=nil && [self.deviceObjet.strDeviceMobile length])
    {
//        JsonService *jsonService = [JsonService sharedManager];
//        [jsonService setWebserviceDelegate:self];
//        [jsonService getCodeWithPhoneNumber:self.deviceObjet.strDeviceMobile];
        //        [self openSocketConnect];

        [SVProgressHUD showWithStatus:@"正在发生验证码.."];
        isNeedShow = NO;
        //用于验证用户
        
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
        /***未知参数***/
        [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
        [mdict setObject:@"10" forKey:@"TaskType"]; // 第一次传0
        [mdict setObject:@"" forKey:@"Content"];
        // 电话号

        NSLog(@"JCKphoneNum%@",phoneNum);
        if (phoneNum.length < 1) {
            phoneNum = @"手机号码错误";
        }
        id pNum = phoneNum;
        // nil奔溃
        NSLog(@"%@",pNum);
        [mdict setObject:pNum forKey:@"SendTo"];
        [mdict setObject:@"APP" forKey:@"ClientType"];
        
        NSString *strJason = [mdict JSONRepresentation];
        
        DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
        
        if([socket isDisconnected]) return;
        
        [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        
        [socket readDataWithTimeout:-1 tag:0];
        
        
    }
    else
    {
        [Util showMsgAlert:@"输入手机号"];
    }
    
}
- (BOOL)checkTel:(NSString *)str

{
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
//        [alert show];
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,1-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
//        [alert show];
        
        
        return NO;
        
    }
    
    
    
    return YES;
    
}


#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    DEBUG_NSLOG(@"select date: %@",[NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute]);
    
    self.strSelectDate = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    
    
}

#pragma mark- 显示日期控件
-(void)showDatePickerView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    if(dateSelectView == nil)
    {
        dateSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 245)];
        dateSelectView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:dateSelectView];
        
        UIToolbar* tempToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, dateSelectView.frame.size.width, 44)];
        [dateSelectView addSubview:tempToolBar];
        
        UILabel* tempHintsLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 220, 34)];
        [tempHintsLabel setBackgroundColor:[UIColor clearColor]];
        [dateSelectView addSubview:tempHintsLabel];
        tempHintsLabel.textAlignment = kUITextAlignmentCenter;
        [tempHintsLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [tempHintsLabel setTextColor:[UIColor blackColor]];
        
        UIButton* tempBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempBtn1 setBackgroundImage:[UIImage imageNamed:@"Resourse.bundle/btnNormal.png"] forState:UIControlStateNormal];
        [tempBtn1 setBackgroundImage:[UIImage imageNamed:@"Resourse.bundle/btnPressed.png"] forState:UIControlStateNormal];
        [tempBtn1 setTitle:@"取消" forState:UIControlStateNormal];
        [tempBtn1 sizeToFit];
        [tempBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dateSelectView addSubview:tempBtn1];
        [tempBtn1 setCenter:CGPointMake(30, 22)];
        [tempBtn1 addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton* tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"Resourse.bundle/btnNormal.png"] forState:UIControlStateNormal];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"Resourse.bundle/btnPressed.png"] forState:UIControlStateNormal];
        [tempBtn setTitle:@"确定" forState:UIControlStateNormal];
        [tempBtn sizeToFit];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dateSelectView addSubview:tempBtn];
        [tempBtn setCenter:CGPointMake(dateSelectView.frame.size.width-15-tempBtn.frame.size.width*.5, 22)];
        [tempBtn addTarget:self action:@selector(actionEnter) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    dateSelectView.hidden =NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    
    NSDate *destDate = [NSDate date];
    
    
    if([self.strSelectDate length])
    {
        
        destDate= [dateFormatter dateFromString:self.strSelectDate];
    }
    else
    {
        destDate= [dateFormatter dateFromString:[destDate stringWithFormat:@"yyyy-MM-dd HH:mm"]];
        
        self.strSelectDate = [destDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    
    UUDatePicker *datePicker= [[UUDatePicker alloc]initWithframe:CGRectMake(0, 45, self.view.frame.size.width, 200)
                                                        Delegate:self
                                                     PickerStyle:UUDateStyle_YearMonthDayHourMinute];
    datePicker.ScrollToDate = destDate;
    //datePicker.maxLimitDate = now;
    //datePicker.minLimitDate = [now dateByAddingTimeInterval:-111111111];
    
    datePicker.minLimitDate = [[NSDate date]dateByAddingTimeInterval:-2222];
    
    [dateSelectView addSubview:datePicker];
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.25];
    
    [dateSelectView setFrame:CGRectMake(0.0, self.view.frame.size.height-245, self.view.frame.size.width, 245)];
    [UIView commitAnimations];
    
    
    
}


-(void)hideDatePickerView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.55];
    
    dateSelectView.frame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 245);
    [dateSelectView setHidden:YES];
    [UIView commitAnimations];
}

#pragma mark - 取消时间
-(void)actionCancel
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.55];
    
    dateSelectView.frame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 245);
    [dateSelectView setHidden:YES];
    [UIView commitAnimations];
}

#pragma mark - 确定 选择时间
-(void)actionEnter
{
    self.medicineRmindObject.strRemindTime = self.strSelectDate;
    
    [mTableView reloadData];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.55];
    
    dateSelectView.frame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 245);
    [dateSelectView setHidden:YES];
    [UIView commitAnimations];
    
}



-(void)showSelectRadiusView
{
    self.actionSheet = [[LXActionSheet alloc]initWithTitle:@"设置经纬度半径范围" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"500米",@"800米",@"1000米",@"2000米"]];
    self.actionSheet.tag = 2;
    [self.actionSheet showInView:self.view];
}


#pragma mark -
#pragma mark - mapView Delegate
- (void)didUpdateBMKUserLocation:(MKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    if(_mapView.isUserLocationVisible == YES)
    {
        return;
    }
    
    
    CLLocationCoordinate2D theCoordinate;
    CLLocationCoordinate2D theCenter;
    
    theCoordinate.latitude = userLocation.location.coordinate.latitude;
    theCoordinate.longitude= userLocation.location.coordinate.longitude;
    
    
    MKCoordinateRegion theRegin;
    theCenter.latitude =userLocation.location.coordinate.latitude;
    theCenter.longitude = userLocation.location.coordinate.longitude;
    theRegin.center=theCenter;
    
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.02;
    theSpan.longitudeDelta = 0.02;
    theRegin.span = theSpan;
    
    
    [self.mapView setRegion:theRegin animated:YES];
    [self.mapView regionThatFits:theRegin];
    
    [_locService stopUserLocationService];
    
    
}
// ios 7 之前
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview = [[MKPolylineView alloc] initWithOverlay:overlay];
        UIColor *color = [UIColor colorWithRed:70.0/255.0f green:178.0/255.0f blue:255.0/255.0f alpha:1.0];
        lineview.strokeColor = [color colorWithAlphaComponent:1.0];
        lineview.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        lineview.lineWidth = 2.5;
        return lineview;
    }
    else if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
        
        UIColor *color = [UIColor colorWithRed:70.0/255.0f green:178.0/255.0f blue:255.0/255.0f alpha:1.0];
        circleView.strokeColor = [color colorWithAlphaComponent:1.0];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
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
    else if([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        return pinView;

    }
    else
    {
        
    }
    
    return pinView;
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@" didSelectview.annotation == %@",view.annotation);

    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        if(call != nil)
        {
            if (call.coordinate.latitude == view.annotation.coordinate.latitude && call.coordinate.longitude == view.annotation.coordinate.longitude)
            {
                // return;
            }
        }
        
        if (call)
        {
            [mapView removeAnnotation:call];
            call = nil;
        }
        
        BasicMapAnnotation *Mapannotation = view.annotation;
        call = [[BasicMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude] ;
        call.title = Mapannotation.title;
        call.imageUrl = Mapannotation.imageUrl;
        call.typeNum = Mapannotation.typeNum;
        call.step = Mapannotation.step;
        call.arraySortNum = Mapannotation.arraySortNum;
        [mapView addAnnotation:call];
        [mapView setCenterCoordinate:call.coordinate animated:YES];
    }


}




#pragma mark- ABPeoplePickerNavigationControllerDelegate

-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    // This code will only compile on versions >= iOS 5.0
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
#else
    [peoplePicker dismissViewControllerAnimated:YES];
    
#endif
    
    
    
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    //获取联系人电话
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        
        //        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        
        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);

        NSString *aLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
        
        if([aLabel isEqualToString:@"_$!<Mobile>!$_"])
        {
            [phones addObject:aPhone];
        }
    }
    
    mTextField.text=@"";
    if([phones count]>0)
    {
        NSString *mobileNo = [NSString stringWithString:[phones objectAtIndex:0]];
        
        NSLog(@"mobileNo == %@",mobileNo);
        
        NSRange range = [mobileNo rangeOfString:@" "];
        if (range.length>0)
        {
            NSRange range2;
            range2.location = range.location + 1;
            range2.length = mobileNo.length - range.location - 1;
            mobileNo = [mobileNo substringWithRange: range2];
            
        }
        
        
        mobileNo = [mobileNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
        mobileNo = [mobileNo stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        
        [mUserPhone setString:mobileNo];
        
        [mTextField setText:mobileNo];
        
        self.deviceObjet.strGuardianManMobile = mobileNo;
        
        [mTableView reloadData];
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    // This code will only compile on versions >= iOS 5.0
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
#else
    [peoplePicker dismissViewControllerAnimated:YES];
    
#endif
    
    return NO;
    
}

-(BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
     shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark -
#pragma mark - TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(currentViewType == addTypeElectronic)
    {
        switch (section) {
            case 0:
                return 15;
                break;
            default: {
                return 4;
                break;
            }
        }
    }
    else
    {
        switch (section) {
            case 0:
                return 18;
                break;
            default: {
                return 4;
                break;
            }
        }
    }
    
    return 0.0;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(currentViewType == addTypeElectronic)
    {
        return 1;
    }
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [mTableviewSection1 count];
    }
    else
    {
        if(currentViewType == addTypeDeviceForPerson)
        {
            return [mTableviewSection2 count];
        }
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"myTableView";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    for (id v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
        //v = nil;
    }
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *tmpAy = nil;
    
    if(indexPath.section == 0)
    {
        tmpAy = [NSArray arrayWithArray:mTableviewSection1];
        
    }
    else if(indexPath.section == 1)
    {
        tmpAy = [NSArray arrayWithArray:mTableviewSection2];
    }
    
    UILabel *titleLab = nil;
    UILabel *theTitleLab = nil;
    
    titleLab = [[UILabel alloc ]initWithFrame:CGRectMake(15, 10, 90, 20)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont systemFontOfSize:15.0];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.text = [tmpAy objectAtIndex:indexPath.row];
    titleLab.textAlignment = kUITextAlignmentLeft;
    [cell.contentView addSubview:titleLab];
    
    theTitleLab = [[UILabel alloc ]initWithFrame:CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 10, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+20), 20)];
    theTitleLab.backgroundColor = [UIColor clearColor];
    theTitleLab.font = [UIFont systemFontOfSize:15.0];
    theTitleLab.textColor = [UIColor blackColor];
    theTitleLab.text = @"";
    theTitleLab.textAlignment = kUITextAlignmentLeft;
    theTitleLab.numberOfLines = 0;
    theTitleLab.lineBreakMode = kUILineBreakModeWordWrap;
    [cell.contentView addSubview:theTitleLab];
    
    if(currentViewType == addTypePeson)
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 1)
            {
                [theTitleLab removeFromSuperview];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                mTextField = [[UITextField alloc] initWithFrame:
                              CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 5, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+35), 30)];
                mTextField.clearsOnBeginEditing = NO;
                mTextField.returnKeyType = UIReturnKeyDone;
                mTextField.delegate = self;
                mTextField.font = [UIFont systemFontOfSize:15.0];
                mTextField.textColor = [UIColor lightGrayColor];
                mTextField.textAlignment = kUITextAlignmentLeft;
                mTextField.tag = indexPath.row;
                
                mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                
                [cell.contentView addSubview:mTextField];
                
                if(self.deviceObjet.strGuardianManMobile!=nil && [self.deviceObjet.strGuardianManMobile length])
                {
                    
                    mTextField.textColor = [UIColor blackColor];

                    mTextField.text  = self.deviceObjet.strGuardianManMobile;
                }
                else
                {
                    mTextField.placeholder  =@"添加监护人电话";
                }
                
                UIImage *img = [UIImage imageNamed:@"imageBtnAdd"];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, 25, 25);
                [btn setBackgroundImage:img forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(adressBookButClick) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = btn;
                
            }
            else if (indexPath.row == 0)
            {
                theTitleLab.textAlignment = kUITextAlignmentLeft;
                
                NSString *str = [Util returnValuableString:self.deviceObjet.strDeviceOwnerName];
                
                if([str length])
                {
                    theTitleLab.text = self.deviceObjet.strDeviceOwnerName;
                }
                else
                {
                    if([self.deviceObjet.strDeviceId length])
                    {
                        theTitleLab.text = @"暂无";
                    }
                    else
                    {
                        theTitleLab.textColor = [UIColor lightGrayColor];

                        theTitleLab.text = @"选择设备";
                    }

                    
                }
            
                    
            }
        }
        else
        {
            [theTitleLab removeFromSuperview];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            mTextField = [[UITextField alloc] initWithFrame:
                          CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 5, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+25), 35)];
            mTextField.clearsOnBeginEditing = NO;
            mTextField.returnKeyType = UIReturnKeyDone;
            mTextField.delegate = self;
            mTextField.font = [UIFont systemFontOfSize:15.0];
            mTextField.textColor = [UIColor lightGrayColor];
            mTextField.textAlignment = kUITextAlignmentLeft;
            
            mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            
            [cell.contentView addSubview:mTextField];
            
            if(self.deviceObjet.strNickName!=nil && [self.deviceObjet.strNickName length])
            {
                mTextField.textColor = [UIColor blackColor];

                mTextField.text  = self.deviceObjet.strNickName;
            }
            else
            {
                mTextField.placeholder  =@"添加亲友昵称";
            }

        }
    }
    else if (currentViewType == addTypeTakeMedicineRemind)
    {
        if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                [theTitleLab removeFromSuperview];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                _textView = [[SZTextView alloc] initWithFrame:
                             CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 0, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+20), 64)];
                _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                _textView.returnKeyType = UIReturnKeyDone;
                _textView.delegate = self;
                _textView.backgroundColor = [UIColor clearColor];
                _textView.font = [UIFont systemFontOfSize:15];
                _textView.textColor = [UIColor darkGrayColor];
                _textView.textAlignment = kUITextAlignmentLeft;
                
                _textView.placeholderTextColor = [UIColor lightGrayColor];
                _textView.tag = indexPath.row;
                
                [cell.contentView addSubview:_textView];
                
                if(self.medicineRmindObject.strRemindContent!=nil && [self.medicineRmindObject.strRemindContent length])
                {
                    _textView.textColor = [UIColor blackColor];

                    _textView.text  = self.medicineRmindObject.strRemindContent;
                }
                else
                {
                    _textView.placeholder  =@"填写提醒内容";
                }
                
                cell.frame = CGRectMake(0, 0, cell.frame.size.width, _textView.frame.origin.y+_textView.frame.size.height+5);
                
            }
        }
        else
        {
            if(indexPath.row == 1)
            {
                if(self.medicineRmindObject.strRemindTime!=nil && [self.medicineRmindObject.strRemindTime length])
                {
                    theTitleLab.text  = self.medicineRmindObject.strRemindTime;
                }
                else
                {
                    theTitleLab.textColor = [UIColor lightGrayColor];
                    
                    theTitleLab.text  =@"设置提醒时间";
                }
                
            }
            else if (indexPath.row == 0)
            {
                
                if(self.medicineRmindObject.strRelationPersonName!=nil && [self.medicineRmindObject.strRelationPersonName length])
                {
                    NSString *str = [Util returnValuableString:self.medicineRmindObject.strRelationPersonName];
                    
                    if([str length])
                    {
                        theTitleLab.text = self.medicineRmindObject.strRelationPersonName;
                    }
                    else
                    {
                        if([self.medicineRmindObject.strDeviceID length])
                        {
                            theTitleLab.text = @"暂无";
                        }
                        else
                        {
                            theTitleLab.textColor = [UIColor lightGrayColor];

                            theTitleLab.text = @"选择提醒手表";
                        }
                        
                        
                    }
                    
                    
                }
                else
                {
                    
                    
                    theTitleLab.text = @"选择提醒手表";
                }
                
            }
        }
    }
    else if (currentViewType == addTypeElectronic)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        titleLab.frame = CGRectMake(15, 10, 70, 20);
        
        theTitleLab.frame = CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 10, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+50), 20);
        
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                if(self.deviceObjet.strLon!=nil && [self.deviceObjet.strLon length])
                {
                    theTitleLab.text = [NSString stringWithFormat:@"%f,%f",[self.deviceObjet.strLat doubleValue]- 0.00328,[self.deviceObjet.strLon doubleValue]- 0.01185];
                }
                else
                {
                    theTitleLab.textColor = [UIColor lightGrayColor];

                    theTitleLab.text = @"选择位置";
                }
            }
            else if (indexPath.row == 1)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                if(self.deviceObjet.strRadius!=nil && [self.deviceObjet.strRadius length])
                {
//                    NSLog(@"%@",theTitleLab.text);
//                    if ([theTitleLab.text isEqualToString:@"2000"] != 0 ) {
//                        NSLog(@"test");
//                        theTitleLab.text = [NSString stringWithFormat:@"%@米",self.deviceObjet.strRadius];
//                    }
//                    else
//                    {
//                        theTitleLab.text = @"已经关闭了电子围栏";
//                    }
                    theTitleLab.text = [NSString stringWithFormat:@"%@米",self.deviceObjet.strRadius];
                    
                }
                else
                {
                    theTitleLab.textColor = [UIColor lightGrayColor];

                    theTitleLab.text = @"设置半径范围";
                }
            }
            else if(indexPath.row == 2)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                theTitleLab.frame = CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 10, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+20), 20);
                
                if([locationInfo shareInstance].detailAddress!=nil && [[locationInfo shareInstance].detailAddress length])
                {
                    NSLog(@"JCKText%@",theTitleLab.text);
                    theTitleLab.text  = [locationInfo shareInstance].detailAddress;
                    
                    CGSize size = [theTitleLab.text boundingRectWithSize:CGSizeMake(theTitleLab.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:theTitleLab.font,NSFontAttributeName, nil] context:nil].size;
                    
                    theTitleLab.frame = CGRectMake(theTitleLab.frame.origin.x, theTitleLab.frame.origin.y, size.width, size.height);
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, theTitleLab.frame.origin.y+theTitleLab.frame.size.height+5);
                    
                }
                else
                {
                    theTitleLab.textColor = [UIColor lightGrayColor];

                    theTitleLab.text  =@"在地图上点选即可得到位置信息";
                }
                
                
                
            }
        }
        
//        cell.frame = CGRectMake(0, 0, cell.frame.size.width, 40);
    }
    else if(currentViewType == addTypeDeviceForPerson)
    {
        if(indexPath.section == 0)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            if(indexPath.row == 1)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                //titleLab.frame = CGRectMake(15, 10, 110, 20);
                
                theTitleLab.frame = CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+20, 10, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+50), 20);
                
               
                [theTitleLab removeFromSuperview];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                mTextField = [[UITextField alloc] initWithFrame:
                              CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 5, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+20), 30)];
                mTextField.clearsOnBeginEditing = NO;
                mTextField.returnKeyType = UIReturnKeyDone;
                mTextField.delegate = self;
                mTextField.font = [UIFont systemFontOfSize:15.0];
                mTextField.textColor = [UIColor lightGrayColor];
                mTextField.textAlignment = kUITextAlignmentLeft;
                mTextField.tag = indexPath.row;
                
                mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                
                [cell.contentView addSubview:mTextField];
                
                if(self.deviceObjet.strNickName!=nil && [self.deviceObjet.strNickName length])
                {
                    mTextField.textColor = [UIColor blackColor];

                    mTextField.text  = self.deviceObjet.strNickName;
                }
                else
                {
                    mTextField.placeholder  =@"亲友昵称";
                }
                
                /*
                UIImage *img = [UIImage imageNamed:@"imageBtnAdd"];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, 25, 25);
                [btn setBackgroundImage:img forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(adressBookButClick) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = btn;
                */
            }
            else if (indexPath.row == 0)
            {
                [theTitleLab removeFromSuperview];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                mTextField = [[UITextField alloc] initWithFrame:
                              CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 5, cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+20), 30)];
                mTextField.clearsOnBeginEditing = NO;
                mTextField.returnKeyType = UIReturnKeyDone;
                mTextField.delegate = self;
                mTextField.font = [UIFont systemFontOfSize:15.0];
                mTextField.textColor = [UIColor lightGrayColor];
                mTextField.textAlignment = kUITextAlignmentLeft;
                mTextField.tag = indexPath.row;
                
                mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                
                [cell.contentView addSubview:mTextField];
                
                if(self.deviceObjet.strDeviceMobile!=nil && [self.deviceObjet.strDeviceMobile length])
                {
                    mTextField.textColor = [UIColor blackColor];
                    mTextField.text = self.deviceObjet.strDeviceMobile;
                }
                else
                {
                    mTextField.placeholder = @"输入手机号";
                }
                
            }
            else if (indexPath.row == 2)
            {
                [theTitleLab removeFromSuperview];
                
                mTextField = [[UITextField alloc] initWithFrame:
                              CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 5, tableView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+115), 35)];
                mTextField.clearsOnBeginEditing = NO;
                mTextField.returnKeyType = UIReturnKeyDone;
                mTextField.keyboardType = UIKeyboardTypeDecimalPad;
                mTextField.enabled = NO;
                mTextField.delegate = self;
                mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                mTextField.textAlignment = kUITextAlignmentLeft;
                
                mTextField.enabled = YES;
                
                mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
                mTextField.tag = indexPath.row;
                
                [cell.contentView addSubview:mTextField];
                
                if([mCheckCode length])
                {
                    mTextField.text = mCheckCode;
                }
                else
                {
                    mTextField.placeholder = @"输入验证码";
                }
                
                
                codeButton = [[UIButton alloc] initWithFrame:CGRectMake(mTextField.frame.origin.x + mTextField.frame.size.width + 10.0, 5, 84, 34)];
                codeButton.layer.borderColor = [UIColor colorWithRed:24.0/255.0 green:165.0/255.0 blue:227.0/255.0 alpha:1.0].CGColor;
                codeButton.layer.borderWidth = 1;
                codeButton.layer.cornerRadius = 2;
                [codeButton setTitle: [NSString stringWithFormat:@"%@",@"获取验证码"] forState:UIControlStateNormal];
                codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
                codeButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
                codeButton.showsTouchWhenHighlighted =YES;
                [codeButton addTarget:self action:@selector(btnGetCode) forControlEvents:UIControlEventTouchUpInside];
                
                [codeButton setTitleColor:[UIColor colorWithRed:24.0/255.0 green:165.0/255.0 blue:227.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [cell.contentView addSubview:codeButton];
                
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                
//                [theTitleLab removeFromSuperview];
//                
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                
//                mTextField = [[UITextField alloc] initWithFrame:
//                              CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 5, tableView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+25), 35)];
//                mTextField.clearsOnBeginEditing = NO;
//                mTextField.returnKeyType = UIReturnKeyDone;
//                mTextField.delegate = self;
//                mTextField.font = [UIFont systemFontOfSize:15.0];
//                mTextField.textColor = [UIColor lightGrayColor];
//                mTextField.textAlignment = kUITextAlignmentCenter;
//                mTextField.tag = indexPath.row;
//                
//                [cell.contentView addSubview:mTextField];
//                
//                if(self.deviceObjet.strNickName!=nil && [self.deviceObjet.strNickName length])
//                {
//                    mTextField.text  = self.deviceObjet.strNickName;
//                }
//                else
//                {
//                    mTextField.placeholder  =@"添加亲友昵称";
//                }

            }
        }
        else
        {
            if(indexPath.row == 0)
            {
                [theTitleLab removeFromSuperview];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                
                mTextField = [[UITextField alloc] initWithFrame:
                              CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 5, tableView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+25), 35)];
                mTextField.clearsOnBeginEditing = NO;
                mTextField.returnKeyType = UIReturnKeyDone;
                mTextField.delegate = self;
                mTextField.font = [UIFont systemFontOfSize:15.0];
                mTextField.textColor = [UIColor lightGrayColor];
                mTextField.textAlignment = kUITextAlignmentLeft;
                mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                mTextField.tag = 3;
                [cell.contentView addSubview:mTextField];
                
                mTextField.clearButtonMode = UITextFieldViewModeNever;
                
                if(self.deviceObjet.strAge!=nil && [self.deviceObjet.strAge length])
                {
                    mTextField.textColor = [UIColor blackColor];

                    mTextField.text  = self.deviceObjet.strAge;
                }
                else
                {
                    mTextField.placeholder  =@"输入被监护人年龄";
                }
            }
            else if (indexPath.row == 1)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                if(self.deviceObjet.strHealthInfo!=nil && [self.deviceObjet.strHealthInfo length])
                {
                    theTitleLab.text  = self.deviceObjet.strHealthInfo;
                    
                    CGSize size = [theTitleLab.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+20), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:theTitleLab.font,NSFontAttributeName, nil] context:nil].size;
                    
                    theTitleLab.frame = CGRectMake(theTitleLab.frame.origin.x, theTitleLab.frame.origin.y, size.width, size.height);
                    
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, theTitleLab.frame.origin.y+theTitleLab.frame.size.height+10);
                    
                }
                else
                {
                    theTitleLab.textColor = [UIColor lightGrayColor];
                    theTitleLab.text  =@"输入健康状况";
                }
            }
            else if (indexPath.row == 2)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                if(self.deviceObjet.strCommonlyUseDrugs!=nil && [self.deviceObjet.strCommonlyUseDrugs length])
                {
                    theTitleLab.text  = self.deviceObjet.strCommonlyUseDrugs;
                    
                    CGSize size = [theTitleLab.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+20), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:theTitleLab.font,NSFontAttributeName, nil] context:nil].size;
                    
                    theTitleLab.frame = CGRectMake(theTitleLab.frame.origin.x, theTitleLab.frame.origin.y, size.width, size.height);
                    
                    cell.frame = CGRectMake(0, 0, cell.frame.size.width, theTitleLab.frame.origin.y+theTitleLab.frame.size.height+10);
                }
                else
                {
                    theTitleLab.textColor = [UIColor lightGrayColor];

                    theTitleLab.text  =@"添加常用药品";
                }
            }
            
            
        }
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectRowIndex = indexPath.row;
    selectSectionIndex = indexPath.section;
    
    NSString *strSelectValue = @"";
    
    id obj = nil;
    
    EditViewType editType = editTypeSelectDevice;
    
    if(currentViewType == addTypePeson)
    {
        obj = self.deviceObjet;
        
        editType = editTypeSelectMyDevice;
        
        if(selectSectionIndex == 0)
        {
            if(selectRowIndex == 0)
            {
                if([self.deviceObjet.strDeviceName length])
                {
                    strSelectValue = self.deviceObjet.strDeviceName;
                }
            }
            else
            {
                return;
            }
            
        }
        else
        {
            return;
        }
        
    }
    else if(currentViewType == addTypeTakeMedicineRemind)
    {
        obj = self.medicineRmindObject;
        
        editType = editTypeSelectPerson;
        
        if(selectSectionIndex == 0)
        {
            if(selectRowIndex == 0)
            {
                if([self.medicineRmindObject.strDeviceName length])
                {
                    strSelectValue = self.medicineRmindObject.strDeviceName;
                }
                
            }
            else
            {
                [self showDatePickerView];
                
                return;
            }
            
        }
        else
        {
            return;
        }

    }
    else if (currentViewType == addTypeElectronic)
    {
        obj = self.deviceObjet;
        
        if(indexPath.row == 1)
        {
            if(self.deviceObjet.strLat !=nil && [self.deviceObjet.strLat length])
            {
                [self showSelectRadiusView];
            }
            else
            {
                [Util showMsgAlert:@"请先选择位置~"];
            }
   
        }
        
        return;
    }
    else if (currentViewType == addTypeDeviceForPerson)
    {
        
        obj = self.deviceObjet;
        
        editType = editTypeWriteUserHealthInfo;
        
        if(selectSectionIndex == 1)
        {
            if(selectRowIndex == 1)
            {
                if([self.deviceObjet.strHealthInfo length])
                {
                    strSelectValue = self.deviceObjet.strHealthInfo;
                }
            }
            else if(selectRowIndex == 2)
            {
                if([self.deviceObjet.strCommonlyUseDrugs length])
                {
                    strSelectValue = self.deviceObjet.strCommonlyUseDrugs;
                }
            }
            else
            {
                return;
                
            }
            
        }
        else
        {
            return;
            
        }

        
    }
    
    
    NSArray *tmpAy = nil;
    
    if(indexPath.section == 0)
    {
        tmpAy = [NSArray arrayWithArray:mTableviewSection1];
        
    }
    else if(indexPath.section == 1)
    {
        tmpAy = [NSArray arrayWithArray:mTableviewSection2];
    }
    
    
    SubEditViewController *subEdit = [[SubEditViewController alloc]initWithEditType:editType withDelegate:self withEditValue:strSelectValue withObject:obj];
    subEdit.selectSectionIndex = indexPath.section;
    subEdit.selectRowIndex = indexPath.row;
    subEdit.title = [tmpAy objectAtIndex:indexPath.row];
    subEdit.navigationItem.title = [tmpAy objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:subEdit animated:YES];
    
    
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.mTextFieldBeingEdited)
    {
        [self.mTextFieldBeingEdited resignFirstResponder];
    }
    
    
    if(iPhone5)
    {
        
    }
    else{
        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDelay:0.35];
//        
//        [UIView setAnimationDelegate:self];
//        
//        mTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        
//        [UIView commitAnimations];
        
    }
    

}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    NSLog(@"clear text :%@",textField.text);

    
    return YES;
}


#pragma mark -
#pragma mark - textView delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    
    if(iPhone5)
    {
        
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.35];
        
        [UIView setAnimationDelegate:self];
        
        mTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    

    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing :%@",textField.text);

    
    self.mTextFieldBeingEdited = textField;
    
    
    if(mUserName == nil)
    {
        mUserName = [[NSMutableString alloc] initWithCapacity:0];
    }
    if(mUserPhone == nil)
    {
        mUserPhone = [[NSMutableString alloc] initWithCapacity:0];
    }
    
    if(currentViewType == addTypePeson)
    {
        if (textField.tag == 1)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                
                self.deviceObjet.strGuardianManMobile = textField.text;
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strGuardianManMobile  =@"";
                
                [mUserPhone setString:@""];
            }
            
        }
        else if(textField.tag == 0)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strNickName = textField.text;
                
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strNickName  =@"";
            }
            
        }
    }
    else if (currentViewType == addTypeTakeMedicineRemind)
    {
        if(textField.tag == 0)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.medicineRmindObject.strRemindContent = textField.text;
            }
            else
            {
                self.medicineRmindObject.strRemindContent = @"";
            }
            
        }
    }
    else if (currentViewType == addTypeDeviceForPerson)
    {
        if (textField.tag == 0)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                
                self.deviceObjet.strDeviceMobile = textField.text;
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strDeviceMobile  =@"";
                
            }
            
        }
        else if(textField.tag == 1)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strNickName = textField.text;
                
            }
            else
            {
                self.deviceObjet.strNickName  =@"";
            }
            
        }
        else if(textField.tag == 2)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strCheckCode = textField.text;
                
            }
            else
            {
                self.deviceObjet.strCheckCode  =@"";
            }
            
        }
        else if(textField.tag == 3)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strHealthInfo = textField.text;
                
            }
            else
            {
                self.deviceObjet.strHealthInfo  =@"";
            }
            
        }
    }
 
    if(iPhone5)
    {
        
    }
    else
    {
        if (textField.tag > 2)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelay:0.35];
            [UIView setAnimationDelegate:self];
            
            mTableView.frame = CGRectMake(0, -115, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView commitAnimations];
            
            
        }
        else
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelay:0.35];
            
            [UIView setAnimationDelegate:self];
            
            mTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView commitAnimations];
        }
    }
    
    

    
    
	return YES;
	
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    self.mTextFieldBeingEdited = textField;
	

    if(mUserName == nil)
    {
        mUserName = [[NSMutableString alloc] initWithCapacity:0];
    }
    if(mUserPhone == nil)
    {
        mUserPhone = [[NSMutableString alloc] initWithCapacity:0];
    }
    
    if(currentViewType == addTypePeson)
    {
        if (textField.tag == 1)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                
                self.deviceObjet.strGuardianManMobile = textField.text;
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strGuardianManMobile  =@"";
                
                [mUserPhone setString:@""];
            }
            
        }
        else if(textField.tag == 0)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strNickName = textField.text;
                
                [mUserPhone setString:textField.text];
            }
            else
            {
               self.deviceObjet.strNickName  =@"";
            }
            
        }
    }
    else if (currentViewType == addTypeTakeMedicineRemind)
    {
        if(textField.tag == 0)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.medicineRmindObject.strRemindContent = textField.text;
            }
            else
            {
                self.medicineRmindObject.strRemindContent = @"";
            }
            
        }
    }
    else if (currentViewType == addTypeDeviceForPerson)
    {
        if (textField.tag == 0)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                
                self.deviceObjet.strDeviceMobile = textField.text;
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strDeviceMobile  =@"";
                
            }
            
        }
        else if(textField.tag == 1)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strNickName = textField.text;
                
            }
            else
            {
                self.deviceObjet.strNickName  =@"";
            }
            
        }
        else if(textField.tag == 2)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strCheckCode = textField.text;
                
            }
            else
            {
                self.deviceObjet.strCheckCode  =@"";
            }
            
        }
        else if(textField.tag == 3)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strHealthInfo = textField.text;
                
            }
            else
            {
                self.deviceObjet.strHealthInfo  =@"";
            }
            
        }
    }
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"AJCKtext :%@",textField.text);
    // 0
    BOOL flag = [self checkTel:textField.text];
    NSLog(@"flag%d",flag);
    if ([self checkTel:textField.text] == 1) {
        phoneNum = textField.text;
    }
    
    if(mUserName == nil)
    {
        mUserName = [[NSMutableString alloc] initWithCapacity:0];
    }
    if(mUserPhone == nil)
    {
        mUserPhone = [[NSMutableString alloc] initWithCapacity:0];
    }
    
    if(currentViewType == addTypePeson)
    {
        if (textField.tag == 1)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                
                self.deviceObjet.strGuardianManMobile = textField.text;
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strGuardianManMobile  =@"";
                
                [mUserPhone setString:@""];
            }
            
        }
        else if(textField.tag == 0)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strNickName = textField.text;
                
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strNickName  =@"";
            }
            
        }
    }
    else if (currentViewType == addTypeTakeMedicineRemind)
    {
        if(textField.tag == 0)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.medicineRmindObject.strRemindContent = textField.text;
            }
            else
            {
                self.medicineRmindObject.strRemindContent = @"";
            }
            
        }
    }
    else if (currentViewType == addTypeDeviceForPerson)
    {
        if (textField.tag == 0)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                
                self.deviceObjet.strDeviceMobile = textField.text;
                [mUserPhone setString:textField.text];
            }
            else
            {
                self.deviceObjet.strDeviceMobile  =@"";
                
            }
            
        }
        else if(textField.tag == 1)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strNickName = textField.text;
                
            }
            else
            {
                self.deviceObjet.strNickName  =@"";
            }
            
        }
        else if(textField.tag == 2)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strCheckCode = textField.text;
                
            }
            else
            {
                self.deviceObjet.strCheckCode  =@"";
            }
            
        }
        else if(textField.tag == 3)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.deviceObjet.strHealthInfo = textField.text;
                
            }
            else
            {
                self.deviceObjet.strHealthInfo  =@"";
            }
            
        }
    }
}



#pragma mark - textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    _textView.text = textView.text;
    
    self.medicineRmindObject.strRemindContent = _textView.text;
    
    if (textView.text.length == 0)
    {
        SZTextView *thisTextView = (SZTextView*)textView;
        
        if(textView.tag == 0)
        {
            
            thisTextView.placeholder = @"填写健康状况";
            
        }
        else
        {
            thisTextView.placeholder = @"填写常用药品";
        }
        
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location > 30 || [textView.text length]>30)
        return NO;
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _textView.text = textView.text;
    
    self.medicineRmindObject.strRemindContent = _textView.text;
    
    
}


#pragma mark -
#pragma mark - 开始socket连接
-(void)openSocketConnect
{
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    if(![socket connectToHost:[FileOperation getServerIP] onPort:[[FileOperation getServerPort] intValue] error:&err])
    {
        
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
//        if ( flag == 0) {
//            // 手表处于离线状态
//            return;
//        }
        int success = [flag intValue];
        
        NSString *strMessage = [mdict valueForKey:@"message"];
        strMessage = [Util returnValuableString:strMessage];
        
        if(success == 0)
        {
            [SVProgressHUD showSuccessWithStatus:strMessage duration:1.0];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:strMessage duration:1.0];

        }
        
    }
    
    
}



#pragma mark -
#pragma mark - webService delegate
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request
{
    DEBUG_NSLOG(@"\n\n start request \n\n ");
    
    if(isNeedShow == YES)
    {
        [self showHUDViewWithString:@"加载中.." withHUDType:SVProgressHUDMaskTypeNone];
    }

    
}

-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    
    if(request.tag == 121 || request.tag == 104 || request.tag == 102) // 121：监护人 101：吃药提醒 102:添加设备
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeAddPerson];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功~"];

                self.deviceObjet.strDeviceName = @"";
                self.deviceObjet.strDeviceMobile = @"";
                self.deviceObjet.strNickName = @"";
                
                self.deviceObjet.strDeviceId = @"";
                self.deviceObjet.strGuardianManMobile = @"";
                self.deviceObjet.strNickName =@"";
                self.deviceObjet.strCheckCode = @"";
                self.deviceObjet.strHealthInfo = @"";
                
                self.medicineRmindObject.strRelationPersonName = @"";
                self.medicineRmindObject.strRemindTime = @"";
                self.medicineRmindObject.strRemindContent = @"";
                
                [mTableView reloadData];
            }
            else
            {
                if([tempObject.strMessage length])
                {
                    [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"添加失败，请重试！"];
                }
                
                
                
            }
        }
    }
    else if (request.tag == 109)
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeCoordinateToAddress];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                if([locationInfo shareInstance].detailAddress !=nil)
                {
                    DEBUG_NSLOG(@"地址转换成功");
                }

                
                [mTableView reloadData];
            }
            else
            {
                if([tempObject.strMessage length])
                {
                    [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"添加失败，请重试！"];
                }
                
                
                
            }
        }
        
        [SVProgressHUD dismiss];
    }
    else if (request.tag == 107)
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeAddElectronic];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功~"];
            }
            else
            {
                if([tempObject.strMessage length])
                {
                    [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"添加失败，请重试！"];
                }
                
                
                
            }
        }
        
        [SVProgressHUD dismiss];
    }
    else if (request.tag == 1212) //获取验证码
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeCheckCode];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            [self openSocketConnect];
            if (tempObject.intSuccess == 1000)
            {
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功~"];
            }
            else
            {
                if([tempObject.strMessage length])
                {
                    [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"发送失败，请重试！"];
                }
                
                
                
            }
        }
        else
        {
            [SVProgressHUD dismiss];

        }
        
    }
    
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}


#pragma mark-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
