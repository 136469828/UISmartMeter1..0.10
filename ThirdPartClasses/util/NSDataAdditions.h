//
//  NSDataAdditions.h
//  ChildrenCalendar
//
//  Created by yangxi zou on 11-1-22.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (NSDataAdditions)
+ (NSData *) dataWithBase64EncodedString:(NSString *)string;
- (id) initWithBase64EncodedString:(NSString *)string;
- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(unsigned int)lineLength;

@property (nonatomic, readonly) NSString* md5Hash;
@end