//
//  SubWatchSettingViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15/5/19.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "JSON.h"
#import "UUDatePicker.h"
#import "SubWatchSettingViewController.h"
#import "MyTimePickerView.h"
#import "SetRemindViewController.h"
#import "model.h"
@interface SubWatchSettingViewController ()<UUDatePickerDelegate>



@end

@implementation SubWatchSettingViewController

@synthesize socket;

-(id)initWithSettingType:(WatchSettingType)type deviceID:(NSString*)deviceId
{
    if(self = [super init])
    {
        settingType = type;
        
        if([deviceId length])
        {
            self.strDeviceID =  deviceId;
        }
        
        [self openSocketConnect];
        
    }
    
    return self;
    
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


#pragma mark -
#pragma mark - initData
-(void)initData
{
    
    addressBookInfoDictionnary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    mAddressNumber = [[NSMutableString alloc] initWithCapacity:0];
    
    mAddressTitle = [[NSMutableString alloc] initWithCapacity:0];
    
    mArrayAddressTitle = [[NSMutableArray alloc] initWithCapacity:0];
    mArrayAddressNumber = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    if(settingType == settingTypeOfGPSUpTime) //GPS上传时间间隔
    {
        mTableviewSection1 = [NSMutableArray arrayWithObjects:@"上传间隔时间(秒):", nil];
        
        [self getGPSInfo];
    }
    else if (settingType == settingTypeOfSOSNumber)//SOS号码
    {
        mTableviewSection1 = [NSMutableArray arrayWithObjects:@"电话号码1:",@"电话号码2:",@"电话号码3:",@"电话号码4:", nil];
        
        [self getSOSNumber];
        
    }
    else if (settingType == settingTypeOfAddressBook)//通讯录
    {
        mTableviewSection1 = [NSMutableArray arrayWithObjects:@"名称1:",@"名称2:",@"名称3:",@"名称4:",@"名称5:",@"名称6:",@"名称7:",@"名称8:", nil];
        
        [self getLinkManInfo];
    }
    else if (settingType == settingTypeOfTakeMedicineRemind) //吃药提醒
    {
        mTableviewSection1 = [NSMutableArray arrayWithObjects:@"提醒时间1:",@"提醒时间2:",@"提醒时间3:", nil];
        
        mTableviewSection2 = [NSMutableArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
        
        [self getMedicineRemind];
        
    }else if (settingType == settingTypeOfCommonlyDrugs)
    {
        // 此处获取从后台的到的常用药
        [self getCommonlyDrugs];
    }
    
    
    
}


#pragma mark - 获取GPS上传时间
-(void)getGPSInfo
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getGPSUploadTimeWithDeviceID:self.strDeviceID];
}


#pragma mark - 获取SOS号码
-(void)getSOSNumber
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getSOSNumberWithDeviceID:self.strDeviceID];
}


#pragma mark - 获取通讯录
-(void)getLinkManInfo
{
    NSLog(@"%d %d",pageSize,page);
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getLinkManWithDeviceID:self.strDeviceID page:page pageSize:pageSize];
}


#pragma mark - 获取吃药提醒
-(void)getMedicineRemind
{
    NSLog(@"%d %d",pageSize,page);
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getMedicineRemindWithDeviceID:self.strDeviceID page:page pageSize:pageSize];
}
#pragma mark - JCK常见药物
-(void)getCommonlyDrugs
{
    NSLog(@"%d %d",pageSize,page);
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getCommonlyDrugsWithDeviceID:self.strDeviceID page:page pageSize:pageSize];
}


#pragma mark -
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    if (timeStr0.length == 0) {
        timeStr0 = @" ";
    }
    if (timeStr1.length == 0) {
        timeStr1 = @" ";
    }
    if (timeStr2.length == 0) {
        timeStr2 = @" ";
    }
    self.strGPSUpLoadSecond = @"";
    [self initData];
    
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    //    self.tableView.separatorColor = [UIColor clearColor];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [ToolSet setExtraCellLineHidden:self.tableView];
    
    [self setTableFooterView];
    
    [self.tableView reloadData];
    
}

#pragma mark- viewDidDisappear
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
    
}


#pragma mark- viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    [self closeSocketConnect];
    
}


#pragma mark -
#pragma mark - Draw TableView
-(void)setTableFooterView
{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.tableView.frame.origin.y+self.tableView.frame.size.height, self.view.frame.size.width, 64.0)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled =YES ;
    
    self.tableView.tableFooterView = footView;
    
    UIButton *bookBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 20.0,self.tableView.frame.size.width-20 ,40.0)];
    [bookBut addTarget:self  action:@selector(btnKeep) forControlEvents:UIControlEventTouchUpInside];
    [bookBut setTitle:@"保存" forState:UIControlStateNormal];
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
    
//    NSLog(@"test");
    if(mTextField)[mTextField resignFirstResponder];
    isNeedShow = YES;
