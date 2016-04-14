//
//  Util.m
//  shuiwenOA
//
//  Created by zhao yang on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "Constants.h"
#import "DebugLog.h"
#import "LoginViewController.h"
#import "UIDevice-Reachability.h"


@implementation Util

// 时间日期函数
// NSDate *datenow = [NSDate date];                          // 现在时间,你可以输出来看下是什么格式
+ (NSString *)strFormatterDate:(NSDate *)senderDate andforMat:(NSString *)sendFormat
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];    // 本地时间
    [dateFormat setDateFormat:sendFormat];     // 输出格式
    NSString *timeStr = [dateFormat stringFromDate:senderDate];  //----------将nsdate按formatter格式转成nsstring时间转时间戳的方法:
    NSLog(@"time is %@",timeStr);
    //    [dateFormat release];
    return timeStr;
}



void URLCacheAlertButtonTitle(NSString *tipMessage,NSString *message,NSString *cancelMessage,id delegate, NSString * otherButtonTitle)
{
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tipMessage
													message:message
												   delegate:delegate
										  cancelButtonTitle:cancelMessage
										  otherButtonTitles: otherButtonTitle,nil];
	[alert show];
    
}

void URLCacheAlertWithMessage(NSString *message)
{
	/* open an alert with an OK button */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:message
												   delegate:nil
										  cancelButtonTitle:@"确定"
										  otherButtonTitles: nil];
	alert.tag=100;
	[alert show];
}


// 图片方向调整
+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) 
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    // CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0, CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0, colorSpace, CGImageGetBitmapInfo(aImage.CGImage));
    CGColorSpaceRelease(colorSpace);
    
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 按指定宽高改变图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context  
    // 并把它设置成为当前正在使用的context  
    UIGraphicsBeginImageContext(size);  
    // 绘制改变大小的图片  
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];  
    // 从当前context中创建一个改变大小后的图片  
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片  
    return scaledImage;  
}



+ (NSInteger) getFileSize:(NSString *)path
{
    NSFileManager *filemanager = [[NSFileManager alloc] init];
    if([filemanager fileExistsAtPath:path])
    {
        NSDictionary *attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ((theFileSize = [attributes objectForKey:NSFileSize]))
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
        return -1;
}



#pragma mark 根据size截取图片中间矩形区域的图片 这里的size是正方形
+(UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size{
    CGSize imageSize = image.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        rect = CGRectMake(leftMargin, 0, imageSize.height, imageSize.height);
       }else
       {
            float topMargin = (imageSize.height - imageSize.width) * 0.5;
            rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
           
       }
    
    CGImageRef imageRef = image.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw = CGRectMake(0, 0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tmp;
}

//--------------截取部分图片到指定位置-------------------------

//图片(UIImage*) img
//要截取的起始坐标sx:(int) sx1 sy:(int)sy1
//要截取的长度和宽度sw:(int) sw1 sh:(int) sh1
//最终要显示的坐标desx:(int) desx1 desy:(int)desy1

#pragma mark -
#pragma mark - 从中间剪切图片

+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size
{
    CGSize originalsize = [originalImage size];
    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;
        
        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}


#pragma mark -
#pragma mark - 得到本地缓存大小
+(NSString *)getLocalCacheSize
{
    
    //文件管理
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //缓存路径
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    NSString *cacheDir = [cachePaths objectAtIndex:0];
    
    NSArray *cacheFileList;
    
    NSEnumerator *cacheEnumerator;
    
    NSString *cacheFilePath;
    
    unsigned long long cacheFolderSize = 0;
    
    cacheFileList = [fileManager subpathsOfDirectoryAtPath:cacheDir error:nil];
    
    cacheEnumerator = [cacheFileList objectEnumerator];
    
    while (cacheFilePath = [cacheEnumerator nextObject]) {
        
        NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:cacheFilePath] error:nil];
        
        cacheFolderSize += [cacheFileAttributes fileSize];
        
    }
    
    //单位MB
    
    if(cacheFolderSize/1024>1024)
    {
        cacheFolderSize = cacheFolderSize/1024/1024;
        
        NSString *str = [NSString stringWithFormat:@"%.1lluMB",cacheFolderSize];
        
        return str;
    }
    else
    {
        cacheFolderSize = cacheFolderSize/1024;
        
        if(cacheFolderSize <= 0)
        {
            return @"";
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%.1lluKB",cacheFolderSize];
            
            return str;
        }
        
        
    }
    
    
    //return cacheFolderSize/1024/1024;
    
}

#pragma mark- 清理缓存（过滤保存用户信息：不删除）
+(BOOL)deleteFileAtPath:(NSString *)pathStr
{
    
    
    BOOL isRemoveOK = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //缓存路径
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    NSString *cacheDir = [cachePaths objectAtIndex:0];
    
    NSArray *cacheFileList;
    
    NSEnumerator *cacheEnumerator;
    
    NSString *cacheFilePath;
    
    
    cacheFileList = [fileManager subpathsOfDirectoryAtPath:cacheDir error:nil];
    
    cacheEnumerator = [cacheFileList objectEnumerator];
    
    while (cacheFilePath = [cacheEnumerator nextObject])
    {
        
        //NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:cacheFilePath] error:nil];
        
        NSString *userInforFilePath = [cacheDir stringByAppendingPathComponent:@"userInfoData.plist"];
        NSString *userCollectFilePath = [cacheDir stringByAppendingPathComponent:@"otherInfoData.plist"];
        
        NSString *strCurFilePath = [cacheDir stringByAppendingPathComponent:cacheFilePath];
        
        
        if ( [userInforFilePath isEqualToString:strCurFilePath] || [userCollectFilePath isEqualToString:strCurFilePath])
        {
            
        }
        else
        {
            
            if ([fileManager removeItemAtPath:strCurFilePath error:nil])
            {
                isRemoveOK = YES;
            }
            
            DEBUG_NSLOG(@" else filePaht == %@", [cacheDir stringByAppendingPathComponent:cacheFilePath]);
            
        }
        
    }
    return isRemoveOK;
    
}


#pragma mark - 用户选择的记录
+ (NSString *)returnSelectInfoFilePath
{
    NSString *info = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"userSelectData.plist" ];
    NSLog(@"%@", info);
    return info;
}

+(BOOL)isUserSelectFileExist
{
    if([[NSFileManager defaultManager] fileExistsAtPath:[self userInfoFilePath]])
    {
        return YES;
    }
    
    return NO;
}



#pragma mark -
#pragma mark - 动画效果
+(void)popView:(UIView *)subView withFrame:(CGRect)_frame
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.35];
    
    subView.frame = _frame;
    
    
    [UIView commitAnimations];
    
}

#pragma mark - 随即颜色
+(UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}


#pragma mark -
#pragma mark - 注销
+(void)saveUserInfoWhenLogout
{
    
}

// 注销
+(void)logOutActionWithAlertDelegate:(id)target
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AlertUserLogOutTitle message:nil delegate:target cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 1000;
//    [alert show];
    //    [alert release];
}




#pragma mark -
#pragma mark - 返回SOAP信息
+(NSString *)getSoapWithRequestService:(NSString *)requestService
                      withRequestXmlns:(NSString *)xmln
                        WithRequestMsg:(NSString *)requestMsg
                     withRequestMsgURL:(NSString *)rerequestMsgURL
{
    
    /*
    
     [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
     "<soap:Body>\n"
     "<RequestServiceData xmlns=\"http://tempuri.org/\">\n"
     "<requestMessage>%@</requestMessage>\n"
     "</RequestServiceData>\n"
     "</soap:Body>\n"
     "</soap:Envelope>\n", strURLnew
     ];
     
     
     
     */
    
    
    
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
            "<soap:Body>\n"
            "<%@ xmlns=\"%@\">\n"
            "<%@>%@</%@>\n"
            "</%@>\n"
            "</soap:Body>\n"
            "</soap:Envelope>\n",requestService,xmln,requestMsg,rerequestMsgURL,requestMsg,requestService];

   
}

+ (NSString *)userInfoFilePath
{
    NSString *info = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"userInfoData.plist" ];
    NSLog(@"%@", info);
    return info;
}
+ (NSString *)ohterInfoFilePath
{
    NSString *info = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"otherInfoData.plist" ];
    NSLog(@"%@", info);
    return info;
}

+(void)saveUserName:(NSString *)Name
{
    NSString *filePath = [Util ohterInfoFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:Name forKey:userInfoFilePath_userName];
        [dict writeToFile:filePath atomically:YES];
//        [dict release];
    }
    else
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [dict setObject:Name forKey:userInfoFilePath_userName];
        [dict writeToFile:filePath  atomically:YES];
//        [dict release];
    }
}
+ (void)writeUserInfoToPath
{
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[Util userInfoFilePath]];
            
    [userInfoDic writeToFile:[Util userInfoFilePath] atomically:YES];
//    [userInfoDic release];
}


//自动新增新的字典
+(void)writePlistFile:(NSString *)plistFileName setKey:(NSMutableArray *)keyName setValue:(NSMutableArray *)valueData
{
	NSString *ValueStr;
	NSString *KeyStr;
	NSMutableDictionary  *dictionary;
	NSString *documentsDirectory=plistFileName;
	
	if([[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory])
		dictionary=[[NSMutableDictionary alloc]initWithContentsOfFile:documentsDirectory];
	else
		dictionary=[[NSMutableDictionary alloc]init];
	
	for (int i = 0; i<[keyName count]; i++)
	{
		ValueStr = [[NSString alloc] initWithFormat:@"%@",[valueData objectAtIndex:i]];
		KeyStr = [[NSString alloc] initWithFormat:@"%@",[keyName objectAtIndex:i]];
		
		[dictionary setValue:ValueStr forKey:KeyStr];
        
#if __has_feature(objc_arc)
        
#else
        [ValueStr release];
		[KeyStr release];
#endif
        
		
	}
	
	[dictionary writeToFile:documentsDirectory atomically:YES];
    
#if __has_feature(objc_arc)
    
#else
    [dictionary release];
	dictionary = nil;
#endif
    
    
	
	
	
}


+ (void)writeSingleUserInfoToPath:(NSString *)senderUserInfo andKey:(NSString *)senderKey
{
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[Util userInfoFilePath]];
    [userInfoDic setObject:senderUserInfo forKey:senderKey];
    [userInfoDic writeToFile:[Util userInfoFilePath] atomically:YES];
//    [userInfoDic release];
}

+ (void)initUserFirstLoginOrRegister
{
    
}

+ (NSString *)dataFilePath
{
    NSString *doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"collectionData.plist" ];
    return doc;
}

