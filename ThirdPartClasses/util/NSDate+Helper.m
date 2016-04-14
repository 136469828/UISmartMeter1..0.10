//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009, 2010, ZETETIC LLC
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {	
	return [NSDate timestampFormatString];
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
//在当前日期前几天
- (NSUInteger)daysAgo {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgo:(NSDate *)ldate{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:ldate
												options:0];
	return [components day];
}
//午夜时间距今几天
- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	[mdf release];
	
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%d days ago", daysAgo];
	}
	return text;
}
 ///返回一周的第几天(周末为第一天)
- (NSUInteger)weekday {
	/*
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	//[weekdayComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [weekdayComponents weekday];
	 */
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//[gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:self];
	//[comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	int weekday = [comps weekday];
	[gregorian release];
	return weekday;
}

- (NSString*)weekdayChinese {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	switch ([weekdayComponents weekday]) {
		case 1:
			return @"周日";
			break;
		case 2:
			return @"周一";
			break;
		case 3:
			return @"周二";
			break;	
		case 4:
			return @"周三";
			break;			
		case 5:
			return @"周四";
			break;
		case 6:
			return @"周五";
			break;
		case 7:
			return @"周六";
			break;			
		default:
			break;
	}
	
	return @"";
	//return [weekdayComponents weekday];
}
//转为NSString类型的
+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	//[inputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
	/* 
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
	NSString *displayString = nil;
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		[componentsToSubtract release];
		if ([date compare:lastweek] == NSOrderedDescending) {
			[displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];			
			if (thatYear >= thisYear) {
				[displayFormatter setDateFormat:@"MMM d"];
			} else {
				[displayFormatter setDateFormat:@"MMM d, yyyy"];
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	[displayFormatter release];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:dateStyle];
	[outputFormatter setTimeStyle:timeStyle];
	NSString *outputString = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return outputString;
}
//返回周日的的开始时间
- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	} 
	
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
	[componentsToSubtract release];
	
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}
//返回当前天的年月日.
- (NSDate *)beginningOfDay {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	// Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
											   fromDate:self];
	return [calendar dateFromComponents:components];
}
//返回当前周的周末
- (NSDate *)endOfWeek {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	[componentsToAdd release];
	
	return endOfWeek;
}

//返回该月的第一天
- (NSDate *)beginningOfMonth
{
	//return [self dateAfterDay:-[ self getDay]+ 1];
	
	return [NSDate dateFromString: [NSString stringWithFormat:@"%d-%d-1",[self getYear],[self getMonth]] withFormat:@"yyyy-M-d"];
	
}
//该月的最后一天
- (NSDate *)endOfMonth
{
	return [[[self beginningOfMonth] dateafterMonth:1] dateAfterDay:-1];
	//return [self dateAfterDay:[self dateafterMonth:1] day:-1];
} 
/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
//获取年月日如:19871127.
- (NSString *)getFormatYearMonthDay
{
	NSString *string = [NSString stringWithFormat:@"%d%02d%02d",[self getYear],[self getMonth],[self getDay]];
	return string;
}
//返回当前月一共有几周(可能为4,5,6)
- (int )getWeekNumOfMonth
{
	return [[self endOfMonth] getWeekOfYear] - [[self beginningOfMonth] getWeekOfYear] + 1;
}
//该日期是该年的第几周
- (int )getWeekOfYear
{
	int i;
	int year = [self getYear];
	NSDate *date = [self endOfWeek];
	for (i = 1;[[ date    dateAfterDay:-7 * i   ] getYear] == year;i++) 
	{
	}
	return i;
}
//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day
{
	/*
	NSCalendar *calendar = [NSCalendar currentCalendar];
	// Get the weekday component of the current date
	// NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:day];
	NSDate *dateAfterDay =  [calendar dateByAddingComponents:componentsToAdd toDate:ctd options:0]  ;
	[componentsToAdd release];
	
	return dateAfterDay;*/
	
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.day = day;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
	
}
//month个月后的日期
- (NSDate *)dateafterMonth: (int)month
{
	/*
	NSCalendar *calendar =  [NSCalendar currentCalendar]  ;
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setMonth:month];
	NSDate *dateAfterMonth =  [calendar dateByAddingComponents:componentsToAdd toDate:self options:0]   ;
	[componentsToAdd release];
	//[dateAfterMonth release];
	//[calendar release];
	return  dateAfterMonth  ;*/
	 
	 
	//NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	//c.month = month;
	//return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
	/*
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:1];
	//[comps setDay:0];
	NSDate *date = [[NSCalendar autoupdatingCurrentCalendar] dateByAddingComponents:comps toDate:self  options:0];
	[comps release];
	//dlog(@"sefl:%@",[self description]);
	//dlog(@"d:%d %@",[date getDay],[date description]);
	return date;
	*/
	if (month<0) {
		month = -month;
		int cmon=[self getMonth];
		int cyear= [ self getYear];
		int newmon = cmon-month;
		//dlog(@"cmon:%d ;%@",cmon,[self stringWithFormat:@"yyy-MM-dd"]);
		if (newmon<=0) {
			return  [NSDate dateFromString:[NSString stringWithFormat:@"%d-%d-1",cyear-(month-cmon+12)/12,(cmon-month+12)] withFormat:@"yyyy-M-d"];
		}else {
			
			//dlog(@"y:%d m:%d",cyear,newmon);
			return  [NSDate dateFromString:[NSString stringWithFormat:@"%d-%d-1",cyear,newmon] withFormat:@"yyyy-M-d"];
		}
	}else {
		int cmon=[self getMonth];
		int cyear= [ self getYear];
		int newmon = cmon+month;
		//dlog(@"cmon:%d ;%@",cmon,[self stringWithFormat:@"yyy-MM-dd"]);
		if (newmon>12) {
			return  [NSDate dateFromString:[NSString stringWithFormat:@"%d-%d-1",cyear+newmon/12,newmon%12] withFormat:@"yyyy-M-d"];
		}else {
			return  [NSDate dateFromString:[NSString stringWithFormat:@"%d-%d-1",cyear,newmon] withFormat:@"yyyy-M-d"];
		}
	 }	
	
	
	
}
//获取日
- (NSUInteger)getDay{
	/*
	NSCalendar *calendar = [NSCalendar currentCalendar];
	//[calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
	//[dayComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [dayComponents day];
	 *//*
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[dateFormatter setDateFormat:@"d"];
	return  [[dateFormatter stringFromDate:self] intValue] ;*/
	return [[self stringWithFormat:@"d"]intValue];
}
//获取月
- (NSUInteger)getMonth
{
	return [[self stringWithFormat:@"M"]intValue];
	/*
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
	[dayComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [dayComponents month];
	 */
}
//获取年
- (NSUInteger)getYear
{
	return [[self stringWithFormat:@"yyyy"]intValue];
	/*
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
	return [dayComponents year];
	 */
}
//获取小时
- (int )getHour {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	NSInteger hour = [components hour];
	return (int)hour;
}
//获取分钟
- (int)getMinute {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	NSInteger minute = [components minute];
	return (int)minute;
}
- (int )getHour:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:date];
	NSInteger hour = [components hour];
	return (int)hour;
}
- (int)getMinute:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:date];
	NSInteger minute = [components minute];
	return (int)minute;
}


