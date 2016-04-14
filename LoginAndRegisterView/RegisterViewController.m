//
//  RegisterViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "RegisterAgreeView.h"

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
	
    //[self setLeftButton];
    
    self.titleLabel.text = self.title;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    [self drawRegisterView];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    keyBoardController = [[UIKeyboardViewController alloc] initWithControllerDelegate:self];
	[keyBoardController addToolbarToKeyboard];
    
    
    
}


#pragma mark -
#pragma mark - drawRegisterView by ZL
-(void)drawRegisterView
{
    CGFloat yposition=25;
    
    UIImage *img = [UIImage imageNamed:@"imgCodeLong@2x"];
    
    imageViewUserName = [[UIImageView alloc] initWithFrame:CGRectMake(30, yposition, self.view.frame.size.width-60, 45)];
    [imageViewUserName setImage:img];
    imageViewUserName.userInteractionEnabled = YES;
    [self.view addSubview:imageViewUserName];
    
    phoneTextField = [[UITextField alloc ]initWithFrame:CGRectMake(10 , 5.0, imageViewUserName.frame.size.width - 20 , 35)];
    phoneTextField.placeholder = @"输入手机号";
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneTextField setFont:TextFont_15];
    phoneTextField.textColor = HEXCOLOR(DefaultColor_666666);
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.backgroundColor = [UIColor clearColor];

    [imageViewUserName addSubview:phoneTextField];
    
    
    yposition=imageViewUserName.frame.size.height+imageViewUserName.frame.origin.y+10;
    
    img = [UIImage imageNamed:@"imgCodeShort@2x"];
    
    imageViewUserPwd = [[UIImageView alloc] initWithFrame:CGRectMake(30, yposition, self.view.frame.size.width-(60+90), 45)];
    [imageViewUserPwd setImage:img];
    imageViewUserPwd.userInteractionEnabled = YES;
    [self.view addSubview:imageViewUserPwd];
    

    
    passwordTextField = [[UITextField alloc ]initWithFrame:CGRectMake(10 , 5.0, imageViewUserPwd.frame.size.width - 20 , 35)];
    passwordTextField.placeholder = @"输入验证码";
    passwordTextField.tag = 2;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordTextField setFont:TextFont_15];
    passwordTextField.textColor = HEXCOLOR(DefaultColor_666666);
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.backgroundColor = [UIColor clearColor];
    
    [imageViewUserPwd addSubview:passwordTextField];
    
    // 生成4位数验证码
    checkCode = arc4random() % 8999 + 1000;
    
   
    
    codeButton = [[UIButton alloc] initWithFrame:CGRectMake(imageViewUserPwd.frame.origin.x + imageViewUserPwd.frame.size.width + 10.0, imageViewUserPwd.frame.origin.y+1, 80, imageViewUserPwd.frame.size.height-1)];
    codeButton.layer.borderColor = [UIColor colorWithRed:24.0/255.0 green:165.0/255.0 blue:227.0/255.0 alpha:1.0].CGColor;
    codeButton.layer.borderWidth = 0.5;
    codeButton.enabled = NO;
    [codeButton setTitle: [NSString stringWithFormat:@"   %d",checkCode] forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:17];
    codeButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    codeButton.userInteractionEnabled = NO;
    [codeButton setTitleColor:[UIColor colorWithRed:24.0/255.0 green:165.0/255.0 blue:227.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:codeButton];
    
    
    yposition=imageViewUserPwd.frame.size.height+imageViewUserPwd.frame.origin.y+25;
    
    CGRect rect = CGRectMake(30, yposition, self.view.frame.size.width-40, 30.0);
    
    RegisterAgreeView *agreeView = [[RegisterAgreeView alloc] init];
    agreeView.navigationController = self.navigationController;
    agreeView.tag = 10010;
    agreeView.frame = rect;
    [self.view addSubview:agreeView];
    
    
    yposition=agreeView.frame.size.height+agreeView.frame.origin.y+25;
    
    // 注册按钮
    rect = CGRectMake(100, yposition, 121, 36);
    
    UIButton *subBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn2.frame =rect;
    [subBtn2 setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:141.0/255.0 blue:45.0/255.0 alpha:1.0]];
    [subBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subBtn2.titleLabel.font = [UIFont systemFontOfSize:18.5];
    [subBtn2 setTitle:@"注  册" forState:UIControlStateNormal];
    subBtn2.layer.cornerRadius =4.0;
    [subBtn2 addTarget:self action:@selector(signBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    subBtn2.showsTouchWhenHighlighted = YES;
    //subBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 3.0, 0.0);
    [self.view addSubview:subBtn2];
    
    
    
}


-(void)checkInputFomat
{
    
    
    DEBUG_NSLOG(@"passwordTextField.text :%@",passwordTextField.text);
    
    RegisterAgreeView *agreeView = (RegisterAgreeView *)[self.view viewWithTag:10010];
    if (!agreeView.checkBtnSelect)
    {
        [Util showMsgAlert:AlertAgreeMentCheck];
        return;
    }
    
    if ([Util isEmptyString:[Util stringFormat:phoneTextField.text]])
    {
        [Util showMsgAlert:AlertPhoneNumEmpty];
        
        return;
    }
    
    if ([Util isEmptyString:[Util stringFormat:passwordTextField.text]])
    {
        [Util showMsgAlert:AlertCheckCodeEumpt];
        
        return;
    }
    
    if([phoneTextField.text integerValue] != checkCode)
    {
        [Util showMsgAlert:AlertCheckCodeError];
        
        return;
    }

}

#pragma mark -
#pragma mark - 注册
-(void)signBtnAction:(id)sender
{
    
    [Util resignKeyboard:self.view];//???????
    
    [self checkInputFomat];
    
  
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Util resignKeyboard:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
