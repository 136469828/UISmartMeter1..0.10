//
//  TestNewsViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-4-7.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "TestNewsViewController.h"

@interface TestNewsViewController ()

@end

@implementation TestNewsViewController

-(id)initWithDetailString:(NSString*)strValue
{
    if(self = [super init])
    {
        self.strDetailInfo = strValue;
    }
    
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"加载中.."];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
        
        [SVProgressHUD dismissWithSuccess:@"" afterDelay:1.0];
        
        [self drawTextView];
    });


}


-(void)drawTextView
{
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, self.view.frame.size.width-20, self.view.frame.size.height-30)];
    [tv setText:self.strDetailInfo];
    tv.backgroundColor = [UIColor clearColor];
    tv.textColor = [UIColor blackColor];
    tv.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:tv];
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

@end
