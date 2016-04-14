//
//  DataObject.h
//  UIOverseasExamination
//
//  Created by RealTmac on 14-12-4.
//  Copyright (c) 2014年 Meten. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataObject : NSObject
{
    
}

@end




#pragma mark-
@interface SampleDataObject : NSObject
{
    NSString *strStatusNo;
    int intSuccessNo;
    int intSuccess;
    NSString *strMessage;
    
    int page;
    int pageSize;
    int allCount;
    
    
    NSMutableArray *arrObjects;
}

@property(nonatomic,strong) NSString *strStatusNo;


@property(nonatomic) int page;
@property(nonatomic) int pageSize;
@property(nonatomic)int allCount;

@property(nonatomic) int intSuccessNo;
@property(nonatomic) int intSuccess;
@property(nonatomic,strong) NSString *strMessage;
@property(nonatomic,strong) NSMutableArray *arrObjects;


@end

//天气预告
@interface DataObjectWeather : NSObject
{
    NSString *strCity;
    NSString *strWeek;
    NSString *strCityid;
    
    NSString *strDate1;
    NSString *strDate2;
    NSString *strDate3;
    NSString *strDate4;
    NSString *strDate5;
    NSString *strDate6;
    
    NSString *StrWeek1;
    NSString *StrWeek2;
    NSString *StrWeek3;
    NSString *StrWeek4;
    NSString *StrWeek5;
    NSString *StrWeek6;
    
    
    NSString *strTemp1;
    NSString *strTemp2;
    NSString *strTemp3;
    NSString *strTemp4;
    NSString *strTemp5;
    NSString *strTemp6;
    
    
    NSString *strWeather1;
    NSString *strWeather2;
    NSString *strWeather3;
    NSString *strWeather4;
    NSString *strWeather5;
    NSString *strWeather6;
    
    
    NSString *strImg1;
    NSString *strImg2;
    NSString *strImg3;
    NSString *strImg4;
    NSString *strImg5;
    NSString *strImg6;
    NSString *strImg7;
    NSString *strImg8;
    NSString *strImg9;
    NSString *strImg10;
    NSString *strImg11;
    NSString *strImg12;
    
}

@property (nonatomic,retain)NSString *strCity;
@property (nonatomic,retain)NSString *strWeek;
@property (nonatomic,retain)NSString *strCityid;

@property (nonatomic,retain)NSString *strDate1;
@property (nonatomic,retain)NSString *strDate2;
@property (nonatomic,retain)NSString *strDate3;
@property (nonatomic,retain)NSString *strDate4;
@property (nonatomic,retain)NSString *strDate5;
@property (nonatomic,retain)NSString *strDate6;

@property (nonatomic,retain)NSString *StrWeek1;
@property (nonatomic,retain)NSString *StrWeek2;
@property (nonatomic,retain)NSString *StrWeek3;
@property (nonatomic,retain)NSString *StrWeek4;
@property (nonatomic,retain)NSString *StrWeek5;
@property (nonatomic,retain)NSString *StrWeek6;


@property (nonatomic,retain)NSString *strTemp1;
@property (nonatomic,retain)NSString *strTemp2;
@property (nonatomic,retain)NSString *strTemp3;
@property (nonatomic,retain)NSString *strTemp4;
@property (nonatomic,retain)NSString *strTemp5;
@property (nonatomic,retain)NSString *strTemp6;


@property (nonatomic,retain)NSString *strWeather1;
@property (nonatomic,retain)NSString *strWeather2;
@property (nonatomic,retain)NSString *strWeather3;
@property (nonatomic,retain)NSString *strWeather4;
@property (nonatomic,retain)NSString *strWeather5;
@property (nonatomic,retain)NSString *strWeather6;


@property (nonatomic,retain)NSString *strImg1;
@property (nonatomic,retain)NSString *strImg2;
@property (nonatomic,retain)NSString *strImg3;
@property (nonatomic,retain)NSString *strImg4;
@property (nonatomic,retain)NSString *strImg5;
@property (nonatomic,retain)NSString *strImg6;
@property (nonatomic,retain)NSString *strImg7;
@property (nonatomic,retain)NSString *strImg8;
@property (nonatomic,retain)NSString *strImg9;
@property (nonatomic,retain)NSString *strImg10;
@property (nonatomic,retain)NSString *strImg11;
@property (nonatomic,retain)NSString *strImg12;


@end


