//
//  SetRemenberV.h
//  No.1 Pharmacy
//
//  Created by JCong on 15/12/7.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SetRemenberV : UIView<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSString *tip1;
    NSString *tip2;
    NSString *tip3;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textV;
@property (nonatomic, strong) UIView *closeV;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *labelView;

@end
