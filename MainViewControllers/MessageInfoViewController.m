//
//  MessageInfoViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "MJRefresh.h"

#import "AddViewController.h"

#import "MessageInfoViewController.h"

@implementation MessageInfoViewController

-(id)initWithMessageType:(messageType)mType withUserID:(NSString*)strID
{
    if(self = [super init])
    {
        currentMessageType = mType;
        
        if(strID !=nil)
        {
            self.strDetailID = strID;
        }
    }
    
    return self;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    netWorkType = netTypeDefult;
    
    self.view.backgroundColor = [UIColor whiteColor];

    if(currentMessageType == messageTypeTakeMedicineRemind)
    {
        UIImage *img = [UIImage imageNamed:@"barbuttonicon_add"];
        
        [self setRightButtonWithTitle:@"" textFont:15 withBackGroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] withBackImage:img withFrame:CGRectMake(0.0, 0.0, img.size.width, img.size.height) isRightButton:YES];
    }
    else
    {
        
    }
    
    [self getAlarmInfo];
    
}

#pragma mark- 获取报警信息 、我的提醒列表
-(void)getAlarmInfo
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    if(currentMessageType == messageTypeAlarmInfo)
    {
        [jsonService getAlarmInfomationWithPage:page pageSize:pageSize];
    }
    else if (currentMessageType == messageTypeTakeMedicineRemind)
    {
        [jsonService getMyReminderListWithPage:page pageSize:pageSize];
    }
    
}


#pragma mark- 设置下拉
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    
    // 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    
}


#pragma mark- 开始进入刷新状态
- (void)headerRereshing
{
    
    isNeedShow = NO;
    
    page = 1;
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self getAlarmInfo];
    
}

-(void)setFooterViewRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}


-(void)footerRereshing
{
    isNeedShow = NO;
    page ++;
    
    [self getAlarmInfo];
    
}


#pragma mark- 添加提醒
-(void)rightButton
{
    if(currentMessageType == messageTypeTakeMedicineRemind)
    {
        NSString *strTitle = @"添加提醒";
        
        AddViewController *addViewController = [[AddViewController alloc] initWithAddViewType:addTypeTakeMedicineRemind withObj:nil];
        addViewController.title = strTitle;
        addViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:addViewController animated:YES];
    }
    else
    {
        self.actionSheet = [[LXActionSheet alloc]initWithTitle:@"清除消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认清除" otherButtonTitles:nil];
        [self.actionSheet showInView:self.view];
    }
    

}


#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    DEBUG_NSLOG(@"%d",(int)buttonIndex);
}

- (void)didClickOnDestructiveButton
{
    DEBUG_NSLOG(@"destructuctive");
}

- (void)didClickOnCancelButton
{
    DEBUG_NSLOG(@"cancelButton");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableViewStyle = UITableViewStylePlain;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    [ToolSet setExtraCellLineHidden:self.tableView];

    
}

//
//-(void)btnKeep
//{
//    
//}

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
    [bookBut setTitle:@"提醒设置" forState:UIControlStateNormal];
    [bookBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBut.layer.cornerRadius = 3.0;
    bookBut.titleLabel.font = [UIFont systemFontOfSize:20.0];
    bookBut.showsTouchWhenHighlighted = YES;
    [bookBut setBackgroundColor:[UIColor colorWithRed:158.0/255.0 green:205.0/255.0 blue:85.0/255.0 alpha:1.0]];
    [footView addSubview:bookBut];
    
    
}


