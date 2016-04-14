//
//  untitled.h
//  newstock
//
//  Created by yangxi zou on 10-12-2.
//  Copyright 2010 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <commoncrypto/CommonDigest.h>  

@interface NSString (Helpers) 
// helper function
- (NSString *) getValueForNamedColumn:(NSString *)column_name  headerNames:(NSArray *)header_names;
- (NSDate *) dateFromString;
- (NSDate *) dateFromISO8601;
- (NSDate *) dateFromDottedTimestamp;
- (NSDate *) dateFromDottedDMY;
- (NSArray *) optionsFromSelect;
- (NSString *) stringByUrlEncoding;
- (NSString *) stringByUrlDecoding;
- (NSString *) stringWithLowercaseFirstLetter;
- (NSString *) stringWithUppercaseFirstLetter;

- (NSComparisonResult)compareDesc:(NSString *)aString;

- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isThisWeek;
- (NSString*)WhenDay;//返回 今日 明日 本周 

-(NSString*)trim;

// md5 maker
- (NSString * )md5;

+ (NSString *) stringFromFormattingBytes:(NSUInteger)bytes;

//中文转拼音
-(NSString*)toPinyin;

- (int) indexOf:(NSString *)text;

@end
