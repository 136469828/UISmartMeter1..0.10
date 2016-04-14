//
//  MenuSelectViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 14-10-9.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "MasterViewController.h"


typedef enum
{
    menuTypeService = 0,
    menuTypeCommunication
}menuSelectType;

@interface MenuSelectViewController : MasterViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mTableView;
    NSMutableArray *mTableviewArr;
    
    menuSelectType menuType;
    
}

-(id)initWithMenuSelectType:(menuSelectType)sType;

@end