#pragma mark-
#pragma mark-
@interface DataObjectSearch : NSObject
{
    NSInteger index_num;
    NSInteger total;
    NSInteger result_num;
    
    
    
    NSString *strID;
    NSString *strName;
    NSString *addr;
    NSString *tel;
    NSString *cate;
    NSString *rate;
    NSString *cost;
    NSString *desc;
    NSString *dist;
    NSString *lng;
    NSString *lat;
    NSString *img_url;
    
}

@property NSInteger index_num;
@property NSInteger total;
@property NSInteger result_num;

@property (nonatomic,retain)NSString *strID;
@property (nonatomic,retain)NSString *strName;
@property (nonatomic,retain)NSString *addr;
@property (nonatomic,retain)NSString *tel;
@property (nonatomic,retain)NSString *cate;
@property (nonatomic,retain)NSString *rate;
@property (nonatomic,retain)NSString *cost;
@property (nonatomic,retain)NSString *desc;
@property (nonatomic,retain)NSString *dist;
@property (nonatomic,retain)NSString *lng;
@property (nonatomic,retain)NSString *lat;
@property (nonatomic,retain)NSString *img_url;



@end





#pragma mark - 酒店
@interface DataObjectHotelInfo: SampleDataObject
{
    NSString *strHotelId;
    NSString *strName;
    NSString *strAddress;
    NSString *strPhone;
    NSString *strFax;
    NSString *strEstablishmentDate;
    NSString *strRenovationDate;
    NSString *strStarRate;
    NSString *strGoogleLat;
    NSString *strGoogleLon;
    NSString *strCityCode;
    NSString *strFacilities;
    NSString *strReviewCount;
    NSString *strReviewGood;
    NSString *strReviewPoor;
    NSString *strReviewScore;
    NSString *strStatus;
    NSString *strminPrice;
    NSString *strmaxPrice;
    NSString *strImgThumb;
    NSString *strMonthSaleCount;
    NSString *strFavariteCount;
    NSString *strroomlist;
    NSString *strsupplierlist;
    NSString *strScorre;
    
    NSString *strOffer_WIFI;
    NSString *strOffer_KTV;
    NSString *strOffer_NET;
    NSString *strOffer_EAT;
    
    
    NSString *strIntroEditor ;
    NSString *strDiningAmenities ;
    NSString *strRecreationAmenities;
    NSString *strGeneralAmenities;
    NSString *strDescription;
    NSString *strTraffic;
    NSString *strCreditCards;
    
    NSInteger RecordCount;
    NSInteger PageIndex;
    BOOL IsFavorite;
    int intFavoriteCount;
    int intCommentTotal;
    
    NSMutableArray *arrRoomList;
    NSMutableArray *arrImageList;
    NSMutableArray *arrCommentList;
}
@property(nonatomic)NSInteger RecordCount;
@property(nonatomic)NSInteger PageIndex;

@property(nonatomic,strong)NSString *strHotelId;
@property(nonatomic,strong)NSString *strName;
@property(nonatomic,strong)NSString *strAddress;
@property(nonatomic,strong)NSString *strPhone;
@property(nonatomic,strong)NSString *strFax;
@property(nonatomic,strong)NSString *strEstablishmentDate;
@property(nonatomic,strong)NSString *strRenovationDate;
@property(nonatomic,strong)NSString *strStarRate;
@property(nonatomic,strong)NSString *strGoogleLat;
@property(nonatomic,strong)NSString *strGoogleLon;
@property(nonatomic,strong)NSString *strCityCode;
@property(nonatomic,strong)NSString *strFacilities;
@property(nonatomic,strong)NSString *strReviewCount;
@property(nonatomic,strong)NSString *strReviewGood;
@property(nonatomic,strong)NSString *strReviewPoor;
@property(nonatomic,strong)NSString *strReviewScore;
@property(nonatomic,strong)NSString *strStatus;
@property(nonatomic,strong)NSString *strminPrice;
@property(nonatomic,strong)NSString *strmaxPrice;
@property(nonatomic,strong)NSString *strImgThumb;
@property(nonatomic,strong)NSString *strMonthSaleCount;
@property(nonatomic,strong)NSString *strFavariteCount;
@property(nonatomic,strong)NSString *strroomlist;
@property(nonatomic,strong)NSString *strsupplierlist;
@property(nonatomic,strong)NSString *strScorre;

