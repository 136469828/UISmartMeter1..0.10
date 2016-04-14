//
//  ManageViewController.h
//  UIDoudouIn
//
//  Created by RealTmac on 14-9-25.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "PAImageView.h"

#import "MasterViewController.h"

@interface ManageViewController : MasterViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *mTableviewArr;
    
    UITableView *mTableView;
    
    UILabel *moneyLable;
    
    PAImageView *avaterImageView;
    
    UIView *tmpTopView;
    
    UIScrollView *mScrollView;
    
    NSMutableArray *menuBtnArray;
    
}
@end
