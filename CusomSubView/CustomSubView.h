//
//  CustomSubView.h
//  UIOverseasExamination
//
//  Created by RealTmac on 14-12-9.
//  Copyright (c) 2014年 Meten. All rights reserved.
//

#import "globalConfig.h"

#import "CalendarDateUtil.h"
#import "JsonService.h"

#import "DataObject.h"
#import "DataPaser.h"

#import "Constants.h"

#import "GraphViewController.h"

#import "SVProgressHUD.h"

#import <UIKit/UIKit.h>


@interface CustomSubView : UIView
{
    UITableView	*mTableView;
    NSMutableArray *mTableviewArr;
    
    UIScrollView *mScrollView;
    
    NSMutableDictionary *mDateDict;
    
    UILabel *tmpTipLable;
    
    
    int curPage;
    int pageSize;
    int allCount;
    
    NetType mNetWorkType;
    
    int intStartDate; // 开始日期的天 值在1-31之间
    int intEndDate;   // 结束日期的天 值在1-31之间
    
    
    NSInteger curDeletIndex;
        
    UILabel *tipLable;
    
    int requestIndex;
    
    healthViewType subViewType;
    
    BOOL isNeedShow;
    
}

@property(nonatomic,strong)    NSString *strCourseName; // 当前科目的名称


@property(nonatomic,strong)    NSDate *currentDate;

@property(nonatomic,strong)    NSString *strMondayDate; // 星期一 的日期

@property(nonatomic,strong)    NSString *strSatadayDate; // 星期日 的日期

@property(nonatomic,strong)    NSString *strDeviceID;

@property(nonatomic,strong)    NSString *strCurrentDate;

@property(nonatomic,strong)    NSIndexPath *selectIndexPath;

@property(nonatomic,strong)    UIViewController           *mDelegate;

@property(nonatomic,strong)    NSMutableArray *weekArray; // 存储星期一到星期天

@property(nonatomic,strong)    NSMutableArray *timeArray; // 存储时间

@property(nonatomic,strong)    NSMutableArray *dayArray;  //  日期

#pragma mark- 我的课表
- (id)initWithFrame:(CGRect)frame  withDelegate:(UIViewController *)paramDelegate withViewTag:(NSInteger)viewTag withDate:(NSString*)strDate withViewType:(healthViewType)subType withDeviceID:(NSString*)strDevID;


@end
