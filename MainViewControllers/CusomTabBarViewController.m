//
//  CusomTabBarViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 14-9-25.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "CusomTabBarViewController.h"

#import "HomeViewController.h"
#import "MapMonitoringViewController.h"
#import "MessageInfoViewController.h"
#import "MoreViewController.h"

#import "HealthNewsViewController.h"


@interface CusomTabBarViewController ()

@end

@implementation CusomTabBarViewController

@synthesize currentSelectedIndex;
@synthesize buttons;

static BOOL FIRSTTIME =YES;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if(slideBg == nil)
        {
            slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide"]];
        }
        
        //[self hideRealTabBar];
        
        [self InitFirstTabBarViewControllers];
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark -
#pragma mark - 初始化一级菜单TabBar
-(void)InitFirstTabBarViewControllers
{
    
    
    HomeViewController *homeView = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    homeView.title = @"健康中心";
    homeView.tabBarItem.title = @"健康中心";
    
    
	UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    /*
    MapMonitoringViewController *mapView = [[MapMonitoringViewController alloc] initWithNibName:nil bundle:nil];
    mapView.title = @"地图";
    mapView.tabBarItem.title = @"地图";
    
	UINavigationController *serviceNav = [[UINavigationController alloc] initWithRootViewController:mapView];
    */
     
    HealthNewsViewController *message = [[HealthNewsViewController alloc] initWithNibName:nil bundle:nil];
    message.title = @"新闻";
    message.tabBarItem.title = @"新闻";
    
    
	UINavigationController *communicationNav = [[UINavigationController alloc] initWithRootViewController:message];
    
    MoreViewController *manageView = [[MoreViewController alloc] initWithNibName:nil bundle:nil];
    manageView.title = @"更多";
    manageView.tabBarItem.title = @"更多";
    
	UINavigationController *manageViewNav = [[UINavigationController alloc] initWithRootViewController:manageView];
    
    self.viewControllers = [NSArray arrayWithObjects:homeNavi,communicationNav,manageViewNav,nil];
    
    
    self.selectedIndex = 0;
    
    // tabBarItem
    for (int i = 0; i < [self.viewControllers count]; i ++ )
    {
        UINavigationController *tempNav = [self.viewControllers objectAtIndex:i];
        
        if (i == self.selectedIndex )
        {
            tempNav.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"TabbarIcon%dclick",i+1]];
        }
        else
        {
            tempNav.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"TabbarIcon%dUnclick",i+1]];
            
        }
    }
    
    
    UIColor *color = [UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0];
    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarBkg@2x"]];
    [self.tabBar setSelectedImageTintColor:color];

    if (IOS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    } else {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0]];
    }


    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    
    //[self customTabBar];
    
}




#pragma mark
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //UINavigationController *nav =(UINavigationController *) [[UIApplication sharedApplication].delegate window].rootViewController;
    //nav.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blueColor];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}


- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}


//自定义tabbar
- (void)customTabBar
{
	//获取tabbar的frame
	CGRect tabBarFrame = self.tabBar.frame;
	backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabBarFrame.size.height)];
    backGroundImageView.image = [UIImage imageNamed:@"TabBarBackground@2x"];
	cusTomTabBarView = [[UIView alloc] initWithFrame:tabBarFrame];
    
    cusTomTabBarView.tag = 101;
    
	//cusTomTabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TabBarBackground@2x"]];
	
    //cusTomTabBarView.backgroundColor = [UIColor grayColor];
    
	//设置tabbar背景
	
	//backGroundImageView.image = [UIImage imageNamed:@"banner.png"];
	[cusTomTabBarView addSubview:backGroundImageView];
	
	
	
	//创建按钮
	NSInteger viewCount = self.viewControllers.count > 4 ? 4 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    
    self.lables = [NSMutableArray arrayWithCapacity:viewCount];
    
	double _width = self.view.frame.size.width / viewCount;
	double _height = self.tabBar.frame.size.height;
    
	//
    for (int i = 0; i < viewCount; i++)
    {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(i*_width, 0, _width, _height);
        NSLog(@"%f",btn.frame.size.width);
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
		btn.tag = i;
		[btn setImage:v.tabBarItem.image forState:UIControlStateNormal];
		[btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 2, 0)];
		//添加标题
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _height-16, _width, _height-32)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.text = v.tabBarItem.title;
		[titleLabel setFont:[UIFont systemFontOfSize:12]];
		titleLabel.textAlignment = 1;
        titleLabel.tag = i;
		titleLabel.textColor = [UIColor grayColor];
		[btn addSubview:titleLabel];
        
		[self.buttons addObject:btn];
		[self.lables addObject:titleLabel];
        
        if(self.selectedIndex == i)
        {
            titleLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0];
        }
        
        
		[cusTomTabBarView addSubview:btn];
	}
    
	[self.view addSubview:cusTomTabBarView];
	[cusTomTabBarView addSubview:slideBg];
    

	//[self performSelector:@selector(slideTabBg:) withObject:[self.buttons objectAtIndex:0]];
    
}




//切换tabbar
- (void)selectedTab:(UIButton *)button
{
    
    if (self.currentSelectedIndex == button.tag)
    {
		[[self.viewControllers objectAtIndex:button.tag] popToRootViewControllerAnimated:YES];
		return;
	}
	self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
	[self performSelector:@selector(slideTabBg:) withObject:button];
    
    for (int i = 0; i < [self.viewControllers count]; i ++ )
    {
        UINavigationController *tempNav = [self.viewControllers objectAtIndex:i];
        
        UIButton *tempBut = [self.buttons objectAtIndex:i];
        
        if ( i == button.tag)
        {
            tempNav.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"TabbarIcon%dclick",i+1]];
        }
        else
        {
            tempNav.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"TabbarIcon%dUnclick",i+1]];
            
        }
        
        [tempBut setImage:tempNav.tabBarItem.image forState:UIControlStateNormal];
        
        
        UILabel *tempLable = [self.lables objectAtIndex:i];
        
        if ( self.currentSelectedIndex == tempLable.tag)
        {
            tempLable.textColor = [UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0];
        }
        else
        {
            tempLable.textColor = [UIColor grayColor];
        }
        
        
    }
    
}


//将自定义的tabbar显示出来
- (void)bringCustomTabBarToFront{
    [self performSelector:@selector(hideRealTabBar)];
    //[cusTomTabBarView setHidden:NO];
    
    
    [cusTomTabBarView setHidden:NO];
    
    //CGRect tabBarFrame = self.tabBar.frame;
    
    //[cusTomTabBarView setFrame:CGRectMake(cusTomTabBarView.frame.origin.x, tabBarFrame.origin.y, cusTomTabBarView.frame.size.width, cusTomTabBarView.frame.size.height)];
    
}

//隐藏自定义tabbar-+
-(void)hideCustomTabBar
{
	//[self performSelector:@selector(hideRealTabBar)];
    
    for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]])
        {
			view.hidden = YES;
			break;
		}
	}
    
    
    [cusTomTabBarView setHidden:YES];
    
    
    
}

//动画结束回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (anim.duration==0.1) {
        [cusTomTabBarView setHidden:YES];
    }
}

//切换滑块位置
- (void)slideTabBg:(UIButton *)btn{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationDelegate:self];
	slideBg.frame = btn.frame;
	[UIView commitAnimations];
	CAKeyframeAnimation * animation;
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.duration = 0.50;
	animation.delegate = self;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	animation.values = values;
	[btn.layer addAnimation:animation forKey:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