+ (void)showMsgAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"我知道了~" otherButtonTitles:nil];
    [alert show];
    
    
    //[Util performSelector:@selector(dismissAlertview:) withObject:alert afterDelay:1.0];
//    [alert release];
}

+ (void)showNetErrorAlert_1
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲，您的网络有问题，请重试！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
//    [alert release];
}

+ (void)showNetErrorAlert_2
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"对不起，获取服务器数据失败！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
//    [alert release];
}

// 图片
+ (UIImage *)setCustomImage:(NSString *)imageName andExt:(NSString *)extendName
{
    NSString *imageComName = [NSString stringWithFormat:@"%@.%@", imageName, extendName];
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:extendName];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageComName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

// 在串中搜索子串  str1 母串 ；str2 子串
+ (BOOL)strRangeofString:(NSString *)str1 andStr:(NSString *)str2
{
    NSRange range = [str1 rangeOfString:str2];
    
    //if (range.length || range.location != NSNotFound)
    if (range.length)
        return YES;
    else
        return NO;
}

+ (void)presentLoginView:(UIViewController *)viewController
{
    
    

    //[viewController presentModalViewController:navlogin animated:YES];
    //    [nextView release];
}


+ (void)pushLoginView:(UINavigationController *)navigationController
{
    NSLog(@"登录");
    LoginViewController *nextView = [[LoginViewController alloc] init];
    [navigationController pushViewController:nextView animated:YES];
//    [nextView release];
}


+ (void)presentLoginViewWithMemberNoLogin:(UIViewController *)viewController
{
    NSLog(@"登录");
    
    LoginViewController *nextView = [[LoginViewController alloc] init];
    
    UINavigationController *navlogin = [[UINavigationController alloc] initWithRootViewController:nextView];
    
    [viewController presentViewController:navlogin animated:YES completion:nil];
}


+ (BOOL)IsNetworkAvailable
{
    if (![UIDevice networkAvailable]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return FALSE;
    } 
    return TRUE;
}


+ (UILabel *)customLabel:(CGRect)sendRect andText:(NSString *)sendText andColor:(UIColor *)sendColor andFont:(UIFont *)sendFont andAlignment:(NSTextAlignment)textAlignment
{
//    UILabel *label = [[[UILabel alloc] initWithFrame:sendRect] autorelease];
    UILabel *label = [[UILabel alloc] initWithFrame:sendRect];
    label.backgroundColor = [UIColor clearColor];
    label.font = sendFont;
    label.textColor = sendColor;
    label.textAlignment = textAlignment;
    label.text = sendText;
    return label;
}
// 画一条直线
+ (void)drawLine:(CGFloat)firstX andlastX:(CGFloat)lastX andlineY:(CGFloat)lineY andColor:(UIColor *)lineColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // set the line properties
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0);    // lineWidth 线的宽度
    CGContextSetAlpha(context, 0.8);    // lineAlpha
    
    // draw the line
    CGContextMoveToPoint(context, firstX, lineY);
    CGContextAddLineToPoint(context, lastX, lineY);
    CGContextStrokePath(context);
}
void myShowAlert(int line, char *functname, id formatstring,...)
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
//	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
    id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	
//	NSString *filename = [[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent];
//	NSString *debugInfo = [NSString stringWithFormat:@"%@:%d\n%s", filename, line, functname];
    
    //UIAlertView *av = [[[UIAlertView alloc] initWithTitle:outstring message:debugInfo delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] autorelease];
//    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:nil message:outstring delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] autorelease];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:outstring delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
	[av show];
}




+ (NSString *)pathApplicationRoot
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
	if ([paths count] > 0) {
        NSString *dPath = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
		return dPath;
	}	
	return nil;
}


+ (NSString *)pathShare
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
	if ([paths count] > 0) {		
        
		NSString *dPath = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
        return dPath;
	}	
	return nil; 
}
+ (NSString *)filePathWith:(NSString *)name isDirectory:(BOOL)isDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
	if ([paths count] > 0) {		
		name = isDirectory ? name : [name lastPathComponent];
		//NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];	
        NSString *dPath = [[self pathApplicationRoot] stringByAppendingPathComponent:name];
		return dPath;
	}	
	return nil;
}
+ (BOOL)createDirectoryIfNecessaryAtPath:(NSString *)path
{
	BOOL succeeded = YES;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSError *err = [[NSError alloc] init];
		succeeded = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
		if (!succeeded) {
			
		}
//		[err release];
	}
	return succeeded;
}
+ (UIImage *)imageWithName:(NSString *)imgname
{
	return [Util imageWithName:imgname ofType:@"png"];
}
+ (UIImage *)imageWithName:(NSString *)imgname ofType:(NSString *)imgtype
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgname ofType:imgtype]];
}


+ (BOOL)isEmptyString:(NSString *)string
{
    BOOL result = NO;
    if (string == nil || [string length] == 0 || [string isEqualToString:@""]) {
        result = YES;
    }
    return result;
}

// 去掉前后空格
+ (NSString *)stringFormat:(id)sender
{
    NSString *senderStr = (NSString *)sender;
    sender = [senderStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return sender;
}
+(BOOL)isPhoneNumber:(NSString*)string
{
	if (!string)
	{
		NSLog(@"empty string!");
		return 0;
	}
//    if([string length] != 11)
//    {
//        NSLog(@"not cell phone number!");
//        return 0;
//    }
	int plusCount=0,leftCount=0,rightCount=0,numCount=0;
	BOOL lastIsNum=0;
	NSString *element;
	NSRange range;
	range.length=1;
	for (int i=0; i<[string length]; i++)
	{
		range.location=i;
		element=[string substringWithRange:range];
		if ([element isEqualToString:@"+"])
		{
			plusCount++;
			if (plusCount>1||range.location)return 0;
			lastIsNum=0;
			continue;
		}
		if ([element isEqualToString:@"-"])
		{
			if (range.location==0||range.location==[string length]-1||!lastIsNum) return 0;
			lastIsNum=0;
			continue;
		}
		if ([element isEqualToString:@"("]) 
		{
			leftCount++;
			if (leftCount>1||rightCount||range.location==[string length]-1||!lastIsNum)return 0;
			lastIsNum=0;
			continue;
		}
		if ([element isEqualToString:@")"])
		{
			rightCount++;
			if (rightCount>1||!leftCount||!range.location||range.location==[string length]-1||!lastIsNum)return 0;
			lastIsNum=0;
			continue;
		}
		if ([element intValue]>-1&&[element intValue]<10&&([element isEqualToString:@"0"]||[element intValue])) 
		{
			numCount++;
			lastIsNum=1;
			continue;
		}
		return 0;
	}
	if (numCount<3)return 0;
	return 1;
}



+(BOOL)isValidatePhoneNumber:(NSString *)phone
{
    //NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *emailRegex = @"\\b(1)[3578][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:phone];
}

+(BOOL)isNotSpecial:(NSString*)string
{
    BOOL result = NO;
    if (string == nil || [string length] == 0 || [string isEqualToString:@""]) {
        return result;
    }
    NSString *element;
    NSRange range;
	range.length=1;
    
	for (int i=0; i<[string length]; i++)
	{
		range.location=i;
		element=[string substringWithRange:range];
        
       //if ((element >= @"0" && element <= @"9" )|| (element >= @"A" && element <= @"Z" )|| ((element >= @"a" && element <= @"z" )))
        //if(element == @" " || element == @";" || element == @"\\"|| element == @"/"|| element == @"\""|| element == @"\'"||element == @"@")
        if([element isEqualToString:@" "] || [element isEqualToString:@";"] || [element isEqualToString:@"\\"] || [element isEqualToString:@"/"] || [element isEqualToString:@"\""] || [element isEqualToString:@"\'"] || [element isEqualToString:@"@"])
        {
            NSLog(@"bad %@",element);
            result =NO;
            break;
            return NO;
           
        }
       else 
       {
           //
        result = YES;
           continue;
           
       }
    }
    
    return result;
}
+(BOOL)isEmailString:(NSString*)email    
{    
    if((0 != [email rangeOfString:@"@"].length) &&    
       (0 != [email rangeOfString:@"."].length))    
    {    
        
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];    
//        NSMutableCharacterSet* tmpInvalidMutableCharSet = [[tmpInvalidCharSet mutableCopy] autorelease];
        NSMutableCharacterSet *tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];    
        
        //使用compare option 来设定比较规则，如    
        //NSCaseInsensitiveSearch是不区分大小写    
        //NSLiteralSearch 进行完全比较,区分大小写    
        //NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值    
        NSRange range1 = [email rangeOfString:@"@"    
                                      options:NSCaseInsensitiveSearch];    
        
        //取得用户名部分    
        NSString* userNameString = [email substringToIndex:range1.location];    
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];    
        
        for(NSString* string in userNameArray)    
        {    
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];    
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])    
                return NO;    
        }    
        
        NSString *domainString = [email substringFromIndex:range1.location+1];    
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];    
        
        for(NSString *string in domainArray)    
        {    
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];    
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])    
                return NO;    
        }    
        
        return YES;    
    }    
    else // no ''@'' or ''.'' present    
        return NO;    
}    



//
//BOOL NSStringIsValidEmail(NSString *checkString)      
//{      
//    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";     
//    NSString *laxString = @".+@.+\.[A-Za-z]{2}[A-Za-z]*";      
//    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;      
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];      
//    return [emailTest evaluateWithObject:checkString];      
//}   
//+(BOOL)isEmailString:(NSString*)string
//{
//    return result;
//}
+(void)alertButtonShowMsg:(NSString *)msg
{
    UIAlertView *alret = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alret show];
//    [alret release];
}




+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg delegate:(id)dgt tag:(NSInteger)tag cancelTitle:(NSString*)cTitle otherTitle:(NSString*)oTitle
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:dgt
                              cancelButtonTitle:cTitle
                              otherButtonTitles:oTitle, nil];
    alertView.tag = tag;
    [alertView show];
    
}



