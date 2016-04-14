//
//  ToolSet.m
//  UIMobileBook
//

//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "Warning.h"
#import "Constants.h"
#import "ToolSet.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import "DebugLog.h"

#import "UISmartMeterAppDelegate.h"


@implementation locationInfo

@synthesize laitude,longtitude,detailAddress,currentCity,currentCoutry;

+ (locationInfo *)shareInstance
{
    
    static dispatch_once_t pred;
    static locationInfo * location = nil;
    
    dispatch_once(&pred, ^{ location = [[self alloc] initSingleton];
    });
	
	return location;
}

- (id)init
{
    NSAssert(NO, @"canot creat instance of singleton");
    
    return nil;
}
-(id)initSingleton
{
    
    self = [super init];
    if (self) {
    }
    return self;
}

@end


#pragma mark- UserInfo
@implementation UserInfo

@synthesize strAreaId,strAreaName,strChName,strEmail,strEnName,strLeftCoins,strMobile,strRCode,strRoles,strSchoolId,strstrSchoolName,strTotalCoins,strUserHeaderURL,strUserID,strUserName;
@synthesize sexFlag,arrayListRoles;

@synthesize updateFlag,showApplication;

@synthesize usericon;

@synthesize unReadMessageCount;

@synthesize strCheckCode;

+ (UserInfo *)shareInstance
{
    
    static dispatch_once_t pred;
    static UserInfo * userInfo = nil;
    
    dispatch_once(&pred, ^{ userInfo = [[self alloc] initSingleton];
    });
	
	return userInfo;
}

- (id)init
{
    NSAssert(NO, @"canot creat instance of singleton");
    
    return nil;
}
-(id)initSingleton
{
    
    self = [super init];
    if (self) {
        
        updateFlag = NO;
        showApplication = 0;
    }
    return self;
}




@end




@implementation UIImage(UIImageScale)




//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}




//等比例缩放
-(UIImage*)imagescaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end




@implementation ToolSet


#pragma mark- 去掉tableview多余的分割线
+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark -
#pragma mark -
#pragma mark 拨打电话
+(void)doCallWithPhoneNumber:(NSString*)phoneNO withDelagate:(id)delegate
{
    NSString *ss = [NSString stringWithFormat:@"确定要拨打%@吗?",phoneNO];
    
    UIAlertView *allerView = [[UIAlertView alloc] initWithTitle:ss message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    allerView.tag = 1999;
    allerView.delegate = delegate;
    [allerView show];
}



#pragma mark -
#pragma mark -
#pragma mark check If NetWork exist
+(BOOL)isNetworkReachable
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}



-(BOOL)checkIsNeedCopyPanoramaFiles
{
    NSString *boundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Panorama.zip"];
    
    NSString* document=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString* dbpath=[document stringByAppendingPathComponent:@"Panorama"];
    
    // 判断是否存在解压过的文件夹 不存在则拷贝zip文件 存在判断是否
    if([[NSFileManager defaultManager] fileExistsAtPath:dbpath])
    {
        [[NSFileManager defaultManager] copyItemAtPath:boundlePath toPath:dbpath error:nil];
        
    }
    else
    {
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:dbpath])
        {
            [[NSFileManager defaultManager] copyItemAtPath:boundlePath toPath:dbpath error:nil];
            
        }
        
    }

    
    return NO;
}





