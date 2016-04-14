//
//  WatchSettingViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15/5/15.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "UIImageCategory.h"
#import "NSData-Base64.h"
#import "SubWatchSettingViewController.h"

#import "WatchSettingViewController.h"

@interface WatchSettingViewController ()

@property (nonatomic,strong) LXActionSheet *actionSheet;


@end

@implementation WatchSettingViewController

-(id)initWithDeive:(DataObjectMyDeviceList*)device
{
    if(self = [super init])
    {
        if(device)
        {
            if(self.deviceInfo == nil)
            {
                self.deviceInfo = [[DataObjectMyDeviceList alloc] init];
            }
            
            self.deviceInfo = device;
        }
    }
    
    return self;
    
}

#pragma mark -
#pragma mark -  viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - leftBackButton
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    CGRect frame = self.navigationItem.leftBarButtonItem.customView.frame;
    frame.size.width = 40;
    self.navigationItem.leftBarButtonItem.customView.frame = frame;
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
//    arrayItems = [NSMutableArray arrayWithObjects:@"GPS上传时间",@"SOS号码",@"通讯录",@"吃药提醒",@"发送图片",@"健康状况",@"常用药物", nil];
    arrayItems = [NSMutableArray arrayWithObjects:@"GPS上传时间",@"SOS号码",@"通讯录",@"吃药提醒",@"健康状况",@"常用药物", nil];
}

#pragma mark -
#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [ToolSet setExtraCellLineHidden:self.tableView];
    
    
}



#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    DEBUG_NSLOG(@"%d",(int)buttonIndex);
    
    if((int)buttonIndex == 0)//拍照
    {
        [self takePictureByCamera];
    }
    else if ((int)buttonIndex == 1) // 相册选取
    {
        [self selectPicture];
    }
    
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
#pragma mark- 设置头像 联网
-(void)setUserHeaderWithImage:(NSData*)imgDate
{
    NSString *strbase64 = [imgDate base64Encoding];
    
    JsonService *jsonService = [JsonService sharedManager];
    [jsonService setWebserviceDelegate:self];
    //[jsonService setUserHeaderWithImageBase64:strbase64];
    
    [jsonService updateUserIconWithPicType:@".jpg" picBase64:strbase64 deivceId:self.deviceInfo.strDeviceId];
    
}

#pragma mark- 拍照
-(void)takePictureByCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持拍照功能"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
#ifdef __IPHONE_6_0
        
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
#else
        [self presentModalViewController :imagePickerController animated:NO];
        
#endif
        
    }
}


#pragma mark- 相册选取
-(void)selectPicture
{
    UIImagePickerController *imgPicker= [[UIImagePickerController alloc] init] ;
    
    imgPicker.delegate = self;
    
    imgPicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
    
    
#ifdef __IPHONE_6_0
    
    
    [self presentViewController:imgPicker animated:YES completion:nil];
    
#else
    [self presentModalViewController :imgPicker animated:NO];
    
#endif
    
}


#pragma mark -
#pragma mark -
// TODO:相机
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
#ifdef __IPHONE_6_0
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
#else
    [picker dismissModalViewControllerAnimated:YES];
    
#endif
    
    
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picker.allowsEditing = YES;
    
#ifdef __IPHONE_6_0
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
#else
    [picker dismissModalViewControllerAnimated:YES];
    
#endif
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    CGSize imagesize = image.size;
    imagesize.height =100;
    imagesize.width =100;
    //对图片大小进行压缩--
    image = [Util handleImage:image withSize:imagesize];
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSString *strPath =[imageURL absoluteString];
    strPath = [Util returnValuableString:strPath];
    
    if([strPath length])// 来自相册,不需要调整方向
    {
        
    }
    else
    {
        image = [image imageRotatedByDegrees:90];
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image,0.25);
    
    // send to server
    
    [self setUserHeaderWithImage:imageData];
    
}



