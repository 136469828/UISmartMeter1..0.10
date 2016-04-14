//
//  AddViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 14-10-11.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "MasterViewController.h"

#import <MapKit/MapKit.h>

#import "LXActionSheet.h"


#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "CustomAnnotation.h"

#import "GCDAsyncSocket.h"


#import <BaiduMapAPI_Location/BMKLocationComponent.h>


#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

typedef enum
{
    addTypePeson = 0,               //添加监护人
    addTypeTakeMedicineRemind,      //吃药提醒
    
    addTypeDeviceForPerson,         //添加设备
    
    addTypeElectronic,              //电子围栏
    
    addTypeOther
}addViewType;


@interface AddViewController : MasterViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate,UITextViewDelegate,MKMapViewDelegate,LXActionSheetDelegate,BMKLocationServiceDelegate,GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;

    
    BMKLocationService* _locService;

    BasicMapAnnotation *call;
    
    UIView *dateSelectView;

    CLLocationCoordinate2D _touchMapCoordinate;  //  点击后那一点的经纬度
    
    NSMutableString *mCheckCode;
    
    UIButton *codeButton;
    
    NSMutableString *mUserPhone;
    NSMutableString *mUserName;
    
    UITextField *mTextField;
    
    UITableView *mTableView;
    
    NSInteger selectRowIndex;
    NSInteger selectSectionIndex;
    
    NSMutableArray *mTableviewSection1;
    NSMutableArray *mTableviewSection2;
    NSMutableArray *mTableviewSection3;
    
    addViewType currentViewType;
    NSString *phoneNum;
}

@property(strong)  GCDAsyncSocket *socket;

@property (nonatomic, strong) NSString *strSelectDate;

@property (nonatomic, strong) MKMapView *mapView;


@property(nonatomic,strong)UITextField *mTextFieldBeingEdited;
@property(nonatomic,strong)DataObjectMyDeviceList *deviceObjet;

@property(nonatomic,strong)DataObjectMedicineRemind *medicineRmindObject;

@property (nonatomic, strong) UIView *closeV;
-(id)initWithAddViewType:(addViewType)aType;

-(id)initWithAddViewType:(addViewType)aType withObj:(DataObjectMyDeviceList*)obj;


@end
