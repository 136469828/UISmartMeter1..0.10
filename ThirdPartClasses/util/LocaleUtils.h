//
//  LocaleUtils.h
//  ChildrenCalendar
//
//  Created by yangxi zou on 11-1-29.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocaleUtils : NSObject {

}
+ (NSString *)getCountryCode;
+ (NSString *)getLanguageCode;
+(BOOL)useLunar;

@end
