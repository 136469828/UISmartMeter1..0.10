//
//  DataObject.m
//  Ministry of culture
//
//  Created by ZhouLiang on 14-4-1.
//  Copyright (c) 2014年 fengjing. All rights reserved.
//
#import "Util.h"
#import "DataObject.h"

@implementation DataObject

@end


#pragma mark-
@implementation SampleDataObject : NSObject
@synthesize strMessage,intSuccess,intSuccessNo,strStatusNo;
@synthesize arrObjects;

@synthesize page,pageSize,allCount;


-(id)init
{
    if(self = [super init])
    {
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark -
#pragma mark- 天气数据结构

@implementation DataObjectWeather


@synthesize strCity;
@synthesize strWeek;
@synthesize strCityid;

@synthesize strDate1;
@synthesize strDate2;
@synthesize strDate3;
@synthesize strDate4;
@synthesize strDate5;
@synthesize strDate6;

@synthesize StrWeek1;
@synthesize StrWeek2;
@synthesize StrWeek3;
@synthesize StrWeek4;
@synthesize StrWeek5;
@synthesize StrWeek6;


@synthesize strTemp1;
@synthesize strTemp2;
@synthesize strTemp3;
@synthesize strTemp4;
@synthesize strTemp5;
@synthesize strTemp6;


@synthesize strWeather1;
@synthesize strWeather2;
@synthesize strWeather3;
@synthesize strWeather4;
@synthesize strWeather5;
@synthesize strWeather6;


@synthesize strImg1;
@synthesize strImg2;
@synthesize strImg3;
@synthesize strImg4;
@synthesize strImg5;
@synthesize strImg6;
@synthesize strImg7;
@synthesize strImg8;
@synthesize strImg9;
@synthesize strImg10;
@synthesize strImg11;
@synthesize strImg12;


-(id)init
{
    if(self == [super init])
    {
        
        strCity = [[NSString alloc] init];
        strWeek = [[NSString alloc] init];
        strCityid = [[NSString alloc] init];
        
        strDate1 = [[NSString alloc] init];
        strDate2 = [[NSString alloc] init];
        strDate3 = [[NSString alloc] init];
        strDate4 = [[NSString alloc] init];
        strDate5 = [[NSString alloc] init];
        strDate6 = [[NSString alloc] init];
        
        StrWeek1 = [[NSString alloc] init];
        StrWeek2 = [[NSString alloc] init];
        StrWeek3 = [[NSString alloc] init];
        StrWeek4 = [[NSString alloc] init];
        StrWeek5 = [[NSString alloc] init];
        StrWeek6 = [[NSString alloc] init];
        
        
        strTemp1 = [[NSString alloc] init];
        strTemp2 = [[NSString alloc] init];
        strTemp3 = [[NSString alloc] init];
        strTemp4  = [[NSString alloc] init];
        strTemp5 = [[NSString alloc] init];
        strTemp6 = [[NSString alloc] init];
        
        strWeather1 = [[NSString alloc] init];
        strWeather2 = [[NSString alloc] init];
        strWeather3 = [[NSString alloc] init];
        strWeather4 = [[NSString alloc] init];
        strWeather5 = [[NSString alloc] init];
        strWeather6 = [[NSString alloc] init];
        
        
        strImg1 = [[NSString alloc] init];
        strImg2 = [[NSString alloc] init];
        strImg3 = [[NSString alloc] init];
        strImg4 = [[NSString alloc] init];
        strImg5 = [[NSString alloc] init];
        strImg6 = [[NSString alloc] init];
        strImg7 = [[NSString alloc] init];
        strImg8 = [[NSString alloc] init];
        strImg9 = [[NSString alloc] init];
        strImg10 = [[NSString alloc] init];
        strImg11 = [[NSString alloc] init];
        strImg12 = [[NSString alloc] init];
        
        
        
    }
    
    return self;
}

@end


@implementation DataObjectSearch

@synthesize index_num,total,result_num;

@synthesize strID,strName,addr,tel,cate,rate,cost,desc,dist,lng,lat,img_url;

-(id)init
{
    if(self = [super init])
    {
        
        
        return self;
    }
    else
    {
        return nil;
    }
}



@end


#pragma mark - 酒店信息
@implementation DataObjectHotelInfo
@synthesize strAddress,strCityCode,strEstablishmentDate,strFacilities,strFavariteCount,strFax,strGoogleLat,strGoogleLon,strHotelId,strImgThumb,strmaxPrice,strminPrice,strMonthSaleCount,strName,strPhone,strRenovationDate,strReviewCount,strReviewGood,strReviewPoor,strReviewScore,strroomlist,strStarRate,strStatus,strsupplierlist;
@synthesize strIntroEditor,strDescription,strCreditCards,strDiningAmenities,strGeneralAmenities,strRecreationAmenities,strTraffic;
@synthesize arrRoomList,arrImageList,arrCommentList;
@synthesize strOffer_EAT,strOffer_KTV,strOffer_NET,strOffer_WIFI;
@synthesize RecordCount,PageIndex;
@synthesize IsFavorite,intFavoriteCount,intCommentTotal;
@synthesize strScorre;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}
@end


#pragma mark-
#pragma mark - 服务器地址结构
@implementation DataObjectServerObject
@synthesize strApiDomain,strId,strIP,strPort,strServerName;

-(id)init
{
    if(self = [super init])
    {
        strApiDomain = [[NSString alloc] init];
        strId = [[NSString alloc] init];
        
        strIP = [[NSString alloc] init];
        strPort = [[NSString alloc] init];
        strServerName = [[NSString alloc] init];
        
        strApiDomain = @"";
        strId = @"";
        strIP = @"";
        strPort = @"";
        strServerName = @"";
        
        return self;
    }
    else
    {
        return nil;
    }
}

@end


#pragma mark-
#pragma mark - 广告
@implementation DataObjectAd

@synthesize strAdCreateDate,strAdDesc,strAdGotoURL,strAdID,strAdTitle,adType;

@synthesize strShowTitle;

@synthesize strLeftMoneyDesc;

@synthesize showFlag;

-(id)init
{
    if(self = [super init])
    {
        strAdCreateDate = [[NSString alloc] init];
        strAdDesc = [[NSString alloc] init];
        
        strAdGotoURL = [[NSString alloc] init];
        strAdID = [[NSString alloc] init];
        
        strAdTitle = [[NSString alloc] init];
        strShowTitle = [[NSString alloc] init];
        
        strLeftMoneyDesc = [[NSString alloc] init];
        
        strAdCreateDate = @"";
        strAdDesc = @"";
        strAdGotoURL = @"";
        strAdID = @"";
        strAdTitle = @"";
        strShowTitle = @"";

        strLeftMoneyDesc = @"";
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - SOS号码

@implementation DataObjectSOS

@synthesize strId,strMobile1,strMobile2,strMobile3,strMobile4;

-(id)init
{
    if(self = [super init])
    {
        return self;
    }
    else
    {
        return nil;
    }
}


@end

#pragma mark - 设备列表

@implementation DataObjectMyDeviceList

@synthesize strHealthInfo,strCheckCode;

@synthesize strCreateTime,strDeviceName,strDeviceType,strDeviceId,strDeviceIMEI,strDeviceMobile,strSocketLastIP,strStatus,strUserId,strValidityDate;

@synthesize strDeviceOwnerName,strAge,strCommonlyUseDrugs;

@synthesize strGuardianId,strGuardianManDeviceId,strGuardManCreateTime,strGuardianName,strGuardianManPhoto,strGuardianManMobile,strGuardianManId;
@synthesize strNickName;

@synthesize strTipDesc;

@synthesize strLat,strLon,strRadius;

@synthesize strAddress,strGPSSecond;

@synthesize subArrayObject;

-(id)init
{
    if(self = [super init])
    {
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - 吃药提醒
@implementation DataObjectMedicineRemind

@synthesize strRelationPersonID,strRelationPersonName,strRemindContent,strRemindTime;
@synthesize strDeviceName,strDeviceID;

@synthesize strTimeList,strWeekDayList;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}

@end


#pragma mark - 报警信息
@implementation DataObjectAlarmInfo

@synthesize strAlarmContent,strAlarmType,strCreateTime,strDeviceId,strDeviceName,strDeviceType,strId,strMobile,strOwnerName;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}

@end

#pragma mark -健康五大分类

@implementation DataObjectHealth

@synthesize strCreateTime,strDeviceID,strHeartTimes,strHighPressure,strID,strLowPressure,strPlusTimes,strSecconds,strSoportValue,strSugarValue;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end



#pragma mark -  围栏信息

@implementation DataObjectElectronicInfo

@synthesize strRadius,strLon,strLat,strAddress,strCreateTime,strDeviceId,strDeviceName,strId,strOwnerName;

@synthesize subPointArray;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end



#pragma mark - 单人监控、多人监控

@implementation DataObjectPersonMonitoriing
@synthesize strCreateTime,strOwnerName,strDeviceName,strMobile,strDeviceType,strID;
@synthesize strIMEI,strSocketLastIP,strSocketLastTime,strUserId,strValidityDate;
@synthesize strStatus;
@synthesize strLon,strLat,subArrayInfo,strAddress;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}

@end

#pragma mark - 老师对学生的反馈记录

@implementation DataObjectTeacherToStudentFeedBack
@synthesize strCourseId,strCourseName,strEndTime,strFeedBack,strFeedTime,strHomeWork,strStartTime;


-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}

@end

#pragma mark - 反馈 查询结构
@implementation DataObjectFeedBack

@synthesize strSAId,strStuId,strAcceptId,strSACnName,strContent,strCreateTime,strSAEnName,strSAPhoto,strSendId;

@synthesize strStuPhoto,strStuCnName,strStuEnName;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - 课程 ->课程考勤

@implementation DataObjectAttendance

@synthesize strAttendence,strChiDaoCount,strKuangKeCount,strEndTime,strDayNum,strCourseName,strCourseId,strCourseDate,strChuqinCount,strSchoolName,strSchoolId,strStartTime,strTeacherCnName,strTeacherEnName,strTeacherId,strZaoTuiCount;
@synthesize strArrangeCourseId;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end



#pragma mark - 获取用户信息、合同信息、课程信息、个人基本信息

@implementation DataObjectUserInfo

@synthesize strContractId;
@synthesize strContractNo;
@synthesize strBegDate;
@synthesize strEndDate;
@synthesize strStatus;



@synthesize strTeaId;
@synthesize strCnName;
@synthesize strEnName;
@synthesize strCourseId;
@synthesize strCourseName;
@synthesize strHours;



@synthesize strUserId;
@synthesize strUserName;
@synthesize strStudentCnName;
@synthesize strStudentEnName;
@synthesize strSex;
@synthesize strMobile;
@synthesize strEmail;
@synthesize strAreaId;
@synthesize strAreaName;
@synthesize strSchoolId;
@synthesize strSchoolName;
@synthesize strPhoto;
@synthesize strLeftMb;
@synthesize strTotalMb;


@synthesize subContractInfoArray;
@synthesize subScourseInfoArray;
@synthesize subStubasicInfoArray;


-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - 联系人

@implementation DataObjectLinkMan

@synthesize strLinkMobile,strLinkName;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end



#pragma mark - 课程信息
@implementation DataObjectCourseInfo

@synthesize strCourseName,strCourseId,strCnName,strEnName,strHours;
@synthesize strTeaId;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - 我的M币信息

@implementation DataObjectMyMBInfo

@synthesize strType,strCnName,strCourseId,strCourseName,strDates,strEndTime,strEnName,strID,strOutMbID,strSendCount,strSendTime,strStartTime,strStuCnName,strStudentId,strStuEnName,strTeacherId,strRemark;
@synthesize subOutMBArray;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end

#pragma mark - 我的成绩

@implementation DataObjectMyGrade

@synthesize strCategoryName,strExamScore,strExamTime,strExamType,strExamTypeName,strSubjectId,strSubjectName,strTitleId,strTotalScore;
@synthesize subObjectArray;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - 已结课时信息
@implementation DataObjectFinishedCourseInfo

@synthesize strTeacherId,strStartTime,strArrangeCourseId,strCourseDate,strCourseId,strCourseName,strCourseStatus,strEndTime,strIsFinish,strSchoolId,strSchoolName,strStatus,strStudentId,strTeacherCnName,strTeacherEnName,strTheCourseNum;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end




#pragma mark - 倒计时
@implementation DataObjectCountDown

@synthesize strCnName,strEnName,strExamAddress,strExamDateTime,strPhoto,strSubject,strCountDownID;

@synthesize strStudentID;

-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - 我的投诉

@implementation DataObjectComplaint

@synthesize strCompainId,strCompainTime,strContent,strStatusName,strStuId,strStatus;


-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end

#pragma mark - 投诉回复
@implementation DataObjectReply

@synthesize strComplainId,strReplyContent,strReplyId,strReplyTime;


-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end


#pragma mark - 消息推送结构
@implementation DataObjectPushMessage

@synthesize strMessageContent,strMessageDetailId,strMessageType,strMessageDateTime;
-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}

#define conent      @"content"
#define type        @"type"
#define detailID    @"detailID"
#define dateTime    @"dateTime"


- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.strMessageContent forKey:conent];
    [encoder encodeObject:self.strMessageType forKey:type];
    
    [encoder encodeObject:self.strMessageDetailId forKey:detailID];
    [encoder encodeObject:self.strMessageDateTime forKey:dateTime];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if(self = [super init])
    {
        self.strMessageContent = [decoder decodeObjectForKey:conent];
        self.strMessageType = [decoder decodeObjectForKey:type];
        self.strMessageDetailId = [decoder decodeObjectForKey:detailID];
        self.strMessageDateTime = [decoder decodeObjectForKey:dateTime];
    }
    
    return self;
    
}


@end

#pragma mark - 检查更新
@implementation DataObjectCheckUpdate

@synthesize strDownlaodURL,strUpdateContent,strVersion,forceUpdateTag;
-(id)init
{
    if(self = [super init])
    {
        
        return self;
    }
    else
    {
        return nil;
    }
}


@end

