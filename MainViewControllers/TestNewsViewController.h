//
//  TestNewsViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-4-7.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "MasterViewController.h"

@interface TestNewsViewController : MasterViewController
{
    
}

@property(nonatomic,strong)NSString *strDetailInfo;

-(id)initWithDetailString:(NSString*)strValue;

@end
