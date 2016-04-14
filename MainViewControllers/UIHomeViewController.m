//
//  UIHomeViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 14-9-25.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "JSON.h"
#import "APService.h"

#import "CityAndCode.h"
#import "EGOImageView.h"

#import "AddViewController.h"
#import "SubTableViewController.h"

#import "ElectronicFenceViewController.h"

#import "DetailViewController.h"

#import "MessageInfoViewController.h"
#import "ManageViewController.h"

#import "MoreViewController.h"

#import "UIHomeViewController.h"
#import "UISmartMeterAppDelegate.h"
#import "MapMonitoringViewController.h"

//#import "APService.h"



extern UISmartMeterAppDelegate *appDelegate;


@interface UIHomeViewController ()


@property (nonatomic , retain) CycleScrollView *mainScorllView;

@end

@implementation UIHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    
    self.title = @"主页";
    
    [self setPushTag];

    getWeatherFailed = NO;
    
    [self checkUpdate];
    
    //[self getWeatherData];
    
    menuBtnArray = [[NSMutableArray alloc ] initWithObjects:

                     [NSDictionary dictionaryWithObjectsAndKeys:@"iconHomeMenu1", @"image",@"健康信息",@"titleName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"iconHomeMenu2", @"image",@"地图监控",@"titleName", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"iconHomeMenu3", @"image",@"报警信息",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconHomeMenu6", @"image",@"手表",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconHomeMenu5", @"image",@"电子围栏",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconHomeMenu4", @"image",@"更多",@"titleName", nil],
                     nil];
    
    [self drawContentView];

}


#pragma mark -
#pragma mark - 检查更新
-(void)checkUpdate
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    [jsonService checkVersion];
    
}


#pragma mark-
#pragma mark- 画抽奖次数滚动条
-(void)reSetLotterView
{
    if (tickerView != nil) {
        
        [tickerView removeFromSuperview];
        tickerView = nil;
    }
    
    if([[UserInfo shareInstance].strChName length])
    {
        NSArray  *tickerStrings = [NSArray arrayWithObjects:[NSString stringWithFormat:@"尊敬的%@，欢迎登录！",[UserInfo shareInstance].strChName], nil];
        tickerView = [[JHTickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 30)];
        [tickerView setDirection:JHTickerDirectionLTR];
        [tickerView setTickerStrings:tickerStrings];
        [tickerView setTickerSpeed:60.0f];
        [tickerView start];
        [self.view addSubview:tickerView];
    }
    
//    NSArray  *tickerStrings = [NSArray arrayWithObjects:[NSString stringWithFormat:@"尊敬的用户，您当前共有%@次抽奖机会！",self.strLotteryNum], nil];
//    tickerView = [[JHTickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 30)];
//    [tickerView setDirection:JHTickerDirectionLTR];
//    [tickerView setTickerStrings:tickerStrings];
//    [tickerView setTickerSpeed:60.0f];
//    [tickerView start];
//    [self.view addSubview:tickerView];
}


#pragma mark - 极光推送
- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    //  if ([tag isEqualToString:@""]) {
    // }
    [*tags addObject:tag];
}


