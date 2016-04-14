//
//  CusomTabBarViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 14-9-25.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "MasterViewController.h"

@interface CusomTabBarViewController : UITabBarController<UITabBarControllerDelegate>
{
    NSMutableArray *buttons;
	int currentSelectedIndex;
	UIImageView *slideBg;
	UIView *cusTomTabBarView;
	UIImageView *backGroundImageView;

}


@property (nonatomic, assign) int				currentSelectedIndex;

@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *lables;

// custom init method
- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;

- (void)hideCustomTabBar;



@end
