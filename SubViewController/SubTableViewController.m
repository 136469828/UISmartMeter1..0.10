//
//  SubTableViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-15.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "PAImageView.h"

#import "AddViewController.h"

#import "WatchSettingViewController.h"

#import "DetailViewController.h"

#import "SubTableViewController.h"

@interface SubTableViewController ()

@end

@implementation SubTableViewController


-(id)initWithViewType:(viewType)vType
{
    {
        currentViewType = vType;
        
    }
    
    return self;
}


#pragma mark -  添加
-(void)rightButton
{

    addViewType addType = addTypePeson;
    NSString *strTitle = @"添加监护人";
    
    if(currentViewType == subViewDeviceList)
    {
        addType = addTypeDeviceForPerson;
        
        strTitle = @"添加设备";
    }
    
    AddViewController *addViewController = [[AddViewController alloc] initWithAddViewType:addType withObj:nil];
    addViewController.title = strTitle;
    addViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addViewController animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    
    if(!self.tableView)
    self.tableView.alpha = 0.0;
    
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [ToolSet setExtraCellLineHidden:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - leftBackButton
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    CGRect frame = self.navigationItem.leftBarButtonItem.customView.frame;
    frame.size.width = 40;
    self.navigationItem.leftBarButtonItem.customView.frame = frame;
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";

    
    if(currentViewType == subViewPersonListViewDefault || currentViewType == subViewDeviceList)
    {
        UIImage *img = [UIImage imageNamed:@"barbuttonicon_add"];
        
        [self setRightButtonWithTitle:@"" textFont:15 withBackGroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] withBackImage:img withFrame:CGRectMake(0.0, 0.0, img.size.width, img.size.height) isRightButton:YES];
    }
    
    [self getMyDevicesList];
    
}


-(void)getMyDevicesList
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getMyDevice];
}



#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.dataSource count])
    {
        return [self.dataSource count];
    }
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(currentViewType == subViewPersonListViewDefault)
    {
        return 1;
        
        
    }

    return 1;
}


#pragma mark -
#pragma mark - TableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    
    return 0;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if(currentViewType == subViewHealthListView)
    {
    
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
        
    }
    else if(currentViewType == subViewDeviceList)
    {
        cell.backgroundColor = [UIColor whiteColor];
        
        if([self.dataSource count])
        {
            CGFloat xposition = 10;
            CGFloat yposition = 15;
            
            DataObjectMyDeviceList *device =[self.dataSource objectAtIndex:indexPath.row];
            
            PAImageView *avaterImageView = [[PAImageView alloc] initWithFrame:CGRectMake(xposition, yposition, 44, 44) backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
            avaterImageView.image = [UIImage imageNamed:@"branddefulthead@2x"];
            avaterImageView.userInteractionEnabled = YES;
            avaterImageView.clipsToBounds = YES;
            avaterImageView.tag = indexPath.row;
            
            avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:avaterImageView];
            
            xposition = avaterImageView.frame.origin.x+avaterImageView.frame.size.width+10;
            
            UILabel *lableNick = [[UILabel alloc] initWithFrame:CGRectMake(xposition, 10, cell.frame.size.width-(xposition+10), 20)];
            lableNick.backgroundColor = [UIColor clearColor];
            lableNick.textColor  =[UIColor blackColor];
            lableNick.font = [UIFont systemFontOfSize:15];
            
            lableNick.text = [NSString stringWithFormat:@"昵称:%@",device.strDeviceOwnerName
                              ];
            [cell.contentView addSubview:lableNick];
            
            yposition = lableNick.frame.origin.y+lableNick.frame.size.height+5;
            
            UILabel *lableLinkMobile = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+100), 20)];
            lableLinkMobile.backgroundColor = [UIColor clearColor];
            lableLinkMobile.textColor  =[UIColor darkGrayColor];
            lableLinkMobile.font = [UIFont systemFontOfSize:14];
            
            lableLinkMobile.text = [NSString stringWithFormat:@"关联手机:%@",device.strDeviceMobile];
            [cell.contentView addSubview:lableLinkMobile];
            
