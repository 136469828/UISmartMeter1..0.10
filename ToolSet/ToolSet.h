//
//  ToolSet.h
//  UIMobileBook
//

//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//


#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>


typedef enum 
{
    btnTypeLogin = 0,
    btnTypeNormal,
    btnTypeRemmberPwd

}btnTypeOfToolSet;



typedef enum
{
    
    typeHomeAdImage =0,
    typeHealthManageLeft,
    typeHealthManage,
    typeHealthBranch,
    typeDynamic,
    typeDiscountFirst,
    typeDiscountNews
    
    
}searchType;

#pragma mark -
@interface locationInfo : NSObject
{
    NSString * laitude;
    NSString * longtitude;
    NSString * detailAddress;
    NSString * currentCity;
    NSString * currentCoutry;

}

@property(nonatomic,retain) NSString * laitude;
@property(nonatomic,retain) NSString * longtitude;
@property(nonatomic,retain) NSString * detailAddress;
@property(nonatomic,retain) NSString * currentCity;
@property(nonatomic,retain) NSString * currentCoutry;

+ (locationInfo *)shareInstance;

@end



#pragma mark - UserInfo
@interface UserInfo : NSObject
{
    BOOL       updateFlag; // 是否有更新
    
    int        showApplication;
    
    UIImage     *usericon;
    
    NSString  *strUserID;
    NSString  *strUserName;
    
    NSString  *strEnName;
    NSString  *strChName;
    
    NSString  *strUserHeaderURL;
    
    int       sexFlag; // 0 女 1男
    
    int       unReadMessageCount; // 未读消息数
    
    NSString  *strEmail; // 邮件
    
    NSString  *strMobile;
    
    NSString  *strRCode;
    NSString  *strAreaId;
    NSString  *strAreaName;
    
    NSString  *strSchoolId;
    
    NSString  *strstrSchoolName;
    
    NSString  *strLeftCoins;
    NSString  *strTotalCoins;
    
    NSString  *strRoles;
    
    NSMutableArray *arrayListRoles;
    
    NSString *strCheckCode;
    
}

@property                   BOOL       updateFlag; // 是否有更新

@property(nonatomic,retain) UIImage     *usericon;

@property(nonatomic,retain) NSString  *strUserID;
@property(nonatomic,retain) NSString  *strUserName;

@property(nonatomic,retain) NSString  *strEnName;
@property(nonatomic,retain) NSString  *strChName;

@property(nonatomic,retain) NSString  *strUserHeaderURL;

@property                   int        showApplication;


@property                   int       sexFlag; // 0 女 1男

@property                   int       unReadMessageCount; // 未读消息数

@property(nonatomic,retain) NSString  *strEmail; // 邮件

@property(nonatomic,retain) NSString  *strMobile;

@property(nonatomic,retain) NSString  *strRCode;
@property(nonatomic,retain) NSString  *strAreaId;
@property(nonatomic,retain) NSString  *strAreaName;

@property(nonatomic,retain) NSString  *strSchoolId;

@property(nonatomic,retain) NSString  *strstrSchoolName;

@property(nonatomic,retain) NSString  *strLeftCoins;
@property(nonatomic,retain) NSString  *strTotalCoins;

@property(nonatomic,retain) NSString  *strRoles;

@property(nonatomic,retain) NSString *strCheckCode;

@property(nonatomic,retain) NSMutableArray *arrayListRoles;


+ (UserInfo *)shareInstance;

@end



@interface UIImage(UIImageScale)
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)imagescaleToSize:(CGSize)size;
@end


@interface ToolSet : NSObject
{
    searchType mSearchType;
}

#pragma mark- 去掉tableview多余的分割线
+(void)setExtraCellLineHidden: (UITableView *)tableView;


+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+(void)setNavigationBarBackGroundImagewithTargetView:(id)view;

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)originImage;


#pragma mark -
#pragma mark 拨打电话
+(void)doCallWithPhoneNumber:(NSString*)phoneNO withDelagate:(id)delegate;


+(BOOL)isNetworkReachable;

+(UIButton *)returnButtonWithSelctor:(SEL)selector target:(id)target withTitle:(NSString *)title frame:(CGRect)_frame;

+(UIBarButtonItem *)returnBackButtonWithSelctor:(SEL)selector target:(id)target withTitle:(NSString *)title frame:(CGRect)_frame backImage:(UIImage *)img;

+(UIBarButtonItem *)returnBackButtonWithSelctor:(SEL)selector target:(id)target withTitle:(NSString *)title frame:(CGRect)_frame;

+(void)setBackGroundImageForTargetView:(UIView *)targetV withImageName:(NSString *)imgName;

//+(UIBarButtonItem *)returnBackButtonWithSelctor:(SEL)selector target:(id)target;


+ (UIButton *)buttonWithTitle:	(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
				darkTextColor:(BOOL)darkTextColor
                   buttonType:(btnTypeOfToolSet)btype;


+(NSString *)dateStringWithDate:(NSString *)dateStr WithTimeInterval:(NSTimeInterval)interval;
+(NSString *)weekStrWithDateString:(NSString *)dateStr WithTimeInterval:(NSTimeInterval)interval;


@end