//    NSLog(@"%u",settingType);
    if(settingType == settingTypeOfGPSUpTime) //gps上传时间
    {
        if(![self.strGPSUpLoadSecond length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请设置GPS上传间隔时间！" withType:2];
            return;
        }
        
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
        [mdict setObject:strGPSTime forKey:@"TaskType"];
        [mdict setObject:self.strGPSUpLoadSecond forKey:@"Content"];
        [mdict setObject:self.strDeviceID forKey:@"SendTo"];
        [mdict setObject:@"APP" forKey:@"ClientType"];
        
        NSString *strJason = [mdict JSONRepresentation];
        
        DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
        
        if([socket isDisconnected]) return;
        
        [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        [socket readDataWithTimeout:-1 tag:0];        
    }
    else if (settingType == settingTypeOfSOSNumber)//SOS号码
    {
        if(![self.objectSOS.strMobile1 length] && [self.objectSOS.strMobile2 length] && [self.objectSOS.strMobile3 length] && [self.objectSOS.strMobile3 length])
        {
            [Util showAlertWithTitle:@"提示" withMessage:@"请设置SOS号码！" withType:2];
            return;
        }
        
        NSString *str1 = [Util returnValuableString:self.objectSOS.strMobile1];
        NSString *str2 = [Util returnValuableString:self.objectSOS.strMobile2];
        NSString *str3 = [Util returnValuableString:self.objectSOS.strMobile3];
        NSString *str4 = [Util returnValuableString:self.objectSOS.strMobile4];
        
        NSString *strFormatNumber = [NSString stringWithFormat:@"%@,%@,%@,%@",str1,str2,str3,str4];
        
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
        [mdict setObject:strSOS forKey:@"TaskType"];
        [mdict setObject:strFormatNumber forKey:@"Content"];
        [mdict setObject:self.strDeviceID forKey:@"SendTo"];
        [mdict setObject:@"APP" forKey:@"ClientType"];
        
        NSString *strJason = [mdict JSONRepresentation];
        
        DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
        
        [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        
        [socket readDataWithTimeout:-1 tag:0];
        
    }
    else if (settingType == settingTypeOfAddressBook)//通讯录
    {
        NSLog(@"%@",mArrayAddressTitle);
        if([mArrayAddressNumber count])
        {
            for(NSMutableDictionary *mdict in mArrayAddressNumber)
            {
                if([mdict.allValues count])
                {
                    for(NSString *str in mdict.allValues)
                    {
                        if([str localizedCompare:@""] == NSOrderedSame)
                        {
                            [mdict removeObjectForKey:[mdict.allKeys objectAtIndex:0]];
                        }
                    }
                }
            }
        }
        
        
        if([mArrayAddressTitle count])
        {
            for(NSMutableDictionary *mdict in mArrayAddressTitle)
            {
                if([mdict.allValues count])
                {
                    for(NSString *str in mdict.allValues)
                    {
                        if([str localizedCompare:@""] == NSOrderedSame)
                        {
                            [mdict removeObjectForKey:[mdict.allKeys objectAtIndex:0]];
                        }
                    }
                }
            }
        }
        
        
        for(int i =0;i< mArrayAddressTitle.count;i++)
        {
            NSMutableDictionary *dict = [mArrayAddressTitle objectAtIndex:i];
            
            NSArray *keyArray = dict.allKeys ; //联系人在表格里的下标
            NSArray *valueArray = dict.allValues; //
            
            if([keyArray count])
            {
                if([mAddressTitle length])
                {
                    [mAddressTitle appendString:[NSString stringWithFormat:@",%@",[valueArray objectAtIndex:0]]];
                }
                else
                {
                    [mAddressTitle setString:[valueArray objectAtIndex:0]];
                }
            }
            
        }
        NSLog(@"%@",mAddressTitle);
        
        
        for(int i =0;i< mArrayAddressNumber.count;i++)
        {
            NSMutableDictionary *dict = [mArrayAddressNumber objectAtIndex:i];
            
            NSArray *keyArray = dict.allKeys ;
            NSArray *valueArray = dict.allValues;
            
            if([keyArray count])
            {
                if([mAddressNumber length])
                {
                    [mAddressNumber appendString:[NSString stringWithFormat:@",%@",[valueArray objectAtIndex:0]]];
                }
                else
                {
                    [mAddressNumber setString:[valueArray objectAtIndex:0]];
                }
                
            }
            
        }
        
        DEBUG_NSLOG(@"\n\n 标题 :%@ \n\n",mAddressTitle);
        
        DEBUG_NSLOG(@"\n\n 号码 :%@ \n\n",[mAddressNumber class]);
        
        NSString *strFormat = [NSString stringWithFormat:@"%@|%@",mAddressTitle,mAddressNumber];
        
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
        [mdict setObject:strSetLinkman forKey:@"TaskType"];
        [mdict setObject:strFormat forKey:@"Content"];
        [mdict setObject:self.strDeviceID forKey:@"SendTo"];
        [mdict setObject:@"APP" forKey:@"ClientType"];
        
        NSString *strJason = [mdict JSONRepresentation];
        
        DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
        [self openSocketConnect];
        
        [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        
        [socket readDataWithTimeout:-1 tag:0];
    }
    else if (settingType == settingTypeOfTakeMedicineRemind) // 吃药提醒
    {

        NSLog(@"%@%@%@",timeStr0,timeStr1,timeStr2);
        if (mArrayRemindTime.count == 0) {
            mArrayRemindTime = [[NSMutableArray alloc] initWithCapacity:3];
            [mArrayRemindTime addObject:timeStr0];
            [mArrayRemindTime addObject:timeStr1];
            [mArrayRemindTime addObject:timeStr2];
        }
        else
        {
            [mArrayRemindTime removeAllObjects];
            [mArrayRemindTime addObject:timeStr0];
            [mArrayRemindTime addObject:timeStr1];
            [mArrayRemindTime addObject:timeStr2];
        }
        if([mArrayRemindTime count])
        {
            for (NSString *strValue in mArrayRemindTime) {
                
                if([strValue localizedCompare:@""] == NSOrderedSame)
                {
                    [mArrayRemindTime removeObject:strValue];
                }
            }
//            // 不可以为空
//                      [mArrayRemindTime removeAllObjects];
//                        NSUserDefaults *u = [[NSUserDefaults alloc] init];
//                        timeStr0 = [u objectForKey:@"tip1"];
//                        timeStr1 = [u objectForKey:@"tip2"];
//                        timeStr2 = [u objectForKey:@"tip3"];
//                        [mArrayRemindTime addObject:timeStr0];
//                        [mArrayRemindTime addObject:timeStr1];
//                        [mArrayRemindTime addObject:timeStr2];
//                        [u synchronize];
//                        for (int i = 0; i<mArrayRemindTime.count; i++) {
//                            NSLog(@"%@ ",mArrayRemindTime[i]);
//                        }
            NSString *strRemindTimes=[mArrayRemindTime componentsJoinedByString:@","]; // 发送都后台的时间指令
            // 周期、药名、备注
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
////            [user setObject:infoL1.text forKey:@"i1"];
//            NSString *dosageStr = [user objectForKey:@"dosage"];
//            NSString *sickNameStr = [user objectForKey:@"sickName"];
//            NSLog(@"%@ %@",dosageStr,sickNameStr);
//            [user synchronize];
            
            NSString *strFormat = [NSString stringWithFormat:@"%@|%@",strRemindTimes,self.objectMedicineRemind.strWeekDayList];
//            NSString *strFormat = [NSString stringWithFormat:@"%@|%@|%@|%@",strRemindTimes,self.objectMedicineRemind.strWeekDayList,sickNameStr,dosageStr];
            NSLog(@"%@",strFormat); // 发送到后台的提醒用药指令
            NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
            [mdict setObject:strMedicine forKey:@"TaskType"];
            [mdict setObject:strFormat forKey:@"Content"];
            [mdict setObject:self.strDeviceID forKey:@"SendTo"];
            [mdict setObject:@"APP" forKey:@"ClientType"];
            
            NSString *strJason = [mdict JSONRepresentation];
            
            DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
            
            [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
            
            [socket readDataWithTimeout:-1 tag:0];
            
            
        }
        else
        {
            [Util showAlertWithTitle:@"" withMessage:@"还没有填写提醒时间~" withType:2];
        }
    }
    if(settingType == settingTypeOfyanzhengma) //验证码上传时间
    {
        
        NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [mdict setObject:[UserInfo shareInstance].strUserID forKey:@"UserId"];
        [mdict setObject:strConnect forKey:@"TaskType"];
        [mdict setObject:self.strGPSUpLoadSecond forKey:@"Content"];
        [mdict setObject:self.strDeviceID forKey:@"SendTo"];
        [mdict setObject:@"APP" forKey:@"ClientType"];
        
        NSString *strJason = [mdict JSONRepresentation];
        
        DEBUG_NSLOG(@"\n\n Json string :%@ \n\n",strJason);
        [self openSocketConnect];
        if([socket isDisconnected]) return;
        
        [socket writeData:[strJason dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        
        [socket readDataWithTimeout:-1 tag:0];
        
    }
    
}



#pragma mark -
#pragma mark - table delegate and dataSource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return @"提醒周期";
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 15;
            break;
        default: {
            return 34;
            break;
        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(settingType == settingTypeOfTakeMedicineRemind)
    {
        return 2;
    }
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [mTableviewSection1 count];
        //        return 1;
    }
    else
    {
        return [mTableviewSection2 count];
    }
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor  =[UIColor whiteColor];
    
    UILabel *titleLab = nil;
    titleLab = [[UILabel alloc ]initWithFrame:CGRectMake(15, 10, 50, 20)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont systemFontOfSize:15.0];
    titleLab.textColor = [UIColor darkGrayColor];
    
    titleLab.textAlignment = kUITextAlignmentLeft;
    [cell.contentView addSubview:titleLab];
    
    if(settingType == settingTypeOfTakeMedicineRemind)
    {
        if(indexPath.section == 0)
        {
            
            titleLab.text = [mTableviewSection1 objectAtIndex:indexPath.row];
        }
        else
        {
            titleLab.text = [mTableviewSection2 objectAtIndex:indexPath.row];
        }
    }
    else
    {
        titleLab.text = [mTableviewSection1 objectAtIndex:indexPath.row];
    }
    
    if(settingType == settingTypeOfGPSUpTime)
    {
        titleLab.frame = CGRectMake(15, 10, 120, 20);
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        mTextField = [[UITextField alloc] initWithFrame:
                      CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 0, cell.contentView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+10), cell.frame.size.height)];
        mTextField.clearsOnBeginEditing = NO;
        //        mTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        mTextField.layer.borderWidth = 0.35;
        mTextField.returnKeyType = UIReturnKeyDone;
        mTextField.delegate = self;
        mTextField.font = [UIFont systemFontOfSize:15.0];
        mTextField.textColor = [UIColor lightGrayColor];
//        mTextField.textAlignment = kUITextAlignmentCenter;
        mTextField.tag = indexPath.row;
        mTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        mTextField.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:mTextField];
        
        if([self.strGPSUpLoadSecond length])
        {
            mTextField.text = self.strGPSUpLoadSecond;
            mTextField.textColor = [UIColor lightGrayColor];
        }
        else
        {
            if([self.dataSource count])
            {
                DataObjectMyDeviceList *device = [self.dataSource objectAtIndex:0];
                
                mTextField.text = device.strGPSSecond;
                mTextField.textColor = [UIColor lightGrayColor];
            }
            else
            {
                mTextField.placeholder=@"设置GPS上传间隔";//默认显示的字
//                mTextField.text = @"设置GPS上传间隔";
            }
        }
        
        
        
    }
    else if(settingType == settingTypeOfSOSNumber)
    {
        titleLab.frame = CGRectMake(15, 10, 100, 20);
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        mTextField = [[UITextField alloc] initWithFrame:
                      CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 0, cell.contentView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+10), cell.frame.size.height)];
        mTextField.clearsOnBeginEditing = NO;
        //        mTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        mTextField.layer.borderWidth = 0.35;
        mTextField.returnKeyType = UIReturnKeyDone;
        mTextField.delegate = self;
        mTextField.font = [UIFont systemFontOfSize:15.0];
        mTextField.textColor = [UIColor lightGrayColor];
        mTextField.textAlignment = kUITextAlignmentCenter;
        mTextField.tag = indexPath.row;
        mTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        mTextField.tag = indexPath.row;
        [cell.contentView addSubview:mTextField];
        
        
        if(self.objectSOS !=nil)
        {
            mTextField.textColor = [UIColor lightGrayColor];
            NSLog(@"%@ %@ %@ %@",self.objectSOS.strMobile1,self.objectSOS.strMobile2,self.objectSOS.strMobile3,self.objectSOS.strMobile4);
            
            if(indexPath.row == 0)
            {
                mTextField.text = self.objectSOS.strMobile1;
            }
            else if(indexPath.row == 1)
            {
                mTextField.text = self.objectSOS.strMobile2;
            }
            else if(indexPath.row == 2)
            {
                mTextField.text = self.objectSOS.strMobile3;
            }
            else if(indexPath.row == 3)
            {
                mTextField.text = self.objectSOS.strMobile4;
            }
            
        }
        else
        {
//            mTextField.text = @"设置SOS号码";
            mTextField.placeholder=@"设置SOS号码";
        }
    }
    else if(settingType == settingTypeOfAddressBook)
    {
        titleLab.frame = CGRectMake(15, 10, 100, 20);
        [titleLab removeFromSuperview];
        
        //联系人的textField
        UITextField *titleTextField = [[UITextField alloc] initWithFrame:
                                       CGRectMake(15, 0, 160, cell.frame.size.height)];
        titleTextField.clearsOnBeginEditing = NO;
        //        mTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        mTextField.layer.borderWidth = 0.35;
        titleTextField.returnKeyType = UIReturnKeyDone;
        titleTextField.delegate = self;
        titleTextField.font = [UIFont systemFontOfSize:15.0];
        titleTextField.textColor = [UIColor darkGrayColor];
        titleTextField.textAlignment = kUITextAlignmentLeft;
        //        titleTextField.tag = indexPath.row;
        titleTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        titleTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        titleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        titleTextField.tag = indexPath.row;
        [cell.contentView addSubview:titleTextField];
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //号码的的textField
        mTextField = [[UITextField alloc] initWithFrame:
                      CGRectMake(titleTextField.frame.origin.x+titleTextField.frame.size.width+10, 0, tableView.frame.size.width-(titleTextField.frame.origin.x+titleTextField.frame.size.width+25), cell.frame.size.height)];
        mTextField.clearsOnBeginEditing = NO;
        //        mTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        mTextField.layer.borderWidth = 0.35;
        mTextField.returnKeyType = UIReturnKeyDone;
        mTextField.delegate = self;
        mTextField.font = [UIFont systemFontOfSize:15.0];
        mTextField.textColor = [UIColor darkGrayColor];
        mTextField.textAlignment = kUITextAlignmentCenter;
        mTextField.tag = indexPath.row;
        mTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        mTextField.tag = indexPath.row+100;
        [cell.contentView addSubview:mTextField];
        
        if([self.dataSource count])
        {
            if(indexPath.row < [self.dataSource count] )
            {
                DataObjectLinkMan *linkInfo = [self.dataSource objectAtIndex:indexPath.row];
                
                titleTextField.text = linkInfo.strLinkName;
                
                mTextField.text = linkInfo.strLinkMobile;
            }
            else
            {
                titleTextField.placeholder = [mTableviewSection1 objectAtIndex:indexPath.row];
                
                mTextField.placeholder = [NSString stringWithFormat:@"电话号码%ld",indexPath.row+1];
            }
            
        }
        else
        {
            mTextField.placeholder = [NSString stringWithFormat:@"电话号码%ld",indexPath.row+1];
        }
    }
    else if(settingType == settingTypeOfTakeMedicineRemind)
    {
        if(indexPath.section == 0)
        {
#if 0
            //            mTextField.hidden = YES;
            //            [self.view addSubview:timeLabel];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            mTextField = [[UITextField alloc] initWithFrame:
                          CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+10, 0, tableView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+25), cell.frame.size.height)];
            mTextField.clearsOnBeginEditing = NO;
            //        mTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //        mTextField.layer.borderWidth = 0.35;
            mTextField.returnKeyType = UIReturnKeyDone;
            mTextField.delegate = self;
            mTextField.font = [UIFont systemFontOfSize:15.0];
            mTextField.textColor = [UIColor darkGrayColor];
            mTextField.textAlignment = kUITextAlignmentCenter;
            mTextField.tag = indexPath.row;
            mTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            mTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            mTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:mTextField];
