//
//  AboutSoftViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-2-11.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "AboutSoftViewController.h"

@interface AboutSoftViewController ()

@end

@implementation AboutSoftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于软件";
    
    [self getSoftWareInfo];
    
}

#pragma mark -
#pragma mark About soft
-(void)getSoftWareInfo
{
    //、、UIView
    
    UIImage *img = [UIImage imageNamed:@"icon"];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-img.size.width/2, 64.0, img.size.width, img.size.height)];
    imgv.backgroundColor = [UIColor clearColor];
    imgv.image = img;
    [self.view addSubview:imgv];
    

    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, imgv.frame.origin.y+imgv.frame.size.height+25, self.view.frame.size.width, 25)];
    [titleLable setTextColor:[UIColor blackColor]];
    [titleLable setTextAlignment:kUITextAlignmentCenter];
    [titleLable setText:softWareName];
    [titleLable setBackgroundColor:[UIColor clearColor]];
    titleLable.font = [UIFont systemFontOfSize:18.0];
    
    [self.view addSubview:titleLable];
    
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, self.view.frame.size.width, 20)];
    [t setBackgroundColor:[UIColor clearColor]];
    [t setTextColor:[UIColor grayColor]];
    [t setTextAlignment:kUITextAlignmentCenter];
    [t setText:[NSString stringWithFormat:@"版本 :%@",softVersion]];
    
    //[t setText:@"版本:1.1"];
    
    [t setFont:[UIFont systemFontOfSize:14.0]];
    
    [self.view addSubview:t];
    

}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