- (void)analyseInput:(NSString **)alias tags:(NSSet **)tags {
    // alias analyse
    if (![*alias length]) {
        // ignore alias
        *alias = nil;
    }
    // tags analyse
    if (![*tags count]) {
        *tags = nil;
    } else {
        __block int emptyStringCount = 0;
        [*tags enumerateObjectsUsingBlock:^(NSString *tag, BOOL *stop) {
            if ([tag isEqualToString:@""]) {
                emptyStringCount++;
            } else {
                emptyStringCount = 0;
                *stop = YES;
            }
        }];
        if (emptyStringCount == [*tags count]) {
            *tags = nil;
        }
    }
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias
{
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    DEBUG_NSLOG(@"TagsAlias回调:%@", callbackString);
}

#pragma mark- 设置推送Tag
-(void)setPushTag
{
    if([UserInfo shareInstance].strUserID !=nil && [[UserInfo shareInstance].strUserID length])
    {
        __autoreleasing NSMutableSet *tags = [NSMutableSet set];
        
        [self setTags:&tags addTag:[UserInfo shareInstance].strUserID];
        
        __autoreleasing NSString *alias = [UserInfo shareInstance].strUserID;
        [self analyseInput:&alias tags:&tags];
        
        [APService setTags:tags
                     alias:alias
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    target:self];
    }
    
    
}


#pragma mark-
- (UIButton *)setLeftBackButton:(NSString *)title andFrame:(CGRect)rect action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    rect.size.width = 38.0;
    rect.size.height = 28.0;
    button.frame = rect;
    button.enabled = NO;
    //[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(rect.origin.y, -5, 0, 0);
    return button;
}

-(void)leftButton
{
    //[Util setCustomItemBar:self.navigationController.navigationBar];
    
    // 左键
    
    self.navigationItem.backBarButtonItem = nil;
    
    CGRect rect = CGRectMake(0, 0, 38, 28);
    UIButton *backButton = [self setLeftBackButton:nil andFrame:rect action:@selector(backEvent)];
    backButton.enabled= NO;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self leftButton];
    
    if(mTableView == nil)
    {
        //[self drawTableView];
    }
    
    
    
}

#pragma mark- 天气
-(void)drawTopView
{
    if(backView == nil)
    {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 50)];
//        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
    }
    else
    {
        for(UIView *view in backView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    if(newWeatherObject!= nil)
    {
        CGFloat xorigin = 15.0;
        
        NSString *strDate = [Util getCurrentShortDate];
        
        NSString *strWeekday = [Util getWeekdayFromDate:[NSDate date]];
        
        
        EGOImageView *weatherImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(xorigin, 12,21, 15)];
        weatherImageView.userInteractionEnabled = NO;
        weatherImageView.placeholderImage = [UIImage imageNamed:@"iconRefresh"];
        weatherImageView.clipsToBounds = YES;
        weatherImageView.contentMode = UIViewContentModeScaleAspectFill;
        [backView addSubview:weatherImageView];
        
        if(newWeatherObject.strImg1!=nil && [newWeatherObject.strImg1 length])
        {
            NSString *strUrl = [NSString stringWithFormat:@"http://m.weather.com.cn/img/%@",newWeatherObject.strImg1];
            
            weatherImageView.imageURL = [NSURL URLWithString:strUrl];
            
        }
        
        xorigin = weatherImageView.frame.origin.x+weatherImageView.frame.size.width+10;
        
        
        
        NSString *strCityName = @"深圳";
        
        if([[locationInfo shareInstance].currentCity length])
        {
            strCityName = [locationInfo shareInstance].currentCity;
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",strDate,strWeekday,strCityName];
        
        UILabel *lableDate = [[UILabel alloc] initWithFrame:CGRectMake(xorigin, 10, 144, 20)];
        lableDate.backgroundColor = [UIColor clearColor];
        lableDate.textColor = [UIColor lightGrayColor];
        lableDate.font = [UIFont systemFontOfSize:14];
        lableDate.text = str;
        [backView addSubview:lableDate];
        
        xorigin = lableDate.frame.origin.x+lableDate.frame.size.width+5;
        

        
        
        
        UILabel *lableWeather = [[UILabel alloc] initWithFrame:CGRectMake(xorigin, 10, backView.frame.size.width-(xorigin+10), 20)];
        lableWeather.backgroundColor = [UIColor clearColor];
        lableWeather.textColor = [UIColor darkGrayColor];
        lableWeather.font = [UIFont systemFontOfSize:14];
        lableWeather.adjustsFontSizeToFitWidth = YES;
        lableWeather.text = [NSString stringWithFormat:@"%@  %@-%@",newWeatherObject.strWeather1,newWeatherObject.strTemp2,newWeatherObject.strTemp1];
        [backView addSubview:lableWeather];
        
    }
    else
    {
        if(getWeatherFailed == YES)
        {
            UILabel *weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 7, 200, 25)];
            weatherLabel.text =  @"获取天气信息失败,请重试~";
            weatherLabel.textAlignment = kUITextAlignmentCenter;
            weatherLabel.textColor = [UIColor blackColor];
            weatherLabel.font = [UIFont systemFontOfSize:15];
            weatherLabel.backgroundColor = [UIColor clearColor];
            [backView addSubview:weatherLabel];
            
            
            UIImage *img = [UIImage imageNamed:@"iconRefresh"];
            
            UIButton *reTryBut = [[UIButton alloc] initWithFrame:CGRectMake(weatherLabel.frame.origin.x+weatherLabel.frame.size.width+25, 3.0,img.size.width ,img.size.height)];
            [reTryBut addTarget:self  action:@selector(btnRefreshWeather) forControlEvents:UIControlEventTouchUpInside];
            [reTryBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [reTryBut setBackgroundImage:img forState:UIControlStateNormal];
            reTryBut.showsTouchWhenHighlighted = YES;
            [backView addSubview:reTryBut];
            
        }
        else
        {
            UILabel *getMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, self.view.frame.size.width, 25)];
            getMoreLabel.text =  @"正在获取天气信息..";
            getMoreLabel.textAlignment = kUITextAlignmentCenter;
            getMoreLabel.textColor = [UIColor blackColor];
            getMoreLabel.font = [UIFont systemFontOfSize:15];
            getMoreLabel.backgroundColor = [UIColor clearColor];
            [backView addSubview:getMoreLabel];
            
            
            
            UIActivityIndicatorView *indicatorViewGetMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
            indicatorViewGetMore.frame = CGRectMake(15.0, 11.0, 20.0, 20.0);
            [backView addSubview:indicatorViewGetMore];
            
            [indicatorViewGetMore startAnimating];
            
            [self getWeatherData];
        }
        
    }
    
    
    
    
}


