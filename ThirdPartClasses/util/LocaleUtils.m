//
//  LocaleUtils.m
//  ChildrenCalendar
//
//  Created by yangxi zou on 11-1-29.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import "LocaleUtils.h"


@implementation LocaleUtils

+ (NSString *)getCountryCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    //dlog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);    
    return [currentLocale objectForKey:NSLocaleCountryCode];
}

+ (NSString *)getLanguageCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    //dlog(@"Language Code is %@", [currentLocale objectForKey:NSLocaleLanguageCode]);    
    return [currentLocale objectForKey:NSLocaleLanguageCode];
}

//根据语言 和区域 判断用户是否使用农历
+(BOOL)useLunar
{
	
	return NO;
}

@end
