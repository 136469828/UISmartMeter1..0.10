//
//  WatchSettingViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15/5/15.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//
#import "LXActionSheet.h"

#import "BaseTableViewController.h"

@interface WatchSettingViewController : BaseTableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LXActionSheetDelegate>
{
    NSMutableArray *arrayItems;
}

@property(nonatomic,strong)DataObjectMyDeviceList *deviceInfo;


-(id)initWithDeive:(DataObjectMyDeviceList*)device;

@end
