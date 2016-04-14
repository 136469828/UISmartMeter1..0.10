//
//  LoginViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-9.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "UIHomeViewController.h"

#import "CusomTabBarViewController.h"

#import "LoginViewController.h"
#import "UISmartMeterAppDelegate.h"

extern UISmartMeterAppDelegate *appDelegate;

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    isAutoLogin = NO;
    
    if(mUserPassWord == nil)
    {
        mUserPassWord = [[NSMutableString alloc] initWithCapacity:0];
    }
    
    if(mUserName == nil)
    {
        mUserName = [[NSMutableString alloc] initWithCapacity:0];
        
    }
    
    
    NSString *strUname = [FileOperation getUserName];
    
    NSString *strUpwd = [FileOperation getPassword];
    
    if(strUname !=nil && [strUname length])
    {
        [mUserName setString:strUname];
    }
    
    if(strUpwd !=nil && [strUpwd length])
    {
        [mUserPassWord setString:strUpwd];
    }
    
    [self drawLoginView];
 
    //自动登录
    if(mUserName != nil && [mUserName length] >0 && mUserPassWord !=nil && [mUserPassWord length]>0)
    {
        isAutoLogin = YES;
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // code to be executed on the main queue after delay
            
            JsonService *jsonService = [JsonService sharedManager];
            
            [jsonService setWebserviceDelegate:self];
            
            [jsonService login:mUserName pwd:mUserPassWord];
        });
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark- 登录界面
-(void)drawLoginView
{
    
    
    avaterImageView = [[PAImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-42, 100, 84, 84) backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
    avaterImageView.image = [UIImage imageNamed:@"AppIcon60x60@2x"];;
    
    avaterImageView.clipsToBounds = YES;
    avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:avaterImageView];
    
    
    //登录table
    if(mLoginTable == nil)
    {
        
        mLoginTableWords = [[NSMutableArray alloc] initWithObjects:@"账号:",@"密码:",nil];
        mLoginTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 210.0f, self.view.frame.size.width, 220.0f) style:UITableViewStyleGrouped];
        mLoginTable.delegate = self;
        mLoginTable.dataSource = self;
        mLoginTable.backgroundView = nil;
        mLoginTable.backgroundColor = [UIColor clearColor];
        //mLoginTable.separatorColor = [UIColor clearColor];
        //mLoginTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        CGFloat yOffset = 0;
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 7.0)
        {
            yOffset = 15.0;
        }
        
        yOffset = 30;
        
        //登录按钮
        loginButtonButton = [ToolSet  buttonWithTitle:@"登    录"
                                               target:self
                                             selector:@selector(loginButtonClick)
                                                frame:CGRectMake(20.0, 130.0 + yOffset, self.view.frame.size.width-40, 42.0)
                                        darkTextColor:NO
                                           buttonType:btnTypeLogin];
        [mLoginTable addSubview:loginButtonButton];
        
        loginButtonButton.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:198.0/255.0 blue:57.0/255.0 alpha:1.0];
        
        CGFloat yposition = 0;
        
        if(iPhone5)
        {
            yposition = self.view.frame.size.height-64;
        }
        else
        {
            mLoginTable.frame = CGRectMake(0.0f, 210.0f, self.view.frame.size.width, 220);
            yposition = mLoginTable.frame.origin.y+mLoginTable.frame.size.height + 20;
        }
    
        
        //登录框效果
        CATransition *myTransition = [ CATransition animation];
        myTransition.duration = 0.45;
        myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
        myTransition.type = kCATransitionPush;
        myTransition.subtype = kCATransitionFromTop;
        [mLoginTable.layer addAnimation:myTransition forKey:nil];
        
        
        [self.view  addSubview:mLoginTable];
        
    }
    else
    {
        [mLoginTable reloadData];
    }
    
    
    
    
}


#pragma mark -
#pragma mark checkInputFormat
-(BOOL)checkInputFormat
{
    if(mUserName != nil && [mUserName length] >0 && mUserPassWord !=nil && [mUserPassWord length]>0)
    {
        return YES;
        
        
    }
    else
    {
        [Util showAlertWithTitle:@"温馨提示" withMessage:LoginEmpty_Error withType:2 withDelay:2.0];
        return NO;
    }
    
}

#pragma mark- 登录事件
-(void)loginButtonClick
{
    
    if(self.mTextFieldBeingEdited)
    {
        [self.mTextFieldBeingEdited resignFirstResponder];
    }
    
    if([self checkInputFormat])
    {
        JsonService *jsonService = [JsonService sharedManager];
        
        [jsonService setWebserviceDelegate:self];
        
        [jsonService login:mUserName pwd:mUserPassWord];
    }
    
    
}


#pragma mark - 进入主页
-(void)comInMainView
{
    [appDelegate resetRootViewIsLoginOut:NO];
    
    //UIHomeViewController *main = [[UIHomeViewController alloc] init];
    //[self.navigationController pushViewController:main animated:YES];
    
}


