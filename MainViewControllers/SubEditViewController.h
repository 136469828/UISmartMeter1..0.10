//
//  SubEditViewController.h
//  UISmartMeter
//
//  Created by RealTmac on 15-1-24.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "SZTextView.h"
#import "model.h"
#import "MasterViewController.h"

typedef enum
{
    editTypeSelectPerson = 0,            //添加吃药提醒 选择人
    editTypeWriteUserHealthInfo,         //健康状况、常用药品
    
    editTypeSelectPersonHealth,
    
    editTypeSelectMyDevice,              //我的设备
    editTypeSelectDevice,                //所有设备
    editTypeWriteTipDesc                 //备注
    

    
}EditViewType;


@protocol editFinishedDelegate <NSObject>



@optional
-(void)didFinishedEditWithValue:(id)objValue;

@optional
-(void)didFinishedEditWithValue:(id)objValue withIndex:(NSInteger)index;

@end
@protocol TwoViewControllerDelegate <NSObject> //协议(类名＋Delegate)
- (void)viewControllerChangeInfo:(model *)InfoModel; //传了一个Modal数据过来

@end

@interface SubEditViewController : MasterViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *mTextField;
    SZTextView *mTextView;
    
    UILabel *placeholderLable;
    
    __unsafe_unretained id<editFinishedDelegate>delegate;

    NSMutableArray *mTableDataSource;
    
    UITableView *mTableView;
    
    NSInteger selectSectionIndex;
    
    NSInteger selectRowIndex;
    
    EditViewType editType;
    
}
@property (nonatomic, weak) id<TwoViewControllerDelegate> indexDelegate;//有一个实现协议的对象

@property       NSInteger selectSectionIndex;

@property       NSInteger selectRowIndex;

@property(assign) __unsafe_unretained id<editFinishedDelegate>delegate;

@property(nonatomic,strong)NSMutableString *mEditValue;

@property(nonatomic,strong)id mEditObject;

-(id)initWithEditType:(EditViewType)eType withDelegate:(id)mDelegate withEditValue:(NSString*)strEdit withObject:(id)object;


-(id)initWithEditType:(EditViewType)eType withDelegate:(id)mDelegate withDataSource:(id)dataSource selectValue:(NSString*)strValue selectIndex:(NSInteger)sIndex withObject:(id)object;

@end