#endif
            UILabel *infoL0 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0,ScreenWidth-80, 40)];
            UILabel *infoL1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0,ScreenWidth-80, 40)];
            UILabel *infoL2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0,ScreenWidth-80, 40)];
            
            switch (indexPath.row) {
                case 0:
                {
                    infoL0.font = [UIFont systemFontOfSize:15];
                    //            infoL.backgroundColor = [UIColor lightGrayColor];
                    infoL0.textAlignment = NSTextAlignmentLeft;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    infoL0.tag = 800;
                    NSLog(@"mArrayRemindTime %ld",mArrayRemindTime.count);
                    if (mArrayRemindTime.count == 0) {
                            infoL0.text = @"点击设置提醒时间";
                    }
                    else
                    {
                        timeStr0 =  mArrayRemindTime[0];
                        infoL0.text = mArrayRemindTime[0];

                    }
//                    timeLabel.text = mArrayRemindTime[0];
                }
                    [cell.contentView addSubview:infoL0];
                    break;
                case 1:
                {
                    infoL1.font = [UIFont systemFontOfSize:15];
                    //            infoL.backgroundColor = [UIColor lightGrayColor];
                    infoL1.textAlignment = NSTextAlignmentLeft;
                    infoL1.text = @"点击设置提醒时间";
                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    timeLabel.text = mArrayRemindTime[1];
                    infoL1.tag = 801;
                    if (mArrayRemindTime.count == 0) {
                        infoL1.text = @"点击设置提醒时间";
                    }
                    else
                    {
                        
                        timeStr1 =  mArrayRemindTime[1];
                        infoL1.text = mArrayRemindTime[1];
                        
                    }

                }
                    [cell.contentView addSubview:infoL1];
                    break;
                    
                case 2:
                {
                    infoL2.font = [UIFont systemFontOfSize:15];
                    //            infoL.backgroundColor = [UIColor lightGrayColor];
                    infoL2.textAlignment = NSTextAlignmentLeft;
                    infoL2.text = @"点击设置提醒时间";
                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    timeLabel.text = mArrayRemindTime[2];
                    infoL2.tag = 802;
                    if (mArrayRemindTime.count == 0) {
                        infoL2.text = @"点击设置提醒时间";
                    }
                    else
                    {
                        timeStr2 =  mArrayRemindTime[2];
                        infoL2.text = mArrayRemindTime[2];
                        
                    }

                }
                    [cell.contentView addSubview:infoL2];
                    break;
                    
                default:
                    break;
            }
            NSLog(@"timeStr -> %@ %@ %@",timeStr0,timeStr1,timeStr2);
            [cell.contentView addSubview:timeLabel];
            
            
            titleLab.frame = CGRectMake(15, 10, 130, 20);
            if([self.dataSource count])
            {
                if([mArrayRemindTime count])
                {
                    // mArrayRemindTime 数据库提醒时间
                    if(indexPath.row == 0)
                    {
                        // JCK
                        mTextField.text = [mArrayRemindTime objectAtIndex:0];
//                        timeLabel.text = [NSString stringWithFormat:@"%@ ",[mArrayRemindTime objectAtIndex:0]]
                        ;
                    }
                    else if (indexPath.row == 1)
                    {
                        if([mArrayRemindTime count] >1)
                        {
                            mTextField.text = [mArrayRemindTime objectAtIndex:1];
                        }
                    }
                    else if (indexPath.row == 2)
                    {
                        if([mArrayRemindTime count] >2)
                        {
                            mTextField.text = [mArrayRemindTime objectAtIndex:2];
                        }
                    }
                }
                
            }
            else
            {
                mTextField.placeholder = @"设置提醒时间";
                
            }
        }
        else
        {
            if([self.dataSource count])
            {
                DataObjectMedicineRemind *remind = [self.dataSource objectAtIndex:0];
                
                NSString *strWeekDay = [remind strWeekDayList];
                NSLog(@"%ld",strWeekDay.length);
                if (strWeekDay.length != 7) {
                    strWeekDay = [NSMutableString stringWithString:@"0000000"];
                }
                if([strWeekDay length])
                {
                    NSRange range = NSMakeRange(indexPath.row, 1);
                    
                    NSString *strValue = [strWeekDay substringWithRange:range];
                    
                    if([strValue intValue] == 1)
                    {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else
                    {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    
                }
                
            }
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - JCK修改吃药提醒
#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%ld  %ld",indexPath.section,indexPath.row);
    if(settingType == settingTypeOfTakeMedicineRemind)
    {
        if (indexPath.section == 0) {
#if 0
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"settingTypeOfTakeMedicineRemind");
                    //            [self showDatePickerView];
                    [MyTimePickerView showTimePickerViewDeadLine:@"20160320" CompleteBlock:^(NSDictionary *infoDic) {
                        NSString *time = infoDic[@"time_value"];
                        //                _timeLabel.text = time;
                        NSLog(@"time---%@", time);
                        timeStr0 = time;
                        [self.tableView reloadData];
                    }];
                    
                }
                    break;
                case 1:
                {
                    NSLog(@"settingTypeOfTakeMedicineRemind");
                    //            [self showDatePickerView];
                    [MyTimePickerView showTimePickerViewDeadLine:@"20160320" CompleteBlock:^(NSDictionary *infoDic) {
                        NSString *time = infoDic[@"time_value"];
                        //                _timeLabel.text = time;
                        NSLog(@"time---%@", time);
                        timeStr1 = time;
                        [self.tableView reloadData];
                    }];
                    
                }
                    break;
                    
                case 2:
                {
                    NSLog(@"settingTypeOfTakeMedicineRemind");
                    //            [self showDatePickerView];
                    [MyTimePickerView showTimePickerViewDeadLine:@"20160320" CompleteBlock:^(NSDictionary *infoDic) {
                        NSString *time = infoDic[@"time_value"];
                        //                _timeLabel.text = time;
                        NSLog(@"time---%@", time);
                        timeStr2 = time;
                        [self.tableView reloadData];
                    }];
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
#endif
#if 0
            // JCK日后实现2级跳转功能打开添加
            SetRemindViewController *setReVC = [[SetRemindViewController alloc] init];
            setReVC.title = @"服药提醒";
            //            NSLog(@"%@",self.title);
            [self.navigationController pushViewController:setReVC animated:YES];
#endif

            for (int i = 0; i<24; i++) {
                NSString *timeStr;
                if (i<10) {
                    timeStr = [NSString stringWithFormat:@"0%d",i];
                }
                else
                {
                    timeStr = [NSString stringWithFormat:@"%d",i];
                }
                if (m_hour.count == 0) {
                    m_hour = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [m_hour addObject:timeStr];
            }
            
            for (int i = 0; i<60; i++) {
                NSString *timeStr;
                if (i<10) {
                    timeStr = [NSString stringWithFormat:@"0%d",i];
                }
                else
                {
                    timeStr = [NSString stringWithFormat:@"%d",i];
                }
                if (m_times.count == 0) {
                    m_times = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [m_times addObject:timeStr];
            }
            [m_times arrayByAddingObject:m_times];
            components = 2;
            selectTag = 800 + indexPath.row;
            [self _initPickerView];
            
        }
        if(indexPath.section == 1)
        {
            if([self.dataSource count])
            {
                DataObjectMedicineRemind *remind = [self.dataSource objectAtIndex:0];
                
                NSMutableString *strWeekDay = [NSMutableString stringWithString:[remind strWeekDayList]];
                NSLog(@"%ld",strWeekDay.length);
                if (strWeekDay.length != 7) {
                    strWeekDay = [NSMutableString stringWithString:@"0000000"];
                }
                if([strWeekDay length])
                {
                    NSRange range = NSMakeRange(indexPath.row, 1);
                    
                    NSString *strValue = [strWeekDay substringWithRange:range];
                    
                    if([strValue intValue] == 1)
                    {
                        [strWeekDay replaceCharactersInRange:range withString:@"0"];
                    }
                    else
                    {
                        [strWeekDay replaceCharactersInRange:range withString:@"1"];
                    }
                    
                    remind.strWeekDayList = strWeekDay;
//                    //一个section刷新
//                    [tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//                  // 加了先设置好时间再设置周期 时间会回复原来的时候
                  [tableView reloadData];
                    
                }
            }
        }
    }
    
}




#pragma mark -
#pragma mark - UITextField delegate
- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    DEBUG_NSLOG(@"clear text :%@",textField.text);
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing :%@",textField.text);
    
    if(settingType == settingTypeOfGPSUpTime)
    {
        mTextField.text = textField.text;
        
        self.strGPSUpLoadSecond= textField.text;
    }
    else if (settingType == settingTypeOfSOSNumber)
    {
        if (textField.tag == 0)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile1 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile1  =@"";
                
            }
            
        }
        else if(textField.tag == 1)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile2 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile2  =@"";
            }
            
        }
        else if(textField.tag == 2)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile3 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile3  =@"";
            }
            
        }
        else if(textField.tag == 3)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile4 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile4  =@"";
            }
            
        }
    }
    else if (settingType == settingTypeOfAddressBook)
    {
        BOOL isFound = NO;
        NSInteger foundIndex= -1;
        
        
        if(textField.tag >= 100)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if([textField.text length])
            {
                [dict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            }
            else
            {
                [dict setObject:textField.text forKey:@""];
            }
            
            for (int i=0; i<[mArrayAddressNumber count]; i++)
            {
                
                NSMutableDictionary *tmpDict = [mArrayAddressNumber objectAtIndex:i];
                
                if ([[tmpDict.allKeys objectAtIndex:0] integerValue] == textField.tag) {
                    
                    isFound = YES;
                    
                    foundIndex = i;
                    
                    break;
                    
                }
            }
            
            if(isFound == YES)
            {
                [mArrayAddressNumber replaceObjectAtIndex:foundIndex withObject:dict];
            }
            else
            {
                [mArrayAddressNumber addObject:dict];
            }
            
            
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if([textField.text length])
            {
                [dict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            }
            else
            {
                [dict setObject:textField.text forKey:@""];
            }
            
            for (int i=0; i<[mArrayAddressTitle count]; i++)
            {
                
                NSMutableDictionary *tmpDict = [mArrayAddressTitle objectAtIndex:i];
                
                if ([[tmpDict.allKeys objectAtIndex:0] integerValue] == textField.tag) {
                    
                    isFound = YES;
                    
                    foundIndex = i;
                    
                    break;
                    
                }
            }
            
            if(isFound == YES)
            {
                [mArrayAddressTitle replaceObjectAtIndex:foundIndex withObject:dict];
            }
            else
            {
                [mArrayAddressTitle addObject:dict];
            }
            
        }
        
        //        NSMutableDictionary *dict = [addressBookInfoDictionnary valueForKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        //
        //        if(dict == nil)
        //        {
        //            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",[NSString stringWithFormat:@"%ld",textField.tag], nil];
        //        }
        //
        //        if(textField.text!=nil && [textField.text length]>0)
        //        {
        //            [dict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        //
        //        }
        //        else
        //        {
        //            [dict setObject:@"" forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        //
        //        }
        //
        //        [addressBookInfoDictionnary setObject:dict forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    }
    else if (settingType == settingTypeOfTakeMedicineRemind)
    {
        [self.view endEditing:YES];
        if(textField.text!=nil && [textField.text length]>0)
        {
            if(textField.tag < [mArrayRemindTime count])
            {
                // 此处是用药提醒上传
                [mArrayRemindTime replaceObjectAtIndex:textField.tag withObject:textField.text];
            }
            else
            {
                [mArrayRemindTime insertObject:textField.text atIndex:textField.tag];
            }
            
        }
        else
        {
            if(textField.tag < [mArrayRemindTime count])
            {
                [mArrayRemindTime replaceObjectAtIndex:textField.tag withObject:@""];
            }
            else
            {
                [mArrayRemindTime insertObject:@"" atIndex:textField.tag];
            }
            
        }
        
    }
    
    
    return YES;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(settingType == settingTypeOfGPSUpTime)
    {
        mTextField.text = textField.text;
        
        self.strGPSUpLoadSecond= textField.text;
    }
    else if (settingType == settingTypeOfSOSNumber)
    {
        if (textField.tag == 0)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile1 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile1  =@"";
                
            }
            
        }
        else if(textField.tag == 1)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile2 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile2  =@"";
            }
            
        }
        else if(textField.tag == 2)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile3 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile3  =@"";
            }
            
        }
        else if(textField.tag == 3)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile4 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile4  =@"";
            }
            
        }
    }
    else if (settingType == settingTypeOfAddressBook)
    {
        BOOL isFound = NO;
        NSInteger foundIndex= -1;
        
        
        if(textField.tag >= 100)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if([textField.text length])
            {
                [dict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            }
            else
            {
                [dict setObject:textField.text forKey:@""];
            }
            
            for (int i=0; i<[mArrayAddressNumber count]; i++)
            {
                
                NSMutableDictionary *tmpDict = [mArrayAddressNumber objectAtIndex:i];
                
                if ([[tmpDict.allKeys objectAtIndex:0] integerValue] == textField.tag) {
                    
                    isFound = YES;
                    
                    foundIndex = i;
                    
                    break;
                    
                }
            }
            
            if(isFound == YES)
            {
                [mArrayAddressNumber replaceObjectAtIndex:foundIndex withObject:dict];
            }
            else
            {
                [mArrayAddressNumber addObject:dict];
            }
            
            
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if([textField.text length])
            {
                [dict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            }
            else
            {
                [dict setObject:textField.text forKey:@""];
            }
            
            for (int i=0; i<[mArrayAddressTitle count]; i++)
            {
                
                NSMutableDictionary *tmpDict = [mArrayAddressTitle objectAtIndex:i];
                
                if ([[tmpDict.allKeys objectAtIndex:0] integerValue] == textField.tag) {
                    
                    isFound = YES;
                    
                    foundIndex = i;
                    
                    break;
                    
                }
            }
            
            if(isFound == YES)
            {
                [mArrayAddressTitle replaceObjectAtIndex:foundIndex withObject:dict];
            }
            else
            {
                [mArrayAddressTitle addObject:dict];
            }
            
        }
        
    }
    else if (settingType == settingTypeOfTakeMedicineRemind)
    {
        if(textField.text!=nil && [textField.text length]>0)
        {
            [mArrayRemindTime replaceObjectAtIndex:textField.tag withObject:textField.text];
            
        }
        else
        {
            [mArrayRemindTime replaceObjectAtIndex:textField.tag withObject:@""];
        }
        
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"修改后的内容text :%@",textField.text);
    
    if(settingType == settingTypeOfGPSUpTime)
    {
        mTextField.text = textField.text;
        
        self.strGPSUpLoadSecond= textField.text;
    }
    else if (settingType == settingTypeOfSOSNumber)
    {
        if (textField.tag == 0)
        {
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile1 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile1  =@"";
                
            }
            
        }
        else if(textField.tag == 1)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile2 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile2  =@"";
            }
            
        }
        else if(textField.tag == 2)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile3 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile3  =@"";
            }
            
        }
        else if(textField.tag == 3)
        {
            
            if(textField.text!=nil && [textField.text length]>0)
            {
                self.objectSOS.strMobile4 = textField.text;
                
            }
            else
            {
                self.objectSOS.strMobile4  =@"";
            }
            
        }
    }
    else if (settingType == settingTypeOfAddressBook)
    {
        BOOL isFound = NO;
        NSInteger foundIndex= -1;
        
        NSLog(@"修改了通讯录里的text :%@",textField.text);
        
        
        if(textField.tag >= 100)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if([textField.text length])
            {
                [dict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            }
            else
            {
                [dict setObject:textField.text forKey:@""];
            }
            
            for (int i=0; i<[mArrayAddressNumber count]; i++)
            {
                
                NSMutableDictionary *tmpDict = [mArrayAddressNumber objectAtIndex:i];
                
                if ([[tmpDict.allKeys objectAtIndex:0] integerValue] == textField.tag) {
                    
                    isFound = YES;
                    
                    foundIndex = i;
                    
                    break;
                    
                }
            }
            
            if(isFound == YES)
            {
                [mArrayAddressNumber replaceObjectAtIndex:foundIndex withObject:dict];
            }
            else
            {
                [mArrayAddressNumber addObject:dict];
            }
            
            
        }
        else
        {
            NSLog(@"%@",textField.text);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            if([textField.text length])
            {
                [dict setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            }
            else
            {
                [dict setObject:textField.text forKey:@""];
            }
            
            NSLog(@"%ld",[mArrayAddressTitle count]);
            for (int i=0; i<[mArrayAddressTitle count]; i++)
            {
                
                NSMutableDictionary *tmpDict = [mArrayAddressTitle objectAtIndex:i];
                
                if ([[tmpDict.allKeys objectAtIndex:0] integerValue] == textField.tag) {
                    
                    isFound = YES;
                    
                    foundIndex = i;
                    
                    break;
                    
                }
            }
            
            if(isFound == YES)
            {
                [mArrayAddressTitle replaceObjectAtIndex:foundIndex withObject:dict];
                NSLog(@"%@",mArrayAddressTitle);
            }
            else
            {
                [mArrayAddressTitle addObject:dict];
            }
            
        }
    }
    else if (settingType == settingTypeOfTakeMedicineRemind)
    {
        if(textField.text!=nil && [textField.text length]>0)
        {
            [mArrayRemindTime replaceObjectAtIndex:textField.tag withObject:textField.text];
            
        }
        else
        {
            [mArrayRemindTime replaceObjectAtIndex:textField.tag withObject:@""];
        }
    }
    
    
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
    
    if(request.tag == 124) // 获取GPS上传时间
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeGPSUploadTime];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                
                if([tempObject.arrObjects count])
                {
                    if(self.dataSource == nil)
                    {
                        self.dataSource = [[NSMutableArray alloc ]init];
                        
                    }
                    else
                    {
                        [self.dataSource removeAllObjects];
                    }
                    
                    [self.dataSource addObjectsFromArray:tempObject.arrObjects];
                    
                    [self.tableView reloadData];
                    
                    
                }
                
                
            }
            else
            {
                [Util showMsgAlert:@"你还没有添加被监护人哦～"];
                
                
            }
            
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }
    }
    else if(request.tag == 125) //sos号码设置
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeSOSSetting];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                
                if([tempObject.arrObjects count])
                {
                    if(self.dataSource == nil)
                    {
                        self.dataSource = [[NSMutableArray alloc ]init];
                    }
                    else
                    {
                        [self.dataSource removeAllObjects];
                    }
                    
                    [self.dataSource addObjectsFromArray:tempObject.arrObjects];
                    
                    if(self.objectSOS != nil)
                    {
                        self.objectSOS = nil;
                    }
                    
                    self.objectSOS = [[DataObjectSOS alloc] init];
                    
                    self.objectSOS = [self.dataSource objectAtIndex: 0];
                    
                    [self.tableView reloadData];
                    
                    
                }
                
                
            }
            else
            {
                [Util showMsgAlert:@"你还没有添加被监护人哦～"];
                
                
            }
            
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }
    }
    else if(request.tag == 126) // 通讯录联系人
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeLinkManInfo];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                
                if([tempObject.arrObjects count])
                {
                    if(self.dataSource == nil)
                    {
                        self.dataSource = [[NSMutableArray alloc ]init];
                        
                    }
                    else
                    {
                        [self.dataSource removeAllObjects];
                    }
                    
                    [self.dataSource addObjectsFromArray:tempObject.arrObjects];
                    
                    if([self.dataSource count])
                    {
                        for (int i=0; i<[self.dataSource count]; i++) {
                            
                            DataObjectLinkMan *info  =[self.dataSource objectAtIndex:i];
                            
                            NSString *strTitle = info.strLinkName;
                            NSString *strNumber = info.strLinkMobile;
                            
                            
                            NSString *strKey = [NSString stringWithFormat:@"%d",i];
                            NSString *strKey2 = [NSString stringWithFormat:@"%d",i+100];
                            
                            NSMutableDictionary *mdict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:strTitle,strKey, nil];
                            
                            NSMutableDictionary *mdict2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:strNumber,strKey2, nil];
                            
                            [mArrayAddressTitle addObject:mdict1];
                            [mArrayAddressNumber addObject:mdict2];
                            
                            
                            
                            [addressBookInfoDictionnary setObject:mdict1 forKey:strKey];
                            //[addressBookInfoDictionnary setObject:mdict2 forKey:strKey2];
                        }
                    }
                    
                    [self.tableView reloadData];
                    
                    
                }
                
                
            }
            else
            {
                [Util showMsgAlert:@"你还没有添加被监护人哦～"];
                
                
            }
            
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }
    }
    else if (request.tag == 127) // 吃药提醒
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeMedicineRemind];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                if([tempObject.arrObjects count])
                {
                    if(self.dataSource == nil)
                    {
                        self.dataSource = [[NSMutableArray alloc ]init];
                    }
                    else
                    {
                        [self.dataSource removeAllObjects];
                    }
                    
                    [self.dataSource addObjectsFromArray:tempObject.arrObjects];
                    
                    if(self.objectMedicineRemind != nil)
                    {
                        self.objectMedicineRemind = nil;
                    }
                    
                    self.objectMedicineRemind = [[DataObjectMedicineRemind alloc] init];
                    
                    self.objectMedicineRemind = [self.dataSource objectAtIndex: 0];
                    
                    if(mArrayRemindTime == nil)
                    {
                        mArrayRemindTime = [[NSMutableArray alloc] init];
                    }
                    
                    if(self.objectMedicineRemind.strTimeList)
                    {
                        NSArray *tmpAyTime = [self.objectMedicineRemind.strTimeList componentsSeparatedByString:@","];
//                        NSLog(@"%@",tmpAyTime);
                        [mArrayRemindTime addObjectsFromArray:tmpAyTime];
                        
                    }
                    
                    [self.tableView reloadData];
                }
                
                
            }
            else
            {
                [Util showMsgAlert:@"你还没有添加被监护人哦～"];
                
                
            }
            
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }
    }
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}


