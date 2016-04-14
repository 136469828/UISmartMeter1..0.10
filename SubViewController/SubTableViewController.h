//
//  SubTableViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-15.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "BaseTableViewController.h"


typedef enum
{
    subViewDeviceList = 0,             //设备列表
    subViewPersonListViewDefault,      //监护人列表
    
    subViewHealthListView,             //健康信息列表
    subViewOther                       //其他
    
    
}viewType;


@interface SubTableViewController : BaseTableViewController<UITextFieldDelegate>
{
    UITextField *fieldMobile;
    
    NSMutableArray *mTableArray;
    
    NSMutableArray *mPersonArray;
    
    viewType currentViewType;
}

-(id)initWithViewType:(viewType)vType;


@end
