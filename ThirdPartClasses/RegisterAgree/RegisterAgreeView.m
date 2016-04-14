//
//  RegisterAgreeView.m
//  NewAIFengJing_2.0
//
//  Created by FengJing on 13-4-24.
//  Copyright (c) 2013年 feng jing. All rights reserved.
//

#import "RegisterAgreeView.h"
#import "Warning.h"
#import "Util.h"
#import "RegisterAgreeContentsView.h"

// 协议
#define agreebgView_Tag       7
#define checkBtn_Tag          8
#define agreeContentBtn_Tag   9
#define promptTextView_Tag    10

// 协议
#define agreeMentView_Height    30.0
#define checkBtn_side           20.0
#define agreeLabel_Width        110.0
#define agreeContentBtn_Width   90.0

@implementation RegisterAgreeView
@synthesize checkBtnSelect = _checkBtnSelect;
@synthesize navigationController = _navigationController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0.0, 0.0, 300.0, agreeMentView_Height);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIView *agreebgView = [[UIView alloc] initWithFrame:rect];
    agreebgView.tag = agreebgView_Tag;
    agreebgView.backgroundColor = [UIColor clearColor];
    
    // button
    CGRect oRect;
    oRect = CGRectMake(10, 10.0/2, checkBtn_side, checkBtn_side);
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:oRect];
    checkBtn.tag = checkBtn_Tag;
    checkBtn.showsTouchWhenHighlighted = YES;
    self.checkBtnSelect = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"check_on@2x" ofType:@"png"];
    [checkBtn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [agreebgView addSubview:checkBtn];
//    [checkBtn release];
    
    // label
    oRect = CGRectMake(10.0*2+checkBtn_side, 10.0/2, agreeLabel_Width, checkBtn_side);
    UILabel *label = [[UILabel alloc] initWithFrame:oRect];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = HEXCOLOR(DefaultColor_666666);
    label.text = @"我已阅读并同意";
    [agreebgView addSubview:label];
//    [label release];
    
    // button
    oRect = CGRectMake(10.0*2+checkBtn_side+agreeLabel_Width, 10.0-4.5, agreeContentBtn_Width, checkBtn_side);
    UIButton *agreeContentBtn = [[UIButton alloc] initWithFrame:oRect];
    agreeContentBtn.tag = agreeContentBtn_Tag;
    agreeContentBtn.titleLabel.font = TextFont_15;
    [agreeContentBtn setTitleColor:HEXCOLOR(DefaultColor_52A2CF) forState:UIControlStateNormal];
    [agreeContentBtn setTitle:@"《注册协议》" forState:UIControlStateNormal];
    [agreeContentBtn addTarget:self action:@selector(agreeContentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [agreebgView addSubview:agreeContentBtn];
//    [agreeContentBtn release];
    
    [self addSubview:agreebgView];
//    [agreebgView release];
}

- (void)checkBtnAction
{
    UIButton *checkBtn = (UIButton *)[self viewWithTag:checkBtn_Tag];
    NSString *path;
    if (_checkBtnSelect)
    {
        self.checkBtnSelect = NO;
        path = [[NSBundle mainBundle] pathForResource:@"check_off@2x" ofType:@"png"];
        [checkBtn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    }
    else
    {
        self.checkBtnSelect = YES;
        path = [[NSBundle mainBundle] pathForResource:@"check_on@2x" ofType:@"png"];
        [checkBtn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    }
}

- (void)agreeContentBtnAction
{
    NSLog(@"注册协议");
    RegisterAgreeContentsView *nextView = [[RegisterAgreeContentsView alloc] init];
    [_navigationController pushViewController:nextView animated:YES];
//    [nextView release];
}

//- (void)dealloc
//{
//    [super dealloc];
//}

@end