#pragma mark- 天气重试
-(void)btnRefreshWeather
{
    getWeatherFailed = NO;
    
    //[self drawTopView];
    
    //[self getWeatherData];
}


#pragma mark -
#pragma mark - 添加按键
-(void)btnAddClicked:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    
    addViewType addType = addTypePeson;
    
    NSString *strtitle = @"";
    
    if(tag == 0)
    {
        addType = addTypePeson;
        
        strtitle = @"添加监护人";
    }
    else
    {
        addType = addTypeTakeMedicineRemind;
        
        strtitle = @"提醒";
    }
    
    if(tag == 0)
    {
        AddViewController *addViewController = [[AddViewController alloc] initWithAddViewType:addType withObj:nil];
        addViewController.title = strtitle;
        addViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:addViewController animated:YES];
        
        /*
        SubTableViewController *addViewController = [[SubTableViewController alloc] initWithViewType:subViewPersonListViewDefault];
        addViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:addViewController animated:YES];
         */
    }
    else
    {
        MessageInfoViewController *message = [[MessageInfoViewController alloc] initWithMessageType:messageTypeTakeMedicineRemind withUserID:nil];
        message.title = @"提醒信息";
        message.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:message animated:YES];
    }
    
    

    
}



#pragma mark -
#pragma mark - 菜单按键
-(void)menuButtonClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
        {
            DetailViewController *dt = [[DetailViewController alloc]initWithPersonName:nil];
            dt.title  =@"健康信息";
            [self.navigationController pushViewController:dt animated:YES];
            
        }
            break;
        case 1:
        {
            MapMonitoringViewController *dt = [[MapMonitoringViewController alloc] init];
            dt.title = @"多人监控";
            dt.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:dt animated:YES];
        }
            break;
        case 2:
        {
            MessageInfoViewController *message = [[MessageInfoViewController alloc] initWithMessageType:messageTypeAlarmInfo withUserID:nil];
            message.title = @"报警信息";
            message.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case 3:
        {
            SubTableViewController *addViewController = [[SubTableViewController alloc] initWithViewType:subViewDeviceList];
            addViewController.title = @"我的监护手表";
            addViewController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:addViewController animated:YES];
            

        }
            break;
        case 4:
        {
            ElectronicFenceViewController *electronicView = [[ElectronicFenceViewController alloc] init];
            electronicView.title = @"电子围栏";
            electronicView.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:electronicView animated:YES];
        }
            break;
        case 5:
        {
            MoreViewController *manager = [[MoreViewController alloc] init];
            manager.title = @"更多";
            manager.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:manager animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark- Scroll deleagte
-(void)scrollToPage:(NSInteger)currentPage
{
    pageControl.currentPage = currentPage;
}

#pragma mark - 菜单视图
-(void)drawContentView
{
    if(mScrollView == nil)
    {
        mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        mScrollView.showsHorizontalScrollIndicator = NO;
        mScrollView.showsVerticalScrollIndicator = NO;
        [mScrollView setBackgroundColor:[UIColor clearColor]];
        
        mScrollView.showsHorizontalScrollIndicator = YES;
        mScrollView.alwaysBounceVertical = YES;
        mScrollView.scrollEnabled = YES;
        mScrollView.delegate = self;
        
        [self.view addSubview:mScrollView];
    }
//    NSLog(@"%f",mScrollView.bounds.size.height);
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, ScreenHeight/3)];
    menuView.backgroundColor = [UIColor whiteColor];
    [mScrollView addSubview:menuView];
    
    
    if(self.mainScorllView == nil)
    {
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0,mScrollView.frame.size.width, 150.0) animationDuration:2];
        self.mainScorllView.backgroundColor = [UIColor clearColor];
        self.mainScorllView.delegate = self;
        
        [menuView addSubview:self.mainScorllView];
    }
