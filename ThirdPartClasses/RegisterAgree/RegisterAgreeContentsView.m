//
//  RegisterAgreeContentsView.m
//  NewAIFengJing_2.0
//
//  Created by FengJing on 13-5-6.
//  Copyright (c) 2013年 feng jing. All rights reserved.
//

#import "RegisterAgreeContentsView.h"
#import "Warning.h"

#import "Util.h"

@interface RegisterAgreeContentsView ()

@end

@implementation RegisterAgreeContentsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.titleLabel.text = @"注册协议";
    
    [self loadWebView];
    
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //禁止弹出Callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"未能连接到服务器！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [customAlert show];
    
    
    
}



-(void)loadWebView
{
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height)];
    myWebView.scalesPageToFit =YES;
    myWebView.delegate =self;
    [self.view addSubview:myWebView];
    myWebView.backgroundColor = [UIColor whiteColor];
    myWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    
    NSURL *url =[NSURL URLWithString:strURL];
    //NSURLRequest *request =[NSURLRequest requestWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.5];
    
    [myWebView loadRequest:request];
    
    }


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc
//{
//    [super dealloc];
//}


@end
