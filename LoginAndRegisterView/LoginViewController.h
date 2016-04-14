//
//  LoginViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-9.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "PAImageView.h"


#import "MasterViewController.h"

@interface LoginViewController : MasterViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL isInTableEdit;
    
    NSMutableString *mUserName;
    NSMutableString *mUserPassWord;
    
    BOOL isAutoLogin;
    
    PAImageView *avaterImageView;
    
    UIButton *loginButtonButton;
    
    UITableView *mLoginTable;
    NSMutableArray *mLoginTableWords;
    
    UITextField	*mtextField;
}

@property(nonatomic,strong)UITextField *mTextFieldBeingEdited;

@end