//    NSLog(@"%f",_mainScorllView.bounds.size.height);
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    NSArray *tmp = [NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg", nil];
    
    
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(10.0, self.mainScorllView.frame.size.height+self.mainScorllView.frame.origin.y-25, self.view.frame.size.width-20, 25)];
    backView2.backgroundColor = [UIColor clearColor];
    
    [backView2 setAlpha:0.55];
    
    [mScrollView addSubview:backView2];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 0.0, backView2.frame.size.width, 25)];
    
    pageControl.currentPage = 0;
    [backView2 addSubview:pageControl];
    
    pageControl.numberOfPages = 4;
    
    
    for(int i=0;i<[tmp count];i++)
    {
        NSString *strImageName = [tmp objectAtIndex:i];
        
        EGOImageView *_imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:strImageName]]; //
        
        _imageView.frame = CGRectMake(i*self.mainScorllView.frame.size.width, 0.0, self.mainScorllView.frame.size.width, 160);
        _imageView.imageURL = [NSURL URLWithString:strImageName];
        
        _imageView.userInteractionEnabled = YES;
        
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _imageView.tag = i;
        
        [self.mainScorllView addSubview:_imageView];
        
        [viewsArray addObject:_imageView];
        
    }
    
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return [viewsArray count];
    };

    //三列
    int totalloc=3;
    CGFloat appvieww=90;
    CGFloat appviewh=70;
    
    CGFloat margin=([UIScreen mainScreen].bounds.size.width-totalloc*appvieww)/(totalloc+1);
