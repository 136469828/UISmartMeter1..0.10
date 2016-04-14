//
//  JsonUtils.m
//  moffice
//
//  Created by szsm on 12-1-11.
//  Copyright (c) 2012年 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import "JsonUtils.h"


@implementation DisplayControl

@synthesize title;

@end

@implementation JsonUtils

//根据 | 间隔 获得标题
+(NSString*)parseName:(NSString*)n
{
   //NSAssert(n!=nil, @"Invalid Field Value");
   if(n==nil)return @"unkonw";
   return [n substringToIndex:[ n rangeOfString:@"|"] .location  ];
}
//获得类型
+(NSString*)parseType:(NSString*)n
{
    //NSAssert(n!=nil, @"Invalid Field Value");
    if(n==nil)return @"unkonw";
    return [n substringFromIndex:[ n rangeOfString:@"|"] .location +1 ];
}



+(id)ParseControlWithTitle:(NSString*)fname data:(NSString*)data delegate:(id)delegate  textAlignment:(UITextAlignment)textAlignment
{
//CCLOG(@"control name:%@ format:%@",[[self class] parseName:fname],[[self class] parseType:fname]);
NSString * format= [[self class] parseType:fname];
NSString * title= [[self class] parseName:fname];

/*
 UITextView *textView = [[[UITextView  alloc] initWithFrame:self.view.frame] autorelease]; //初始化大小并自动释放
 textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色  
 textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小  
 textView.delegate = self;//设置它的委托方法  
 textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
 textView.text = d;//设置它显示的内容  
 textView.returnKeyType = UIReturnKeyDefault;//返回键的类型  
 textView.keyboardType = UIKeyboardTypeDefault;//键盘类型  
 textView.scrollEnabled = YES;//是否可以拖动  
 textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
 */
data=[NSString stringWithFormat:@"%@%@",data,@" "];
CGFloat width=290.0f;

if(textAlignment==UITextAlignmentLeft)width=224.0f;

DisplayControl *dc;

if([format isEqualToString:@"txt"]){//
    CGSize size = CGSizeMake(200,2000); 
    //CGSize titlesize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];  
    dc =[[[DisplayControl alloc] initWithFrame:CGRectMake(6,5,320-20,0)] autorelease];//60
    [dc setBackgroundColor:[UIColor clearColor]];
    [dc setTitle:[NSString stringWithFormat:@"%@%@",title,@":"]];
    dc.userInteractionEnabled=NO;
    //dc.backgroundColor=[UIColor redColor];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,320-20,10)] autorelease];  
    
    [label setNumberOfLines:0];   //设置自动行数与字符换行
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.backgroundColor=[UIColor clearColor];
    // 测试字串  
    //NSString *s = @"这是一个测试！！！adsfsaf时发生发勿忘我勿忘我勿忘我勿忘我勿忘我阿阿阿阿阿阿阿阿阿阿阿阿阿啊00000000阿什顿。。。";  
    UIFont *font = [UIFont systemFontOfSize:15]; 
    [label setText:[NSString stringWithFormat:@"%@:%@",title,data]];
    [label setFont:font];
    [label sizeToFit];
    //设置一个行高上限  
    
    //计算实际frame大小，并将label的frame变成实际大小 
    CGRect frame = [label frame];
    CGRect dcframe = [dc frame];
    CGSize labelsize = [data sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];  
    // frame.size.width = labelsize.width ;
    frame.size.height = labelsize.height;
    
    //dcframe.size.width = labelsize.width ;
    dcframe.size.height = labelsize.height;
    frame.origin.y = 0;//
    
    [label setFrame: frame]; 
    [dc setFrame:dcframe];
    
    if(textAlignment==UITextAlignmentCenter){
        label.center = dc.center;
    }else{
        //frame.origin.x = 60;//
        [label setFrame: frame]; 
    } 
    
    [dc addSubview:label];
    return dc;
}else if([format isEqualToString:@"html"]){
    
    dc =[[[DisplayControl alloc] initWithFrame:CGRectMake(10,6,280,200)] autorelease];//60
    ///[dc setTitle:[NSString stringWithFormat:@"%@%@",title,@":"]];
    dc.clipsToBounds =YES;
    UIWebView *webview=[[[UIWebView alloc]initWithFrame:CGRectMake(0,-5, 280, 200)] autorelease];
    webview.delegate=nil;
    //webview.scalesPageToFit = YES;
    //webview.autoresizesSubviews = YES;
    //webview.contentMode = UIViewContentModeScaleAspectFill;
    //[webview setMultipleTouchEnabled:YES];
    //[webview.scrollView setScrollEnabled:YES];
    //[webview setShowsVerticalScrollIndicator:NO] ;
    //webview.backgroundColor = [UIColor whiteColor];
    [webview loadHTMLString:data baseURL:nil];
    UIFont *font = [UIFont fontWithName:@"Arial" size:20.0f];
    CGSize size = CGSizeMake(width,2000);  
    CGSize labelsize = [data sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap]; 
    CGRect frame = [webview frame];
    CGRect dcframe = [dc frame];
    [webview setBackgroundColor:[UIColor clearColor]];
    //dc.backgroundColor=[UIColor redColor];
    //UIScrollView *tempView=(UIScrollView *)[webview.subviews objectAtIndex:0];
    //tempView.scrollEnabled=NO;
    //CGSize actualSize = [webview sizeThatFits:CGSizeZero];
    //webview.scalesPageToFit = YES;
    //frame.size.width = width ;
    if(labelsize.height<200&&[data indexOf:@"<img"]<0){
        //frame.size.height = labelsize.height+5;
        //dcframe.size.height = labelsize.height ;   
    }
    
    if(textAlignment==UITextAlignmentCenter){
        webview.center = dc.center;
    }else{
        //frame.origin.x = 50;//
        [webview setFrame: frame]; 
    }
    
    [webview setFrame: frame]; 
    [dc setFrame:dcframe];
    
    
    [dc addSubview:webview];
    return dc;
}else if([format isEqualToString:@"jpg"]||[format isEqualToString:@"png"]){
    
    dc =[[[DisplayControl alloc] initWithFrame:CGRectMake(10,6,width,80)] autorelease];//60
    [dc setTitle:@""];
    
    
    NSData *imgdata = [GTMBase64 decodeData: [data dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]]; 
    UIImageView *iview =[[UIImageView alloc] initWithImage:[UIImage imageWithData:imgdata]];
    [iview setFrame:CGRectMake(0,0, 290, 200)];
    iview.userInteractionEnabled=YES;
    [iview setContentMode:UIViewContentModeScaleAspectFit];                
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(handleTapFrom:)]; 
    [iview addGestureRecognizer:recognizer]; 
    [recognizer release];
    [dc addSubview:iview];
    [iview release]; 
    [dc setFrame:CGRectMake(dc.frame.origin.x,dc.frame.origin.y, 300, 200)];//
    dc.userInteractionEnabled=YES;
    
    return dc;
}

