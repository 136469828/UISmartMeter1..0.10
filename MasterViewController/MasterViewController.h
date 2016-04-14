//
//  MasterViewController.h
//  UIOfficeOA
//
//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//


#import "LXActionSheet.h"


#import "FileOperation.h"
#import "Constants.h"
#import "ToolSet.h"
#import "Warning.h"
#import "DebugLog.h"
#import "SVProgressHUD.h"

#import "UIKeyboardViewController.h"

#import "NetWebServiceRequest.h"

#import "JsonService.h"
#import "NSString+Helpers.h"

#import "Util.h"

#import "DataObject.h"
#import "DataPaser.h"

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController<LXActionSheetDelegate>
{
    UILabel *titleLabel;
    UIImageView *logoView;
    
    NetType netWorkType;
    
    BOOL isNeedShow;
    
    UILabel *tipLable;
    
    int page;
    int pageSize;
    int allCount;
    
}

@property (nonatomic,strong) LXActionSheet *actionSheet;


@property (nonatomic, strong) UILabel  *titleLabel;
@property(nonatomic,strong) UIImageView *logoView;
@property(nonatomic,strong) UILabel *tipLable;

- (void)setBackButton;

-(void)backEvent;

// 左键
//-(void)setLeftButton;

-(void)setRightButtonWithTitle:(NSString *)strTitle textFont:(CGFloat)textFont withBackGroundColor:(UIColor *)color titleColor:(UIColor *)titleColor withBackImage:(UIImage *)image withFrame:(CGRect)rect isRightButton:(BOOL)isRight;

//-(void)spinnerViewStartAnimation;
//
//-(void)spinnerViewStopAnimation;

-(void)showHUDViewWithString:(NSString*)strMsg withHUDType:(SVProgressHUDMaskType)maskType;

-(void)dismissHUDViewWithString:(NSString*)strMsg;


@end