#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    
    if([self.dataSource count])
    {
        DataObjectAlarmInfo *alarmInfo  =[self.dataSource objectAtIndex:indexPath.row];
        
        if(currentMessageType == messageTypeAlarmInfo)
        {
            CGFloat xposition = 10;
            CGFloat yposition = 15;
            
            UILabel *lableNick = [[UILabel alloc] initWithFrame:CGRectMake(xposition, 10, cell.frame.size.width-(xposition+10), 20)];
            lableNick.backgroundColor = [UIColor clearColor];
            lableNick.textColor  =[UIColor blackColor];
            lableNick.font = [UIFont systemFontOfSize:15];
            
            lableNick.text = [NSString stringWithFormat:@"昵称:%@",alarmInfo.strOwnerName
                              ];
            [cell.contentView addSubview:lableNick];
            
            yposition = lableNick.frame.origin.y+lableNick.frame.size.height+5;
            
            UILabel *lableDateTime = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+10), 20)];
            lableDateTime.backgroundColor = [UIColor clearColor];
            lableDateTime.textColor  =[UIColor darkGrayColor];
            lableDateTime.font = [UIFont systemFontOfSize:14];
            
            lableDateTime.text = [NSString stringWithFormat:@"日期:%@",alarmInfo.strCreateTime];
            NSLog(@"%@",lableDateTime.text);
            
            [cell.contentView addSubview:lableDateTime];
            
            
            yposition = lableDateTime.frame.origin.y+lableDateTime.frame.size.height+5;
            
            UILabel *lableMsgInfo = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+10), 20)];
            lableMsgInfo.backgroundColor = [UIColor clearColor];
            lableMsgInfo.textColor  =[UIColor darkGrayColor];
            lableMsgInfo.font = [UIFont systemFontOfSize:14];
            lableMsgInfo.numberOfLines = 0;
            lableMsgInfo.lineBreakMode = kUILineBreakModeWordWrap;
            lableMsgInfo.text = [NSString stringWithFormat:@"报警信息:%@",alarmInfo.strAlarmContent];
            [cell.contentView addSubview:lableMsgInfo];
            
            CGSize size = [lableMsgInfo.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-(lableNick.frame.origin.x+10), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:lableMsgInfo.font,NSFontAttributeName, nil] context:nil].size;
            
            lableMsgInfo.frame = CGRectMake(lableMsgInfo.frame.origin.x, lableMsgInfo.frame.origin.y, size.width, size.height);
            
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, lableMsgInfo.frame.origin.y+size.height+5);

        }
        else if (currentMessageType == messageTypeTakeMedicineRemind)
        {
            CGFloat xposition = 10;
            CGFloat yposition = 15;
            
            UILabel *lableNick = [[UILabel alloc] initWithFrame:CGRectMake(xposition, 10, cell.frame.size.width-(xposition+10), 20)];
            lableNick.backgroundColor = [UIColor clearColor];
            lableNick.textColor  =[UIColor blackColor];
            lableNick.font = [UIFont systemFontOfSize:15];
            
            lableNick.text = [NSString stringWithFormat:@"昵称:%@(电话:%@)",alarmInfo.strOwnerName,alarmInfo.strMobile];
            [cell.contentView addSubview:lableNick];
            
            yposition = lableNick.frame.origin.y+lableNick.frame.size.height+5;
            
            UILabel *lableDateTime = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+10), 20)];
            lableDateTime.backgroundColor = [UIColor clearColor];
            lableDateTime.textColor  =[UIColor darkGrayColor];
            lableDateTime.font = [UIFont systemFontOfSize:14];
            
            lableDateTime.text = [NSString stringWithFormat:@"日期:%@",alarmInfo.strCreateTime];

            [cell.contentView addSubview:lableDateTime];
            
            
            yposition = lableDateTime.frame.origin.y+lableDateTime.frame.size.height+5;
            
            UILabel *lableMsgInfo = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+10), 20)];
            lableMsgInfo.backgroundColor = [UIColor clearColor];
            lableMsgInfo.textColor  =[UIColor darkGrayColor];
            lableMsgInfo.font = [UIFont systemFontOfSize:14];
            lableMsgInfo.numberOfLines = 0;
            lableMsgInfo.lineBreakMode = kUILineBreakModeWordWrap;
            lableMsgInfo.text = [NSString stringWithFormat:@"提醒信息:%@",alarmInfo.strAlarmContent];
            [cell.contentView addSubview:lableMsgInfo];
            
            CGSize size = [lableMsgInfo.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-(lableNick.frame.origin.x+10), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:lableMsgInfo.font,NSFontAttributeName, nil] context:nil].size;
            
            lableMsgInfo.frame = CGRectMake(lableMsgInfo.frame.origin.x, lableMsgInfo.frame.origin.y, size.width, size.height);
            
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, lableMsgInfo.frame.origin.y+size.height+5);
            
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
    id obj = nil;
    if(request.tag == 108)
    {
        obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeAlarmInfo];
    }
    else if (request.tag == 1088)
    {
        obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeMyRemindInfo];
    }
    
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
                    if(self.dataSource == nil)
                    {
                        self.dataSource = [[NSMutableArray alloc ]init];
                    }
                    else
                    {
                        [self.dataSource removeAllObjects];
                    }
                    
                    [self.dataSource addObjectsFromArray:tempObject.arrObjects];
                }
                else
                {
                    if(self.dataSource == nil)
                    {
                        self.dataSource = [[NSMutableArray alloc ]init];
                    }
                    
                    [self.dataSource addObjectsFromArray:tempObject.arrObjects];
                }

                [self.tableView reloadData];

            }
            
            
        }
        else
        {
            if (tempObject.strMessage == nil || [tempObject.strMessage isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:@"查询不到提醒信息"];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
            }

            
            
        }
    }
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}


@end