return dc;
}

+(id)ParseControl:(NSString*)fname data:(NSString*)data delegate:(id)delegate  textAlignment:(UITextAlignment)textAlignment
{
    //CCLOG(@"control name:%@ format:%@",[[self class] parseName:fname],[[self class] parseType:fname]);
    NSString * format= [[self class] parseType:fname];
    NSString * title= [[self class] parseName:fname];
    
    /*
    UITextView *textView = [[[UITextView  alloc] initWithFrame:self.view.frame] autorelease]; //初始化大小并自动释放
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色  
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小  
    textView.delegate = self;//设置它的委托方法  
    textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    textView.text = d;//设置它显示的内容  
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型  
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型  
    textView.scrollEnabled = YES;//是否可以拖动  
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
     */
    data=[NSString stringWithFormat:@"%@%@",data,@" "];
    CGFloat width=290.0f;
    
    if(textAlignment==UITextAlignmentLeft)width=224.0f;
   
    DisplayControl *dc;
    
    if([format isEqualToString:@"txt"]){//
        CGSize size = CGSizeMake(200,2000); 
        CGSize titlesize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];  
        dc =[[[DisplayControl alloc] initWithFrame:CGRectMake(titlesize.width+14,5,320-titlesize.width-40,0)] autorelease];//60
        [dc setBackgroundColor:[UIColor clearColor]];
        [dc setTitle:[NSString stringWithFormat:@"%@%@",title,@":"]];
        dc.userInteractionEnabled=NO;
        //dc.backgroundColor=[UIColor redColor];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,320-titlesize.width-40,10)] autorelease];  
       
        [label setNumberOfLines:0];   //设置自动行数与字符换行
        label.lineBreakMode = UILineBreakModeCharacterWrap;
        label.backgroundColor=[UIColor clearColor];
        // 测试字串  
        //NSString *s = @"这是一个测试！！！adsfsaf时发生发勿忘我勿忘我勿忘我勿忘我勿忘我阿阿阿阿阿阿阿阿阿阿阿阿阿啊00000000阿什顿。。。";  
        UIFont *font = [UIFont systemFontOfSize:15]; 
        [label setText:data];
        [label setFont:font];
        [label sizeToFit];
        //设置一个行高上限  
         
        //计算实际frame大小，并将label的frame变成实际大小 
        CGRect frame = [label frame];
        CGRect dcframe = [dc frame];
        CGSize labelsize = [data sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];  
       // frame.size.width = labelsize.width ;
        frame.size.height = labelsize.height;
                
        //dcframe.size.width = labelsize.width ;
        dcframe.size.height = labelsize.height;
         frame.origin.y = 0;//
        
        [label setFrame: frame]; 
        [dc setFrame:dcframe];
       
        if(textAlignment==UITextAlignmentCenter){
            label.center = dc.center;
        }else{
            //frame.origin.x = 60;//
            [label setFrame: frame]; 
        } 
            
        [dc addSubview:label];
        return dc;
    }else if([format isEqualToString:@"html"]){
       
        dc =[[[DisplayControl alloc] initWithFrame:CGRectMake(10,6,280,300)] autorelease];//60
        ///[dc setTitle:[NSString stringWithFormat:@"%@%@",title,@":"]];
        dc.clipsToBounds =YES;
        UIWebView *webview=[[[UIWebView alloc]initWithFrame:CGRectMake(0,-5, 280, 300)] autorelease];
        webview.delegate=nil;
        [webview setMultipleTouchEnabled:YES];
        //[webview.scrollView setScrollEnabled:YES];
        //[webview setShowsVerticalScrollIndicator:NO] ;
        //webview.backgroundColor = [UIColor whiteColor];
        [webview loadHTMLString:data baseURL:nil];
        UIFont *font = [UIFont fontWithName:@"Arial" size:20.0f];
        CGSize size = CGSizeMake(width,2000);  
        CGSize labelsize = [data sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap]; 
        CGRect frame = [webview frame];
        CGRect dcframe = [dc frame];
         [webview setBackgroundColor:[UIColor clearColor]];
         //dc.backgroundColor=[UIColor redColor];
        //UIScrollView *tempView=(UIScrollView *)[webview.subviews objectAtIndex:0];
        //tempView.scrollEnabled=NO;
        //CGSize actualSize = [webview sizeThatFits:CGSizeZero];
        //webview.scalesPageToFit = YES;
        //frame.size.width = width ;
        if(labelsize.height<200&&[data indexOf:@"<img"]<0){
            frame.size.height = labelsize.height+5;
            dcframe.size.height = labelsize.height ;   
        }
        
        if(textAlignment==UITextAlignmentCenter){
              webview.center = dc.center;
        }else{
            //frame.origin.x = 50;//
             [webview setFrame: frame]; 
        }
        
        [webview setFrame: frame]; 
        [dc setFrame:dcframe];
               
        
         [dc addSubview:webview];
        return dc;
    }else if([format isEqualToString:@"jpg"]||[format isEqualToString:@"png"]){
       
        dc =[[[DisplayControl alloc] initWithFrame:CGRectMake(10,6,width,80)] autorelease];//60
        [dc setTitle:@""];
        
        
        NSData *imgdata = [GTMBase64 decodeData: [data dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]]; 
        UIImageView *iview =[[UIImageView alloc] initWithImage:[UIImage imageWithData:imgdata]];
        [iview setFrame:CGRectMake(0,0, 290, 200)];
        iview.userInteractionEnabled=YES;
        [iview setContentMode:UIViewContentModeScaleAspectFit];                
        UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(handleTapFrom:)]; 
        [iview addGestureRecognizer:recognizer]; 
        [recognizer release];
        [dc addSubview:iview];
        [iview release]; 
        [dc setFrame:CGRectMake(dc.frame.origin.x,dc.frame.origin.y, 300, 200)];//
        dc.userInteractionEnabled=YES;
        
        return dc;
    }
        
    return dc;
}


@end