//UIAlertView* alertViewLoad
+(UIAlertView *)showProgressAlert:(NSString*)title delegates:(id)sender cancelTitle:(NSString*)cancel otherTitle:(NSString*)orther
{  
//    UIAlertView *alertViewLoad = [[[UIAlertView alloc] initWithTitle:title  
//                                                message:@"\n\n" 
//                                               delegate:sender  
//                                      cancelButtonTitle:cancel 
//                                      otherButtonTitles:orther]  
//                     autorelease]; 
    UIAlertView *alertViewLoad = [[UIAlertView alloc] initWithTitle:title  
                                                             message:@"\n\n" 
                                                            delegate:sender  
                                                   cancelButtonTitle:cancel 
                                                  otherButtonTitles:orther, nil];

//    UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //activityIndicatorView.frame = CGRectMake(30, 50, 225, 50); 
    [alertViewLoad addSubview:activityIndicatorView]; 
    //[loadingView addSubview:activityIndicatorView];  
    activityIndicatorView.autoresizingMask =  
    UIViewAutoresizingFlexibleLeftMargin |  
    UIViewAutoresizingFlexibleRightMargin |  
    UIViewAutoresizingFlexibleTopMargin |  
    UIViewAutoresizingFlexibleBottomMargin;  
    [activityIndicatorView startAnimating];
    
    
    [alertViewLoad show];
    //[alertViewLoad release];
    return alertViewLoad;
}   

+(void)removeLoadingViews:(UIAlertView *)alertViewLoad
{
    if(alertViewLoad)
    {
        [alertViewLoad dismissWithClickedButtonIndex:0 animated:YES];
        // [alertViewLoad release];
    }
    //alertViewLoad = nil;
}

+ (UIButton *)newButtonWithTitle:(NSString *)title

                          target:(id)target

                        selector:(SEL)selector

                           frame:(CGRect)frame

                           image:(UIImage *)image

                    imagePressed:(UIImage *)imagePressed

                   darkTextColor:(BOOL)darkTextColor

{   
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    // or you can do this:
    
    //      UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    
    
    
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
    
    
    
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
    
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    
    
    UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
    
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    
    
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    
    button.backgroundColor = [UIColor clearColor];
    
    
    
    return button;
    
}


#pragma mark-
#pragma mark 弹出警告
+(void)showAlertWithTitle:(NSString *)strTitle withMessage:(NSString *)strMessage withType:(int) type
{
    if (type == 1)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        
    }
    else if (type == 2)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alerView show];
        [Util performSelector:@selector(dismissAlertview:) withObject:alerView afterDelay:1.5];
        
    }
}


#pragma mark 弹出警告
+(void)showAlertWithTitle:(NSString *)strTitle withMessage:(NSString *)strMessage withType:(int) type withDelay:(NSTimeInterval)delays
{
    if (type == 1)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        
    }
    else if (type == 2)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alerView show];
        [Util performSelector:@selector(dismissAlertview:) withObject:alerView afterDelay:delays];
        
    }
}

+(void)dismissAlertview:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}




//输入框失去焦点，隐藏键盘
+ (void)resignKeyboard:(UIView *)resignView
{
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

/*
手机的验证： ^(13[0-9]|15[0-9]|18[8|9|6|7|2])\d{8}$
邮箱的验证：^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$
*/
// 验证手机号
+ (BOOL)checkMobile:(NSString *)sender
{
    BOOL result;
    NSString *mobile = [Util stringFormat:sender];

    // ^(13[0-9]|15[0-9]|18[8|9|6|7|2])\d{8}$
    result = [mobile isMatchedByRegex:@"\\b^(13[0-9]|15[0-9]|18[8|9|6|7|2])\\d{8}$\\b"];
    if (result == YES)
        return YES;
    else
        return NO;
}


// 验证邮箱
+ (BOOL)checkEmail:(NSString *)sender
{
    BOOL result;
    NSString *mobile = [Util stringFormat:sender];

    // ^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$
    result = [mobile isMatchedByRegex:@"\\b^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$\\b"];
    if (result == YES)
        return YES;
    else
        return NO;
}

// 订票验证姓名【长度不能超过5，不能为空，必须为汉字】
+ (BOOL)checkUsername:(NSString *)sender
{
    BOOL result;
    NSString *usrname = [Util stringFormat:sender];
    if (usrname.length == 0)
    {
        result = NO;
    }
    else if (usrname.length < 1 || usrname.length > 5)
    {
        result = NO;
    }
    else 
    {
        // ^[a-zA-Z0-9_-]{4,16}$
        //result = [usrname isMatchedByRegex:@"\\b^[a-zA-Z0-9_-]{4,16}$\\b"];
        result = [usrname isMatchedByRegex:@"\\b^[\\\u4E00-\\\u9FFF]{1,6}$\\b"];
        if (result == YES)
        {
            //NSLog(@"username 合法");
            result = YES;
        }
        else 
        {
            result = NO;
        }
    }
    
    return result;
}

/**
// 验证用户证件号
// 有且等于 16 位， 或 18只能输入数字以及大写的 X 
*/
+ (BOOL)checkUserCode:(NSString *)sender
{
    BOOL result;
    NSString *userCode = [Util stringFormat:sender];
    if (userCode.length == 18 || userCode.length == 15)
    {
        // @"^(^\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$"
        result = [userCode isMatchedByRegex:@"\\b^(^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X))$\\b"];
        if (result == YES)
        {
            //NSLog(@"username 合法");
            result = YES;
        }
        else 
        {
            result = NO;
        }
    }
    else 
    {
        result = NO;
    }
    
    return result;
}

// 昵称
+ (BOOL)checkNickname:(NSString *)sendStr
{
    BOOL result;
    BOOL isRight;
    NSString *nickStr = [Util stringFormat:sendStr];
    if (nickStr.length == 0)
    {
        isRight = NO;
    }
    else if (nickStr.length < 2 || nickStr.length > 16)
    {
        isRight = NO;
    }
    else 
    {
        // ^[a-zA-Z0-9_-]{4,16}$
        result = [nickStr isMatchedByRegex:@"\\b^[a-zA-Z0-9_-[\\\u4E00-\\\u9FFF]]{2,40}$\\b"];
        if (result == YES)
        {
            isRight = YES;
        }
        else 
        {
            isRight = NO;
        }
    }
    
    return isRight;
}






+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#define NavBar_Width    320.0
#define NavBar_Height   44.0
#define NavBar_Height_ios7   64.0
// bar 背景
+ (void)setCustomItemBar:(UINavigationBar *)sendNavBar
{
    UINavigationBar *navBar = sendNavBar;
    navBar.backgroundColor = [UIColor whiteColor];
    
    // @"air_bar_bg"  @"navbar"  @"navbar_ios7"
    UIImage *image = [Util setCustomImage:@"air_bar_bg" andExt:@"png"];
    UIImage *barbackImage;
    if (IOS_VERSION >= 7.0)
        barbackImage = [Util reSizeImage:image toSize:CGSizeMake(NavBar_Width, NavBar_Height_ios7)];
    else
        barbackImage = [Util reSizeImage:image toSize:CGSizeMake(NavBar_Width, NavBar_Height)];
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        [navBar setBackgroundImage:barbackImage  forBarMetrics:UIBarMetricsDefault];    //if iOS 5.0 and later
    else
        [navBar setBackgroundImage:barbackImage];
}

+ (void)setCustomItemBar:(UINavigationBar *)sendNavBar andImage:(UIImage *)image
{
    UINavigationBar *navBar = sendNavBar;
    navBar.backgroundColor = [UIColor whiteColor];
    
    UIImage *barbackImage;
    if (IOS_VERSION >= 7.0)
        barbackImage = [Util reSizeImage:image toSize:CGSizeMake(NavBar_Width, NavBar_Height_ios7)];
    else
        barbackImage = [Util reSizeImage:image toSize:CGSizeMake(NavBar_Width, NavBar_Height)];
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        [navBar setBackgroundImage:barbackImage  forBarMetrics:UIBarMetricsDefault];    //if iOS 5.0 and later
    else
        [navBar setBackgroundImage:barbackImage];
}

// bar 标题
+ (UILabel *)setItemBarTitleView:(NSString *)sendText andShadowColor:(UIColor *)shadowColor
{
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(76, 0, 168, 44)];
    titleLab.textAlignment = kUITextAlignmentCenter;
    [titleLab setFont:TextFont_20];
    titleLab.numberOfLines = 0;
    titleLab.lineBreakMode = kUILineBreakModeWordWrap;
    [titleLab setTextColor:[UIColor whiteColor]];
    if (shadowColor != nil)
    {
        titleLab.shadowColor = shadowColor;
        titleLab.shadowOffset = CGSizeMake(0, -1.0);
    }
    [titleLab setBackgroundColor:[UIColor clearColor]];
    // titleLab.adjustsFontSizeToFitWidth = YES;
    [titleLab setText:sendText];
    return titleLab;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    
    return destDate;
    
}



+ (NSString *)getTimeNow
{
    NSString* date = nil;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd-hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    NSString *years = [date substringToIndex:10];
    NSString *days = [date substringFromIndex:11];
   // NSString *hour = [date substringFromIndex:12];
    
    NSString *timeNow =[NSString stringWithFormat:@"%@ %@ ", years,days];
//    [formatter release];
    
    return timeNow;
}


+ (NSString *)getCurrentShortDate
{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}



+(NSString *)currentDateToString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSDate *date = [NSDate date];
    
    NSString *strDate = [formatter stringFromDate:date];
    
    return strDate;
    

}


+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


#pragma mark -
#pragma mark - 得到前一个月 日期
+(NSDate *)getPreDaysInNewMonthWithDate:(NSDate *)mydate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    
    return newdate;
}

#pragma mark -
#pragma mark - 得到后一个月 日期
+(NSDate *)getNextDaysInNewMonthWithDate:(NSDate *)mydate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:+1];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    
    return newdate;
}

#pragma mark- 返回当前周 星期一 到 星期天 的数据
+(NSMutableArray*)returnWeekDayArrayWithDate:(NSDate*)thisDate
{
    
    NSMutableArray *weekArray = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:thisDate];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday]; // 为本周的第几天
    // 得到几号
    NSInteger day = [comp day]; //当前多少号
    
    NSLog(@"weekDay:%d   day:%d",weekDay,day);
    
    NSInteger mdate = [calendar firstWeekday];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) // 如果为星期天 往前退 6天为起始时间
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        weekDay = [comp weekday]-1;
        
        firstDiff = mdate - weekDay;
        lastDiff = 7 - weekDay;
    }

    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:thisDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:thisDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    

    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    
    NSLog(@"当前 %@",[formater stringFromDate:thisDate]);
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    
    NSString *startDate = [Util returnCurrentDateIsEndDate:NO withDate:firstDayOfWeek];
    
    startDate = [Util dateStrWithOriginalString:startDate FromFormatter:@"yyyyy-MM-dd" toFormatter:@"d"];
    
    int intStartDate = [startDate intValue];
    
    NSString *endDate = [Util returnCurrentDateIsEndDate:YES withDate:lastDayOfWeek];
    
    endDate = [Util dateStrWithOriginalString:endDate FromFormatter:@"yyyy-MM-dd" toFormatter:@"d"];
    
    int intEndDate = [endDate intValue];
    
    NSLog(@"星期一 :%d",intStartDate);
    
    NSLog(@"星期日 :%d",intEndDate);
    
    [weekArray addObject:@"一"];
    [weekArray addObject:@"二"];
    [weekArray addObject:@"三"];
    [weekArray addObject:@"四"];
    [weekArray addObject:@"五"];
    [weekArray addObject:@"六"];
    [weekArray addObject:@"日"];
    
    
    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    
    NSLog(@"当前 %@",[formater stringFromDate:thisDate]);
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    
    return weekArray;
}


