//
//  MessageInfoViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-5.
//  Copyright (c) 2015年 RealTmac. All rights reserved.
//

#import "BaseTableViewController.h"

#import <UIKit/UIKit.h>

typedef enum
{
    messageTypeAlarmInfo = 0,
    messageTypeTakeMedicineRemind
    
    
}messageType;

@interface MessageInfoViewController : BaseTableViewController
{
    messageType currentMessageType;
    NSMutableArray *messageArray;
}
@property(nonatomic,strong)NSString *strDetailID;

-(id)initWithMessageType:(messageType)mType withUserID:(NSString*)strID;

@end
