//
//  UIHomeViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 14-9-25.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "CycleScrollView.h"

#import "JHTickerView.h"


#import "MasterViewController.h"

@interface UIHomeViewController : MasterViewController<UITableViewDataSource,UITableViewDelegate,scrollPageDelegate>
{
    JHTickerView *tickerView;

    NSString *strurlToItunes;
    
    
    UIPageControl *pageControl;

    
    UITableView *mTableView;
    NSMutableArray *mTableviewArr;
    
    NSMutableArray *menuBtnArray;
        
    UIView *contentView;
    
    UIScrollView *mScrollView;
    
    UIView *backView;
    
    BOOL getWeatherFailed; // 获取天气失败

    
    DataObjectWeather *newWeatherObject;
}



@end
