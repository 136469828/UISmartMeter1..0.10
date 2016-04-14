//
//  SetRemenberV.m
//  No.1 Pharmacy
//
//  Created by JCong on 15/12/7.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "SetRemenberV.h"
#import "KeyboardToolBar.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation SetRemenberV
{
    NSArray *titls;
    NSArray *nams;
    NSInteger components;
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame ];
    if (self) {
        [self _initTableiew];
    }
    return self;
}
- (void)_initTableiew{    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setScrollEnabled:NO];
    [self addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboaedDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboaedDidappear:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) // 第一组
    {
        titls = @[@"药品:",@"每次用量"];
        cell.textLabel.text = titls[indexPath.row];
        if (indexPath.row == 0) // 药名
        {
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth - 250, 0, 250, 44)];
            _textField.placeholder = @"请输入药名";
            _textField.delegate = self;
            [KeyboardToolBar registerKeyboardToolBar:self.textField];
            [cell.contentView addSubview:_textField];
            
        }// 药名
        if (indexPath.row == 1 && indexPath.section == 0) // 每次用量
        {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 0, 50, 50)];
            imageV.image = [UIImage imageNamed:@"addtixing"];
            [cell.contentView addSubview:imageV];
            UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 5, ScreenWidth/3, 40)];
            infoL.tag = 1999;
            //            infoL.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:infoL];
            
        } // 每次用量
        
    }// 第二组
    else if (indexPath.section == 1) // 第二组
    {
        titls = @[@"重复",@"时间"];
        cell.textLabel.text = titls[indexPath.row];
        if (indexPath.row == 0) // 重复
        {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45,0, 50, 50)];
            imageV.backgroundColor = [UIColor clearColor];
            imageV.image = [UIImage imageNamed:@"addtixing"];
            [cell.contentView addSubview:imageV];
            UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 5, ScreenWidth/3, 40)];
            infoL.tag = 2000;
            //            infoL.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:infoL];
        }// 重复
        
        if (indexPath.row == 1) // 时间
        {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45,0, 50, 50)];
            imageV.tag = 2200;
            imageV.backgroundColor = [UIColor clearColor];
            imageV.image = [UIImage imageNamed:@"addtixing"];
            [cell.contentView addSubview:imageV];
            UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(20, 5,ScreenWidth, 40)];
            infoL.tag = 2001;
            infoL.font = [UIFont systemFontOfSize:14];
//            infoL.backgroundColor = [UIColor lightGrayColor];
            infoL.textAlignment = NSTextAlignmentCenter;
            infoL.text = @"点击设置提醒时间";
            [cell.contentView addSubview:infoL];
            
        }// 时间
        
    }
    else if (indexPath.section == 2) // 备注
    {
        _textV = [[UITextView alloc] initWithFrame:cell.bounds];
        _textV.delegate= self;
        _textV.font = [UIFont systemFontOfSize:17];
        _textV.text = @"点击在此处添加备注";
        _textV.textColor = [UIColor lightGrayColor];
        
        [cell.contentView addSubview:_textV];
    }
//    cell.textLabel.text = @"点击选择提醒时间";
    return cell;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 100;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        NSLog(@"%@",indexPath);
//     01 10 11
    if (indexPath.section == 0 && indexPath.row == 1 ) {
        titls = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100",@"200"];
        
        nams = @[@"mg",@"g",@"ml",@"片",@"粒",@"丸",@"贴",@"袋",@"滴",@"瓶"];
        components = 2;
        
        [self _initPickerView];
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            titls = @[@"不重复",@"每天",@"每周",@"每半月",@"每月"];
            components = 1;
        }else{
            titls = @[@"无",@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"];
            
            
            
            nams = @[@"无",@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"];
            components = 3;
//             [self _initPickerView];
        }
        [self _initPickerView];
    }
}
- (void)keyboaedDidShow:(NSNotification *)notif{
    //        NSLog(@"键盘出现 %@",notif);
#if 0
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardWillShowNotification];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGRect viewRect = [self.view frame];
    viewRect.origin.y = viewRect.origin.y - keyboardSize.height - 30;
    NSLog(@"%f - %f    // BUG",viewRect.origin.y,viewRect.size.height);
    //    if (viewRect.origin.y >= 14) {
    //        return;
    //    }
    self.view.frame = viewRect;