#pragma mark -
#pragma mark - TableView Delegate and DataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId =@"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell ==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    for(id v in cell.contentView.subviews) [v removeFromSuperview];
    
    //左边标签
    UILabel *label = [[UILabel alloc] initWithFrame:
                      CGRectMake(10, 5, 80, 35)];
    label.textAlignment = kUITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.text = [mLoginTableWords objectAtIndex:[indexPath row]];
    [cell.contentView addSubview:label];
    
    mtextField = [[UITextField alloc] initWithFrame:
                  CGRectMake(110, 5, 185, 35)];
    mtextField.clearsOnBeginEditing = NO;
    [mtextField setDelegate:self];
    
    mtextField.returnKeyType = UIReturnKeyDone;
    mtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //右边输入框
    if([indexPath row] == 0)
    {
        
        if([mUserName length])
        {
            mtextField.text = mUserName;
        }
        else
        {
            mtextField.placeholder = @"请输入账号";
        }
        
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if([indexPath row] == 1)
    {
        
        mtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        if([mUserPassWord length])
        {
            mtextField.text = mUserPassWord;
        }
        else
        {
            mtextField.placeholder = @"请输入密码";
        }
        
        mtextField.secureTextEntry = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    mtextField.tag = [indexPath row];
    
    
    mtextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    mtextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mtextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [cell.contentView addSubview:mtextField];
    
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 54);
    
    return cell;
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.mTextFieldBeingEdited)
    {
        [self.mTextFieldBeingEdited resignFirstResponder];
    }
}


#pragma mark -
#pragma mark - textView delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    isInTableEdit = YES;
    
	return YES;
	
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	
    if(isInTableEdit)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.45];
    }
    
    avaterImageView.frame = CGRectMake(self.view.frame.size.width/2-42, 30.0f, avaterImageView.frame.size.width, avaterImageView.frame.size.height);
    
	[mLoginTable setFrame:CGRectMake(0.0f, 100.0f, self.view.frame.size.width, mLoginTable.frame.size.height)];
    self.mTextFieldBeingEdited = textField;
	
    
    
	[UIView commitAnimations];
    
    if(mUserName == nil)
    {
        mUserName = [[NSMutableString alloc] initWithCapacity:0];
    }
    if(mUserPassWord == nil)
    {
        mUserPassWord = [[NSMutableString alloc] initWithCapacity:0];
    }
    
    
    if(textField.tag == 0)
    {
        
        if(textField.text!=nil && [textField.text length]>0)
        {
            [mUserName setString:textField.text];
        }
        else
        {
            [mUserName setString:@""];
        }
        
    }
    else if (textField.tag == 1)
    {
        if(textField.text!=nil && [textField.text length]>0)
        {
            [mUserPassWord setString:textField.text];
        }
        else
        {
            [mUserPassWord setString:@""];
        }
        
    }


}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(!isInTableEdit)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
    }
    avaterImageView.frame = CGRectMake(self.view.frame.size.width/2-42, 100, 84, 84);
    
    [mLoginTable setFrame:CGRectMake(0.0f, 210.0f, self.view.frame.size.width, mLoginTable.frame.size.height)];
    
    NSInteger textFieldTag = textField.tag;
   
    if(mUserName == nil)
    {
        mUserName = [[NSMutableString alloc] initWithCapacity:0];
    }
    if(mUserPassWord == nil)
    {
        mUserPassWord = [[NSMutableString alloc] initWithCapacity:0];
    }
    
    DEBUG_NSLOG(@"textField.text:%@",textField.text);
    if(textFieldTag == 0)
    {
        
        if(textField.text!=nil && [textField.text length]>0)
        {
            [mUserName setString:textField.text];
        }
        else
        {
            [mUserName setString:@""];
        }
        
    }
    else if (textFieldTag == 1)
    {
        if(textField.text!=nil && [textField.text length]>0)
        {
            [mUserPassWord setString:textField.text];
        }
        else
        {
            [mUserPassWord setString:@""];
        }
        
    }


    [UIView commitAnimations];
    
    isInTableEdit = NO;
    
}


#pragma mark -
#pragma mark - webService delegate
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request
{
    DEBUG_NSLOG(@"\n\n start request \n\n ");
    
    if(isAutoLogin)
        [self showHUDViewWithString:@"自动登录中.." withHUDType:SVProgressHUDMaskTypeGradient];
    else
    [self showHUDViewWithString:@"登录中.." withHUDType:SVProgressHUDMaskTypeGradient];
    
    
    
}

-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    
    if(request.tag == 100)
    {
        id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeLogin];
        
        if (obj!=nil)
        {
            SampleDataObject *tempObject =  (SampleDataObject *)obj;
            
            if (tempObject.intSuccess == 1000)
            {
                
                [SMFileUtils writePlistToCache:[requestStr dataUsingEncoding:NSUTF8StringEncoding] filename:userInfoData] ;
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功~"];
                
                [FileOperation saveConfigKey:userLoginName value:mUserName];
                [FileOperation saveConfigKey:userLoginPassword value:mUserPassWord];
                
                [FileOperation saveConfigKey:userLoginType value:@"0"];
                
                [self comInMainView];
                
            }
            else
            {
                if([tempObject.strMessage length])
                {
                    [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"登录失败，请重试！"];
                }
                
                
                
            }
        }
    }
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}


#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
