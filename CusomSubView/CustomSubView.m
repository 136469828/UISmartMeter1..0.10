//
//  CustomSubView.m
//  UIOverseasExamination
//
//  Created by RealTmac on 14-12-9.
//  Copyright (c) 2014年 Meten. All rights reserved.
//

#import "Util.h"


#import "SHLineGraphView.h"
#import "SHPlot.h"

#import "ToolSet.h"

#import "NSString+Helpers.h"

#import "NSDate+Helper.h"

#import "CustomSubView.h"


@implementation CustomSubView

#pragma mark- 我的课表
- (id)initWithFrame:(CGRect)frame  withDelegate:(UIViewController *)paramDelegate withViewTag:(NSInteger)viewTag withDate:(NSString*)strDate withViewType:(healthViewType)subType withDeviceID:(NSString*)strDevID
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isNeedShow  =YES;
        
        self.strDeviceID = strDevID;
        
        self.strCurrentDate = strDate;
        
        self.currentDate = [strDate dateFromISO8601];
        
        self.strMondayDate = [Util returnCurrentDateIsEndDate:NO withDate:self.currentDate];
        
        self.strSatadayDate = [Util returnCurrentDateIsEndDate:YES withDate:self.currentDate];
        
        //self.strMondayDate = @"2014-11-22";
        
        DEBUG_NSLOG(@"New 周一时间:%@",self.strMondayDate);
        
        self.dayArray = [self switchDay];
        
        self.mDelegate = paramDelegate;
        requestIndex = viewTag;
        
        subViewType = subType;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self showTipView];
        
        curPage = 1;
        pageSize = 20;
        
        [self loadDataSource];
        
    }
    
    return self;
}


-(void)showTipView
{
    tmpTipLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 124, self.frame.size.width, 44)];
    tmpTipLable.backgroundColor = [UIColor clearColor];
    tmpTipLable.font = [UIFont systemFontOfSize:16];
    tmpTipLable.textAlignment = kUITextAlignmentCenter;
    tmpTipLable.text = @"您还没有登录哦~";
    tmpTipLable.textColor = [UIColor darkGrayColor];
    [self addSubview:tmpTipLable];
    
    [tmpTipLable setHidden:YES];
}


#pragma mark- 获取数据
-(void)loadDataSource
{
    
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    NSString *strMethod = @"";
    
    if(subViewType == healthTypeBloodPressure)
    {
        strMethod =@"GetHealthBloodPressure";
    }
    else if (subViewType == healthTypeBloodSugar)
    {
        strMethod =@"GetHealthBloodSugar";
    }
    else if (subViewType == healthTypeHealthPlus)//睡眠
    {
        strMethod =@"GetHealthPulse";
    }
    else if (subViewType == healthTypeHealthSport)//运动
    {
        strMethod =@"GetHealthSport";
    }
    else if (subViewType == healthTypeHeartRate)
    {
        strMethod =@"GetHealthHeartRate";
    }
    
    //self.strMondayDate =@"2015-01-25";
    //self.strSatadayDate = @"2015-01-31";
    
    
    [jsonService getHealthInfoWithDeviceID:self.strDeviceID withMethodName:strMethod beginDate:self.strMondayDate endDate:self.strSatadayDate];

}

NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};


