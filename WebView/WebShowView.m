//
//  WebShowView.m
//  fengjingIOSnew
//
//  Created by Xu Guo on 12/11/12.
//
//

#import "WebShowView.h"
#import "Util.h"

#import "DebugLog.h"

@interface WebShowView ()

@end

@implementation WebShowView
@synthesize webUrl;

@synthesize strParameter;

@synthesize flag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    webView = nil;
    MyToolbar = nil;

}

-(void)viewDidUnload
{
    webView = nil;
    MyToolbar = nil;
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self drawSubView];

    
}

-(void)loadData
{
    // loading view
    

    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadWebPageWithString:webUrl andParameter:strParameter];
    });
}

- (void)loadWebPageWithString:(NSString*)urlString andParameter:(NSString *)strPara
{
    if(flag == 1)
    {
        NSString * ustring = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *urlweb =[ustring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        DEBUG_NSLOG(@"\n\n strPara \n\n:%@",strPara);
        
        DEBUG_NSLOG(@"\n\n urlString \n\n:%@",urlString);
        
        
        NSString *body = strPara;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:urlweb]];
        
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
        
        [webView loadRequest:request];

    }
    else
    {
        NSString * ustring = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *urlweb =[ustring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        DEBUG_NSLOG(@"\n\n strPara \n\n:%@",strPara);
        
        DEBUG_NSLOG(@"\n\n urlString \n\n:%@",urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:urlweb]];
        
        [webView loadRequest:request];

    }
    
    
}

/*
-(void)addBottomBar
{
    UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
//    tmp.backgroundColor = self.view.backgroundColor;
//    tmp.layer.shadowColor = [[UIColor blackColor] CGColor];
//    tmp.layer.shadowOffset = CGSizeMake(0, -2);
//    tmp.layer.shadowRadius = 2.0;
//    tmp.layer.shadowOpacity = 0.8;
    tmp.backgroundColor = [UIColor whiteColor];
    
    //tmp.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:91.0/255.0 blue:129.0/225.0 alpha:1];

    
    [self.view addSubview:tmp];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(45.0, 10, 30, 24.0);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"WebView_TabBar_Back_Icon_HL"] forState:UIControlStateNormal];
    btn1.showsTouchWhenHighlighted = YES;
    [btn1 addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    [tmp addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(150.0, 10, 30, 24.0);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"WebView_TabBar_Advance_Icon_HL"] forState:UIControlStateNormal];
    btn2.showsTouchWhenHighlighted = YES;
    [btn2 addTarget:self action:@selector(goforward:) forControlEvents:UIControlEventTouchUpInside];

    [tmp addSubview:btn2];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(180+75, 10, 30, 24.0);
    [btn3 setBackgroundImage:[UIImage imageNamed:@"WebView_TabBar_Refresh_Icon_HL"] forState:UIControlStateNormal];
    btn3.showsTouchWhenHighlighted = YES;
    [btn3 addTarget:self action:@selector(reloadweb:) forControlEvents:UIControlEventTouchUpInside];
    [tmp addSubview:btn3];
    

}

 */
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    loaded = 0;
    
    
    [self loadData];
}


-(void)drawSubView
{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    webView.scalesPageToFit =YES;
    webView.delegate =self;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [webView setDataDetectorTypes:UIDataDetectorTypeAll];
    [webView setUserInteractionEnabled:YES];
    
    [self.view addSubview:webView];
    
}



- (void)backTo:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)goback:(id)sender
{
    [webView goBack];//返回
}

-(void)goforward:(id)sender
{
    [webView goForward];//向前
}

-(void)reloadweb:(id)sender
{
    [webView reload];//重新加载数据
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(loaded != 1)
    {
        [self showHUDViewWithString:@"加载中.." withHUDType:SVProgressHUDMaskTypeNone];
        
        //[SVProgressHUD showWithStatus:@"加载中.."];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    loaded = 1;
    [SVProgressHUD dismiss];
    
    [self dismissHUDViewWithString:@""];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    loaded = 1;
    [SVProgressHUD dismissWithError:@"载入失败"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
