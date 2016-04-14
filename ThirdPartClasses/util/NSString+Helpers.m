//
//  untitled.m
//  newstock
//
//  Created by yangxi zou on 10-12-2.
//  Copyright 2010 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import "NSString+Helpers.h"
#import "NSDate+Helper.h"

@implementation NSString (Helpers)

#pragma mark Helpers

//返回 今日 明日 本周 
- (NSString*)WhenDay
{
	if ([self isToday ]) {
		return @"今日";
	}
	
	if ([self isTomorrow ]) {
		return @"明日";
	}
	
	if ([self isThisWeek ]) {
		return @"本周";
	}
	
	return @"";
}

//判断是否 为当天
- (BOOL)isToday
{
	NSDate *today=[NSDate date];
	return [self isEqualToString:[today stringWithFormat:@"yyyy-MM-dd"] ]; 
}

//判断是否 为明天
- (BOOL)isTomorrow
{
	NSDate *tomorrowday= [[[NSDate alloc] initWithTimeIntervalSinceNow:+24*60*60] autorelease];
	return [self isEqualToString:[tomorrowday stringWithFormat:@"yyyy-MM-dd"] ]; 
}

//判断是否为本周
- (BOOL)isThisWeek
{
	NSDate *targetDate;
	NSDateFormatter *dateFormatter10 = [[NSDateFormatter alloc] init];
	[dateFormatter10 setDateFormat:@"yyyy-MM-dd"]; /* Unicode Locale Data Markup Language */
	//[dateFormatter10 setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
	targetDate = [dateFormatter10 dateFromString:self]; 
	[dateFormatter10 release];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:[NSDate date]
												 toDate:targetDate
												options:0];
	//dlog(@"ago %@:%d",self, [components day]+1+[[NSDate date] weekday]);
	if ([components day]<0)return NO;
	if ([components day]+1+[[NSDate date] weekday]>7) {
		return NO;
	}else {
		return YES;
	}
}
-(NSString*)trim{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSDate *) dateFromString
{
	NSDate *retDate;
	
	switch ([self length]) 
	{
		case 8:
		{
			NSDateFormatter *dateFormatter8 = [[NSDateFormatter alloc] init];
			[dateFormatter8 setDateFormat:@"yyyyMMdd"]; /* Unicode Locale Data Markup Language */
			[dateFormatter8 setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
			retDate = [dateFormatter8 dateFromString:self]; 
			[dateFormatter8 release];
			return retDate;
		}
		case 10:
		{
			NSDateFormatter *dateFormatterToRead = [[NSDateFormatter alloc] init];
			[dateFormatterToRead setDateFormat:@"MM/dd/yyyy"]; /* Unicode Locale Data Markup Language */
			[dateFormatterToRead setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
			retDate = [dateFormatterToRead dateFromString:self];
			[dateFormatterToRead release];
			return retDate;
		}
	}
	
	return nil;
}


- (NSDate *) dateFromISO8601
{
	NSMutableString *str = [self mutableCopy];
    NSDateFormatter* sISO8601 = nil;
    
    if (!sISO8601) {
        sISO8601 = [[[NSDateFormatter alloc] init] autorelease];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
       // [sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
         [sISO8601 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if ([str hasSuffix:@"Z"]) 
	{
		[str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
		[sISO8601 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }    
    NSDate *d = [sISO8601 dateFromString:str];
	[str release];
    return d;
}

- (NSDate *) dateFromDottedTimestamp
{
	NSMutableString *str = [self mutableCopy];
    NSDateFormatter* sISO8601 = nil;
    
    if (!sISO8601) {
        sISO8601 = [[[NSDateFormatter alloc] init] autorelease];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:@"yyyy.MM.dd.HH.mm.ss"];
    }
	
    NSDate *d = [sISO8601 dateFromString:str];
	[str release];
    return d;
}

- (NSDate *) dateFromDottedDMY
{
	NSMutableString *str = [self mutableCopy];
    NSDateFormatter* sISO8601 = nil;
    
    if (!sISO8601) {
        sISO8601 = [[[NSDateFormatter alloc] init] autorelease];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:@"dd.MM.yyyy"];
    }
	
    NSDate *d = [sISO8601 dateFromString:str];
	[str release];
    return d;
}


// pass in a HTML <select>, returns the options as NSArray 
- (NSArray *) optionsFromSelect
{
	NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
	NSString *tmpList = [[self stringByReplacingOccurrencesOfString:@">" withString:@"|"] stringByReplacingOccurrencesOfString:@"<" withString:@"|"];
	
	NSArray *listItems = [tmpList componentsSeparatedByString:@"|"];
	NSEnumerator *myEnum = [listItems objectEnumerator];
	NSString *aString;
	
	while (aString = [myEnum nextObject])
	{
		if ([aString rangeOfString:@"value"].location != NSNotFound)
		{
			NSArray *optionParts = [aString componentsSeparatedByString:@"="];
			NSString *tmpString = [[optionParts objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
			[tmpArray addObject:tmpString];
		}
	}
	
	NSArray *retArray = [NSArray arrayWithArray:tmpArray];  // non-mutable, autoreleased
	[tmpArray release];
	return retArray;
}

- (NSString *) getValueForNamedColumn:(NSString *)column_name headerNames:(NSArray *)header_names
{
	NSArray *columns = [self componentsSeparatedByString:@"\t"];
	NSInteger idx = [header_names indexOfObject:column_name];
	if (idx>=[columns count])
	{
		return nil;
	}
	
	return [columns objectAtIndex:idx];
}

- (NSString *) stringByUrlEncoding
{
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8) autorelease];
}

- (NSString *) stringByUrlDecoding
{
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	//      return [(NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)self, NULL, kCFStringEncodingUTF8) autorelease];
}



- (NSComparisonResult)compareDesc:(NSString *)aString
{
	return -[self compare:aString];
}


// method to calculate a standard md5 checksum of this string, check against: http://www.adamek.biz/md5-generator.php
- (NSString * )md5
{
	const char *cStr = [self UTF8String];
	unsigned char result [CC_MD5_DIGEST_LENGTH];//
	CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString 
			stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1],
			result[2], result[3],
			result[4], result[5],
			result[6], result[7],
			result[8], result[9],
			result[10], result[11],
			result[12], result[13],
			result[14], result[15]
			];
}
/*
 +(NSString *) unicodeToUtf8:(NSString *)string
 {
 NSString *tempStr1 = [string stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];  
 NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@""" withString:@"\\""];  
 NSString *tempStr3 = [[@""" stringByAppendingString:tempStr2] stringByAppendingString:@"""];  
 NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];  
 NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData  
 mutabilityOption:NSPropertyListImmutable   
 format:NULL  
 errorDescription:NULL];  
 
 //NSLog(@"Output = %@", returnStr);  
 
 return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
 }

  */

+(NSString *) utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++) {
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else
        {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
        
    }
   
    return s;
}
- (int) indexOf:(NSString *)text {
    NSRange range = [self rangeOfString:text];
    if ( range.length > 0 ) {
        return range.location;
    } else {
        return -1;
    }
}

-(NSString*)toPinyin
{ 
    NSDictionary *zm= [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e", @"f", @"g",@"h",@"j",@"k",  @"l",@"m",@"n", @"o",@"p", @"q", @"r", @"s", @"t", @"w", @"x",@"y",@"z",nil] forKeys:[NSArray arrayWithObjects:@"u554a",@"u516b",@"u64e6",@"u642d",@"u5a40",@"u53d1",@"u560e",@"u54c8",@"u51e0",                                                                                                                                                                                                                                                                                                                                                                                                                                              @"u5f00",@"u62c9",@"u5988",@"u62ff",@"u5662",@"u556a",@"u4e03",@"u7136",@"u4ee8",@"u4ed6",@"u6316",@"u5915",@"u4e2b",@"u531d",nil] ]  ;
    // NSDictionary *zm= [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"a",@"b",nil] forKeys:[NSArray arrayWithObjects:@"\\u554a",@"\\u516b",nil] ]  ;
    NSString *ret;
    NSArray *listItems = [[NSString utf8ToUnicode:self] componentsSeparatedByString:@"\\"];
    
	NSEnumerator *myEnum = [listItems objectEnumerator];
	NSString *aString;
	 while (aString = [myEnum nextObject]){
         ret=[ret stringByAppendingFormat:@"%@,",  [zm objectForKey:aString] ];
        
     }
   
    return ret;
}

+ (NSString *) stringFromFormattingBytes:(NSUInteger)bytes
{
	double kBytes = bytes / 1024.0;
	double mBytes = kBytes / 1024;
	
	if (bytes<1024)
	{
		return [NSString stringWithFormat:@"%d bytes", bytes];
	}
	else if (kBytes < 1024.0)
	{
		return [NSString stringWithFormat:@"%.2f KB", kBytes];
	}
	else 
	{
		return [NSString stringWithFormat:@"%.2f MB", mBytes];
	}
}

- (NSString *) stringWithLowercaseFirstLetter
{
	return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *) stringWithUppercaseFirstLetter
{
	return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
}


@end