-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    switch (section) {
        case 0:
            return 15;
            break;
        default: {
            return 4;
            break;
        }
    }
    
    return 0.0;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayItems count];
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
    
    UILabel *titleLab = nil;
    UILabel *theTitleLab = nil;
    
    titleLab = [[UILabel alloc ]initWithFrame:CGRectMake(15, 10, 120, 20)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont systemFontOfSize:15.0];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.text = [arrayItems objectAtIndex:indexPath.row];
    titleLab.textAlignment = kUITextAlignmentLeft;
    [cell.contentView addSubview:titleLab];
    
    
    if(indexPath.row == 4 || indexPath.row == 5)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        titleLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y, 80, titleLab.frame.size.height);
        
        theTitleLab = [[UILabel alloc ]initWithFrame:CGRectMake(titleLab.frame.origin.x+titleLab.frame.size.width+15, 10, tableView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+30), 20)];
        theTitleLab.backgroundColor = [UIColor clearColor];
        theTitleLab.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        theTitleLab.textColor = [UIColor blackColor];
        theTitleLab.text = @"未填写";
        theTitleLab.textAlignment = kUITextAlignmentLeft;
        theTitleLab.numberOfLines = 0;
        theTitleLab.lineBreakMode = kUILineBreakModeWordWrap;
        [cell.contentView addSubview:theTitleLab];
        
        if(indexPath.row == 4)
        {
            if(self.deviceInfo)
            {
                theTitleLab.text = self.deviceInfo.strHealthInfo;
            }
        }
        else if (indexPath.row == 5)
        {
            if(self.deviceInfo)
            {
                // 一直为空
                NSLog(@"%@",self.deviceInfo.strCommonlyUseDrugs);
                theTitleLab.text = self.deviceInfo.strCommonlyUseDrugs;
            }
        }
        
        CGSize size = [theTitleLab.text boundingRectWithSize:CGSizeMake(tableView.frame.size.width-(titleLab.frame.origin.x+titleLab.frame.size.width+30), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:theTitleLab.font,NSFontAttributeName, nil] context:nil].size;
        
        if(size.height > 20)
        {
            theTitleLab.frame = CGRectMake(theTitleLab.frame.origin.x, theTitleLab.frame.origin.y, size.width, size.height);
            
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, theTitleLab.frame.origin.y+size.height+5);
        }
        else
        {
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 44);
        }
        
        
    }
    else
    {
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, 44);
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 4 || indexPath.row == 5) return;
    
//    if(indexPath.row == 4) // 上传图片
//    {
//        self.actionSheet = [[LXActionSheet alloc]initWithTitle:@"发送图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选取"]];
//        [self.actionSheet showInView:self.view];
//    }
    else
    {
        NSString *strTitle = @"";
        WatchSettingType settingType = settingTypeOfGPSUpTime;
        
        switch (indexPath.row) {
            case 0:
            {
                strTitle = @"GPS上传时间设置";
                settingType = settingTypeOfGPSUpTime;
            }
                break;
            case 1:
            {
                strTitle = @"SOS号码设置";
                
                settingType = settingTypeOfSOSNumber;
            }
                break;
            case 2:
            {
                strTitle = @"通讯录设置";
                
                settingType = settingTypeOfAddressBook;
            }
                break;
            case 3:
            {
                strTitle = @"吃药提醒设置";
                settingType = settingTypeOfTakeMedicineRemind;
            }
                break;
            case 5:
            {
                strTitle = @"常用药物设置";
                settingType = settingTypeOfCommonlyDrugs;
            }
                break;

            default:
                break;
        }
        
        
        SubWatchSettingViewController *setting = [[SubWatchSettingViewController alloc] initWithSettingType:settingType deviceID:self.deviceInfo.strDeviceId];
        setting.title = strTitle;
        [self.navigationController pushViewController:setting animated:YES];
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
    id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeUploadIcon];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
        }
    }
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}



#pragma mark -
#pragma mark - memoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
