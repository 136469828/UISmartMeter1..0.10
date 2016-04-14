//
//  GraphViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-16.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//


#import "FSLineChart.h"
#import "UIColor+FSPalette.h"

#import "MasterViewController.h"

typedef enum
{
    healthTypeBloodPressure = 0,
    healthTypeBloodSugar,
    healthTypeHealthSport,
    healthTypeHealthPlus,
    healthTypeHeartRate
    
}healthViewType;

@interface GraphViewController : MasterViewController<UIScrollViewDelegate>
{
    
    UIView *menuView;
    
    int currentIndex; // 当前页  默认是中间 第九页
    
    NSInteger currentYearValue;
    
    CGFloat historyX;
    
    BOOL isLeft;
    
    UIScrollView *mScrollView;
    
    NSMutableArray *mItemNameArray;

    FSLineChart* lineChart;
    
    healthViewType currentHealthType;
    
}

@property(nonatomic,strong)NSMutableArray *buttons;


@property(nonatomic,strong)NSString *strDate;

@property(nonatomic,strong)NSString *strScrollYear; // 滑动的年

@property(nonatomic,strong)NSString *strDeviceID;

-(id)initWithViewType:(healthViewType)healType withDeviceID:(NSString*)strDeviceId;

@end