#pragma mark -
#pragma mark - 拷贝文件
-(void)copyPanoramaFiles
{
    

    NSString *myd = [ [[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Plam.sqlite"];
    NSString* document=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString* dbpath=[document stringByAppendingPathComponent:@"Plam.sqlite"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:dbpath])
    {
        [[NSFileManager defaultManager] copyItemAtPath:myd toPath:dbpath error:nil];
        
    }
    else
    {
        DEBUG_NSLOG(@"存在");
    }

    
    

}





#pragma mark -
#pragma mark -
#pragma mark set a background image for a target view
+(void)setBackGroundImageForTargetView:(UIView *)targetV withImageName:(NSString *)imgName
{
    targetV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
}




+(UIButton *)returnButtonWithSelctor:(SEL)selector target:(id)target withTitle:(NSString *)title frame:(CGRect)_frame
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = _frame;
    [backButton setBackgroundImage:[UIImage imageNamed:@"imageBtnCustom"] forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton setTitle:title forState:UIControlStateNormal];
    
    return backButton;
}


+(UIBarButtonItem *)returnBackButtonWithSelctor:(SEL)selector target:(id)target withTitle:(NSString *)title frame:(CGRect)_frame
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = _frame;
    [backButton setBackgroundImage:[UIImage imageNamed:@"imageBtnCustom"] forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    backButton.showsTouchWhenHighlighted = YES;
   [backButton setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    
    return temporaryBarButtonItem;
}


+(UIBarButtonItem *)returnBackButtonWithSelctor:(SEL)selector target:(id)target withTitle:(NSString *)title frame:(CGRect)_frame backImage:(UIImage *)img
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = _frame;
    [backButton setBackgroundImage:img forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    
    return temporaryBarButtonItem;
}



+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    //    CGSize subImageSize = CGSizeMake(size.width, size.height);
    //    //定义裁剪的区域相对于原图片的位置
    //
    //    CGRect subImageRect = CGRectMake(0, 0, size.width, size.height);
    //    CGImageRef imageRef = img.CGImage;
    //    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    //    UIGraphicsBeginImageContext(subImageSize);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextDrawImage(context, subImageRect, subImageRef);
    //    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    //    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}



+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)originImage
{
    UIImage *sourceImage = originImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}





+(void)setNavigationBarBackGroundImagewithTargetView:(id)view
{
    if(view!=nil && [view isMemberOfClass:[UINavigationBar class]])
    {
        UINavigationBar *na = (UINavigationBar *)view;
        
        
        if([na respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            UIImage *image = [UIImage imageNamed:@"navigationBarBackGround"];
            
            image = [self scaleToSize:image size:CGSizeMake(image.size.width, 44.0)];
            
            [na setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
    }
}

#pragma mark -
#pragma mark -
#pragma mark custom UIButton
+ (UIButton *)buttonWithTitle:	(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
				darkTextColor:(BOOL)darkTextColor
                   buttonType:(btnTypeOfToolSet)btype
{	
    
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(btype == btnTypeLogin)
    {
        button.frame = frame;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitle:title forState:UIControlStateNormal];	
        
        if (darkTextColor)
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        
        //UIImage *newImage = [[UIImage imageNamed:@"imageNaviBar"]  stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        //UIImage *newPressedImage = [[UIImage imageNamed:@"Image_BtnClicked.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        //[button setBackgroundImage:newImage forState:UIControlStateNormal];
        button.showsTouchWhenHighlighted = YES;
        
        //[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
         button.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:116.0/255.0 blue:9.0/255.0 alpha:1.0];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        button.titleLabel.font = [UIFont systemFontOfSize: 20];

    }
    else if(btype == btnTypeRemmberPwd)
    {
        button.frame = frame;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //[button setTitle:title forState:UIControlStateNormal];	
        
//        if (darkTextColor)
//        {
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
        
        UIImage *newImage = [UIImage imageNamed:@"checkbox_nor.png"];
        
        
        //UIImage *newPressedImage = [[UIImage imageNamed:@"Image_BtnClicked"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        
        
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
        //[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];	
        // button.backgroundColor = [UIColor orangeColor];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize: 14];

    }
    else if(btype == btnTypeNormal)
    {
        button.frame = frame;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitle:title forState:UIControlStateNormal];
        
        if (darkTextColor)
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        
        UIImage *newImage = [[UIImage imageNamed:@"Image_BtnUnclicked.png"]  stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        //UIImage *newPressedImage = [[UIImage imageNamed:@"Image_BtnClicked.png"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        
        UIImage *newPressedImage = [[UIImage imageNamed:@"Image_BtnClicked"] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        
        
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
        [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
        // button.backgroundColor = [UIColor orangeColor];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
    }
    
	
	
   	return button;
}




+(NSString *)dateStringWithDate:(NSString *)dateStr WithTimeInterval:(NSTimeInterval)interval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M月d日"];
    
    NSDate *oldDate = [NSDate date];
    NSLog(@"oldDate == %@",[dateFormatter stringFromDate:oldDate]);
    NSDate *newDate = [oldDate dateByAddingTimeInterval:interval];
    NSString *newDateStr = [dateFormatter stringFromDate:newDate];
    return newDateStr;
    
}

+(NSString *)weekStrWithDateString:(NSString *)dateStr WithTimeInterval:(NSTimeInterval)interval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M年d月"];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    [dateFormatter setTimeZone:localZone];
    NSDate *oldDate = [NSDate date];
    NSLog(@"oldDate == %@",[dateFormatter stringFromDate:oldDate]);
    NSDate *newDate = [oldDate dateByAddingTimeInterval:interval];
    
    
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:newDate];
    NSInteger weekday = [componets weekday];//1代表星期日，2代表星期一，
    
    NSString *weekStr = nil;
    
    switch (weekday) {
            
        case 1:
        {
            weekStr = @"星期日";
            
        }
            break;
        case 2:
        {
            weekStr = @"星期一";
            
        }
            break;
        case 3:
        {
            weekStr = @"星期二";
            
        }
            break;
        case 4:
        {
            weekStr = @"星期三";
            
        }
            break;
        case 5:
        {
            weekStr = @"星期四";
            
        }
            break;
        case 6:
        {
            weekStr = @"星期五";
            
        }
            break;
        case 7:
        {
            weekStr = @"星期六";
            
        }
            break;
            
        default:
            break;
    }
    
    return weekStr;
}


@end