//    int count = [menuBtnArray count];
    
    for (int i=0; i<[menuBtnArray count]; i++) {
        int row=i/totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%totalloc;//列号
        
         NSMutableDictionary *mdict = [menuBtnArray objectAtIndex:i];
        
        CGFloat appviewx=margin+(margin+appvieww)*loc;
        CGFloat appviewy=margin+(margin+appviewh)*row;
        
        
        //创建uiview控件
        UIView *appview=[[UIView alloc]initWithFrame:CGRectMake(appviewx, appviewy + _mainScorllView.bounds.size.height - 15, appvieww, appviewh)];
//        [appview setBackgroundColor:[UIColor purpleColor]];
        [menuView addSubview:appview];
        //设置按钮图片
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        [Btn setBackgroundImage:[UIImage imageNamed:[mdict valueForKey:@"image"]] forState:UIControlStateNormal];
        
        Btn.showsTouchWhenHighlighted = YES;
        Btn.tag = i;
        [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[Btn setFrame:CGRectMake(5, 5, 100, 100)];
        Btn.frame = CGRectMake(20, 15, 55, 55);
        [Btn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [appview addSubview:Btn];
        
//
//        //创建文本标签
        UILabel *applable=[[UILabel alloc]initWithFrame:CGRectMake (appview.bounds.size.width/2-55/2 - 2,appview.bounds.size.height +5, 65, 10)];
        //        applable.backgroundColor = [UIColor redColor];
        NSString *ss = [mdict valueForKey:@"titleName"];
        [applable setText:ss];
        [applable setBackgroundColor:[UIColor clearColor]];
        [applable setTextColor:[UIColor darkGrayColor]];
        [applable setFont:[UIFont systemFontOfSize:13.0]];

//        [applable setText:titles[i]];
        [applable setTextAlignment:NSTextAlignmentCenter];
        [applable setFont:[UIFont systemFontOfSize:12.0]];
//        [appview addSubview:applable];
        [appview addSubview:applable];
        
        
    }
    
 

    

    float xCoordinate, yCoordinate;
    
    CGFloat objectHeight;
    
    for (int i=0; i<[menuBtnArray count]; i++)
    {
        
        NSMutableDictionary *mdict = [menuBtnArray objectAtIndex:i];
        
        CGRect frame;
        
        xCoordinate = (i%3)*([UIScreen mainScreen].bounds.size.width/6 + 40)+40;
        yCoordinate = (i/3)*(NAVIGATION_BUTTON_HEIGHT + 40) + self.mainScorllView.frame.origin.y+self.mainScorllView.frame.size.height+20;
        
        
        //设置按钮图片
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];

        
        [Btn setBackgroundImage:[UIImage imageNamed:[mdict valueForKey:@"image"]] forState:UIControlStateNormal];
        
        Btn.showsTouchWhenHighlighted = YES;
        Btn.tag = i;
        frame.size.width = NAVIGATION_BUTTON_WIDTH;	//设置按钮坐标及大小
        frame.size.height = NAVIGATION_BUTTON_HEIGHT;
        frame.origin.x = xCoordinate;
        frame.origin.y = yCoordinate;
        [Btn setFrame:frame];
        [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[Btn setFrame:CGRectMake(5, 5, 100, 100)];
        
        [Btn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        [menuView addSubview:Btn];
        
        
        objectHeight = Btn.frame.size.height + yCoordinate ;
        

         NSString *ss = [mdict valueForKey:@"titleName"];

         //按钮标题
         CGSize sizeTitle = [ss sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200.0f, 1000.0f) lineBreakMode:kUILineBreakModeWordWrap];


         int labelWidth = sizeTitle.width;

         UILabel  *Lable = [[UILabel alloc] initWithFrame:CGRectMake(Btn.frame.origin.x + (Btn.frame.size.width - labelWidth )/ 2,yCoordinate+NAVIGATION_BUTTON_WIDTH+10,labelWidth,NAVIGATION_LABEL_HEIGHT)];
         [Lable setTextAlignment:kUITextAlignmentCenter];
         [Lable setText:ss];
         [Lable setBackgroundColor:[UIColor clearColor]];
         [Lable setTextColor:[UIColor darkGrayColor]];
         [Lable setFont:[UIFont systemFontOfSize:13.0]];
//        [mScrollView addSubview:Lable];

         objectHeight = Lable.frame.size.height + Lable.frame.origin.y + 10;
        
    }

    menuView.frame = CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y, menuView.frame.size.width, objectHeight+20);
    
    for(int i=0;i<2;i++)
    {
        CGFloat xposition = i*(self.view.frame.size.width/2-5)+5;
        
        UIButton *btn = [UIButton   buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xposition, menuView.frame.origin.y+menuView.frame.size.height+8, self.view.frame.size.width/2-10, 64);
        btn.layer.cornerRadius = 2.0;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor =  [UIColor whiteColor];
        [mScrollView addSubview:btn];
     
        
        UIImage *img = nil;
        
        if(i == 0)
        {
            img = [UIImage imageNamed:@"iconAddAppointment"];
        }
        else if (i == 1)
        {
            img = [UIImage imageNamed:@"iconAddService"];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14.5, img.size.width, img.size.height)];
        imageView.image = img;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn addSubview:imageView];
        
        
        UILabel  *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width+5,22,btn.frame.size.width-(imageView.frame.origin.x + imageView.frame.size.width+10),20)];
        [nameLable setTextAlignment:kUITextAlignmentCenter];
        
        [nameLable setBackgroundColor:[UIColor clearColor]];
        
        [nameLable setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:18]];
        [btn addSubview:nameLable];
        
        if(i == 0)
        {
            nameLable.text = @"监护人";
            [nameLable setTextColor:[UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0]];
        }
        else if(i == 1)
        {
            nameLable.text = @"提醒";
            [nameLable setTextColor:[UIColor colorWithRed:63.0/255.0 green:173.0/255.0 blue:249.0/255.0 alpha:1.0]];
        }
        
    }
    
    CGFloat yorigin = menuView.frame.origin.y+menuView.frame.size.height+170;
    
    
    mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, yorigin);
    
}