@property(nonatomic,strong)NSString *strIntroEditor ;
@property(nonatomic,strong)NSString *strDiningAmenities ;
@property(nonatomic,strong)NSString *strRecreationAmenities;
@property(nonatomic,strong)NSString *strGeneralAmenities;
@property(nonatomic,strong)NSString *strDescription;
@property(nonatomic,strong)NSString *strTraffic;
@property(nonatomic,strong)NSString *strCreditCards;

@property(nonatomic,strong)NSMutableArray *arrRoomList;
@property(nonatomic,strong)NSMutableArray *arrImageList;
@property(nonatomic,strong)NSMutableArray *arrCommentList;


@property(nonatomic,strong)NSString *strOffer_WIFI;
@property(nonatomic,strong)NSString *strOffer_KTV;
@property(nonatomic,strong)NSString *strOffer_NET;
@property(nonatomic,strong)NSString *strOffer_EAT;

@property(nonatomic)BOOL IsFavorite;
@property(nonatomic)int intFavoriteCount;
@property(nonatomic) int intCommentTotal;


@end


#pragma mark-
#pragma mark - 广告
@interface DataObjectAd : SampleDataObject
{
    
    NSString *strAdID;
    NSInteger adType;
    NSString *strAdCreateDate;
    NSString *strAdTitle;
    NSString *strAdDesc;
    NSString *strAdGotoURL;
    NSString *strShowTitle;
    
    NSString *strLeftMoneyDesc;
    
    int showFlag;
    
    
}

@property(nonatomic,strong)NSString *strAdID;
@property NSInteger adType;
@property(nonatomic,strong)NSString *strAdCreateDate;
@property(nonatomic,strong)NSString *strAdTitle;
@property(nonatomic,strong)NSString *strAdDesc;
@property(nonatomic,strong)NSString *strAdGotoURL;

@property(nonatomic,strong)NSString *strLeftMoneyDesc;

@property int showFlag;


@property(nonatomic,strong)NSString *strShowTitle;

@end


#pragma mark - 服务器地址结构
@interface DataObjectServerObject : SampleDataObject
{
    NSString *strId;
    NSString *strServerName;
    NSString *strIP;
    NSString *strPort;
    NSString *strApiDomain;
    
}

@property(nonatomic,strong)NSString *strId;
@property(nonatomic,strong)NSString *strServerName;
@property(nonatomic,strong)NSString *strIP;

@property(nonatomic,strong)NSString *strPort;
@property(nonatomic,strong)NSString *strApiDomain;

@end



#pragma mark - 检查更新
@interface DataObjectCheckUpdate : SampleDataObject
{
    
    NSString *strVersion;
    
    NSInteger forceUpdateTag;
    
    NSString *strDownlaodURL;
    NSString *strUpdateContent;
    
    
    
}

@property(nonatomic,strong)NSString *strVersion;
@property NSInteger forceUpdateTag;


@property(nonatomic,strong)NSString *strDownlaodURL;
@property(nonatomic,strong)NSString *strUpdateContent;



@end


#pragma mark - SOS号码
@interface DataObjectSOS : SampleDataObject
{
    
    NSString *strMobile1;
    
    NSString *strMobile2;
    NSString *strMobile3;
    NSString *strMobile4;
    NSString *strId;

    
}

@property(nonatomic,strong)NSString *strMobile1;
@property(nonatomic,strong)NSString *strMobile2;
@property(nonatomic,strong)NSString *strMobile3;

@property(nonatomic,strong)NSString *strMobile4;
@property(nonatomic,strong)NSString *strId;

@end



#pragma mark - 设备列表
@interface DataObjectMyDeviceList : SampleDataObject
{
    NSString *strDeviceId;
    NSString *strDeviceType;
    
    NSString *strDeviceName;
    
    NSString *strDeviceIMEI;
    NSString *strDeviceMobile;
    
    NSString *strDeviceOwnerName;
    
    NSString *strHealthInfo;
    NSString *strAge;
    NSString *strCommonlyUseDrugs;
    
    NSString *strCheckCode;
    
    NSString *strStatus;
    NSString *strUserId;
    NSString *strCreateTime;
    
    NSString *strSocketLastIP;
    
    NSString *strValidityDate;

    NSString *strLat;
    NSString *strLon;
    
    NSString *strRadius;
    
    NSString *strGPSSecond;
    
    
    // --------
    
    NSString *strAddress;
    
    NSString *strTipDesc;
    
    NSString *strGuardianName;
    NSString *strGuardianManMobile;
    NSString *strGuardianManPhoto;
    NSString *strGuardianId;
    
    NSString *strGuardianManId;
    
