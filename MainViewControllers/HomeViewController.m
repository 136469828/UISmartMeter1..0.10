//
//  HomeViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-4-7.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "GoogleMapShow.h"

#import "EGOImageView.h"
#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"健康";

    netWorkType = netTypeDefult;
    
//    api = [[AibangApi alloc] init];
//    api.delegate = self;
    
    page = 1;
    pageSize = 20;
    
//    self.strCity = @"深圳";
    
    locationInfo *location = [locationInfo shareInstance];

    if(location.longtitude!=nil && [location.longtitude length]>0 && location.laitude!=nil && [location.laitude length]>0)
    {
        
    }
    else
    {
        if(mLocationManager)
        {
            [mLocationManager startCLLocationManager:YES needPopConfirmAlert:NO];
        }
        else
        {
            mLocationManager = [[CustomLocationManager alloc] init:self];
            [mLocationManager startCLLocationManager:YES needPopConfirmAlert:NO];
        }

    }

    [self setRightButtonWithTitle:@"地图模式" textFont:15 withBackGroundColor:[UIColor clearColor] titleColor:[UIColor clearColor] withBackImage:nil withFrame:CGRectMake(0, 0, 0, 0) isRightButton:YES];
    
    [self loadDataSource];
    
    
}

-(void)rightButton
{
    
    GoogleMapShow *googleShow = [[GoogleMapShow alloc] initWithDataSource:self.dataSource withMapType:mapTypeReadRouteBusiness];
    
    googleShow.title = @"地图";
    googleShow.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    bar.tintColor = [UIColor colorWithRed:248.0/255.0 green:167.0/255.0 blue:0.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:bar];
    [self.navigationController pushViewController: googleShow animated:YES];
    
    //[UIView beginAnimations:@"animation" context:nil];
    //[UIView setAnimationDuration:0.75];
    
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    //[UIView commitAnimations];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self reloadTableView];
    
}

#pragma mark start GPS delegate
#pragma mark -
#pragma mark -
- (void)locationValue:(CustomLocationManager *)location;
{
    
    DEBUG_NSLOG(@"\n\n appdelegate did get location \n\n");
    
}
- (void)unLocationValue:(CustomLocationManager *)location;
{
    DEBUG_NSLOG(@"\n\n appdelegate did not get location \n\n");
}

-(void)didGetGeoDetailAddress:(CustomLocationManager *)location
{
    
}


-(void)loadDataSource
{
    locationInfo *location = [locationInfo shareInstance];

    NSString *strPage = [NSString stringWithFormat:@"%d",page];
    
    NSLog(@"\n\n newdelegate.strcurrentLng :%@ \n\n",location.longtitude);
    
    NSLog(@"\n\n newdelegate.strcurrentLat :%@ \n\n",location.laitude);
    
    
    NSLog(@"\n\n appDelegate.currentCity :%@\n\n",self.strCity);
    
//    [api searchBizWithCity:@"深圳市"
//                     Query:@"健身中心"
//                   Address:@""
//                  Category:@""
//                       Lng:nil
//                       Lat:nil
//                    Radius:@"0"
//                  Rankcode:@"2"
//                      From:strPage
//                        To:@"20"];

}

#pragma mark-
#pragma mark- tableView 协议方法