#pragma mark -
#pragma mark -获取消息
-(void)getMyMemo
{
//    JsonService *jservice=[JsonService sharedManager];
//    [jservice setDelegate:self];
//    [jservice getMyMemoByPage:currentPage];
//    
//    [SVProgressHUD showWithStatus:@"加载中..."];
}



#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        
    }
    else
    {
        if(buttonIndex == 0)
        {
            
            DEBUG_NSLOG(@"url is:%@",strurlToItunes);
            
            if(strurlToItunes!=nil && [strurlToItunes length]>0)
            {
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strurlToItunes]])
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strurlToItunes]];
                }
                else
                {
                    
                    [self alertMessage:@"Safari无法启动，未能链接到指定网站"];
                }
            }
            
            
        }
        else
        {
            DEBUG_NSLOG(@"\n\n\n reminder me latar\n\n\n");
        }
    }
    
    
}

-(void)alertMessage:(NSString *)message withButtonCounts:(NSInteger)count
{
    UIAlertView *alert = nil;
    
    if(count == 1)
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"有新版本发布啦~"
                 message:message
                 delegate:self
                 cancelButtonTitle:@"  立即更新 "
                 otherButtonTitles:nil,nil];
    }
    else
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"有新版本发布啦~"
                 message:message
                 delegate:self
                 cancelButtonTitle:@"  立即更新 "
                 otherButtonTitles:@"  以后再说 ",nil];
    }
    
    for(id v in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if(v!=nil && [v isMemberOfClass:[UIAlertView class]])
        {
            break;
        }
    }
    
    [alert show];
    
}

-(void)alertMessage:(NSString *)message
{
    UIAlertView *alert = nil;
    
    alert = [[UIAlertView alloc]
             initWithTitle:nil
             message:message
             delegate:self
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil,nil];
    
    alert.tag = 100;
    [alert show];
    
}