#pragma mark -
#pragma mark - drawSubView
-(void)drawSubView
{
    
    if([mTableviewArr count])
    {
        
        //initate the graph view
        SHLineGraphView *_lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 300)];
        
        NSDictionary *_themeAttributes = @{
                                           kXAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                           kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                           kYAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                           kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                           kYAxisLabelSideMarginsKey : @20,
                                           kPlotBackgroundLineColorKye : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4]
                                           };
        _lineGraph.themeAttributes = _themeAttributes;
        
        NSMutableArray *lowArray = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray *highArray = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray *tmp2 = [[NSMutableArray alloc]init];
        NSMutableArray *tmp3 = [[NSMutableArray alloc]init];
        
        
        NSMutableArray *tmpX = [[NSMutableArray alloc]init];
        
        if(subViewType == healthTypeBloodPressure)
        {
            for(int i=0;i<[mTableviewArr count];i++)
            {
                DataObjectHealth *health = [mTableviewArr objectAtIndex:i];
                
                NSNumber *numHigh = [NSNumber numberWithInt:[health.strHighPressure intValue]];
                
                NSNumber *numlow = [NSNumber numberWithInt:[health.strLowPressure intValue]];
                
                [tmp2 addObject:numHigh];
                
                [tmp3 addObject:numlow];
                
                NSString *str = [NSString stringWithFormat:@"%d",i+1];
                
                NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithObject:numlow forKey:str];
                
                NSMutableDictionary *mdict2 = [NSMutableDictionary dictionaryWithObject:numHigh forKey:str];
                
                [lowArray addObject:mdict];
                [highArray addObject:mdict2];
                
                NSString *strDate = [Util dateStrWithOriginalString:health.strCreateTime FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy/M/d"];
                
                NSMutableDictionary *mdict3 = [NSMutableDictionary dictionaryWithObject:strDate forKey:str];
                
                [tmpX addObject:mdict3];
                
            }
            
            
            NSArray *array = [tmp2 sortedArrayUsingComparator:cmptr];
            NSString *max = [array lastObject];
            
            NSArray *array2 = [tmp3 sortedArrayUsingComparator:cmptr];
            NSString *min = [array2 firstObject];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, _lineGraph.frame.origin.y+_lineGraph.frame.size.height+25, self.frame.size.height-30, 20)];
            lable.backgroundColor  =[UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"最高血压值：%@",max];
            lable.textColor = [UIColor darkGrayColor];
            lable.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable];
            
            
            UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(15, lable.frame.origin.y+lable.frame.size.height+15, self.frame.size.height-30, 20)];
            lable2.backgroundColor  =[UIColor clearColor];
            lable2.text = [NSString stringWithFormat:@"最低血压值：%@",min];
            lable2.textColor = [UIColor darkGrayColor];
            lable2.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable2];
            
        }
        else if(subViewType == healthTypeBloodSugar)
        {
            for(int i=0;i<[mTableviewArr count];i++)
            {
                DataObjectHealth *health = [mTableviewArr objectAtIndex:i];
                
                NSNumber *numHigh = [NSNumber numberWithInt:[health.strSugarValue intValue]];
                
                
                [tmp2 addObject:numHigh];
                
                NSString *str = [NSString stringWithFormat:@"%d",i+1];
                
                NSMutableDictionary *mdict2 = [NSMutableDictionary dictionaryWithObject:numHigh forKey:str];

                [highArray addObject:mdict2];
                
                
                NSString *strDate = [Util dateStrWithOriginalString:health.strCreateTime FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy/M/d"];
                
                NSMutableDictionary *mdict3 = [NSMutableDictionary dictionaryWithObject:strDate forKey:str];
                
                [tmpX addObject:mdict3];
                
            }
            
            NSArray *array = [tmp2 sortedArrayUsingComparator:cmptr];
            NSString *max = [array lastObject];
            
            NSString *min = [array firstObject];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, _lineGraph.frame.origin.y+_lineGraph.frame.size.height+25, self.frame.size.height-30, 20)];
            lable.backgroundColor  =[UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"最高血糖值：%@",max];
            lable.textColor = [UIColor darkGrayColor];
            lable.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable];

            
            UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(15, lable.frame.origin.y+lable.frame.size.height+15, self.frame.size.height-30, 20)];
            lable2.backgroundColor  =[UIColor clearColor];
            lable2.text = [NSString stringWithFormat:@"最低血糖值：%@",min];
            lable2.textColor = [UIColor darkGrayColor];
            lable2.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable2];
            
        }
        else if(subViewType == healthTypeHealthSport)
        {
            for(int i=0;i<[mTableviewArr count];i++)
            {
                DataObjectHealth *health = [mTableviewArr objectAtIndex:i];
                
                NSNumber *numHigh = [NSNumber numberWithInt:[health.strSoportValue intValue]];
                
                
                [tmp2 addObject:numHigh];
                
                NSString *str = [NSString stringWithFormat:@"%d",i+1];
                
                
                NSMutableDictionary *mdict2 = [NSMutableDictionary dictionaryWithObject:numHigh forKey:str];
                
                //NSString *strLow = health.strLowPressure;
                //NSString *strHigh = health.strHighPressure;
                
                [highArray addObject:mdict2];
                
                NSString *strDate = [Util dateStrWithOriginalString:health.strCreateTime FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy/M/d"];
                
                NSMutableDictionary *mdict3 = [NSMutableDictionary dictionaryWithObject:strDate forKey:str];
                
                [tmpX addObject:mdict3];
            }
            
            NSArray *array = [tmp2 sortedArrayUsingComparator:cmptr];
            NSString *max = [array lastObject];
            
            NSString *min = [array firstObject];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, _lineGraph.frame.origin.y+_lineGraph.frame.size.height+25, self.frame.size.height-30, 20)];
            lable.backgroundColor  =[UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"最大肺活量：%@",max];
            lable.textColor = [UIColor darkGrayColor];
            lable.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable];
            
            
            UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(15, lable.frame.origin.y+lable.frame.size.height+15, self.frame.size.height-30, 20)];
            lable2.backgroundColor  =[UIColor clearColor];
            lable2.text = [NSString stringWithFormat:@"最小肺活量：%@",min];
            lable2.textColor = [UIColor darkGrayColor];
            lable2.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable2];
            
            
        }
        else if(subViewType == healthTypeHealthPlus)
        {
            for(int i=0;i<[mTableviewArr count];i++)
            {
                DataObjectHealth *health = [mTableviewArr objectAtIndex:i];
                
                NSNumber *numHigh = [NSNumber numberWithInt:[health.strPlusTimes intValue]+1];
                
                
                [tmp2 addObject:numHigh];
                
                NSString *str = [NSString stringWithFormat:@"%d",i+1];

                NSMutableDictionary *mdict2 = [NSMutableDictionary dictionaryWithObject:numHigh forKey:str];
                
                //NSString *strLow = health.strLowPressure;
                //NSString *strHigh = health.strHighPressure;
                
                [highArray addObject:mdict2];
                
                NSString *strDate = [Util dateStrWithOriginalString:health.strCreateTime FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy/M/d"];
                
                NSMutableDictionary *mdict3 = [NSMutableDictionary dictionaryWithObject:strDate forKey:str];
                
                [tmpX addObject:mdict3];
            }
            
            NSArray *array = [tmp2 sortedArrayUsingComparator:cmptr];
            NSString *max = [array lastObject];
            
            NSString *min = [array firstObject];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, _lineGraph.frame.origin.y+_lineGraph.frame.size.height+25, self.frame.size.height-30, 20)];
            lable.backgroundColor  =[UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"最高脉搏值：%@",max];
            lable.textColor = [UIColor darkGrayColor];
            lable.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable];
            
            
            UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(15, lable.frame.origin.y+lable.frame.size.height+15, self.frame.size.height-30, 20)];
            lable2.backgroundColor  =[UIColor clearColor];
            lable2.text = [NSString stringWithFormat:@"最低脉搏值：%@",min];
            lable2.textColor = [UIColor darkGrayColor];
            lable2.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable2];

            
            //return;
            
        }
        else if(subViewType == healthTypeHeartRate)
        {
            for(int i=0;i<[mTableviewArr count];i++)
            {
                DataObjectHealth *health = [mTableviewArr objectAtIndex:i];
                
                NSNumber *numHigh = [NSNumber numberWithInt:[health.strHeartTimes intValue]];
                
                [tmp2 addObject:numHigh];
                
                NSString *str = [NSString stringWithFormat:@"%d",i+1];
                
                NSMutableDictionary *mdict2 = [NSMutableDictionary dictionaryWithObject:numHigh forKey:str];
                
                //NSString *strLow = health.strLowPressure;
                //NSString *strHigh = health.strHighPressure;
                
                [highArray addObject:mdict2];
                
                NSString *strDate = [Util dateStrWithOriginalString:health.strCreateTime FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy/M/d"];
                
                NSMutableDictionary *mdict3 = [NSMutableDictionary dictionaryWithObject:strDate forKey:str];
                
                [tmpX addObject:mdict3];
            }
            
            
            NSArray *array = [tmp2 sortedArrayUsingComparator:cmptr];
            NSString *max = [array lastObject];
            
            NSString *min = [array firstObject];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, _lineGraph.frame.origin.y+_lineGraph.frame.size.height+25, self.frame.size.height-30, 20)];
            lable.backgroundColor  =[UIColor clearColor];
            lable.text = [NSString stringWithFormat:@"最大心率值：%@",max];
            lable.textColor = [UIColor darkGrayColor];
            lable.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable];
            
            
            UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(15, lable.frame.origin.y+lable.frame.size.height+15, self.frame.size.height-30, 20)];
            lable2.backgroundColor  =[UIColor clearColor];
            lable2.text = [NSString stringWithFormat:@"最小心率值：%@",min];
            lable2.textColor = [UIColor darkGrayColor];
            lable2.font = [UIFont systemFontOfSize:16];
            [self addSubview:lable2];
        }
        
        NSArray *array = [tmp2 sortedArrayUsingComparator:cmptr];
        NSString *max = [array lastObject];
        
        NSLog(@"%@",max);
        
        _lineGraph.yAxisRange = @([max floatValue]*130/100);
        

        //_lineGraph.yAxisRange = @(100);
        
        _lineGraph.yAxisSuffix = @"";
        
        _lineGraph.xAxisValues =tmpX;
        SHPlot *_plot1 = [[SHPlot alloc] init];
        
        SHPlot *_plot2 = [[SHPlot alloc] init];
        
        _plot1.plottingValues = highArray;
        
        
        NSDictionary *_plotThemeAttributes = @{
                                               kPlotFillColorKey : [UIColor clearColor],
                                               kPlotStrokeWidthKey : @2,
                                               kPlotStrokeColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                               kPlotPointFillColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                               kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                               };
        
        if([lowArray count])
        {
            _plot2.plottingValues = lowArray;

            _plot2.plotThemeAttributes = _plotThemeAttributes;
            
            [_lineGraph addPlot:_plot2];
        }
        
        NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7" , @"8", @"9", @"10", @"11", @"12",@"13", @"14", @"15", @"16"];
        _plot1.plottingPointsLabels = arr;
        
        //set plot theme attributes
        
        /**
         *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
         *  is applied selected and the graph is plotted with those default settings.
         */
        
        
        
        _plot1.plotThemeAttributes = _plotThemeAttributes;
        [_lineGraph addPlot:_plot1];
        
        //You can as much `SHPlots` as you can in a `SHLineGraphView`
        
        [_lineGraph setupTheView];
        
        [self addSubview:_lineGraph];

        
        
    }
    
}


