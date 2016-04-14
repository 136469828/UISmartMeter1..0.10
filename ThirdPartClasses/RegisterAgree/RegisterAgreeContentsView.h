//
//  RegisterAgreeContentsView.h
//  NewAIFengJing_2.0
//
//  Created by FengJing on 13-5-6.
//  Copyright (c) 2013年 feng jing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface RegisterAgreeContentsView : MasterViewController<UIWebViewDelegate>
{
    UIWebView *myWebView;
    NSString *strURL;
}


- (id)initWithURL:(NSString *)URL;

@end