#pragma mark - checkver message
-(void)showSoftWareMessageWihOBJ:(DataObjectCheckUpdate *)obj
{
    
    if(obj!=nil)
    {
        
        if(![obj.strVersion isEqual:[NSNull null]])
        {
            //obj.strVersion = @"1.0.1";
            if(obj.strVersion!=nil && [obj.strVersion length]>0)
            {
                NSComparisonResult result = [obj.strVersion compare:softVersion];
                
                if(result == NSOrderedDescending) // 大于
                {
                    [UserInfo shareInstance].updateFlag = YES;
                    
                    int count = 2;
                    
                    if(strurlToItunes == nil)
                    {
                        strurlToItunes = [[NSString alloc] initWithString:obj.strDownlaodURL];
                    }
                    else
                    {
                        strurlToItunes = obj.strDownlaodURL;
                    }
                    
                    
                    if(obj.forceUpdateTag == 1) // 表示强制更新
                    {
                        count = 1;
                        
                    }  // 为0时 正常更新
                    
                    
                    [self alertMessage:obj.strUpdateContent withButtonCounts:count];
                }
                
            }
            
        }
        
    }
    
}



#pragma mark -
#pragma mark - TableView delegate and DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.frame.size.width,5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTable = @"customTableView";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strTable];
	
	if (cell == nil)
	{
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTable];
	}
    
    for (id v in cell.contentView.subviews)
	{
		[v removeFromSuperview];
		
	}
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor whiteColor];
    
    cell.imageView.image = [UIImage imageNamed:@"check_on"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = @"测试新闻非常精彩";
    
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, cell.frame.size.height)];
//    
//    view.backgroundColor = [UIColor whiteColor];
//    
//    [cell.contentView addSubview:view];
//    
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
//    lable.backgroundColor = [UIColor clearColor];
//    lable.textColor = [UIColor grayColor];
//    
//    //lable.textColor = [UIColor colorWithRed:70.0/255.0 green:191.0/255.0 blue:241.0/255.0 alpha:1.0];
//    
//    lable.font = [UIFont boldSystemFontOfSize:16.0];
//    [view addSubview:lable];
//    
//    lable.text = @"测试新闻非常精彩";

    
    return cell;
}



#pragma mark -
#pragma mark - webService delegate
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request
{
    DEBUG_NSLOG(@"\n\n start request \n\n ");

}

-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    
    id obj = nil;
    
    obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeCheckVersion];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            [SVProgressHUD dismiss];
            
            if([tempObject.arrObjects count])
            {
                DataObjectCheckUpdate *oneObject = (DataObjectCheckUpdate *)[tempObject.arrObjects objectAtIndex:0];
                
                if(oneObject)
                {
                    [self showSoftWareMessageWihOBJ:oneObject];
                }
                
            }
            
            
        }
        
    }
    
    
    [SVProgressHUD dismiss];
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
   
}




#pragma mark -
#pragma mark -获取天气预告
-(void)getWeatherData
{
    JsonService *jservice=[JsonService sharedManager];
    [jservice setDelegate:self];
    [jservice getCityWeather];
}

#pragma mark -
#pragma mark -获取天气成功
- (void)requestDataFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    
    if([responseData length]>0)
    {
        
        if(request.tag == requestTagWeather)
        {
            
            NSMutableArray* marray = nil;
            
            if([responseData length]>0)
            {
                
                marray = [DataPaser returnDataSourceWithData:responseData withType:jsonTypeWeather];
                
                if(marray == nil || [marray count]<=0)
                {
                    
                }
                else
                {
                    
                    DEBUG_NSLOG(@"weather info == %@",[marray objectAtIndex:0]);
                    DataObjectWeather *weatherObject = (DataObjectWeather *)[marray objectAtIndex:0];
                    
                    if(newWeatherObject == nil)
                    {
                        newWeatherObject = [[DataObjectWeather alloc] init];
                    }
                    
                    newWeatherObject = weatherObject;
                    
                    //[self drawTopView];
                    
                    
                }
                
                
            }
            
            
            
        }
        
    }
    else
    {
        
        return;
    }
}

#pragma mark -
#pragma mark -获取天气失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    getWeatherFailed = YES;

    //[self drawTopView];
    
    
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
