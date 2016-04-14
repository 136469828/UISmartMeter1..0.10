//
//  MoreViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "UISmartMeterAppDelegate.h"

#import "ModifyPassWordViewController.h"
#import "WebShowView.h"
#import "AboutSoftViewController.h"


#import "MoreViewController.h"

extern UISmartMeterAppDelegate *appDelegate;

@interface MoreViewController()

@property (nonatomic,strong) LXActionSheet *actionSheet;


@end

@implementation MoreViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    self.dataSource  =[NSMutableArray arrayWithObjects:@"修改密码"/*,@"使用帮助",@"版本检测"*/,@"关于软件", nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTableFooterView];
    
}

#pragma mark -
#pragma mark - Draw TableView
-(void)setTableFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.tableView.frame.origin.y+self.tableView.frame.size.height, self.view.frame.size.width, 64.0)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled =YES ;
    
    
    UIButton *bookBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 10.0,self.tableView.frame.size.width-20 ,40.0)];
    [bookBut addTarget:self  action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [bookBut setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [bookBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBut.titleLabel.font = [UIFont systemFontOfSize:20.0];
    bookBut.layer.cornerRadius = 3.0;
    bookBut.showsTouchWhenHighlighted = YES;
    [bookBut setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:63.0/255.0 blue:57.0/255.0 alpha:1.0]];
    [footView addSubview:bookBut];
    
    self.tableView.tableFooterView = footView;
}


-(void)loginOut
{
    self.actionSheet = [[LXActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据,下次登录需要再次输入账号密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
    [self.actionSheet showInView:self.view];
    
    
    // example
    /*
     self.actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"QQ注册",@"微博注册",@"微信注册"]];
     [self.actionSheet showInView:self.view];
     */
}


#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    DEBUG_NSLOG(@"%d",(int)buttonIndex);
}

- (void)didClickOnDestructiveButton
{
    DEBUG_NSLOG(@"destructuctive");
    
    [FileOperation removeValueForKey:userLoginName];
    [FileOperation removeValueForKey:userLoginPassword];

    [appDelegate resetRootViewIsLoginOut:YES];
    
}

- (void)didClickOnCancelButton
{
    DEBUG_NSLOG(@"cancelButton");
}


#pragma mark -
#pragma mark - 检查更新
-(void)checkUpdate
{
    isNeedShow = YES;
    
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService checkVersion];
    
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        DEBUG_NSLOG(@"url is:%@",strurlToItunes);
        
        if(strurlToItunes!=nil && [strurlToItunes length]>0)
        {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strurlToItunes]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strurlToItunes]];
            }
            else
            {
                
                [self alertMessage:@"Safari无法启动，未能链接到指定网站"];
            }
        }
        
        
    }
    else
    {
        DEBUG_NSLOG(@"\n\n\n reminder me latar\n\n\n");
    }
    
}

#pragma mark- 更新tips
-(void)alertMessage:(NSString *)message withButtonCounts:(NSInteger)count
{
    UIAlertView *alert = nil;
    
    if(count == 1)
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"有新版本发布啦~"
                 message:message
                 delegate:self
                 cancelButtonTitle:@"  立即更新 "
                 otherButtonTitles:nil,nil];
    }
    else
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"有新版本发布啦~"
                 message:message
                 delegate:self
                 cancelButtonTitle:@"  立即更新 "
                 otherButtonTitles:@"  以后再说 ",nil];
    }
    
    alert.tag = 0;
    
    [alert show];
    
}

#pragma mark-
-(void)alertMessage:(NSString *)message
{
    UIAlertView *alert = nil;
    
    alert = [[UIAlertView alloc]
             initWithTitle:nil
             message:message
             delegate:self
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil,nil];
    
    alert.tag = 100;
    [alert show];
    
}


#pragma mark - checkver message
-(void)showSoftWareMessageWihOBJ:(DataObjectCheckUpdate *)obj
{
    
    if(obj!=nil)
    {
        
        if(![obj.strVersion isEqual:[NSNull null]])
        {
            
            if(obj.strVersion!=nil && [obj.strVersion length]>0)
            {
                
                NSComparisonResult result = [obj.strVersion compare:softVersion];
                
                if(result == NSOrderedDescending) // 大于
                {
                    int count = 2;
                    
                    if(strurlToItunes == nil)
                    {
                        strurlToItunes = [[NSString alloc] initWithString:obj.strDownlaodURL];
                    }
                    else
                    {
                        strurlToItunes = obj.strDownlaodURL;
                    }
                    
                    
                    if(obj.forceUpdateTag == 1) // 表示强制更新
                    {
                        count = 1;
                        
                    }  // 为0时 正常更新
                    
                    
                    [self alertMessage:obj.strUpdateContent withButtonCounts:count];
                }
                else
                {
                    [self alertMessage:checkVersionUpdate];
                }
            }
            else
            {
                [self alertMessage:checkVersionUpdate];
            }
        }
        
    }
    
    
    
}



#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 15;
    }
    else
    {
        return 4;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.dataSource count])
    {
        if(indexPath.row == [self.dataSource count])
        {
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel  *lableTitle= [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 150, 15)];
    [lableTitle setBackgroundColor:[UIColor clearColor]];
    [lableTitle setTextColor:[UIColor darkGrayColor]];
    [lableTitle setFont:[UIFont systemFontOfSize:15.]];
    [cell.contentView addSubview:lableTitle];
    
    lableTitle.text = [self.dataSource objectAtIndex:indexPath.section];
    
    
    return cell;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        ModifyPassWordViewController *modify = [[ModifyPassWordViewController alloc]init];
        modify.title = @"修改密码";
        [self.navigationController pushViewController:modify animated:YES];
        
    }
    else if(indexPath.section == 1)
    {
        AboutSoftViewController *about = [[AboutSoftViewController alloc]init];
        about.title = @"关于软件";
        [self.navigationController pushViewController:about animated:YES];
        
//        WebShowView *web = [[WebShowView alloc]init];
//        web.webUrl = kUseHekpRequestURL;
//        web.flag = 2;
//        web.title = @"试用帮助";
//        [self.navigationController pushViewController:web animated:YES];
        
    }
    else if(indexPath.section == 2)
    {
        //[self checkUpdate];
        
        AboutSoftViewController *about = [[AboutSoftViewController alloc]init];
        about.title = @"关于软件";
        [self.navigationController pushViewController:about animated:YES];
        
    }
    else if(indexPath.section == 3)
    {
        AboutSoftViewController *about = [[AboutSoftViewController alloc]init];
        about.title = @"关于软件";
        [self.navigationController pushViewController:about animated:YES];
        
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
    
    id obj = nil;
    
    obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeCheckVersion];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            [SVProgressHUD dismiss];
            
            if([tempObject.arrObjects count])
            {
                DataObjectCheckUpdate *oneObject = (DataObjectCheckUpdate *)[tempObject.arrObjects objectAtIndex:0];
                
                if(oneObject)
                {
                    [self showSoftWareMessageWihOBJ:oneObject];
                }
            }
   
        }
        
    }
    
    
    [SVProgressHUD dismiss];
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [SVProgressHUD dismissWithError:@"请检查网络设置!"];
}


@end