#pragma mark-
-(NSInteger)weekDate:(NSDate*)date
{
    // 获取当前年月日和周几
    //    NSDate *_date=[NSDate date];
    NSCalendar *_calendar=[NSCalendar currentCalendar];
    NSInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *com=[_calendar components:unitFlags fromDate:date];
    NSString *_dayNum=@"";
    NSInteger dayInt = 0;
    switch ([com weekday]) {
        case 1:{
            _dayNum=@"日";
            dayInt = 1;
            break;
        }
        case 2:{
            _dayNum=@"一";
            dayInt = 2;
            break;
        }
        case 3:{
            _dayNum=@"二";
            dayInt = 3;
            break;
        }
        case 4:{
            _dayNum=@"三";
            dayInt = 4;
            break;
        }
        case 5:{
            _dayNum=@"四";
            dayInt = 5;
            break;
        }
        case 6:{
            _dayNum=@"五";
            dayInt = 6;
            break;
        }
        case 7:{
            _dayNum=@"六";
            dayInt = 7;
            break;
        }
            
            
        default:
            break;
    }
    
    return dayInt;
}


-(NSMutableArray*)switchDay
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    int head = 0;
    int foot = 0;
    switch ([self weekDate:self.currentDate]) {
        case 1:{
            head = 0;
            foot = 6;
            break;
        }
        case 2:{
            head = 1;
            foot = 5;
            break;
        }
        case 3:{
            head = 2;
            foot = 4;
            break;
        }
        case 4:{
            head = 3;
            foot = 3;
            break;
        }
        case 5:{
            head = 4;
            foot = 2;
            break;
        }
        case 6:{
            head = 5;
            foot = 1;
            break;
        }
        case 7:{
            head = 6;
            foot = 0;
            break;
        }
            
            
        default:
            break;
    }
    
    NSLog(@"%d , %d", head, foot);
    

    for (int i = -head; i < 0; i++)// 前面
    {
        NSDate *choseDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([self.currentDate timeIntervalSinceReferenceDate]+i*24*3600)];
        
        DEBUG_NSLOG(@"\n\n choseDate %@ \n\n",choseDate);
        
        NSString* str = [NSString stringWithFormat:@"%d",[CalendarDateUtil getDayWithDate:choseDate]];
        [array addObject:str];
    }
    
    [array addObject:[NSString stringWithFormat:@"%d", [CalendarDateUtil getDayWithDate:self.currentDate]]];
    
    //sy 添加日期
    int tempNum = 1;
    for (int i = 0; i < foot; i++)
    {
        
        NSDate *choseDate=[[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([self.currentDate timeIntervalSinceReferenceDate]+tempNum*24*3600)];
        
        DEBUG_NSLOG(@"\n\n choseDate %@ \n\n",choseDate);
        
        NSString* str = [NSString stringWithFormat:@"%d",[CalendarDateUtil getDayWithDate:choseDate]];

        
        //NSString* str = [NSString stringWithFormat:@"%d", [CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:tempNum]]];
        [array addObject:str];
        tempNum++;
        
        
        NSLog(@"str = %d", [array count]);
    }
    
    NSLog(@"weekArray = %d", [array count]);
    
    return array;
}


