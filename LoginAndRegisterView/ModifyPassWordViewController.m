//
//  ModifyPassWordViewController.m
//  UIOverseasExamination
//
//  Created by Eason_Zhou on 15-1-23.
//  Copyright (c) 2015年 Meten. All rights reserved.
//

#import "ModifyPassWordViewController.h"

@interface ModifyPassWordViewController ()

@end

@implementation ModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawSubView];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    //self.tableView.separatorColor = [UIColor clearColor];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
    
    [self setTableFooterViewWithTitle:@"修改密码"];
}


-(void)tableViewTapped:(UITapGestureRecognizer*)gesture
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(void)drawSubView
{
    self.title = @"修改密码";
    
    mTableViewWords = [[NSMutableArray alloc] initWithObjects:@"旧密码",@"新密码",@"确认新密码",nil];
    
    if(mUserNewPassWord == nil)
    {
        mUserNewPassWord = [[NSMutableString alloc] initWithCapacity:0];
        
    }
    
    if(mUserComformNewPassWord == nil)
    {
        mUserComformNewPassWord = [[NSMutableString alloc] initWithCapacity:0];
        
    }
    
    if(mUserOldPassWord == nil)
    {
        mUserOldPassWord = [[NSMutableString alloc] initWithCapacity:0];
        
    }
    
    [mUserNewPassWord setString:@""];
    [mUserOldPassWord setString:@""];
    
    
}


#pragma mark -
#pragma mark - Draw TableView
-(void)setTableFooterViewWithTitle:(NSString*)strTitle
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.tableView.frame.origin.y+self.tableView.frame.size.height, self.view.frame.size.width, 84.0)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled =YES ;
    
    
    bookBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 25.0,self.tableView.frame.size.width-20 ,40.0)];
    [bookBut addTarget:self  action:@selector(btnSubmit) forControlEvents:UIControlEventTouchUpInside];
    [bookBut setTitle:strTitle forState:UIControlStateNormal];
    [bookBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBut.titleLabel.font = [UIFont systemFontOfSize:20.0];
    bookBut.layer.cornerRadius = 3.0;
    bookBut.showsTouchWhenHighlighted = YES;
    [bookBut setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:63.0/255.0 blue:57.0/255.0 alpha:1.0]];
    [footView addSubview:bookBut];
    
    self.tableView.tableFooterView = footView;
}



#pragma mark -
#pragma mark - 保存
-(void)btnSubmit
{
    if(mtextField) [mtextField resignFirstResponder];
    
    if([Util isEmptyString:mUserNewPassWord] || [Util isEmptyString:mUserOldPassWord] || [Util isEmptyString:mUserComformNewPassWord])
    {
        [Util showMsgAlert:AlertTwoPwdEmpty];
        
        return;
    }
    
    if([mUserNewPassWord length] < 4 || [mUserOldPassWord length] < 4 || [mUserComformNewPassWord length] < 4)
    {
        [Util showMsgAlert:@"密码长度过短，最少四位数~"];
        
        return;
    }
    
    if([mUserComformNewPassWord localizedCompare:mUserNewPassWord] != NSOrderedSame)
    {
        [Util showMsgAlert:@"新密码和确认密码不一致~"];
        
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self modifyPassWord];
    
}


-(void)modifyPassWord
{

    JsonService *jsonService = [JsonService sharedManager];
    [jsonService setWebserviceDelegate:self];
    
    [jsonService resetPassWordWithNewPwd:mUserNewPassWord oldPwd:mUserOldPassWord];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
}


#pragma mark -
#pragma mark - TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 18;
            break;
        default: {
            return 4;
            break;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"myTableView";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    for (id v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
        //v = nil;
    }
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    //左边标签
    UILabel *label = [[UILabel alloc] initWithFrame:
                      CGRectMake(15, 5, 84, 35)];
    //label.textAlignment = kUITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.text = [mTableViewWords objectAtIndex:[indexPath row]];
    [cell.contentView addSubview:label];
    
    
    mtextField = [[UITextField alloc] initWithFrame:
                  CGRectMake(120, 5, 165, 35)];
    mtextField.clearsOnBeginEditing = NO;
    mtextField.returnKeyType = UIReturnKeyDone;
    mtextField.delegate = self;
    mtextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    mtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //右边输入框
    if([indexPath row] == 0)
    {
        
        mtextField.placeholder = @"旧密码";
        mtextField.secureTextEntry = YES;
        [mtextField setText:mUserOldPassWord];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if([indexPath row] == 1)
    {
        
        mtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        mtextField.placeholder = @"新密码";
        mtextField.secureTextEntry = YES;
        [mtextField setText:mUserNewPassWord];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if([indexPath row] == 2)
    {
        
        mtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        mtextField.placeholder = @"确认新密码";
        mtextField.secureTextEntry = YES;
        [mtextField setText:mUserComformNewPassWord];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    mtextField.tag = [indexPath row];
    
    mtextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    mtextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mtextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [cell.contentView addSubview:mtextField];
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 44);
    
    
    return cell;
}



#pragma mark - textView delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.location > 11 || [textField.text length]>11)
        return NO;
    
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        [mUserOldPassWord setString:textField.text];
    }
    else if (textField.tag == 1)
    {
        [mUserNewPassWord setString:textField.text];
    }
    else if (textField.tag == 2)
    {
        [mUserComformNewPassWord setString:textField.text];
    }
    
}

-(void)poptoRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- webService delegate
-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest*)request requetString:(NSString *)reqestString
{
    id obj = nil;
    
    obj = [DataPaser returnObjectWithString:reqestString withType:jsonDataTypeUpdatePwd];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            if([tempObject.strMessage length])
            {
                [FileOperation saveConfigKey:userLoginPassword value:mUserNewPassWord];
                
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功！"];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功！"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
            
            
        }
    }
    
    [SVProgressHUD dismiss];
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest*)request requetString:(NSString *)reqestString
{
    DEBUG_NSLOG(@"fail request str:%@",reqestString);
    
    [SVProgressHUD showErrorWithStatus:NETWORKSETTING];
}



#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
