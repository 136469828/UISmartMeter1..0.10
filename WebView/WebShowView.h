//
//  WebShowView.h
//  fengjingIOSnew
//
//  Created by Xu Guo on 12/11/12.
//
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"


@interface WebShowView : MasterViewController<UIWebViewDelegate>
{
    
    UIWebView *webView;
    UIToolbar *MyToolbar;
    
    NSString *strParameter;
    
    NSString *webUrl;
    int loaded;
    int flag;
}
@property (nonatomic,retain)   NSString *webUrl;

@property (nonatomic,retain)    NSString *strParameter;

@property (nonatomic) int flag;

@end
