//
//  HistoryViewController.m
//  UISmartMeter
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 RealTmac QQ:1016159548. All rights reserved.
//

#import "HistoryViewController.h"
#import "RBCustomDatePickerView.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

     RBCustomDatePickerView *pickerView = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 380)];
    [self.view addSubview:pickerView];
    
    UIButton *isClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [isClickBtn setTitle:@"确定" forState:UIControlStateNormal];
    [isClickBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchDown];
    isClickBtn.backgroundColor = [UIColor redColor];
    isClickBtn.frame = CGRectMake(35,400, ScreenWidth - 70, 35);
    [self.view addSubview:isClickBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchDown];
    cancelBtn.backgroundColor = [UIColor redColor];
    cancelBtn.frame = CGRectMake(35,440, ScreenWidth - 70, 35);
    [self.view addSubview:cancelBtn];
    
//    NSLog(@"%@",pickerView.timeStr);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma  mark - BtnAction
- (void)clickCancel{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}
@end
