//
//  ModifyPassWordViewController.h
//  UIOverseasExamination
//
//  Created by Eason_Zhou on 15-1-23.
//  Copyright (c) 2015年 Meten. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ModifyPassWordViewController : BaseTableViewController<UITextFieldDelegate>
{
    UITextField *mtextField;

    NSMutableArray *mTableViewWords;
    
    UIButton *bookBut;

    NSMutableString *mUserComformNewPassWord;
    NSMutableString *mUserNewPassWord;
    NSMutableString *mUserOldPassWord;
}
@end