//            xposition = lableLinkMobile.frame.origin.x+lableLinkMobile.frame.size.width+5;
//
//            
//            UILabel *lableRelation= [[UILabel alloc] initWithFrame:CGRectMake(xposition, yposition, cell.frame.size.width-(xposition+10), 20)];
//            lableRelation.backgroundColor = [UIColor clearColor];
//            lableRelation.textColor  =[UIColor darkGrayColor];
//            lableRelation.font = [UIFont systemFontOfSize:14];
//            
//            lableRelation.text = [NSString stringWithFormat:@"关系:%@",device.strDeviceMobile];
//            [cell.contentView addSubview:lableRelation];
            
            
            yposition = lableLinkMobile.frame.origin.y+lableLinkMobile.frame.size.height+5;
            
            UILabel *lableHealthInfo = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+10), 20)];
            lableHealthInfo.backgroundColor = [UIColor clearColor];
            lableHealthInfo.textColor  =[UIColor blackColor];
            lableHealthInfo.font = [UIFont systemFontOfSize:14];
            lableHealthInfo.numberOfLines = 0;
            lableHealthInfo.lineBreakMode = kUILineBreakModeWordWrap;
            lableHealthInfo.text = [NSString stringWithFormat:@"健康状态:%@",device.strHealthInfo];
            [cell.contentView addSubview:lableHealthInfo];
            
            CGSize size = [lableHealthInfo.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-(lableNick.frame.origin.x+10), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:lableHealthInfo.font,NSFontAttributeName, nil] context:nil].size;
            
            lableHealthInfo.frame = CGRectMake(lableHealthInfo.frame.origin.x, lableHealthInfo.frame.origin.y, size.width, size.height);
            
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, lableHealthInfo.frame.origin.y+size.height+5);
            
            
        }
        
    }
    else if (currentViewType == subViewPersonListViewDefault)
    {
        if([self.dataSource count])
        {
            DataObjectMyDeviceList *device =[self.dataSource objectAtIndex:indexPath.section];
            if(device.subArrayObject!= nil && [device.subArrayObject count])
            {
                DataObjectMyDeviceList *subDevice =[device.subArrayObject objectAtIndex:indexPath.row];
                
                cell.textLabel.text = subDevice.strNickName;
                
                NSLog(@"\n name :%@ \n",subDevice.strNickName);
                
            }
            
            
        }
        else
        {
            
        }
    }
    
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
    
    if(currentViewType == subViewDeviceList) //进入设置界面
    {
        if([self.dataSource count])
        {
            DataObjectMyDeviceList *device =[self.dataSource objectAtIndex:indexPath.row];
            
            NSString *str = [NSString stringWithFormat:@"手表设置-%@",device.strDeviceOwnerName];
            
            WatchSettingViewController *watch = [[WatchSettingViewController alloc]initWithDeive:device];
            watch.title =str;
            watch.navigationItem.title = str;
            [self.navigationController pushViewController:watch animated:YES];
            
        }
    }
    else
    {
        if([self.dataSource count])
        {
            DataObjectMyDeviceList *device =[self.dataSource objectAtIndex:indexPath.section];
            if(device.subArrayObject!= nil && [device.subArrayObject count])
            {
                DataObjectMyDeviceList *subDevice = [device.subArrayObject objectAtIndex:indexPath.row];
                
                DetailViewController *dt = [[DetailViewController alloc]initWithPersonName:subDevice.strGuardianManDeviceId];
                dt.title =@"实时追踪";
                [self.navigationController pushViewController:dt animated:YES];
            }
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
    
    id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeMyDeviceList];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            [SVProgressHUD dismiss];
            
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
                
                self.tableView.alpha = 1.0;
                
                [self.tableView reloadData];
    
            }
            
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
            
            
        }
    }
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
