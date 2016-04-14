//
//  RegisterViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "MasterViewController.h"

@interface RegisterViewController : MasterViewController<UIKeyboardViewControllerDelegate>
{
    UIImageView *imageViewUserName;
    UIImageView *imageViewUserPwd;
    
    UIKeyboardViewController *keyBoardController;
    
    UIButton *codeButton;

    NSInteger checkCode;
    
    UITextField *phoneTextField;
    UITextField *passwordTextField;
}
@end