    NSString *strGuardianManDeviceId;
    
    NSString *strNickName;
    
    NSString *strGuardManCreateTime;
    
    NSMutableArray *subArrayObject;
    
    NSString *addressTime;
    
}

@property(nonatomic,strong)NSString *strHealthInfo;
@property(nonatomic,strong)NSString *strAge;
@property(nonatomic,strong)NSString *strCommonlyUseDrugs;

@property(nonatomic,strong)NSString *strCheckCode;

@property(nonatomic,strong)NSString *strTipDesc;

@property(nonatomic,strong)NSString *strDeviceId;

@property(nonatomic,strong)NSString *strDeviceType;
@property(nonatomic,strong)NSString *strDeviceName;

@property(nonatomic,strong)NSString *strDeviceIMEI;
@property(nonatomic,strong)NSString *strDeviceMobile;

@property(nonatomic,strong)NSString *strDeviceOwnerName;

@property(nonatomic,strong)NSString *strStatus;
@property(nonatomic,strong)NSString *strUserId;

@property(nonatomic,strong)NSString *strCreateTime;

@property(nonatomic,strong)NSString *strSocketLastIP;

@property(nonatomic,strong)NSString *strValidityDate;

@property(nonatomic,strong)NSString *strLat;
@property(nonatomic,strong)NSString *strLon;

@property(nonatomic,strong)NSString *strRadius;

@property(nonatomic,strong)NSString *strAddress;
@property(nonatomic,strong)NSString *strGPSSecond;


@property(nonatomic,strong)NSString *strGuardianName;
@property(nonatomic,strong)NSString *strGuardianManMobile;

@property(nonatomic,strong)NSString *strGuardianManPhoto;

@property(nonatomic,strong)NSString *strGuardianId;

@property(nonatomic,strong)NSString *strGuardianManId;

@property(nonatomic,strong)NSString *strGuardianManDeviceId;

@property(nonatomic,strong)NSString *strNickName;

@property(nonatomic,strong)NSString *strGuardManCreateTime;

@property(nonatomic,strong)NSMutableArray *subArrayObject;

@end


#pragma mark - 吃药提醒
@interface DataObjectMedicineRemind : SampleDataObject
{
    
    NSString *strDeviceName;
    NSString *strDeviceID;
    
    NSString *strRelationPersonName;
    NSString *strRelationPersonID;
    NSString *strRemindTime;
    
    NSString *strRemindContent;
    
    NSString *strTimeList;
    NSString *strWeekDayList;
    
}


@property(nonatomic,strong)NSString *strDeviceName;
@property(nonatomic,strong)NSString *strDeviceID;

@property(nonatomic,strong)NSString *strRelationPersonName;
@property(nonatomic,strong)NSString *strRelationPersonID;
@property(nonatomic,strong)NSString *strRemindTime;

@property(nonatomic,strong)NSString *strRemindContent;

@property(nonatomic,strong)NSString *strTimeList;
@property(nonatomic,strong)NSString *strWeekDayList;

@end


#pragma mark - 报警信息
@interface DataObjectAlarmInfo : SampleDataObject
{
    NSString *strDeviceName;
    NSString *strDeviceType;
    NSString *strMobile;
    
    NSString *strOwnerName;
    NSString *strId;
    
    NSString *strDeviceId;
    
    NSString *strAlarmType;
    NSString *strAlarmContent;
    
    NSString *strCreateTime;
    
}


@property(nonatomic,strong)NSString *strDeviceName;
@property(nonatomic,strong)NSString *strDeviceType;

@property(nonatomic,strong)NSString *strMobile;
@property(nonatomic,strong)NSString *strOwnerName;

@property(nonatomic,strong)NSString *strId;
@property(nonatomic,strong)NSString *strDeviceId;

@property(nonatomic,strong)NSString *strAlarmType;

@property(nonatomic,strong)NSString *strAlarmContent;

@property(nonatomic,strong)NSString *strCreateTime;

@end



#pragma mark -  围栏信息
@interface DataObjectElectronicInfo : SampleDataObject
{
    NSString *strDeviceName;
    NSString *strDeviceId;
    
    NSString *strOwnerName;
    NSString *strId;
    
    NSString *strLat;
    NSString *strLon;
    
    NSString *strCreateTime;
    
    NSString *strAddress;
    
    NSString *strRadius;
    
    NSMutableArray *subPointArray;
    
}

@property(nonatomic,strong)NSString *strLat;
@property(nonatomic,strong)NSString *strLon;