- (NSString*) month{
	/*
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];	
	[dateFormatter setDateFormat:@"MMMM"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [dateFormatter stringFromDate:self];
	 */
	return [self stringWithFormat:@"MMMM"];
}
- (NSString*) year{
	/*
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];	
	[dateFormatter setDateFormat:@"yyyy"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [dateFormatter stringFromDate:self];*/
	return [self stringWithFormat:@"yyyy"];
}

- (NSString*) weekdate{
	/*
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormat setDateFormat:@"eee"];
	[dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	return [dateFormat stringFromDate:self];
	 */
	return [self stringWithFormat:@"eee"];
}

//是否为今天
- (BOOL)isToday
{
	NSDate *today=[NSDate date];
	return [[self stringWithFormat:@"yyyy-MM-dd"] isEqualToString:[today stringWithFormat:@"yyyy-MM-dd"] ]; 
}
- (BOOL)isYesterday
{
	NSDate *yesterday= [[[NSDate alloc] initWithTimeIntervalSinceNow:-24*60*60] autorelease];
	return [[self stringWithFormat:@"yyyy-MM-dd"] isEqualToString:[yesterday stringWithFormat:@"yyyy-MM-dd"] ]; 
}


+(NSDate*)today
{
	NSDate *mytoday=[NSDate date];
	return [NSDate dateFromString:[mytoday stringWithFormat:@"yyyy-MM-dd 00:01"] withFormat:@"yyyy-MM-dd HH:mm"];
}

-(NSString*)toShortString
{ 
    if([self isToday])
    {
        return [self stringWithFormat:@"今天 HH:mm"];
    }
    if([self isYesterday])
    {
        return [self stringWithFormat:@"昨天 HH:mm"];
    }
    //CCLOG(@"%f",[self timeIntervalSinceNow ]/(60*60));
    return [self stringWithFormat:@"MM-dd HH:mm"];
}

@end