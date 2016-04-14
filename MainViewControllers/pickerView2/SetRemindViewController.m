//
//  SetRemindViewController.m
//  No.1 Pharmacy
//
//  Created by JCong on 15/11/23.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "SetRemindViewController.h"
//#import "RemindViewController.h"
#import "SetRemenberV.h"
@interface SetRemindViewController ()

@end

@implementation SetRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(pushRemindVC)];
//    self.navigationItem.rightBarButtonItem = rBtn;
    SetRemenberV *srV = [[SetRemenberV alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:srV];
    
    
}
- (void)pushRemindVC{
//    NSLog(@"_isAddCount = %d",_isAddCount);
    if (!_isAddCount) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refrshView" object:nil];
    }

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"alertView is %@",alertView);
    //    UIAlertView *al = (UIAlertView *)[self.view viewWithTag:2000];
    if (alertView.tag == 101010) {
        switch (buttonIndex) {
            case 0:
                [self pushRemindVC];
                break;
            case 1:
                nil;
                break;
            default:
                break;
        }
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *u = [[NSUserDefaults alloc] init];
    [u removeObjectForKey:@"tip1"];
    [u removeObjectForKey:@"tip2"];
    [u removeObjectForKey:@"tip3"];
    [u synchronize];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"提醒时间已被更改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    alView.tag = 101010;
    [alView show];

}
@end