#endif
    
    
}
- (void)keyboaedDidappear:(NSNotification *)notif{
    NSLog(@"键盘消失");
    [_closeV removeFromSuperview];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (void)leaveEditMode {
    [self.textV resignFirstResponder];
    
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //  667 - 313
    _closeV = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-49-258, ScreenWidth, 40)];
    _closeV.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *colseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colseBtn.frame = CGRectMake(ScreenWidth-45, 5, 40, 25);
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchDown];
    [_closeV addSubview:colseBtn];
    [self addSubview:_closeV];
    
    [UITableView animateWithDuration:0.25 animations:^{
        _tableView.frame = CGRectMake(0, -238+30+59, ScreenWidth, ScreenHeight);
    }];
    textView.text=@"";
    _textV.textColor = [UIColor blackColor];
    return YES;
    
}
- (void)_initPickerView{
    _closeV= [[UIView alloc] initWithFrame:self.bounds];
    _closeV.backgroundColor = [UIColor lightGrayColor];
    _closeV.alpha = 0.4;
    UITapGestureRecognizer * tapV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    _closeV.userInteractionEnabled = YES;
    [_closeV addGestureRecognizer:tapV];
    [self addSubview:_closeV];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight/2, ScreenWidth,ScreenHeight/2.5)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate= self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight - ScreenHeight/2, ScreenWidth, 80)];
    _labelView.backgroundColor = [UIColor whiteColor];
    if (components == 3) {
        NSArray *titleNams = @[@"第一次",@"第二次",@"第三次"];
        for (int i = 0; i < 3; i++) {
            UILabel *pickerL = [[UILabel alloc] initWithFrame:CGRectMake(20 + (i*ScreenWidth/3),45, ScreenWidth, 40)];
            pickerL.text = titleNams[i];
            pickerL.font = [UIFont systemFontOfSize:17];
            [self.labelView addSubview:pickerL];
        }
        
    }
    UIButton *cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelB.frame = CGRectMake(10,10, 40, 40);
    [cancelB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelB setTitle:@"取消" forState:UIControlStateNormal];
    [cancelB addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchDown];
    [self.labelView addSubview:cancelB];
    
    UIButton *clickB = [UIButton buttonWithType:UIButtonTypeCustom];
    clickB.frame = CGRectMake(ScreenWidth - 55,10, 40, 40);
    [clickB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clickB setTitle:@"确定" forState:UIControlStateNormal];
    [clickB addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.labelView addSubview:clickB];
    
    [self addSubview:_labelView];
}
// 显示列数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return titls.count;
    }
    else
    {
        return nams.count;
    }
}
//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerVie{
    return components;
}

// 显示内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSString *title = [titls objectAtIndex:row];
        return title;
    }else{
        NSString *title = [nams objectAtIndex:row];
        return title;
    }
    return nil;
}
// 选择了..
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (components == 1)
    {
        //        NSLog(@"%@",[NSString stringWithFormat:@"%@",titls[row]]);
        UILabel *infoL1 = (UILabel *)[self viewWithTag:2000];
        //        infoL1.textAlignment = UITextAlignmentRight;
        infoL1.textAlignment = NSTextAlignmentRight;
        infoL1.text = titls[row];
        NSLog(@"%@",infoL1.text);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:infoL1.text forKey:@"i1"];
        [user synchronize];
        
    }
    else if (components == 3)
    {
        NSInteger selectedOneIndex = [self.pickerView selectedRowInComponent:0];
        NSInteger selectedTwoIndex = [self.pickerView selectedRowInComponent:1];
        NSInteger selectedThreeIndex = [self.pickerView selectedRowInComponent:2];
//        NSInteger selectedFourIndex = [self.pickerView selectedRowInComponent:3];
        //        NSLog(@"%@",[NSString stringWithFormat:@"%@-%@-%@-%@",titls[selectedOneIndex],nams[selectedTwoIndex],nams[selectedThreeIndex],nams[selectedFourIndex]]);
        UIImageView *imgV = (UIImageView *)[self viewWithTag:2200];
        [imgV removeFromSuperview];
        UILabel *infoL2 = (UILabel *)[self viewWithTag:2001];
        infoL2.text = [NSString stringWithFormat:@"第一次%@  第二次%@  第三次%@",titls[selectedOneIndex],nams[selectedTwoIndex],nams[selectedThreeIndex]];
        infoL2.textAlignment = NSTextAlignmentCenter;
        tip1 = titls[selectedOneIndex];
        tip2 = nams[selectedTwoIndex];
        tip3 = nams[selectedThreeIndex];
        NSLog(@"%@ %@ %@",tip1,tip2,tip3);
        
//        infoL2.textAlignment = UITextLayoutDirectionRight;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:infoL2.text forKey:@"i2"];
        [user setObject:tip1 forKey:@"tip1"];
        [user setObject:tip2 forKey:@"tip2"];
        [user setObject:tip3 forKey:@"tip3"];
        
        [user synchronize];

    }
    else
    {
        NSInteger selectedLeftIndex = [self.pickerView selectedRowInComponent:0];
        NSInteger selectedRightIndex = [self.pickerView selectedRowInComponent:1];
        //        NSLog(@"%@",[NSString stringWithFormat:@"%@--%@",titls[selectedLeftIndex],nams[selectedRightIndex]]);
        UILabel *infoL3 = (UILabel *)[self viewWithTag:1999];
        infoL3.text = [NSString stringWithFormat:@"%@%@",titls[selectedLeftIndex],nams[selectedRightIndex]];
        infoL3.textAlignment = NSTextAlignmentCenter;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:infoL3.text forKey:@"dosage"];
        [user synchronize];
        NSLog(@"%@",infoL3.text);
    }
    
}


- (void)closeView{
    [self.closeV removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.labelView removeFromSuperview];

}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField -- %@",textField.text);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:textField.text forKey:@"sickName"];
    [user synchronize];
}
@end
