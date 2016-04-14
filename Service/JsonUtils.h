//
//  JsonUtils.h
//  moffice
//
//  Created by szsm on 12-1-11.
//  Copyright (c) 2012年 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
#import "NSString+Helpers.h"

@interface DisplayControl : UIView
{
    NSString *title;//输出标题 
}

@property (retain,readwrite)NSString *title;

@end

@interface JsonUtils : NSObject

//将属性转换为控件
+(DisplayControl*)ParseControl:(NSString*)fname data:(NSString*)data delegate:(id)delegate textAlignment:(UITextAlignment)textAlignment;
+(DisplayControl*)ParseControlWithTitle:(NSString*)fname data:(NSString*)data delegate:(id)delegate textAlignment:(UITextAlignment)textAlignment;

@end

