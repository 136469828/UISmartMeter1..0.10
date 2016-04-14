//
//  GraphViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-16.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "CustomSubView.h"

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

-(id)initWithViewType:(healthViewType)healType withDeviceID:(NSString*)strDeviceId
{
    if(self = [super init])
    {
        self.strDeviceID = strDeviceId;
        
        currentHealthType = healType;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentIndex = 40;
    
    isLeft = NO;
    
    self.strDate = [Util dateToStringFromDate:[NSDate date]];

    
    mItemNameArray = [NSMutableArray arrayWithObjects:@"前一周",@"本周",@"后一周", nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(mScrollView == nil)
    {
        [self drawSubView];
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - animation
-(void)doSlideAnimatonWithIndex:(NSInteger)paramIndex
{
    
    for(int i=0;i<[self.buttons count];i++)
    {
        UIButton *btn = [self.buttons objectAtIndex:i];
        
        if(btn.tag == paramIndex)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnSelect"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:125./255. green:179./255. blue:64./255. alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnUnSelect"] forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        
    }
    
    
}

#pragma mark- 菜单事件
-(void)menuButClickOn:(UIButton*)btn
{
    if(btn.tag == 0) // 前一周
    {
        currentIndex --;

        isLeft = YES;
    }
    else if (btn.tag == 1) // 本周
    {
        currentIndex  = 40;
        
    }
    else if (btn.tag == 2) // 后
    {
        //限制不能查询查询当前日期后的数据
        
        if(currentIndex <80)
        {
            currentIndex ++;
        }
        
        isLeft = NO;

    }

    [self initWithViewIndex:currentIndex];
}


#pragma mark - subview
-(void)drawSubView
{
 
    menuView = [[UIView alloc ]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 38.0)];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.userInteractionEnabled = YES;
    [self.view addSubview:menuView];
    
    CGFloat x = 0.0;
    NSLog(@"%ld",mItemNameArray.count);
    for (int i = 0; i<[mItemNameArray count]; i++)
    {
        CGFloat buttonWidth = self.view.frame.size.width/3;
        
        UIButton *menuBut = [[UIButton alloc] initWithFrame:CGRectMake(x, 0.0, buttonWidth, menuView.frame.size.height)];
        menuBut.tag = i;
        [menuBut addTarget:self action:@selector(menuButClickOn:) forControlEvents:UIControlEventTouchUpInside];
        [menuBut setTitle:[mItemNameArray objectAtIndex:i] forState:UIControlStateNormal];
        menuBut.tag = i;
        menuBut.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [menuView addSubview:menuBut];
        menuBut.titleLabel.textAlignment = kUITextAlignmentCenter;
        [menuBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        x += buttonWidth;
        
        if (i == 1)
        {
            [menuBut setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnSelect"] forState:UIControlStateNormal];
            [menuBut setTitleColor:[UIColor colorWithRed:125./255. green:179./255. blue:64./255. alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            [menuBut setBackgroundImage:[UIImage imageNamed:@"imageMenuBtnUnSelect"] forState:UIControlStateNormal];
            
        }
        
        if(self.buttons == nil)
        {
            self.buttons = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        [self.buttons addObject:menuBut];
        
    }
    
    
    // 只能查询前后两个月
    
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,menuView.frame.origin.y+menuView.frame.size.height,self.view.frame.size.width, self.view.frame.size.height-(menuView.frame.origin.y+menuView.frame.size.height))];
    mScrollView.delegate = self;
    mScrollView.contentSize = CGSizeMake(self.view.frame.size.width*80, self.view.frame.size.height-(menuView.frame.origin.y+menuView.frame.size.height));
    mScrollView.pagingEnabled = YES;
    mScrollView.userInteractionEnabled = YES;
    mScrollView.bounces = YES;
    mScrollView.scrollEnabled = YES;
    mScrollView.backgroundColor = [UIColor whiteColor];
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mScrollView];
    
    [self initWithViewIndex:currentIndex];
    
}

#pragma mark -
- (void)initWithViewIndex:(NSInteger)_index
{
    
    DEBUG_NSLOG(@"current Index:%d",_index);
    
    NSDate *tmpDate = [NSDate dateFromString:self.strDate];
    
    DEBUG_NSLOG(@"self.strDate :%@",self.strDate);
    
    DEBUG_NSLOG(@"[Util dateToStringFromDate:[NSDate date]] :%@",[Util dateToStringFromDate:[NSDate date]]);
    
    
    
    
    
    if(isLeft == YES) // 前面课程
    {
        [self doSlideAnimatonWithIndex:0];
        
        if([self.strDate isEqualToString:[Util dateToStringFromDate:[NSDate date]]])
        {
            self.strDate = [Util dateToStringFromDate:[NSDate date]];
        }
        else
        {
            self.strDate = [Util dateToStringFromDate:[tmpDate dateAfterDay:-7]];
        }
        
        DEBUG_NSLOG(@"\n\n  前一个周日期 :%@ \n\n",self.strDate);
        
    }
    else //if (isLeft) // 后面课程
    {
        if(currentIndex == 40)
        {
            [self doSlideAnimatonWithIndex:1];
            
            self.strDate = [Util dateToStringFromDate:[NSDate date]];
        }
        else
        {
            [self doSlideAnimatonWithIndex:2];
            
            if([self.strDate isEqualToString:[Util dateToStringFromDate:[NSDate date]]])
            {
                self.strDate = [Util dateToStringFromDate:[NSDate date]];
            }
            else
            {
                self.strDate = [Util dateToStringFromDate:[tmpDate dateAfterDay:7]];
            }
        }
        
        DEBUG_NSLOG(@"\n\n  后一个周日期 :%@ \n\n",self.strDate);
        
//        if([self.strDate isEqualToString:[Util dateToStringFromDate:[NSDate date]]])
//        {
//            self.strDate = [Util dateToStringFromDate:[NSDate date]];
//        }
//        else
//        {
//            self.strDate = [Util dateToStringFromDate:[tmpDate dateAfterDay:7]];
//        }
        
    }
    
    
    CGRect frame = mScrollView.frame;
    frame.origin.x = frame.size.width * _index;
    
    
    //frame.origin.y = 0;
    [mScrollView scrollRectToVisible:frame animated:YES];
    if([mScrollView viewWithTag:_index+1000])
    {
        DEBUG_NSLOG(@"当前scroll 已经存在");
        return;
    }
    
    if(currentIndex < 0 || currentIndex > 80)
    {
        return;
    }
    
    
    DEBUG_NSLOG(@" mScrollView.frame.size.height:%f",mScrollView.frame.size.height);
    
    CustomSubView *newView = [[CustomSubView alloc] initWithFrame:CGRectMake(frame.origin.x, 0.0, mScrollView.frame.size.width, mScrollView.frame.size.height) withDelegate:self withViewTag:_index + 1000 withDate:self.strDate withViewType:currentHealthType withDeviceID:self.strDeviceID];
    newView.tag = _index+1000;
    [mScrollView addSubview:newView];
    
}


-(void)drawTopView
{
    NSString *startDate = [Util returnCurrentDateIsEndDate:NO withDate:[NSDate date]];
    
    NSString *endDate = [Util returnCurrentDateIsEndDate:YES withDate:[NSDate date]];
    
    DEBUG_NSLOG(@"start date:%@    endDate:%@",startDate,endDate);
    
    
    
    
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    historyX = scrollView.contentOffset.x;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<historyX) //左边滑动
    {
        isLeft = YES;
        
        DEBUG_NSLOG(@"前");
        
        NSDate *thieDate = [NSDate dateFromString:self.strDate];
        
        NSString *strTmpDate = [Util dateToStringFromDate:[thieDate dateAfterDay:-7]];
        
        thieDate = [NSDate dateFromString:strTmpDate];
        
        //self.strDate = strTmpDate;
        
        NSString *strYear = [NSString stringWithFormat:@"%d",[thieDate getYear]];
        
    }
    else if (scrollView.contentOffset.x>historyX) // 右边滑动
    {
        isLeft = NO;
        
        DEBUG_NSLOG(@"后");
        
        NSDate *thieDate = [NSDate dateFromString:self.strDate];
        
        NSString *strTmpDate = [Util dateToStringFromDate:[thieDate dateAfterDay:7]];
        
        thieDate = [NSDate dateFromString:strTmpDate];
        
        //self.strDate = strTmpDate;
        

    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //mScrollView.scrollEnabled = YES;
    
    CGFloat pageWidth = mScrollView.frame.size.width;
    int thispage = floor((mScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        currentIndex = thispage;
        
        [self initWithViewIndex:thispage];
        
    }
    else
    {
        
        DEBUG_NSLOG(@"current is tableview");
        
    }
    
    
    
}



/*
#pragma mark-
-(FSLineChart*)chart1 {
    
    if(lineChart == nil)
    {
        // Generating some dummy data
        NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:10];
        
        for(int i=0;i<10;i++) {
            chartData[i] = [NSNumber numberWithInt:rand() % 100];
        }
        
        // Creating the line chart
        lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(10, 15, [UIScreen mainScreen].bounds.size.width - 20, 200)];
        
        lineChart.gridStep = 3;
        
        lineChart.labelForIndex = ^(NSUInteger item) {
            return [NSString stringWithFormat:@"%lu",(unsigned long)item];
        };
        
        lineChart.labelForValue = ^(CGFloat value) {
            return [NSString stringWithFormat:@"%.f", value];
        };
        
        
        [lineChart setChartData:chartData];
        
    }
    
    return lineChart;
}

#pragma mark-
-(FSLineChart*)chart2 {
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:101];
    
    for(int i=0;i<101;i++) {
        chartData[i] = [NSNumber numberWithFloat: (float)i / 30.0f + (float)(rand() % 100) / 500.0f];
    }
    
    // Creating the line chart
    lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 15, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    
    lineChart.gridStep = 4;
    lineChart.color = [UIColor fsOrange];
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%lu%%",(unsigned long)item];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f €", value];
    };
    
    [lineChart setChartData:chartData];
    
    return lineChart;
}

*/




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