@property(nonatomic,strong)NSString *strDeviceName;
@property(nonatomic,strong)NSString *strDeviceId;

@property(nonatomic,strong)NSString *strOwnerName;
@property(nonatomic,strong)NSString *strId;

@property(nonatomic,strong)NSString *strCreateTime;
@property(nonatomic,strong)NSString *strAddress;

@property(nonatomic,strong)NSString *strRadius;

@property(nonatomic,strong)NSMutableArray *subPointArray;

@end



#pragma mark -健康五大分类
@interface DataObjectHealth : SampleDataObject
{
    NSString *strID;
    NSString *strDeviceID;
    NSString *strCreateTime;
    
    //血压、心率
    NSString *strHeartTimes;
    NSString *strLowPressure;
    NSString *strHighPressure;
    
    //血糖
    NSString *strSugarValue;
    
    //肺活量
    NSString *strSecconds;
    NSString *strSoportValue;
    
    //脉搏
    NSString *strPlusTimes;
    
}

@property(nonatomic,strong)NSString *strID;
@property(nonatomic,strong)NSString *strDeviceID;
@property(nonatomic,strong)NSString *strCreateTime;

@property(nonatomic,strong)NSString *strHeartTimes;

@property(nonatomic,strong)NSString *strLowPressure;

@property(nonatomic,strong)NSString *strHighPressure;

@property(nonatomic,strong)NSString *strSugarValue;
@property(nonatomic,strong)NSString *strSecconds;

@property(nonatomic,strong)NSString *strSoportValue;

@property(nonatomic,strong)NSString *strPlusTimes;


@end


#pragma mark - 单人监控、多人监控
@interface DataObjectPersonMonitoriing : SampleDataObject
{
    
    NSString *strLat;
    
    NSString *strLon;
    
    NSString *strAddress;
    
    NSString *strID;
    
    NSString *strDeviceType;
    NSString *strDeviceName;
    
    NSString *strIMEI;
    NSString *strMobile;
    
    NSString *strOwnerName;
    
    NSString *strStatus;
    NSString *strUserId;
    
    NSString *strCreateTime;
    NSString *strSocketLastIP;
    
    NSString *strSocketLastTime;
    
    NSString *strValidityDate;
    
    NSMutableArray *subArrayInfo;
    
    
}

@property(nonatomic,strong)NSString *strLat;

@property(nonatomic,strong)NSString *strLon;
@property (nonatomic,strong)NSString  *strAddress;
@property(nonatomic,strong)NSString *strID;

@property(nonatomic,strong)NSString *strDeviceType;
@property(nonatomic,strong)NSString *strDeviceName;

@property(nonatomic,strong)NSString *strIMEI;
@property(nonatomic,strong)NSString *strMobile;
@property(nonatomic,strong)NSString *strOwnerName;
@property(nonatomic,strong)NSString *strStatus;

@property(nonatomic,strong)NSString *strUserId;
@property(nonatomic,strong)NSString *strCreateTime;

@property(nonatomic,strong)NSString *strSocketLastIP;
@property(nonatomic,strong)NSString *strSocketLastTime;
@property(nonatomic,strong)NSString *strValidityDate;


@property(nonatomic,strong)NSMutableArray *subArrayInfo;


@end

#pragma mark - 老师对学生的反馈记录
@interface DataObjectTeacherToStudentFeedBack : SampleDataObject
{

    NSString *strCourseId;
    
    NSString *strCourseName;
    
    NSString *strStartTime;
    NSString *strEndTime;
    
    NSString *strHomeWork;
    NSString *strFeedBack;
    
    NSString *strFeedTime;
}

@property(nonatomic,strong)NSString *strCourseId;

@property(nonatomic,strong)NSString *strCourseName;

@property(nonatomic,strong)NSString *strStartTime;

@property(nonatomic,strong)NSString *strEndTime;

@property(nonatomic,strong)NSString *strHomeWork;
@property(nonatomic,strong)NSString *strFeedBack;

@property(nonatomic,strong)NSString *strFeedTime;


@end

#pragma mark - 反馈 查询结构
@interface DataObjectFeedBack : SampleDataObject
{
    
    NSString *strSAId;
    NSString *strStuId;
    NSString *strSACnName;
    NSString *strSAEnName;
    
    NSString *strStuCnName;
    NSString *strStuEnName;
    
    NSString *strStuPhoto;
    
    NSString *strSAPhoto;
    
