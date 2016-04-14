//
//  MoreViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "LXActionSheet.h"


#import "BaseTableViewController.h"

#import <UIKit/UIKit.h>

@interface MoreViewController : BaseTableViewController<LXActionSheetDelegate>
{
    
    NSString *strurlToItunes;
    
}
@end
