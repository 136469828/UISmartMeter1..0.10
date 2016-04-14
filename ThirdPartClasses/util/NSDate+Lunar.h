//
//  NSDate+Lunar.h
//  ChildrenCalendar
//
//  Created by yangxi zou on 11-1-28.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"//;

@interface NSDate(Lunar)

//-(NSString*)toLunar;

-(void )initLunar_x;
-(void )initLunar;
-(NSString*)toLunarShortDate_x;
-(NSString*)toLunarShortDate;
-(NSString *)toLunarLongDate ;

-(int)getLunarYear;
-(int)getLunarMonth;
-(int)getLunarDay;


@end
