//
//  SubWatchSettingViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15/5/19.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "GCDAsyncSocket.h"


#import "BaseTableViewController.h"

typedef enum
{
    settingTypeOfGPSUpTime = 0,            //GPS上传时间
    settingTypeOfSOSNumber,                //SOS号码
    settingTypeOfAddressBook,              //通讯录
    settingTypeOfTakeMedicineRemind,       //吃药提醒
    settingTypeOfSendImage,                //发送图片
    settingTypeOfHealthInfo,               //健康状况
    settingTypeOfCommonlyDrugs,            //常用药物
    settingTypeOfyanzhengma
    
}WatchSettingType;


@interface SubWatchSettingViewController : BaseTableViewController<UITextFieldDelegate,GCDAsyncSocketDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    GCDAsyncSocket *socket;
    
    UITextField *mTextField;
    
    NSMutableArray *mTableviewSection1;
    NSMutableArray *mTableviewSection2;
    
    WatchSettingType settingType;
    
    NSMutableString *mAddressTitle;
    NSMutableString *mAddressNumber;
    
    NSMutableArray *mArrayAddressTitle;
    NSMutableArray *mArrayAddressNumber;

    NSMutableArray *mArrayRemindTime;
    
    
    NSMutableDictionary *addressBookInfoDictionnary; // 通讯录字典信息
    UIPickerView *timePick;
    UIView *dateSelectView;
    
    UILabel *timeLabel;
    UILabel *timeLabel1;
    UILabel *timeLabel2;
    NSString *timeStr0;
    NSString *timeStr1;
    NSString *timeStr2;
    
    NSInteger selectTag;
    NSMutableArray *m_hour;
    NSMutableArray *m_times;
    NSInteger components;
    
}
@property (nonatomic, strong) NSString *strSelectDate;
@property(strong)  GCDAsyncSocket *socket;


@property(nonatomic,strong)NSString *strDeviceID;

@property(nonatomic,strong)NSString *strGPSUpLoadSecond;

@property(nonatomic,strong)DataObjectSOS *objectSOS;

@property(nonatomic,strong)DataObjectMedicineRemind *objectMedicineRemind;

// pickerView
@property (nonatomic, strong) UIView *closeV;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *labelView;
/*********************************/


@property(nonatomic,strong)DataObjectMedicineRemind *medicineRmindObject;

-(id)initWithSettingType:(WatchSettingType)type deviceID:(NSString*)deviceId;

@end