#pragma mark - 得到当前周 星期一 和星期天 的日期
+(NSString *)returnCurrentDateIsEndDate:(BOOL)isEnd withDate:(NSDate *)thisDate
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:thisDate];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday]; // 为本周的第几天
    // 得到几号
    NSInteger day = [comp day]; //当前多少号
    
    NSLog(@"weekDay:%d   day:%d",weekDay,day);
    
    NSInteger mdate = [calendar firstWeekday];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;

    
    if (weekDay == 1) //  星期天    如果为星期天 往前退 6天为起始时间
    {
        firstDiff = 0;
        lastDiff = 7;
    }
    else
    {
        weekDay = [comp weekday]-1;
        
        firstDiff = mdate - weekDay;
        
        lastDiff = 7 - weekDay;
        
        NSLog(@"lastDiff1:%ld  ",lastDiff);
        
    }
    
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:thisDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:thisDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    
    NSLog(@"当前 %@",[formater stringFromDate:thisDate]);
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    
    if(isEnd == YES) // 取星期天
    {
        NSString *endDate = [formater stringFromDate:lastDayOfWeek];
        
        return endDate;
    }
    else
    {
        NSString *beginDate = [formater stringFromDate:firstDayOfWeek];
        return beginDate;
    }
    
    
    return @"";
    
}


#pragma mark - 得到某个日期 属于星期几
+ (NSString *)getWeekdayFromDate:(NSDate*)date
{
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    
    components = [calendar components:unitFlags fromDate:date];
    
    NSUInteger weekday = [components weekday];
    
    NSInteger mdate = [calendar firstWeekday];
    
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekday == 1) // 如果为星期天 往前退 6天为起始时间
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        weekday = [components weekday]-1;
        
        firstDiff = mdate - weekday;
        lastDiff = 7 - weekday;
    }

    
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    
    
    NSString* week = nil;
    switch (weekday) {
        case 7:{
            week=@"六";
            break;
        }
        case 1:{
            week=@"日";
            break;
        }
        case 2:{
            week=@"一";
            break;
        }
        case 3:{
            week=@"二";
            break;
        }
        case 4:{
            week=@"三";
            break;
        }
        case 5:{
            week=@"四";
            break;
        }
        case 6:{
            week=@"五";
            break;
        }
        default:
            break;
    }
    
    week = [NSString stringWithFormat:@"周%@",week];
    
    return week;
    
}


+(NSString *)dateStrWithOriginalString:(NSString *)originalDateString FromFormatter:(NSString *)originalFormat  toFormatter:(NSString *)toFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:originalFormat];
    NSDate *tempDate = [formatter dateFromString:originalDateString];
   //NSLog(@"tempDate = %@,originalDateString = %@",tempDate,originalDateString);
    [formatter setDateFormat:toFormat];
    NSString *newDateStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:tempDate]];
    //NSLog(@"newDateStr = %@",newDateStr);

    return newDateStr;
}


+(NSDate*)getCurrentDate
{
    NSDate * date = [NSDate date];
    
    return date;
}


+(NSString *)dateToStringFromDate:(NSDate*)date
{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;

}



+(NSDate *)dateWithOriginalString:(NSString *)originalDateString FromFormatter:(NSString *)originalFormat  toFormatter:(NSString *)toFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:originalFormat];
    NSDate *tempDate = [formatter dateFromString:originalDateString];
    NSLog(@"tempDate == %@",tempDate);
    [formatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",toFormat]];
    NSString *newDateStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:tempDate]];
    NSLog(@"newDateStr == %@",newDateStr);
    NSDate *newDate = [formatter dateFromString:newDateStr];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit |                                  NSYearCalendarUnit) fromDate:newDate];
    NSDate *todayDate = [calendar dateFromComponents:components];
    NSLog(@"todayDate == %@",todayDate);
    
    return newDate;
}

+(NSInteger)getLiveDay:(NSDate *)begainDay leaveIn:(NSDate *)endDay
{
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    //    NSDateComponents *components = [gregorian components:unitFlags fromDate:begainDay toDate:endDay options:0];
    //    NSInteger days = [components day];
    //    return days;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:begainDay  toDate:endDay  options:0];
    int days = [comps day];
    
    return days;
    
}


+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

+(NSString *)datesCountFromeDate:(NSDate *)beginDate toDate:(NSDate *)toDate withDateFormat:(NSString *)strFormatter
{
    
    int value = [Util compareOneDay:beginDate withAnotherDay:toDate];
    
    if(value == 1)
    {
        return @"-100";
    }
    else
    {
        //创建日期格式化对象
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:strFormatter];
        
        
        //创建了两个日期对象
        //	NSDate *date1=[dateFormatter dateFromString:@"2010年3月3日"];
        //	NSDate *date2=[dateFormatter dateFromString:@"2010年3月8日"];
        //NSDate *date=[NSDate date];
        //NSString *curdate=[dateFormatter stringFromDate:date];
        
        //取两个日期对象的时间间隔：
        //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
        NSTimeInterval time=[toDate timeIntervalSinceDate:beginDate];
        int days=((int)time)/(3600*24);
        //int hours=((int)time)%(3600*24)/3600;
        //NSString *dateCount=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
        NSString *dateCount=[[NSString alloc] initWithFormat:@"%i",days];
        
        NSLog(@"dateContent == %@",dateCount);
        
        return dateCount;
    }
    
    
    
    
    
}



// 计算两个日期之间的天数
+(NSInteger)daysFromStartDate:(NSString *)startDateStr andToDate:(NSString *)endDateStr andForMat:(NSString *)sendFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];    // 本地时间
    [formatter setDateFormat:sendFormat];                   //设定时间格式,这里可以设置成自己需要的格式
    NSDate *startDate = [formatter dateFromString:startDateStr];
    NSDate *endDate = [formatter dateFromString:endDateStr];
    
	NSTimeInterval time=[endDate timeIntervalSinceDate:startDate];
	int days=((int)time)/(3600*24);
	int hours=((int)time)%(3600*24)/3600;
	NSString *dateCount=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    NSLog(@"dateContent == %@",dateCount);
    
    return days;
}



