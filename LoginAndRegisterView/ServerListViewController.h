//
//  ServerListViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 16/2/4.
//  Copyright © 2016年 RealTmac QQ:1016159548. All rights reserved.
//

#import "MasterViewController.h"

/**
 *  获取服务器列表，仅第一次使用
 */
@interface ServerListViewController :MasterViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mTableView;
    
    NSMutableArray *dataSource;
}
@end
