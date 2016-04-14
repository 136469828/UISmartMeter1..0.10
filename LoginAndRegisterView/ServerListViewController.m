//
//  ServerListViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 16/2/4.
//  Copyright © 2016年 RealTmac . All rights reserved.
//

#import "UISmartMeterAppDelegate.h"

#import "ServerListViewController.h"

extern UISmartMeterAppDelegate *appDelegate;

@interface ServerListViewController ()

@end

@implementation ServerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"请选择服务器";
    
    [self getServerList];
    
    // Do any additional setup after loading the view.
}



-(void)drawTableView
{
    if(mTableView == nil)
    {
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        mTableView.backgroundColor = [UIColor clearColor];
        mTableView.backgroundView = nil;
        mTableView.dataSource = self;
        mTableView.delegate = self;
        
        [self.view addSubview:mTableView];
    }
    else
    {
        [mTableView reloadData];
    }
    
}


/**
 *  获取服务器列表
 */
-(void)getServerList
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService getServerURLList];

}


#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if([dataSource count])
    {
        DataObjectServerObject *serverObject  =[dataSource objectAtIndex:indexPath.row];
        
        cell.textLabel.text = serverObject.strServerName;
        cell.detailTextLabel.text = serverObject.strApiDomain;
        
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([dataSource count])
    {
        DataObjectServerObject *serverObject  =[dataSource objectAtIndex:indexPath.row];
        
        if([serverObject.strApiDomain length])
        {
            [FileOperation saveConfigKey:SERVERURLADDRESS value:serverObject.strApiDomain];
            
            [FileOperation saveConfigKey:kSocketServerIP value:serverObject.strIP];
            [FileOperation saveConfigKey:kSokectServerPort value:serverObject.strPort];
            
            [appDelegate resetRootViewIsLoginOut:YES];
            
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
    
    id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeGetServerURL];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            [SVProgressHUD dismiss];
            
            if([tempObject.arrObjects count])
            {
                if(dataSource == nil)
                {
                    dataSource = [[NSMutableArray alloc ]init];
                }
                else
                {
                    [dataSource removeAllObjects];
                }
                
                [dataSource addObjectsFromArray:tempObject.arrObjects];
                
                [self drawTableView];
                
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




/**
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