    NSString *strSendId;
    NSString *strAcceptId;
    NSString *strContent;
    NSString *strCreateTime;
    
    
}

@property(nonatomic,strong)NSString *strSAId;
@property(nonatomic,strong)NSString *strStuId;

@property(nonatomic,strong)NSString *strSACnName;

@property(nonatomic,strong)NSString *strSAEnName;

@property(nonatomic,strong)NSString *strStuCnName;

@property(nonatomic,strong)NSString *strStuEnName;

@property(nonatomic,strong)NSString *strStuPhoto;

@property(nonatomic,strong)NSString *strSAPhoto;

@property(nonatomic,strong)NSString *strSendId;
@property(nonatomic,strong)NSString *strAcceptId;
@property(nonatomic,strong)NSString *strContent;
@property(nonatomic,strong)NSString *strCreateTime;

@end


#pragma mark - 课程 ->课程考勤
@interface DataObjectAttendance : SampleDataObject
{
    NSString *strChuqinCount;
    NSString *strChiDaoCount;
    NSString *strZaoTuiCount;
    NSString *strKuangKeCount;
    
    
    NSString *strDayNum;
    NSString *strCourseId;
    NSString *strCourseName;
    
    NSString *strStartTime;
    NSString *strEndTime;
    NSString *strCourseDate;
    
    NSString *strTeacherId;
    
    NSString *strTeacherCnName;
    NSString *strTeacherEnName;
    
    NSString *strAttendence;  // 1:出勤 2:迟到 3:早退 4:旷课
    
    NSString *strSchoolId;
    NSString *strSchoolName;
    
    NSString *strArrangeCourseId;
    
}

@property(nonatomic,strong)NSString *strChuqinCount;
@property(nonatomic,strong)NSString *strChiDaoCount;

@property(nonatomic,strong)NSString *strZaoTuiCount;
@property(nonatomic,strong)NSString *strKuangKeCount;

@property(nonatomic,strong)NSString *strDayNum;

@property(nonatomic,strong)NSString *strCourseId;
@property(nonatomic,strong)NSString *strCourseName;

@property(nonatomic,strong)NSString *strStartTime;
@property(nonatomic,strong)NSString *strEndTime;

@property(nonatomic,strong)NSString *strCourseDate;

@property(nonatomic,strong)NSString *strTeacherId;
@property(nonatomic,strong)NSString *strTeacherCnName;

@property(nonatomic,strong)NSString *strTeacherEnName;
@property(nonatomic,strong)NSString *strAttendence;

@property(nonatomic,strong)NSString *strSchoolId;

@property(nonatomic,strong)NSString *strSchoolName;

@property(nonatomic,strong)NSString *strArrangeCourseId;

@end

#pragma mark - 获取用户信息、合同信息、课程信息、个人基本信息
@interface DataObjectUserInfo : SampleDataObject
{
    
    NSString *strContractId;
    NSString *strContractNo;
    NSString *strBegDate;
    NSString *strEndDate;
    NSString *strStatus;
    
    
    
    NSString *strTeaId;
    NSString *strCnName;
    NSString *strEnName;
    NSString *strCourseId;
    NSString *strCourseName;
    NSString *strHours;
    
    
    
    NSString *strUserId;
    NSString *strUserName;
    NSString *strStudentCnName;
    NSString *strStudentEnName;
    NSString *strSex;
    NSString *strMobile;
    NSString *strEmail;
    NSString *strAreaId;
    NSString *strAreaName;
    NSString *strSchoolId;
    NSString *strSchoolName;
    NSString *strPhoto;
    NSString *strLeftMb;
    NSString *strTotalMb;
    
    
    NSMutableArray *subContractInfoArray;
    NSMutableArray *subScourseInfoArray;
    NSMutableArray *subStubasicInfoArray;
    
}

@property(nonatomic,strong)NSString *strContractId;
@property(nonatomic,strong)NSString *strContractNo;
@property(nonatomic,strong)NSString *strBegDate;
@property(nonatomic,strong)NSString *strEndDate;
@property(nonatomic,strong)NSString *strStatus;


@property(nonatomic,strong)NSString *strTeaId;
@property(nonatomic,strong)NSString *strCnName;
@property(nonatomic,strong)NSString *strEnName;
@property(nonatomic,strong)NSString *strCourseId;
@property(nonatomic,strong)NSString *strCourseName;
@property(nonatomic,strong)NSString *strHours;


