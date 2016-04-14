//
//  MasterViewController.m
//  UIOfficeOA
//
//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//



#import "Constants.h"
#import "DebugLog.h"
#import "FileOperation.h"

#import "MasterViewController.h"

@interface MasterViewController ()



@property (nonatomic, strong) UILabel *lableTips;

@property (nonatomic, strong) UIButton *myLoginBtn;

@end

@implementation MasterViewController


@synthesize tipLable,title,titleLabel;
@synthesize logoView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION < 7.0)
    {
        if([self.navigationController.viewControllers count]>1)
        {
            [self setBackButton];
        }
    }
    else
    {
        if (IOS_VERSION >= 7.0) {
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0]];
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        } else {
            [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0]];
        }
    }
    
    
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.view.backgroundColor = ColorRGB(236.0, 239.0, 243.0, 1);
    
    netWorkType = netTypeDefult;
    
    page = 1;
    pageSize = 20;
    
    allCount = 0;

    isNeedShow = YES;
    
    self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 124, self.view.frame.size.width, 44)];
    self.tipLable.backgroundColor = [UIColor clearColor];
    self.tipLable.font = [UIFont systemFontOfSize:16];
    self.tipLable.textAlignment = kUITextAlignmentCenter;
    self.tipLable.text = @"您还没有登录哦~";
    self.tipLable.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.tipLable];
    
    [self.tipLable setHidden:YES];
    
    self.myLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myLoginBtn.frame = CGRectMake(self.view.frame.size.width/2-52, self.tipLable.frame.origin.y+self.tipLable.frame.size.height+10, 104, 34);
    [self.myLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.myLoginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [self.myLoginBtn setBackgroundColor:[UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0]];
    self.myLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.myLoginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.myLoginBtn];
    
    [self.myLoginBtn setHidden:YES];
    
    
}


#pragma mark- viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    // 键盘问题 、 以及 ios7兼容问题
    if (IOS_VERSION >= 7.0)
    {
        //self.wantsFullScreenLayout = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent=NO;
        
    }
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


-(void)backEvent
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setBackButton
{
    
    // 左键
    CGRect rect = CGRectMake(0, 0, 38, 28);
    UIButton *backButton = [self setLeftBackButton:nil andFrame:rect action:@selector(backEvent)];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    // 标题
    
    
}




-(void)rightButton
{
    
}


#pragma mark -
#pragma mark - Right Button
-(void)setRightButtonWithTitle:(NSString *)strTitle textFont:(CGFloat)textFont withBackGroundColor:(UIColor *)color titleColor:(UIColor *)titleColor withBackImage:(UIImage *)image withFrame:(CGRect)rect isRightButton:(BOOL)isRight
{
    UIButton *button = [ToolSet buttonWithTitle:strTitle target:self selector:@selector(rightButton) frame:CGRectMake(0, 0, 44.0, 34.0) darkTextColor:NO buttonType:btnTypeLogin];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if(image!=nil)
    {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.frame = rect;
    }
    
    
    button.backgroundColor = color;
    button.titleLabel.font = [UIFont systemFontOfSize:textFont];
    
    UIBarButtonItem *rightButton_1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if(isRight == YES)
    {
        self.navigationItem.rightBarButtonItem = rightButton_1;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = rightButton_1;
    }
    
}


- (UIButton *)setLeftBackButton:(NSString *)title andFrame:(CGRect)rect action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    rect.size.width = 38.0;
    rect.size.height = 28.0;
    button.frame = rect;
    [button setBackgroundImage:[UIImage imageNamed:@"d01"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"d01"] forState:UIControlStateHighlighted];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(rect.origin.y, -5, 0, 0);
    return button;
}

#pragma mark- show login button
-(void)showLoginButton
{
    [self.tipLable setHidden:NO];
    
    [self.myLoginBtn setHidden:NO];
    
}

#pragma mark- viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self dismissHUD];
    
}


#pragma mark- show loading
-(void)showHUDViewWithString:(NSString*)strMsg withHUDType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD dismiss];
    
    if([strMsg length])
    {
        [SVProgressHUD showWithStatus:strMsg maskType:maskType];
    }
    else
    {
        [SVProgressHUD showWithMaskType:maskType];
    }
    
    
}


#pragma mark- dismiss loading
-(void)dismissHUDViewWithString:(NSString*)strMsg
{
    [SVProgressHUD dismissWithError:strMsg];
}

-(void)dismissHUD
{
    [SVProgressHUD dismiss];
}



#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
