//
//  DataPaser.h
//  Ministry of culture
//
//  Created by ZhouLiang on 14-4-1.
//  Copyright (c) 2014年 fengjing. All rights reserved.
//



#import <Foundation/Foundation.h>


typedef enum
{
    jsonTypeWeather = 0,
    
    jsonDataTypeCheckVersion,                   // 检查更新
    
    jsonDataTypeGetServerURL,                   // 获取服务器地址列表
    
    jsonDataTypeLogin,                          // 登录
    jsonDataTypeRegister,                       // 注册
    
    jsonDataTypeCheckCode,                      // 获取验证码
    
    jsonDataTypeUserInfo,                       // 用户信息
    
    jsonDataTypeUploadIcon,                     // 修改用户头像
    
    jsonDataTypeUpdatePwd,                      // 修改密码
    
    jsonDataTypeThirdPartBindStatus,            // 第三方绑定状态
    
    jsonDataTypeCancelBindStatus,               // 解除绑定状态
    
    // ----------------------------------------------------------
    
    jsonDataTypeAddPerson,                      // 添加监护人
    
    jsonDataTypeAddTakeMedicineRemind,          // 添加吃药提醒
    
    jsonDataTypeMyDeviceList,                   // 我的设备课表
    
    jsonDataTypeAlarmInfo,                      // 报警信息
    
    jsonDataTypeMyRemindInfo,                   // 我的提醒列表
    
    jsonDataTypePersonMonitoring,               // 实时监控、多人监控
    
    jsonDataTypeElectronic,                     // 电子围栏
    
    jsonDataTypeAddElectronic,                  // 新增电子围栏
    
    jsonDataTypeHistoryPlayBack,                // 历史回放
    
    jsonDataTypeCoordinateToAddress,            // 经纬度转地址
    
    jsonDataTypeHealthItems,                    // 健康五大类
    
    jsonDataTypeGPSUploadTime,                  // GPS上传时间
    
    jsonDataTypeSOSSetting,                     // SOS号码设置
    
    jsonDataTypeLinkManInfo,                    // 手表联系人设置
    
    jsonDataTypeMedicineRemind,                 // 吃药提醒
    
    jsonDataTypeMyTeacherAndStudent,            // 我的老师我的学生
    
    jsonDataTypeTeacherToStudentPayDetail,      // 老师与学生的打赏记录
    
    jsonDataTypeTeacherToStudentFeedBack,       // 老师与学生的反馈记录
    
    jsonDataTypeSAFeedBackList,                 // sa和学生的反馈列表
    
    jsonDataTypePostFeedBackToSA,               // 提交反馈给SA
    
    jsonDataTypeScheduleAttendance,             // 课程考勤
    
    jsonDataTypeFinishedCourseName,             // 已结科目名称
    
    jsonDataTypeFinishedCourseInfo,             // 已结科目信息
    
    jsonDataTypeContactDetail,                  // 联系人详情
    
    jsonDataTypeMyCountDown,                    // 倒计时
    
    jsonDataTypeAddMyCountDown,                 // 新增倒计时
    
    jsonDataTypeDeleteMyCountDown,              // 删除倒计时
    
    jsonDataTypeMyComplints,                    // 我的投诉
    
    jsonDataTypeMyComplintsDetail,              // 我的投诉详情
    
    jsonDataTypeCancelCourse,                   // 取消课程
    
    jsonDataTypeSendMB,                         // 打赏MB
    

}jsonDataType;


@interface DataPaser : NSObject
{
    jsonDataType jsonType;
}
@property (nonatomic, strong) NSMutableArray *historyData;
+(NSMutableArray *)returnDataWithData:(NSData *)data;

+(id)returnDataSourceWithData:(NSData *)receive withType:(jsonDataType)jType;
+(id)returnObjectWithString:(NSString *)receive withType:(jsonDataType)jType;

@end