@property(nonatomic,strong)NSString *strUserId;
@property(nonatomic,strong)NSString *strUserName;
@property(nonatomic,strong)NSString *strStudentCnName;
@property(nonatomic,strong)NSString *strStudentEnName;
@property(nonatomic,strong)NSString *strSex;
@property(nonatomic,strong)NSString *strMobile;

@property(nonatomic,strong)NSString *strEmail;
@property(nonatomic,strong)NSString *strAreaId;
@property(nonatomic,strong)NSString *strAreaName;
@property(nonatomic,strong)NSString *strSchoolId;
@property(nonatomic,strong)NSString *strSchoolName;
@property(nonatomic,strong)NSString *strPhoto;

@property(nonatomic,strong)NSString *strLeftMb;
@property(nonatomic,strong)NSString *strTotalMb;


@property(nonatomic,strong)NSMutableArray *subContractInfoArray;
@property(nonatomic,strong)NSMutableArray *subScourseInfoArray;
@property(nonatomic,strong)NSMutableArray *subStubasicInfoArray;


@end


#pragma mark - 联系人
@interface DataObjectLinkMan : SampleDataObject
{
    NSString *strLinkName;
    NSString *strLinkMobile;

}



@property(nonatomic,strong)NSString *strLinkName;
@property(nonatomic,strong)NSString *strLinkMobile;
@end

#pragma mark - 课程信息
@interface DataObjectCourseInfo : SampleDataObject
{
    
    NSString *strTeaId;
    NSString *strCnName;
    NSString *strEnName;
    NSString *strCourseId;
    NSString *strCourseName;

    NSString *strHours;

}



@property(nonatomic,strong)NSString *strTeaId;
@property(nonatomic,strong)NSString *strCnName;
@property(nonatomic,strong)NSString *strEnName;
@property(nonatomic,strong)NSString *strCourseId;
@property(nonatomic,strong)NSString *strCourseName;
@property(nonatomic,strong)NSString *strHours;

@end


#pragma mark - 我的M币信息
@interface DataObjectMyMBInfo :SampleDataObject
{
    NSString *strType;
    
    NSString *strID;
    NSString *strStudentId;
    NSString *strStuCnName;
    NSString *strStuEnName;
    
    NSString *strRemark;
    
    NSString *strSendCount;
    NSString *strDates;
    
    NSString *strOutMbID;
    NSString *strTeacherId;
    
    NSString *strCnName;
    NSString *strEnName;
    NSString *strCourseId;
    NSString *strCourseName;
    NSString *strStartTime;
    NSString *strEndTime;
    
    NSString *strSendTime;

    NSMutableArray *subOutMBArray;
    
}


@property(nonatomic,strong)NSString *strType;
@property(nonatomic,strong)NSString *strID;
@property(nonatomic,strong)NSString *strStudentId;
@property(nonatomic,strong)NSString *strStuCnName;

@property(nonatomic,strong)NSString *strStuEnName;
@property(nonatomic,strong)NSString *strSendCount;
@property(nonatomic,strong)NSString *strDates;
@property(nonatomic,strong)NSString *strOutMbID;

@property(nonatomic,strong)NSString *strTeacherId;
@property(nonatomic,strong)NSString *strCnName;
@property(nonatomic,strong)NSString *strEnName;
@property(nonatomic,strong)NSString *strCourseId;

@property(nonatomic,strong)NSString *strCourseName;
@property(nonatomic,strong)NSString *strStartTime;

@property(nonatomic,strong)NSString *strEndTime;
@property(nonatomic,strong)NSString *strSendTime;

@property(nonatomic,strong)NSString *strRemark;

@property(nonatomic,strong)NSMutableArray *subOutMBArray;

@end


#pragma mark - 我的成绩
@interface DataObjectMyGrade :SampleDataObject
{
    NSString *strTitleId;
    
    NSString *strCategoryName;
    NSString *strTotalScore;
    NSString *strExamTime;
    NSString *strExamType;
    NSString *strExamTypeName;
    
    NSString *strSubjectId;
    NSString *strSubjectName;
    NSString *strExamScore;

    
    NSMutableArray *subObjectArray;
    
}


@property(nonatomic,strong)NSString *strTitleId;
@property(nonatomic,strong)NSString *strCategoryName;
@property(nonatomic,strong)NSString *strTotalScore;
@property(nonatomic,strong)NSString *strExamTime;

@property(nonatomic,strong)NSString *strExamType;
@property(nonatomic,strong)NSString *strExamTypeName;