#pragma mark - JCKpickerView
- (void)_initPickerView{
//    [self.tableView reloadData];
    _closeV= [[UIView alloc] initWithFrame:self.view.bounds];
    _closeV.backgroundColor = [UIColor lightGrayColor];
    _closeV.alpha = 0.4;
    UITapGestureRecognizer * tapV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    _closeV.userInteractionEnabled = YES;
    [_closeV addGestureRecognizer:tapV];
    [self.view addSubview:_closeV];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight/2, ScreenWidth,ScreenHeight/2.5)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate= self;
    _pickerView.dataSource = self;
    [self.view addSubview:_pickerView];
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight - ScreenHeight/2, ScreenWidth, 80)];
    _labelView.backgroundColor = [UIColor whiteColor];
    if (components == 2) {
        NSArray *titlem_times = @[@"时",@"分"];
        for (int i = 0; i < 2; i++) {
            UILabel *pickerL = [[UILabel alloc] initWithFrame:CGRectMake(20 + (i*ScreenWidth/2),45, ScreenWidth/2-80, 40)];
            pickerL.text = titlem_times[i];
            pickerL.font = [UIFont systemFontOfSize:17];
            pickerL.textAlignment = NSTextAlignmentCenter;
            [self.labelView addSubview:pickerL];
        }
        
    }
    UIButton *cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelB.tag = 404;
    cancelB.frame = CGRectMake(10,10, 40, 40);
    [cancelB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelB setTitle:@"取消" forState:UIControlStateNormal];
    [cancelB addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchDown];
    [self.labelView addSubview:cancelB];
    
    UIButton *clickB = [UIButton buttonWithType:UIButtonTypeCustom];
    clickB.tag = 400;
    clickB.frame = CGRectMake(ScreenWidth - 55,10, 40, 40);
    [clickB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clickB setTitle:@"完成" forState:UIControlStateNormal];
    [clickB addTarget:self action:@selector(closeViewAndSend) forControlEvents:UIControlEventTouchUpInside];
    [self.labelView addSubview:clickB];
    
    [self.view addSubview:_labelView];
}
// 显示列数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return m_hour.count;
    }
    else
    {
        return m_times.count;
    }
}
//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerVie{
    return components;
}

// 显示内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSString *title = [m_hour objectAtIndex:row];
        return title;
    }
    else
    {
        NSString *title = [m_times objectAtIndex:row];
        return title;
    }
    return nil;
}
// 选择了..
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger selectedOneIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger selectedTwoIndex = [self.pickerView selectedRowInComponent:1];
    UILabel *timeLab = (UILabel *)[self.view viewWithTag:selectTag];
    timeLab.text = [NSString stringWithFormat:@"%@:%@",m_hour[selectedOneIndex],m_times[selectedTwoIndex]];
    switch (selectTag) {
        case 800:
        {
            timeStr0 = timeLab.text;
        }
            break;
        case 801:
        {
            timeStr1 = timeLab.text;
        }
            break;
        case 802:
        {
            timeStr2 = timeLab.text;
        }
            break;
            
        default:
            break;
    }
    
}
- (void)closeViewAndSend
{
    [self btnKeep];
    [self.closeV removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.labelView removeFromSuperview];
}

- (void)closeView
{
    [self.tableView reloadData];
    [self.closeV removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.labelView removeFromSuperview];
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