#pragma mark -
#pragma mark - netWork delegate
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request
{
   [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeNone];
}


-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    id obj = nil;
    
    obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeHealthItems];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            tmpTipLable.hidden = YES;
            tmpTipLable.text = @"";
            
            if([tempObject.arrObjects count])
            {
                [SVProgressHUD dismiss];
                
                if(mTableviewArr == nil)
                {
                    mTableviewArr = [[NSMutableArray alloc ]init];
                    
                }
                else
                {
                    [mTableviewArr removeAllObjects];
                }
                
                [mTableviewArr addObjectsFromArray:tempObject.arrObjects];
                
                [self drawSubView];
                
            }
            else
            {
                [SVProgressHUD dismissWithSuccess:@"暂无健康信息哦~"];
                
            }
            
        }
        else
        {
            [SVProgressHUD dismiss];

            
            if(tempObject.intSuccess == 1001)
            {
                if([tempObject.strMessage length])
                {
                    tmpTipLable.hidden = NO;
                    tmpTipLable.text = tempObject.strMessage;
                }
                else
                {
                    tmpTipLable.hidden = NO;
                    tmpTipLable.text = NODATA;
                    
                }
            }
            else
            {
                tmpTipLable.hidden = NO;
                tmpTipLable.text = @"请求异常，请重试~";
                
            }

            
        }
    }

}


-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [SVProgressHUD dismissWithError:requestStr];

}



@end