@property(nonatomic,strong)NSString *strSubjectId;
@property(nonatomic,strong)NSString *strSubjectName;
@property(nonatomic,strong)NSString *strExamScore;

@property(nonatomic,strong)NSMutableArray *subObjectArray;


@end


#pragma mark - 已结课时信息
@interface DataObjectFinishedCourseInfo : SampleDataObject
{
    
    NSString *strStudentId;
    NSString *strTeacherId;
    NSString *strTeacherCnName;
    
    NSString *strTeacherEnName;
    NSString *strCourseDate;
    
    NSString *strStartTime;
    
    NSString *strEndTime;
    NSString *strCourseId;
    NSString *strCourseName;
    NSString *strSchoolId;
    NSString *strSchoolName;
    NSString *strCourseStatus;
    NSString *strArrangeCourseId;
    NSString *strIsFinish;
    
    NSString *strStatus;
    NSString *strTheCourseNum;
}

@property(nonatomic,strong) NSString *strStudentId;
@property(nonatomic,strong) NSString *strTeacherId;
@property(nonatomic,strong) NSString *strTeacherCnName;

@property(nonatomic,strong) NSString *strTeacherEnName;
@property(nonatomic,strong) NSString *strCourseDate;

@property(nonatomic,strong) NSString *strStartTime;

@property(nonatomic,strong) NSString *strEndTime;
@property(nonatomic,strong) NSString *strCourseId;

@property(nonatomic,strong) NSString *strCourseName;
@property(nonatomic,strong) NSString *strSchoolId;
@property(nonatomic,strong) NSString *strSchoolName;
@property(nonatomic,strong) NSString *strCourseStatus;

@property(nonatomic,strong) NSString *strArrangeCourseId;
@property(nonatomic,strong) NSString *strIsFinish;

@property(nonatomic,strong) NSString *strStatus;
@property(nonatomic,strong) NSString *strTheCourseNum;
@end


#pragma mark - 倒计时
@interface DataObjectCountDown : SampleDataObject
{
    NSString *strCountDownID;
    
    NSString *strStudentID;
    
    NSString *strCnName;
    
    NSString *strEnName;
    
    NSString *strPhoto;
    
    NSString *strSubject;
    
    NSString *strExamDateTime;
    NSString *strExamAddress;
}

@property(nonatomic,strong) NSString *strCountDownID;

@property(nonatomic,strong) NSString *strStudentID;

@property(nonatomic,strong) NSString *strCnName;

@property(nonatomic,strong) NSString *strEnName;
@property(nonatomic,strong) NSString *strPhoto;

@property(nonatomic,strong) NSString *strSubject;

@property(nonatomic,strong) NSString *strExamDateTime;
@property(nonatomic,strong) NSString *strExamAddress;

@end


@interface  DataObjectDate:SampleDataObject
{
    
}


@end


#pragma mark - 我的投诉
@interface DataObjectComplaint : SampleDataObject
{
    
    NSString *strStuId;
    
    NSString *strCompainId;
    
    NSString *strCompainTime;
    
    NSString *strContent;
    
    NSString *strStatus;
    
    NSString *strStatusName;
    
    
}

@property(nonatomic,strong)NSString *strStuId;
@property(nonatomic,strong)NSString *strCompainId;

@property(nonatomic,strong)NSString *strCompainTime;
@property(nonatomic,strong)NSString *strContent;
@property(nonatomic,strong)NSString *strStatus;
@property(nonatomic,strong)NSString *strStatusName;

@end




#pragma mark - 投诉回复
@interface DataObjectReply : SampleDataObject
{
    NSString *strComplainId;
    
    NSString *strReplyId;
    NSString *strReplyContent;
    NSString *strReplyTime;
}


@property(nonatomic,strong)NSString *strComplainId;
@property(nonatomic,strong)NSString *strReplyId;
@property(nonatomic,strong)NSString *strReplyContent;
@property(nonatomic,strong)NSString *strReplyTime;

@end

#pragma mark - 消息推送结构
@interface DataObjectPushMessage : NSObject<NSCoding>
{
    
    NSString *strMessageContent;
    NSString *strMessageType;
    NSString *strMessageDetailId;
    
    NSString *strMessageDateTime;
}

@property(nonatomic,strong)NSString *strMessageContent;
@property(nonatomic,strong)NSString *strMessageType;
@property(nonatomic,strong)NSString *strMessageDetailId;

@property(nonatomic,strong)NSString *strMessageDateTime;

@end