+(NSString *)returnValuableString:(NSString *)keyValue
{
    if (keyValue != nil && ![keyValue isEqual:[NSNull null]])
    {
        if ([keyValue isEqualToString:@" (null)"] || [keyValue isEqualToString:@" null"] || [keyValue isEqualToString:@" <null>"])
        {
            
            return @"";
        }
        else
        {
            keyValue = [keyValue stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            
            return keyValue;
        }
        
    }
    else
    {
        return @"";
    }
    
}


#define HANZI_START 19968
#define HANZI_COUNT 20902
static char firstLetterArray[HANZI_COUNT] =
"ydkqsxnwzssxjbymgcczqpssqbycdscdqldylybssjgyqzjjfgcclzznwdwzjljpfyynnjjtmynzwzhflzppqhgccyynmjqyxxgd"
"nnsnsjnjnsnnmlnrxyfsngnnnnqzggllyjlnyzssecykyyhqwjssggyxyqyjtwktjhychmnxjtlhjyqbyxdldwrrjnwysrldzjpc"
"bzjjbrcfslnczstzfxxchtrqggddlyccssymmrjcyqzpwwjjyfcrwfdfzqpyddwyxkyjawjffxjbcftzyhhycyswccyxsclcxxwz"
"cxnbgnnxbxlzsqsbsjpysazdhmdzbqbscwdzzyytzhbtsyyfzgntnxjywqnknphhlxgybfmjnbjhhgqtjcysxstkzglyckglysmz"
"xyalmeldccxgzyrjxjzlnjzcqkcnnjwhjczccqljststbnhbtyxceqxkkwjyflzqlyhjxspsfxlmpbysxxxytccnylllsjxfhjxp"
"jbtffyabyxbcczbzyclwlczggbtssmdtjcxpthyqtgjjxcjfzkjzjqnlzwlslhdzbwjncjzyzsqnycqynzcjjwybrtwpyftwexcs"
"kdzctbyhyzqyyjxzcfbzzmjyxxsdczottbzljwfckscsxfyrlrygmbdthjxsqjccsbxyytswfbjdztnbcnzlcyzzpsacyzzsqqcs"
"hzqydxlbpjllmqxqydzxsqjtzpxlcglqdcwzfhctdjjsfxjejjtlbgxsxjmyjjqpfzasyjnsydjxkjcdjsznbartcclnjqmwnqnc"
"lllkbdbzzsyhqcltwlccrshllzntylnewyzyxczxxgdkdmtcedejtsyyssdqdfmxdbjlkrwnqlybglxnlgtgxbqjdznyjsjyjcjm"
"rnymgrcjczgjmzmgxmmryxkjnymsgmzzymknfxmbdtgfbhcjhkylpfmdxlxjjsmsqgzsjlqdldgjycalcmzcsdjllnxdjffffjcn"
"fnnffpfkhkgdpqxktacjdhhzdddrrcfqyjkqccwjdxhwjlyllzgcfcqjsmlzpbjjblsbcjggdckkdezsqcckjgcgkdjtjllzycxk"
"lqccgjcltfpcqczgwbjdqyzjjbyjhsjddwgfsjgzkcjctllfspkjgqjhzzljplgjgjjthjjyjzccmlzlyqbgjwmljkxzdznjqsyz"
"mljlljkywxmkjlhskjhbmclyymkxjqlbmllkmdxxkwyxwslmlpsjqqjqxyqfjtjdxmxxllcrqbsyjbgwynnggbcnxpjtgpapfgdj"
"qbhbncfjyzjkjkhxqfgqckfhygkhdkllsdjqxpqyaybnqsxqnszswhbsxwhxwbzzxdmndjbsbkbbzklylxgwxjjwaqzmywsjqlsj"
"xxjqwjeqxnchetlzalyyyszzpnkyzcptlshtzcfycyxyljsdcjqagyslcllyyysslqqqnldxzsccscadycjysfsgbfrsszqsbxjp"
"sjysdrckgjlgtkzjzbdktcsyqpyhstcldjnhmymcgxyzhjdctmhltxzhylamoxyjcltyfbqqjpfbdfehthsqhzywwcncxcdwhowg"
"yjlegmdqcwgfjhcsntmydolbygnqwesqpwnmlrydzszzlyqpzgcwxhnxpyxshmdqjgztdppbfbhzhhjyfdzwkgkzbldnzsxhqeeg"
"zxylzmmzyjzgszxkhkhtxexxgylyapsthxdwhzydpxagkydxbhnhnkdnjnmyhylpmgecslnzhkxxlbzzlbmlsfbhhgsgyyggbhsc"
"yajtxglxtzmcwzydqdqmngdnllszhngjzwfyhqswscelqajynytlsxthaznkzzsdhlaxxtwwcjhqqtddwzbcchyqzflxpslzqgpz"
"sznglydqtbdlxntctajdkywnsyzljhhdzckryyzywmhychhhxhjkzwsxhdnxlyscqydpslyzwmypnkxyjlkchtyhaxqsyshxasmc"
"hkdscrsgjpwqsgzjlwwschsjhsqnhnsngndantbaalczmsstdqjcjktscjnxplggxhhgoxzcxpdmmhldgtybynjmxhmrzplxjzck"
"zxshflqxxcdhxwzpckczcdytcjyxqhlxdhypjqxnlsyydzozjnhhqezysjyayxkypdgxddnsppyzndhthrhxydpcjjhtcnnctlhb"
"ynyhmhzllnnxmylllmdcppxhmxdkycyrdltxjchhznxclcclylnzsxnjzzlnnnnwhyqsnjhxynttdkyjpychhyegkcwtwlgjrlgg"
"tgtygyhpyhylqyqgcwyqkpyyettttlhyylltyttsylnyzwgywgpydqqzzdqnnkcqnmjjzzbxtqfjkdffbtkhzkbxdjjkdjjtlbwf"
"zpptkqtztgpdwntpjyfalqmkgxbcclzfhzcllllanpnxtjklcclgyhdzfgyddgcyyfgydxkssendhykdndknnaxxhbpbyyhxccga"
"pfqyjjdmlxcsjzllpcnbsxgjyndybwjspcwjlzkzddtacsbkzdyzypjzqsjnkktknjdjgyepgtlnyqnacdntcyhblgdzhbbydmjr"
"egkzyheyybjmcdtafzjzhgcjnlghldwxjjkytcyksssmtwcttqzlpbszdtwcxgzagyktywxlnlcpbclloqmmzsslcmbjcsdzkydc"
"zjgqjdsmcytzqqlnzqzxssbpkdfqmddzzsddtdmfhtdycnaqjqkypbdjyyxtljhdrqxlmhkydhrnlklytwhllrllrcxylbnsrnzz"
"symqzzhhkyhxksmzsyzgcxfbnbsqlfzxxnnxkxwymsddyqnggqmmyhcdzttfgyyhgsbttybykjdnkyjbelhdypjqnfxfdnkzhqks"
"byjtzbxhfdsbdaswpawajldyjsfhblcnndnqjtjnchxfjsrfwhzfmdrfjyxwzpdjkzyjympcyznynxfbytfyfwygdbnzzzdnytxz"
"emmqbsqehxfznbmflzzsrsyqjgsxwzjsprytjsjgskjjgljjynzjjxhgjkymlpyyycxycgqzswhwlyrjlpxslcxmnsmwklcdnkny"
"npsjszhdzeptxmwywxyysywlxjqcqxzdclaeelmcpjpclwbxsqhfwrtfnjtnqjhjqdxhwlbyccfjlylkyynldxnhycstyywncjtx"
"ywtrmdrqnwqcmfjdxzmhmayxnwmyzqtxtlmrspwwjhanbxtgzypxyyrrclmpamgkqjszycymyjsnxtplnbappypylxmyzkynldgy"
"jzcchnlmzhhanqnbgwqtzmxxmllhgdzxnhxhrxycjmffxywcfsbssqlhnndycannmtcjcypnxnytycnnymnmsxndlylysljnlxys"
"sqmllyzlzjjjkyzzcsfbzxxmstbjgnxnchlsnmcjscyznfzlxbrnnnylmnrtgzqysatswryhyjzmgdhzgzdwybsscskxsyhytsxg"
"cqgxzzbhyxjscrhmkkbsczjyjymkqhzjfnbhmqhysnjnzybknqmcjgqhwlsnzswxkhljhyybqcbfcdsxdldspfzfskjjzwzxsddx"
"jseeegjscssygclxxnwwyllymwwwgydkzjggggggsycknjwnjpcxbjjtqtjwdsspjxcxnzxnmelptfsxtllxcljxjjljsxctnswx"
"lennlyqrwhsycsqnybyaywjejqfwqcqqcjqgxaldbzzyjgkgxbltqyfxjltpydkyqhpmatlcndnkxmtxynhklefxdllegqtymsaw"
"hzmljtkynxlyjzljeeyybqqffnlyxhdsctgjhxywlkllxqkcctnhjlqmkkzgcyygllljdcgydhzwypysjbzjdzgyzzhywyfqdtyz"
"szyezklymgjjhtsmqwyzljyywzcsrkqyqltdxwcdrjalwsqzwbdcqyncjnnszjlncdcdtlzzzacqqzzddxyblxcbqjylzllljddz"
"jgyqyjzyxnyyyexjxksdaznyrdlzyyynjlslldyxjcykywnqcclddnyyynycgczhjxcclgzqjgnwnncqqjysbzzxyjxjnxjfzbsb"
"dsfnsfpzxhdwztdmpptflzzbzdmyypqjrsdzsqzsqxbdgcpzswdwcsqzgmdhzxmwwfybpngphdmjthzsmmbgzmbzjcfzhfcbbnmq"
"dfmbcmcjxlgpnjbbxgyhyyjgptzgzmqbqdcgybjxlwnkydpdymgcftpfxyztzxdzxtgkptybbclbjaskytssqyymscxfjhhlslls"
"jpqjjqaklyldlycctsxmcwfgngbqxllllnyxtyltyxytdpjhnhgnkbyqnfjyyzbyyessessgdyhfhwtcqbsdzjtfdmxhcnjzymqw"
"srxjdzjqbdqbbsdjgnfbknbxdkqhmkwjjjgdllthzhhyyyyhhsxztyyyccbdbpypzyccztjpzywcbdlfwzcwjdxxhyhlhwczxjtc"
"nlcdpxnqczczlyxjjcjbhfxwpywxzpcdzzbdccjwjhmlxbqxxbylrddgjrrctttgqdczwmxfytmmzcwjwxyywzzkybzcccttqnhx"
"nwxxkhkfhtswoccjybcmpzzykbnnzpbthhjdlszddytyfjpxyngfxbyqxzbhxcpxxtnzdnnycnxsxlhkmzxlthdhkghxxsshqyhh"
"cjyxglhzxcxnhekdtgqxqypkdhentykcnymyyjmkqyyyjxzlthhqtbyqhxbmyhsqckwwyllhcyylnneqxqwmcfbdccmljggxdqkt"
"lxkknqcdgcjwyjjlyhhqyttnwchhxcxwherzjydjccdbqcdgdnyxzdhcqrxcbhztqcbxwgqwyybxhmbymykdyecmqkyaqyngyzsl"
"fnkkqgyssqyshngjctxkzycssbkyxhyylstycxqthysmnscpmmgcccccmnztasmgqzjhklosjylswtmqzyqkdzljqqyplzycztcq"
"qpbbcjzclpkhqcyyxxdtdddsjcxffllchqxmjlwcjcxtspycxndtjshjwhdqqqckxyamylsjhmlalygxcyydmamdqmlmcznnyybz"
"xkyflmcncmlhxrcjjhsylnmtjggzgywjxsrxcwjgjqhqzdqjdcjjskjkgdzcgjjyjylxzxxcdqhhheslmhlfsbdjsyyshfyssczq"
"lpbdrfnztzdkykhsccgkwtqzckmsynbcrxqbjyfaxpzzedzcjykbcjwhyjbqzzywnyszptdkzpfpbaztklqnhbbzptpptyzzybhn"
"ydcpzmmcycqmcjfzzdcmnlfpbplngqjtbttajzpzbbdnjkljqylnbzqhksjznggqstzkcxchpzsnbcgzkddzqanzgjkdrtlzldwj"
"njzlywtxndjzjhxnatncbgtzcsskmljpjytsnwxcfjwjjtkhtzplbhsnjssyjbhbjyzlstlsbjhdnwqpslmmfbjdwajyzccjtbnn"
"nzwxxcdslqgdsdpdzgjtqqpsqlyyjzlgyhsdlctcbjtktyczjtqkbsjlgnnzdncsgpynjzjjyyknhrpwszxmtncszzyshbyhyzax"
"ywkcjtllckjjtjhgcssxyqyczbynnlwqcglzgjgqyqcczssbcrbcskydznxjsqgxssjmecnstjtpbdlthzwxqwqczexnqczgwesg"
"ssbybstscslccgbfsdqnzlccglllzghzcthcnmjgyzazcmsksstzmmzckbjygqljyjppldxrkzyxccsnhshhdznlzhzjjcddcbcj"
"xlbfqbczztpqdnnxljcthqzjgylklszzpcjdscqjhjqkdxgpbajynnsmjtzdxlcjyryynhjbngzjkmjxltbsllrzpylssznxjhll"
"hyllqqzqlsymrcncxsljmlzltzldwdjjllnzggqxppskyggggbfzbdkmwggcxmcgdxjmcjsdycabxjdlnbcddygskydqdxdjjyxh"
"saqazdzfslqxxjnqzylblxxwxqqzbjzlfbblylwdsljhxjyzjwtdjcyfqzqzzdzsxzzqlzcdzfxhwspynpqzmlpplffxjjnzzyls"
"jnyqzfpfzgsywjjjhrdjzzxtxxglghtdxcskyswmmtcwybazbjkshfhgcxmhfqhyxxyzftsjyzbxyxpzlchmzmbxhzzssyfdmncw"
"dabazlxktcshhxkxjjzjsthygxsxyyhhhjwxkzxssbzzwhhhcwtzzzpjxsyxqqjgzyzawllcwxznxgyxyhfmkhydwsqmnjnaycys"
"pmjkgwcqhylajgmzxhmmcnzhbhxclxdjpltxyjkdyylttxfqzhyxxsjbjnayrsmxyplckdnyhlxrlnllstycyyqygzhhsccsmcct"
"zcxhyqfpyyrpbflfqnntszlljmhwtcjqyzwtlnmlmdwmbzzsnzrbpdddlqjjbxtcsnzqqygwcsxfwzlxccrszdzmcyggdyqsgtnn"
"nlsmymmsyhfbjdgyxccpshxczcsbsjyygjmpbwaffyfnxhydxzylremzgzzyndsznlljcsqfnxxkptxzgxjjgbmyyssnbtylbnlh"
"bfzdcyfbmgqrrmzszxysjtznnydzzcdgnjafjbdknzblczszpsgcycjszlmnrznbzzldlnllysxsqzqlcxzlsgkbrxbrbzcycxzj"
"zeeyfgklzlnyhgzcgzlfjhgtgwkraajyzkzqtsshjjxdzyznynnzyrzdqqhgjzxsszbtkjbbfrtjxllfqwjgclqtymblpzdxtzag"
"bdhzzrbgjhwnjtjxlkscfsmwlldcysjtxkzscfwjlbnntzlljzllqblcqmqqcgcdfpbphzczjlpyyghdtgwdxfczqyyyqysrclqz"
"fklzzzgffcqnwglhjycjjczlqzzyjbjzzbpdcsnnjgxdqnknlznnnnpsntsdyfwwdjzjysxyyczcyhzwbbyhxrylybhkjksfxtjj"
"mmchhlltnyymsxxyzpdjjycsycwmdjjkqyrhllngpngtlyycljnnnxjyzfnmlrgjjtyzbsyzmsjyjhgfzqmsyxrszcytlrtqzsst"
"kxgqkgsptgxdnjsgcqcqhmxggztqydjjznlbznxqlhyqgggthqscbyhjhhkyygkggcmjdzllcclxqsftgjslllmlcskctbljszsz"
"mmnytpzsxqhjcnnqnyexzqzcpshkzzyzxxdfgmwqrllqxrfztlystctmjcsjjthjnxtnrztzfqrhcgllgcnnnnjdnlnnytsjtlny"
"xsszxcgjzyqpylfhdjsbbdczgjjjqzjqdybssllcmyttmqnbhjqmnygjyeqyqmzgcjkpdcnmyzgqllslnclmholzgdylfzslncnz"
"lylzcjeshnyllnxnjxlyjyyyxnbcljsswcqqnnyllzldjnllzllbnylnqchxyyqoxccqkyjxxxyklksxeyqhcqkkkkcsnyxxyqxy"
"gwtjohthxpxxhsnlcykychzzcbwqbbwjqcscszsslcylgddsjzmmymcytsdsxxscjpqqsqylyfzychdjynywcbtjsydchcyddjlb"
"djjsodzyqyskkyxdhhgqjyohdyxwgmmmazdybbbppbcmnnpnjzsmtxerxjmhqdntpjdcbsnmssythjtslmltrcplzszmlqdsdmjm"
"qpnqdxcfrnnfsdqqyxhyaykqyddlqyyysszbydslntfgtzqbzmchdhczcwfdxtmqqsphqwwxsrgjcwnntzcqmgwqjrjhtqjbbgwz"
"fxjhnqfxxqywyyhyscdydhhqmrmtmwctbszppzzglmzfollcfwhmmsjzttdhlmyffytzzgzyskjjxqyjzqbhmbzclyghgfmshpcf"
"zsnclpbqsnjyzslxxfpmtyjygbxlldlxpzjyzjyhhzcywhjylsjexfszzywxkzjlnadymlymqjpwxxhxsktqjezrpxxzghmhwqpw"
"qlyjjqjjzszcnhjlchhnxjlqwzjhbmzyxbdhhypylhlhlgfwlcfyytlhjjcwmscpxstkpnhjxsntyxxtestjctlsslstdlllwwyh"
"dnrjzsfgxssyczykwhtdhwjglhtzdqdjzxxqgghltzphcsqfclnjtclzpfstpdynylgmjllycqhynspchylhqyqtmzymbywrfqyk"
"jsyslzdnjmpxyyssrhzjnyqtqdfzbwwdwwrxcwggyhxmkmyyyhmxmzhnksepmlqqmtcwctmxmxjpjjhfxyyzsjzhtybmstsyjznq"
"jnytlhynbyqclcycnzwsmylknjxlggnnpjgtysylymzskttwlgsmzsylmpwlcwxwqcssyzsyxyrhssntsrwpccpwcmhdhhxzdzyf"
"jhgzttsbjhgyglzysmyclllxbtyxhbbzjkssdmalhhycfygmqypjyjqxjllljgclzgqlycjcctotyxmtmshllwlqfxymzmklpszz"
"cxhkjyclctyjcyhxsgyxnnxlzwpyjpxhjwpjpwxqqxlxsdhmrslzzydwdtcxknstzshbsccstplwsscjchjlcgchssphylhfhhxj"
"sxallnylmzdhzxylsxlmzykcldyahlcmddyspjtqjzlngjfsjshctsdszlblmssmnyymjqbjhrzwtyydchjljapzwbgqxbkfnbjd"
"llllyylsjydwhxpsbcmljpscgbhxlqhyrljxyswxhhzlldfhlnnymjljyflyjycdrjlfsyzfsllcqyqfgqyhnszlylmdtdjcnhbz"
"llnwlqxygyyhbmgdhxxnhlzzjzxczzzcyqzfngwpylcpkpykpmclgkdgxzgxwqbdxzzkzfbddlzxjtpjpttbythzzdwslcpnhslt"
"jxxqlhyxxxywzyswttzkhlxzxzpyhgzhknfsyhntjrnxfjcpjztwhplshfcrhnslxxjxxyhzqdxqwnnhyhmjdbflkhcxcwhjfyjc"
"fpqcxqxzyyyjygrpynscsnnnnchkzdyhflxxhjjbyzwttxnncyjjymswyxqrmhxzwfqsylznggbhyxnnbwttcsybhxxwxyhhxyxn"
"knyxmlywrnnqlxbbcljsylfsytjzyhyzawlhorjmnsczjxxxyxchcyqryxqzddsjfslyltsffyxlmtyjmnnyyyxltzcsxqclhzxl"
"wyxzhnnlrxkxjcdyhlbrlmbrdlaxksnlljlyxxlynrylcjtgncmtlzllcyzlpzpzyawnjjfybdyyzsepckzzqdqpbpsjpdyttbdb"
"bbyndycncpjmtmlrmfmmrwyfbsjgygsmdqqqztxmkqwgxllpjgzbqrdjjjfpkjkcxbljmswldtsjxldlppbxcwkcqqbfqbccajzg"
"mykbhyhhzykndqzybpjnspxthlfpnsygyjdbgxnhhjhzjhstrstldxskzysybmxjlxyslbzyslzxjhfybqnbylljqkygzmcyzzym"
"ccslnlhzhwfwyxzmwyxtynxjhbyymcysbmhysmydyshnyzchmjjmzcaahcbjbbhblytylsxsnxgjdhkxxtxxnbhnmlngsltxmrhn"
"lxqqxmzllyswqgdlbjhdcgjyqyymhwfmjybbbyjyjwjmdpwhxqldyapdfxxbcgjspckrssyzjmslbzzjfljjjlgxzgyxyxlszqkx"
"bexyxhgcxbpndyhwectwwcjmbtxchxyqqllxflyxlljlssnwdbzcmyjclwswdczpchqekcqbwlcgydblqppqzqfnqdjhymmcxtxd"
"rmzwrhxcjzylqxdyynhyyhrslnrsywwjjymtltllgtqcjzyabtckzcjyccqlysqxalmzynywlwdnzxqdllqshgpjfjljnjabcqzd"
"jgthhsstnyjfbswzlxjxrhgldlzrlzqzgsllllzlymxxgdzhgbdphzpbrlwnjqbpfdwonnnhlypcnjccndmbcpbzzncyqxldomzb"
"lzwpdwyygdstthcsqsccrsssyslfybnntyjszdfndpdhtqzmbqlxlcmyffgtjjqwftmnpjwdnlbzcmmcngbdzlqlpnfhyymjylsd"
"chdcjwjcctljcldtljjcbddpndsszycndbjlggjzxsxnlycybjjxxcbylzcfzppgkcxqdzfztjjfjdjxzbnzyjqctyjwhdyczhym"
"djxttmpxsplzcdwslshxypzgtfmlcjtacbbmgdewycyzxdszjyhflystygwhkjyylsjcxgywjcbllcsnddbtzbsclyzczzssqdll"
"mjyyhfllqllxfdyhabxggnywyypllsdldllbjcyxjznlhljdxyyqytdlllbngpfdfbbqbzzmdpjhgclgmjjpgaehhbwcqxajhhhz"
"chxyphjaxhlphjpgpzjqcqzgjjzzgzdmqyybzzphyhybwhazyjhykfgdpfqsdlzmljxjpgalxzdaglmdgxmmzqwtxdxxpfdmmssy"
"mpfmdmmkxksyzyshdzkjsysmmzzzmdydyzzczxbmlstmdyemxckjmztyymzmzzmsshhdccjewxxkljsthwlsqlyjzllsjssdppmh"
"nlgjczyhmxxhgncjmdhxtkgrmxfwmckmwkdcksxqmmmszzydkmsclcmpcjmhrpxqpzdsslcxkyxtwlkjyahzjgzjwcjnxyhmmbml"
"gjxmhlmlgmxctkzmjlyscjsyszhsyjzjcdajzhbsdqjzgwtkqxfkdmsdjlfmnhkzqkjfeypzyszcdpynffmzqykttdzzefmzlbnp"
"plplpbpszalltnlkckqzkgenjlwalkxydpxnhsxqnwqnkxqclhyxxmlnccwlymqyckynnlcjnszkpyzkcqzqljbdmdjhlasqlbyd"
"wqlwdgbqcryddztjybkbwszdxdtnpjdtcnqnfxqqmgnseclstbhpwslctxxlpwydzklnqgzcqapllkqcylbqmqczqcnjslqzdjxl"
"ddhpzqdljjxzqdjyzhhzlkcjqdwjppypqakjyrmpzbnmcxkllzllfqpylllmbsglzysslrsysqtmxyxzqzbscnysyztffmzzsmzq"
"hzssccmlyxwtpzgxzjgzgsjzgkddhtqggzllbjdzlsbzhyxyzhzfywxytymsdnzzyjgtcmtnxqyxjscxhslnndlrytzlryylxqht"
"xsrtzcgyxbnqqzfhykmzjbzymkbpnlyzpblmcnqyzzzsjztjctzhhyzzjrdyzhnfxklfzslkgjtctssyllgzrzbbjzzklpkbczys"
"nnyxbjfbnjzzxcdwlzyjxzzdjjgggrsnjkmsmzjlsjywqsnyhqjsxpjztnlsnshrnynjtwchglbnrjlzxwjqxqkysjycztlqzybb"
"ybyzjqdwgyzcytjcjxckcwdkkzxsnkdnywwyyjqyytlytdjlxwkcjnklccpzcqqdzzqlcsfqchqqgssmjzzllbjjzysjhtsjdysj"
"qjpdszcdchjkjzzlpycgmzndjxbsjzzsyzyhgxcpbjydssxdzncglqmbtsfcbfdzdlznfgfjgfsmpnjqlnblgqcyyxbqgdjjqsrf"
"kztjdhczklbsdzcfytplljgjhtxzcsszzxstjygkgckgynqxjplzbbbgcgyjzgczqszlbjlsjfzgkqqjcgycjbzqtldxrjnbsxxp"
"zshszycfwdsjjhxmfczpfzhqhqmqnknlyhtycgfrzgnqxcgpdlbzcsczqlljblhbdcypscppdymzzxgyhckcpzjgslzlnscnsldl"
"xbmsdlddfjmkdqdhslzxlsznpqpgjdlybdskgqlbzlnlkyyhzttmcjnqtzzfszqktlljtyyllnllqyzqlbdzlslyyzxmdfszsnxl"
"xznczqnbbwskrfbcylctnblgjpmczzlstlxshtzcyzlzbnfmqnlxflcjlyljqcbclzjgnsstbrmhxzhjzclxfnbgxgtqncztmsfz"
"kjmssncljkbhszjntnlzdntlmmjxgzjyjczxyhyhwrwwqnztnfjscpyshzjfyrdjsfscjzbjfzqzchzlxfxsbzqlzsgyftzdcszx"
"zjbjpszkjrhxjzcgbjkhcggtxkjqglxbxfgtrtylxqxhdtsjxhjzjjcmzlcqsbtxwqgxtxxhxftsdkfjhzyjfjxnzldlllcqsqqz"
"qwqxswqtwgwbzcgcllqzbclmqjtzgzyzxljfrmyzflxnsnxxjkxrmjdzdmmyxbsqbhgzmwfwygmjlzbyytgzyccdjyzxsngnyjyz"
"nbgpzjcqsyxsxrtfyzgrhztxszzthcbfclsyxzlzqmzlmplmxzjssfsbysmzqhxxnxrxhqzzzsslyflczjrcrxhhzxqndshxsjjh"
"qcjjbcynsysxjbqjpxzqplmlxzkyxlxcnlcycxxzzlxdlllmjyhzxhyjwkjrwyhcpsgnrzlfzwfzznsxgxflzsxzzzbfcsyjdbrj"
"krdhhjxjljjtgxjxxstjtjxlyxqfcsgswmsbctlqzzwlzzkxjmltmjyhsddbxgzhdlbmyjfrzfcgclyjbpmlysmsxlszjqqhjzfx"
"gfqfqbphngyyqxgztnqwyltlgwgwwhnlfmfgzjmgmgbgtjflyzzgzyzaflsspmlbflcwbjztljjmzlpjjlymqtmyyyfbgygqzgly"
"zdxqyxrqqqhsxyyqxygjtyxfsfsllgnqcygycwfhcccfxpylypllzqxxxxxqqhhsshjzcftsczjxspzwhhhhhapylqnlpqafyhxd"
"ylnkmzqgggddesrenzltzgchyppcsqjjhclljtolnjpzljlhymhezdydsqycddhgznndzclzywllznteydgnlhslpjjbdgwxpcnn"
"tycklkclwkllcasstknzdnnjttlyyzssysszzryljqkcgdhhyrxrzydgrgcwcgzqffbppjfzynakrgywyjpqxxfkjtszzxswzddf"
"bbqtbgtzkznpzfpzxzpjszbmqhkyyxyldkljnypkyghgdzjxxeaxpnznctzcmxcxmmjxnkszqnmnlwbwwqjjyhclstmcsxnjcxxt"
"pcnfdtnnpglllzcjlspblpgjcdtnjjlyarscffjfqwdpgzdwmrzzcgodaxnssnyzrestyjwjyjdbcfxnmwttbqlwstszgybljpxg"
"lbnclgpcbjftmxzljylzxcltpnclcgxtfzjshcrxsfysgdkntlbyjcyjllstgqcbxnhzxbxklylhzlqzlnzcqwgzlgzjncjgcmnz"
"zgjdzxtzjxycyycxxjyyxjjxsssjstsstdppghtcsxwzdcsynptfbchfbblzjclzzdbxgcjlhpxnfzflsyltnwbmnjhszbmdnbcy"
"sccldnycndqlyjjhmqllcsgljjsyfpyyccyltjantjjpwycmmgqyysxdxqmzhszxbftwwzqswqrfkjlzjqqyfbrxjhhfwjgzyqac"
"myfrhcyybynwlpexcczsyyrlttdmqlrkmpbgmyyjprkznbbsqyxbhyzdjdnghpmfsgbwfzmfqmmbzmzdcgjlnnnxyqgmlrygqccy"
"xzlwdkcjcggmcjjfyzzjhycfrrcmtznzxhkqgdjxccjeascrjthpljlrzdjrbcqhjdnrhylyqjsymhzydwcdfryhbbydtssccwbx"
"glpzmlzjdqsscfjmmxjcxjytycghycjwynsxlfemwjnmkllswtxhyyyncmmcyjdqdjzglljwjnkhpzggflccsczmcbltbhbqjxqd"
"jpdjztghglfjawbzyzjltstdhjhctcbchflqmpwdshyytqwcnntjtlnnmnndyyyxsqkxwyyflxxnzwcxypmaelyhgjwzzjbrxxaq"
"jfllpfhhhytzzxsgqjmhspgdzqwbwpjhzjdyjcqwxkthxsqlzyymysdzgnqckknjlwpnsyscsyzlnmhqsyljxbcxtlhzqzpcycyk"
"pppnsxfyzjjrcemhszmnxlxglrwgcstlrsxbygbzgnxcnlnjlclynymdxwtzpalcxpqjcjwtcyyjlblxbzlqmyljbghdslssdmxm"
"bdczsxyhamlczcpjmcnhjyjnsykchskqmczqdllkablwjqsfmocdxjrrlyqchjmybyqlrhetfjzfrfksryxfjdwtsxxywsqjysly"
"xwjhsdlxyyxhbhawhwjcxlmyljcsqlkydttxbzslfdxgxsjkhsxxybssxdpwncmrptqzczenygcxqfjxkjbdmljzmqqxnoxslyxx"
"lylljdzptymhbfsttqqwlhsgynlzzalzxclhtwrrqhlstmypyxjjxmnsjnnbryxyjllyqyltwylqyfmlkljdnlltfzwkzhljmlhl"
"jnljnnlqxylmbhhlnlzxqchxcfxxlhyhjjgbyzzkbxscqdjqdsndzsygzhhmgsxcsymxfepcqwwrbpyyjqryqcyjhqqzyhmwffhg"
"zfrjfcdbxntqyzpcyhhjlfrzgpbxzdbbgrqstlgdgylcqmgchhmfywlzyxkjlypjhsywmqqggzmnzjnsqxlqsyjtcbehsxfszfxz"
"wfllbcyyjdytdthwzsfjmqqyjlmqsxlldttkghybfpwdyysqqrnqwlgwdebzwcyygcnlkjxtmxmyjsxhybrwfymwfrxyymxysctz"
"ztfykmldhqdlgyjnlcryjtlpsxxxywlsbrrjwxhqybhtydnhhxmmywytycnnmnssccdalwztcpqpyjllqzyjswjwzzmmglmxclmx"
"nzmxmzsqtzppjqblpgxjzhfljjhycjsrxwcxsncdlxsyjdcqzxslqyclzxlzzxmxqrjmhrhzjbhmfljlmlclqnldxzlllfyprgjy"
"nxcqqdcmqjzzxhnpnxzmemmsxykynlxsxtljxyhwdcwdzhqyybgybcyscfgfsjnzdrzzxqxrzrqjjymcanhrjtldbpyzbstjhxxz"
"ypbdwfgzzrpymnnkxcqbyxnbnfyckrjjcmjegrzgyclnnzdnkknsjkcljspgyyclqqjybzssqlllkjftbgtylcccdblsppfylgyd"
"tzjqjzgkntsfcxbdkdxxhybbfytyhbclnnytgdhryrnjsbtcsnyjqhklllzslydxxwbcjqsbxnpjzjzjdzfbxxbrmladhcsnclbj"
"dstblprznswsbxbcllxxlzdnzsjpynyxxyftnnfbhjjjgbygjpmmmmsszljmtlyzjxswxtyledqpjmpgqzjgdjlqjwjqllsdgjgy"
"gmscljjxdtygjqjjjcjzcjgdzdshqgzjggcjhqxsnjlzzbxhsgzxcxyljxyxyydfqqjhjfxdhctxjyrxysqtjxyefyyssyxjxncy"
"zxfxcsxszxyyschshxzzzgzzzgfjdldylnpzgsjaztyqzpbxcbdztzczyxxyhhscjshcggqhjhgxhsctmzmehyxgebtclzkkwytj"
"zrslekestdbcyhqqsayxcjxwwgsphjszsdncsjkqcxswxfctynydpccczjqtcwjqjzzzqzljzhlsbhpydxpsxshhezdxfptjqyzc"
"xhyaxncfzyyhxgnqmywntzsjbnhhgymxmxqcnssbcqsjyxxtyyhybcqlmmszmjzzllcogxzaajzyhjmchhcxzsxsdznleyjjzjbh"
"zwjzsqtzpsxzzdsqjjjlnyazphhyysrnqzthzhnyjyjhdzxzlswclybzyecwcycrylchzhzydzydyjdfrjjhtrsqtxyxjrjhojyn"
"xelxsfsfjzghpzsxzszdzcqzbyyklsgsjhczshdgqgxyzgxchxzjwyqwgyhksseqzzndzfkwyssdclzstsymcdhjxxyweyxczayd"
"mpxmdsxybsqmjmzjmtjqlpjyqzcgqhyjhhhqxhlhdldjqcfdwbsxfzzyyschtytyjbhecxhjkgqfxbhyzjfxhwhbdzfyzbchpnpg"
"dydmsxhkhhmamlnbyjtmpxejmcthqbzyfcgtyhwphftgzzezsbzegpbmdskftycmhbllhgpzjxzjgzjyxzsbbqsczzlzscstpgxm"
"jsfdcczjzdjxsybzlfcjsazfgszlwbczzzbyztzynswyjgxzbdsynxlgzbzfygczxbzhzftpbgzgejbstgkdmfhyzzjhzllzzgjq"
"zlsfdjsscbzgpdlfzfzszyzyzsygcxsnxxchczxtzzljfzgqsqqxcjqccccdjcdszzyqjccgxztdlgscxzsyjjqtcclqdqztqchq"
"qyzynzzzpbkhdjfcjfztypqyqttynlmbdktjcpqzjdzfpjsbnjlgyjdxjdcqkzgqkxclbzjtcjdqbxdjjjstcxnxbxqmslyjcxnt"
"jqwwcjjnjjlllhjcwqtbzqqczczpzzdzyddcyzdzccjgtjfzdprntctjdcxtqzdtjnplzbcllctdsxkjzqdmzlbznbtjdcxfczdb"
"czjjltqqpldckztbbzjcqdcjwynllzlzccdwllxwzlxrxntqjczxkjlsgdnqtddglnlajjtnnynkqlldzntdnycygjwyxdxfrsqs"
"tcdenqmrrqzhhqhdldazfkapbggpzrebzzykyqspeqjjglkqzzzjlysyhyzwfqznlzzlzhwcgkypqgnpgblplrrjyxcccgyhsfzf"
"wbzywtgzxyljczwhncjzplfflgskhyjdeyxhlpllllcygxdrzelrhgklzzyhzlyqszzjzqljzflnbhgwlczcfjwspyxzlzlxgccp"
"zbllcxbbbbnbbcbbcrnnzccnrbbnnldcgqyyqxygmqzwnzytyjhyfwtehznjywlccntzyjjcdedpwdztstnjhtymbjnyjzlxtsst"
"phndjxxbyxqtzqddtjtdyztgwscszqflshlnzbcjbhdlyzjyckwtydylbnydsdsycctyszyyebgexhqddwnygyclxtdcystqnygz"
"ascsszzdzlcclzrqxyywljsbymxshzdembbllyyllytdqyshymrqnkfkbfxnnsbychxbwjyhtqbpbsbwdzylkgzskyghqzjxhxjx"
"gnljkzlyycdxlfwfghljgjybxblybxqpqgntzplncybxdjyqydymrbeyjyyhkxxstmxrczzjwxyhybmcflyzhqyzfwxdbxbcwzms"
"lpdmyckfmzklzcyqycclhxfzlydqzpzygyjyzmdxtzfnnyttqtzhgsfcdmlccytzxjcytjmkslpzhysnwllytpzctzccktxdhxxt"
"qcyfksmqccyyazhtjplylzlyjbjxtfnyljyynrxcylmmnxjsmybcsysslzylljjgyldzdlqhfzzblfndsqkczfyhhgqmjdsxyctt"
"xnqnjpyybfcjtyyfbnxejdgyqbjrcnfyyqpghyjsyzngrhtknlnndzntsmgklbygbpyszbydjzsstjztsxzbhbscsbzczptqfzlq"
"flypybbjgszmnxdjmtsyskkbjtxhjcegbsmjyjzcstmljyxrczqscxxqpyzhmkyxxxjcljyrmyygadyskqlnadhrskqxzxztcggz"
"dlmlwxybwsyctbhjhcfcwzsxwwtgzlxqshnyczjxemplsrcgltnzntlzjcyjgdtclglbllqpjmzpapxyzlaktkdwczzbncctdqqz"
"qyjgmcdxltgcszlmlhbglkznnwzndxnhlnmkydlgxdtwcfrjerctzhydxykxhwfzcqshknmqqhzhhymjdjskhxzjzbzzxympajnm"
"ctbxlsxlzynwrtsqgscbptbsgzwyhtlkssswhzzlyytnxjgmjrnsnnnnlskztxgxlsammlbwldqhylakqcqctmycfjbslxclzjcl"
"xxknbnnzlhjphqplsxsckslnhpsfqcytxjjzljldtzjjzdlydjntptnndskjfsljhylzqqzlbthydgdjfdbyadxdzhzjnthqbykn"
"xjjqczmlljzkspldsclbblnnlelxjlbjycxjxgcnlcqplzlznjtsljgyzdzpltqcssfdmnycxgbtjdcznbgbqyqjwgkfhtnbyqzq"
"gbkpbbyzmtjdytblsqmbsxtbnpdxklemyycjynzdtldykzzxtdxhqshygmzsjycctayrzlpwltlkxslzcggexclfxlkjrtlqjaqz"
"ncmbqdkkcxglczjzxjhptdjjmzqykqsecqzdshhadmlzfmmzbgntjnnlhbyjbrbtmlbyjdzxlcjlpldlpcqdhlhzlycblcxccjad"
"qlmzmmsshmybhbnkkbhrsxxjmxmdznnpklbbrhgghfchgmnklltsyyycqlcskymyehywxnxqywbawykqldnntndkhqcgdqktgpkx"
"hcpdhtwnmssyhbwcrwxhjmkmzngwtmlkfghkjyldyycxwhyyclqhkqhtdqkhffldxqwytyydesbpkyrzpjfyyzjceqdzzdlattpb"
"fjllcxdlmjsdxegwgsjqxcfbssszpdyzcxznyxppzydlyjccpltxlnxyzyrscyyytylwwndsahjsygyhgywwaxtjzdaxysrltdps"
"syxfnejdxyzhlxlllzhzsjnyqyqyxyjghzgjcyjchzlycdshhsgczyjscllnxzjjyyxnfsmwfpyllyllabmddhwzxjmcxztzpmlq"
"chsfwzynctlndywlslxhymmylmbwwkyxyaddxylldjpybpwnxjmmmllhafdllaflbnhhbqqjqzjcqjjdjtffkmmmpythygdrjrdd"
"wrqjxnbysrmzdbyytbjhpymyjtjxaahggdqtmystqxkbtzbkjlxrbyqqhxmjjbdjntgtbxpgbktlgqxjjjcdhxqdwjlwrfmjgwqh"
"cnrxswgbtgygbwhswdwrfhwytjjxxxjyzyslphyypyyxhydqpxshxyxgskqhywbdddpplcjlhqeewjgsyykdpplfjthkjltcyjhh"
"jttpltzzcdlyhqkcjqysteeyhkyzyxxyysddjkllpymqyhqgxqhzrhbxpllnqydqhxsxxwgdqbshyllpjjjthyjkyphthyyktyez"
"yenmdshlzrpqfbnfxzbsftlgxsjbswyysksflxlpplbbblnsfbfyzbsjssylpbbffffsscjdstjsxtryjcyffsyzyzbjtlctsbsd"
"hrtjjbytcxyyeylycbnebjdsysyhgsjzbxbytfzwgenhhhthjhhxfwgcstbgxklstyymtmbyxjskzscdyjrcythxzfhmymcxlzns"
"djtxtxrycfyjsbsdyerxhljxbbdeynjghxgckgscymblxjmsznskgxfbnbbthfjyafxwxfbxmyfhdttcxzzpxrsywzdlybbktyqw"
"qjbzypzjznjpzjlztfysbttslmptzrtdxqsjehbnylndxljsqmlhtxtjecxalzzspktlzkqqyfsyjywpcpqfhjhytqxzkrsgtksq"
"czlptxcdyyzsslzslxlzmacpcqbzyxhbsxlzdltztjtylzjyytbzypltxjsjxhlbmytxcqrblzssfjzztnjytxmyjhlhpblcyxqj"
"qqkzzscpzkswalqsplczzjsxgwwwygyatjbbctdkhqhkgtgpbkqyslbxbbckbmllndzstbklggqkqlzbkktfxrmdkbftpzfrtppm"
"ferqnxgjpzsstlbztpszqzsjdhljqlzbpmsmmsxlqqnhknblrddnhxdkddjcyyljfqgzlgsygmjqjkhbpmxyxlytqwlwjcpbmjxc"
"yzydrjbhtdjyeqshtmgsfyplwhlzffnynnhxqhpltbqpfbjwjdbygpnxtbfzjgnnntjshxeawtzylltyqbwjpgxghnnkndjtmszs"
"qynzggnwqtfhclssgmnnnnynzqqxncjdqgzdlfnykljcjllzlmzznnnnsshthxjlzjbbhqjwwycrdhlyqqjbeyfsjhthnrnwjhwp"
"slmssgzttygrqqwrnlalhmjtqjsmxqbjjzjqzyzkxbjqxbjxshzssfglxmxnxfghkzszggslcnnarjxhnlllmzxelglxydjytlfb"
"kbpnlyzfbbhptgjkwetzhkjjxzxxglljlstgshjjyqlqzfkcgnndjsszfdbctwwseqfhqjbsaqtgypjlbxbmmywxgslzhglsgnyf"
"ljbyfdjfngsfmbyzhqffwjsyfyjjphzbyyzffwotjnlmftwlbzgyzqxcdjygzyyryzynyzwegazyhjjlzrthlrmgrjxzclnnnljj"
"yhtbwjybxxbxjjtjteekhwslnnlbsfazpqqbdlqjjtyyqlyzkdksqjnejzldqcgjqnnjsncmrfqthtejmfctyhypymhydmjncfgy"
"yxwshctxrljgjzhzcyyyjltkttntmjlzclzzayyoczlrlbszywjytsjyhbyshfjlykjxxtmzyyltxxypslqyjzyzyypnhmymdyyl"
"blhlsyygqllnjjymsoycbzgdlyxylcqyxtszegxhzglhwbljheyxtwqmakbpqcgyshhegqcmwyywljyjhyyzlljjylhzyhmgsljl"
"jxcjjyclycjbcpzjzjmmwlcjlnqljjjlxyjmlszljqlycmmgcfmmfpqqmfxlqmcffqmmmmhnznfhhjgtthxkhslnchhyqzxtmmqd"
"cydyxyqmyqylddcyaytazdcymdydlzfffmmycqcwzzmabtbyctdmndzggdftypcgqyttssffwbdttqssystwnjhjytsxxylbyyhh"
"whxgzxwznnqzjzjjqjccchykxbzszcnjtllcqxynjnckycynccqnxyewyczdcjycchyjlbtzyycqwlpgpyllgktltlgkgqbgychj"
"xy";
char pinyinFirstLetter(unsigned short hanzi)
{
    int index = hanzi - HANZI_START;
    if (index >= 0 && index <= HANZI_COUNT)
    {
        return firstLetterArray[index];
    }
    else
    {
        //return '#';
        
        return hanzi;
    }
}


@end
