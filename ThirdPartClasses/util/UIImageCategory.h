//
//  UIImageCategory.h
//  CategorySample
//
//  Created by yile on 3/29/09.
//  Copyright 2009 Quoord. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Category)


-(UIImage*)strethImageWith:(NSString *)imageName;

//缩放图片 比例要相同 不然变形
//如果高度0,则根据比例计算高度
//如果宽度0,则根据比例计算宽度
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;
//阴影化
- (UIImage*)imageWithShadow;
//截取指定区域图形
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
//变换弧度 0－1
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

//变换角度 0－360
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
//固定大小变换角度
- (UIImage *)imageRotatedByDegreesFixedSize:(CGFloat)degrees  ;

+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
//获得图片指定xy像素的颜色
+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count;

//合成图片
- (UIImage *)synthImage:(UIImage *)image;

//颜色遮罩
+(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;
//图片遮罩
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage;
//剪辑图片 用png图片 原始图片大小不变
+ (UIImage *)clipImage:(UIImage *)imageIn withMask:(UIImage *)maskIn atRect:(CGRect) maskRect;
//剪辑图片 用png图片 图片大小改变未maskRect
+ (UIImage *)clipImageResize:(UIImage *)imageIn withMask:(UIImage *)maskIn atRect:(CGRect) maskRect;

+ (UIImage *)loadBundleImage:(NSString*)imgname;



@end