// TODO:  -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource != nil && [self.dataSource count] >0) {
        
        if ([self.dataSource count] < allCount) {
            
            return [self.dataSource count] +1;
        }
        else
        {
            return [self.dataSource count];
        }
        
    }
    
    if([self.dataSource count])
    {
        
        
        return [self.dataSource count];
    }

    return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.dataSource count])
    {
        
        if(indexPath.row == [self.dataSource count])
        {
            return 44;
        }
        
        return 84.0;
    }
    
    
    
    return 44.0;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.dataSource count])
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell != nil)
        {
            for (UIView *subView in cell.contentView.subviews)
            {
                
                if ([subView isMemberOfClass:[UIActivityIndicatorView class]]) {
                    
                    UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*)subView;
                    activityIndicatorView.alpha = 1.0;
                    [activityIndicatorView startAnimating];
                    break;
                }
                
                if ([subView isMemberOfClass:[UILabel class]]) {
                    
                    UILabel *lable = (UILabel*)subView;
                    lable.text = @"正在载入";
                    break;
                }
            }
            
            
            netWorkType = netTypeMore;
            
            page++;
            
            
            [self loadDataSource];
        }
        
    }
    else
    {
        DataObjectSearch *dt = [self.dataSource objectAtIndex:indexPath.row];
        
        NSMutableArray *may = [NSMutableArray arrayWithObjects:dt, nil];
        
        GoogleMapShow *gog = [[GoogleMapShow alloc] initWithDataSource:may withMapType:mapTypeRoadRoute];
        gog.title = dt.strName;
        
        //    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        //    //barbutton.tintColor = [UIColor clearColor];
        //    barbutton.tintColor = [UIColor colorWithRed:248.0/255.0 green:167.0/255.0 blue:0.0 alpha:1];
        //
        //
        //    [self.navigationItem setBackBarButtonItem:barbutton];
        
        [self.navigationController pushViewController:gog animated:YES];
    }
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTable = @"customTableView";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strTable];
    
    for (id v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
        
    }
    
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTable];
    }
    
    if([self.dataSource count]>0)
    {
        if (indexPath.row == [self.dataSource count])
        {
            cell.accessoryType = UITableViewCellAccessoryNone;

            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            // last add Button
            UILabel *getMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 25)];
            getMoreLabel.text =  ZTTABLEVIEW_TITLE_GET_MORE;
            getMoreLabel.textAlignment = kUITextAlignmentCenter;
            getMoreLabel.textColor = [UIColor blackColor];
            getMoreLabel.font = [UIFont systemFontOfSize:18];
            getMoreLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:getMoreLabel];
            
            UIActivityIndicatorView *indicatorViewGetMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
            indicatorViewGetMore.frame = CGRectMake(15.0, 11.0, 20.0, 20.0);
            [cell.contentView addSubview:indicatorViewGetMore];
            indicatorViewGetMore.alpha = 0.0;
            //indicatorViewGetMore.alpha = 1.0;
            //[indicatorViewGetMore startAnimating];

            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            DataObjectSearch *dsearch = [self.dataSource objectAtIndex:indexPath.row];
            
            
            EGOImageView *imageView  =[[EGOImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 44+20, 44+20)];
            imageView.image = [UIImage imageNamed:@"admob-money"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            
            if(dsearch.img_url!=nil && [dsearch.img_url length]>0)
            {
                imageView.imageURL = [NSURL URLWithString:dsearch.img_url];
                
            }
            
            [cell.contentView addSubview:imageView];
            
            
            UILabel *tLable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+5, 10, self.view.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+15), 20)];
            tLable.numberOfLines = 1;
            tLable.lineBreakMode = NSLineBreakByClipping;
            tLable.backgroundColor = [UIColor clearColor];
            tLable.textColor = [UIColor blackColor];
            tLable.font = [UIFont systemFontOfSize:15.0];
            tLable.text = dsearch.strName;
            
            [cell.contentView addSubview:tLable];
            
            UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+5, tLable.frame.origin.y+tLable.frame.size.height+10, self.view.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+15), 15)];
            lbl.text = dsearch.cate;
            lbl.lineBreakMode = NSLineBreakByClipping;
            lbl.textColor = [UIColor blackColor];
            lbl.font = [UIFont systemFontOfSize:13.0f];
            [cell.contentView addSubview:lbl];
            
            
            NSLog(@"dsearch.dist :%@",dsearch.dist);
            
            int dis = [dsearch.dist floatValue]*1000;
            
            //        UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(69+5+120+30, lbl.frame.origin.y+lbl.frame.size.height+5, self.view.frame.size.width-(69+5+120+50), 15)];
            //        distance.text = [NSString stringWithFormat:@"约%d米",dis];
            //        distance.textColor = [UIColor blackColor];
            //        distance.font = [UIFont systemFontOfSize:14.0f];
            //        [cell.contentView addSubview:distance];
        }
        
        
        
    }
    
    
    return cell;
    
}
// TODO:  -(void) requestDidFailedWithError:(NSData*)data aibangApi:(id)aibangApi
//-(void) requestDidFailedWithError:(NSError*)error aibangApi:(id)aibangApi;
//{
//    [SVProgressHUD showErrorWithStatus:@"网络错误.."];
//    
//}
//
//// TODO:  -(void) requestDidFinishWithData:(NSData*)data aibangApi:(id)aibangApi
//-(void) requestDidFinishWithData:(NSData*)data aibangApi:(id)aibangApi
//{
//    
//    NSString* result = [[NSString alloc] initWithData:data
//                                             encoding:NSUTF8StringEncoding];
//
//    NSLog(@"result :%@",result);
//    
//    
//    if(data!=nil && [data length]>0)
//    {
//        if([self.dataSource count])
//        {
//            [self.dataSource addObjectsFromArray:[DataPaser returnDataWithData:data]];
//        }
//        else
//        {
//            self.dataSource = [DataPaser returnDataWithData:data];
//        }
//        
//        if([self.dataSource count]>0)
//        {
//            DataObjectSearch *se = [self.dataSource objectAtIndex:0];
//            
//            allCount = se.total;
//            
//            DEBUG_NSLOG(@"dataSource count :%d",[self.dataSource count]);
//            
//            [self reloadTableView];
//        }
//        else
//        {
//            
//        }
//        
//        [SVProgressHUD dismiss];
//        
//    }
//    
//    
//}


-(void)reloadTableView
{
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor  =[UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
