//
//  SubEditViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-1-24.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "PAImageView.h"
#import "model.h"
#import "SubEditViewController.h"

@interface SubEditViewController ()

@end

@implementation SubEditViewController

@synthesize delegate;
@synthesize selectRowIndex,selectSectionIndex;


-(id)initWithEditType:(EditViewType)eType withDelegate:(id)mDelegate withDataSource:(id)dataSource selectValue:(NSString*)strValue selectIndex:(NSInteger)sIndex withObject:(id)object
{
    self = [super init];
    if (self) {
        
        editType = eType;
        
        delegate = mDelegate;
        
        if(self.mEditValue ==nil)
        {
            self.mEditValue = [[NSMutableString alloc] initWithCapacity:0];
        }
        
        if(dataSource !=nil)
        {
            if(mTableDataSource == nil)
            {
                mTableDataSource = [[NSMutableArray alloc]init];
            }
            
            [mTableDataSource addObjectsFromArray:dataSource];
            
        }
        [self.mEditValue setString:strValue];
        self.mEditObject = object;
        
    }
    return self;
}


-(id)initWithEditType:(EditViewType)eType withDelegate:(id)mDelegate withEditValue:(NSString*)strEdit withObject:(id)object
{
    self = [super init];
    if (self) {
        
        editType = eType;
        
        delegate = mDelegate;
        
        if(self.mEditValue ==nil)
        {
            self.mEditValue = [[NSMutableString alloc] initWithCapacity:0];
        }
        
        self.mEditObject = object;
        [self.mEditValue setString:strEdit];
        
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self drawTableView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if(editType == editTypeSelectDevice || editType == editTypeSelectMyDevice)
    {
        if (selectSectionIndex == 0)
        {
            if(selectRowIndex == 0)
            {
                [self getDeviceList];
            }
        }
        else
        {
            
        }
    }
    else if(editType == editTypeSelectPerson)
    {
        if (selectSectionIndex == 0)
        {
            if(selectRowIndex == 0)
            {
                [self getDeviceList];
            }
            
        }

    }
    else if (editType == editTypeWriteUserHealthInfo)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancel)];
        
    }
    else if (editType == editTypeSelectPersonHealth)
    {
        if([mTableDataSource count])
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancel)];
            
            
        }
    }
    
    
}


-(void)btnCancel
{
    if([self.navigationController.viewControllers count]>1)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(mTextField)[mTextField becomeFirstResponder];
    
    if(mTextView)[mTextView becomeFirstResponder];
    
}

#pragma mark- 获取设备
-(void)getDeviceList
{
    JsonService *jsonService = [JsonService sharedManager];
    
    [jsonService setWebserviceDelegate:self];
    
    if(editType == editTypeSelectDevice)
    {
        [jsonService getDeviceList];
    }
    else
    {
        [jsonService getMyDevice];
    }
    
    
}

#pragma mark - 获取亲友
-(void)getMyRelationPerson
{
    
    
}

#pragma mark-
#pragma mark- drawTableView
-(void)drawTableView
{
    CGFloat yorgin = 0.0;
    
    if(mTableView == nil)
    {
        mTableView = [[UITableView alloc]  initWithFrame:CGRectMake(0,yorgin, self.view.frame.size.width ,self.view.frame.size.height-64) style: UITableViewStyleGrouped];
        [mTableView setDelegate:self];
        [mTableView setDataSource:self];
        
        mTableView.backgroundColor = [UIColor clearColor];
        mTableView.backgroundView = nil;
        
        [self.view addSubview:mTableView];
        
    }
    else
    {
        [mTableView reloadData];
    }
}


- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)delegateWithValue:(id)value
{
    if(value!=nil)
    {
        [delegate didFinishedEditWithValue:value];
        
        if([self.navigationController.viewControllers count]>1)
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    
}


#pragma mark -
#pragma mark - TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 15;
            break;
        default: {
            return 4;
            break;
        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(editType == editTypeSelectDevice)
    {
        return 1;
    }
    else if(editType == editTypeSelectMyDevice)
    {
        return 1;
    }
    else if(editType == editTypeSelectPersonHealth)
    {
        return 1;
    }
    else if(editType == editTypeWriteUserHealthInfo)
    {
        return 1;
    }
    else if (editType == editTypeSelectPerson) // 添加吃药提醒
    {
        return 1;
    }
    else
    {
        if([mTableDataSource count]>0)
        {
            return [mTableDataSource count];
            
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(editType == editTypeSelectPersonHealth)
    {
        if([mTableDataSource count]>0)
        {
            return [mTableDataSource count];
            
        }
    }
    else if (editType == editTypeSelectPerson)
    {
        if([mTableDataSource count]>0)
        {
            
            return [mTableDataSource count];
            
        }
    }
    else if (editType == editTypeSelectDevice)
    {
        if([mTableDataSource count])
        {
            return [mTableDataSource count];
        }
    }
    else if (editType == editTypeSelectMyDevice)
    {
        if([mTableDataSource count])
        {
            return [mTableDataSource count];
        }
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"myTableView";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
	
	for (id v in cell.contentView.subviews)
	{
		[v removeFromSuperview];
		//v = nil;
	}
    
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
	}
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if([mTableDataSource count])
    {
        if(editType == editTypeSelectDevice)
        {
            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.row];
            
            NSString *strDeviceName = [device strDeviceName];
            
            cell.textLabel.text = strDeviceName;
            
            if([self.mEditValue length])
            {
                if([self.mEditValue isEqualToString:strDeviceName])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
        else if(editType == editTypeSelectPersonHealth || editType == editTypeSelectDevice || editType == editTypeSelectMyDevice || editType == editTypeSelectPerson)
        {
            CGFloat xposition = 10;
            CGFloat yposition = 15;
            
            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.row];
            
            PAImageView *avaterImageView = [[PAImageView alloc] initWithFrame:CGRectMake(xposition, yposition, 44, 44) backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
            avaterImageView.image = [UIImage imageNamed:@"branddefulthead@2x"];
            avaterImageView.userInteractionEnabled = YES;
            avaterImageView.clipsToBounds = YES;
            avaterImageView.tag = indexPath.row;
            
            avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:avaterImageView];
            
            xposition = avaterImageView.frame.origin.x+avaterImageView.frame.size.width+10;
            
            UILabel *lableNick = [[UILabel alloc] initWithFrame:CGRectMake(xposition, 10, cell.frame.size.width-(xposition+10), 20)];
            lableNick.backgroundColor = [UIColor clearColor];
            lableNick.textColor  =[UIColor blackColor];
            lableNick.font = [UIFont systemFontOfSize:15];
            
            lableNick.text = [NSString stringWithFormat:@"昵称:%@",device.strDeviceOwnerName
];
            [cell.contentView addSubview:lableNick];
            
            yposition = lableNick.frame.origin.y+lableNick.frame.size.height+5;
            
            UILabel *lableLinkMobile = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+10), 20)];
            lableLinkMobile.backgroundColor = [UIColor clearColor];
            lableLinkMobile.textColor  =[UIColor darkGrayColor];
            lableLinkMobile.font = [UIFont systemFontOfSize:14];
            
            lableLinkMobile.text = [NSString stringWithFormat:@"关联手机:%@",device.strDeviceMobile];
            [cell.contentView addSubview:lableLinkMobile];
            
            
            yposition = lableLinkMobile.frame.origin.y+lableLinkMobile.frame.size.height+5;
            
            UILabel *lableHealthInfo = [[UILabel alloc] initWithFrame:CGRectMake(lableNick.frame.origin.x, yposition, cell.frame.size.width-(lableNick.frame.origin.x+10), 20)];
            lableHealthInfo.backgroundColor = [UIColor clearColor];
            lableHealthInfo.textColor  =[UIColor blackColor];
            lableHealthInfo.font = [UIFont systemFontOfSize:14];
            lableHealthInfo.numberOfLines = 0;
            lableHealthInfo.lineBreakMode = kUILineBreakModeWordWrap;
            lableHealthInfo.text = [NSString stringWithFormat:@"健康状态:%@",device.strHealthInfo];
            [cell.contentView addSubview:lableHealthInfo];
            
            CGSize size = [lableHealthInfo.text boundingRectWithSize:CGSizeMake(cell.frame.size.width-(lableNick.frame.origin.x+10), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:lableHealthInfo.font,NSFontAttributeName, nil] context:nil].size;
            
            lableHealthInfo.frame = CGRectMake(lableHealthInfo.frame.origin.x, lableHealthInfo.frame.origin.y, size.width, size.height);
            
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, lableHealthInfo.frame.origin.y+size.height+5);
            
        }
        else
        {
            
            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.section];
            
            NSString *strDeviceName = [device strDeviceName];
            
            cell.textLabel.text = strDeviceName;
            
            if([self.mEditValue length])
            {
                if([self.mEditValue isEqualToString:strDeviceName])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
            
//            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.section];
//            if(device.subArrayObject!= nil && [device.subArrayObject count])
//            {
//                DataObjectMyDeviceList *subDevice =[device.subArrayObject objectAtIndex:indexPath.row];
//                
//                cell.textLabel.text = subDevice.strNickName;
//                
//                NSLog(@"\n name :%@ \n",subDevice.strNickName);
//                
//                if([self.mEditValue length])
//                {
//                    if([self.mEditValue isEqualToString:subDevice.strNickName])
//                    {
//                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    }
//                    else
//                    {
//                        cell.accessoryType = UITableViewCellAccessoryNone;
//                    }
//                }
//                
//            }

            
        }
 
    }
    else
    {
        if(editType == editTypeWriteUserHealthInfo)
        {
            if(selectSectionIndex == 1)
            {
                mTextView = [[SZTextView alloc] initWithFrame:
                             CGRectMake(8, 4, cell.frame.size.width-15, 124)];
                mTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                mTextView.returnKeyType = UIReturnKeyDone;
                mTextView.delegate = self;
                mTextView.backgroundColor = [UIColor clearColor];
                mTextView.font = [UIFont systemFontOfSize:15];
                mTextView.textColor = [UIColor darkGrayColor];
                mTextView.placeholderTextColor = [UIColor lightGrayColor];
                mTextView.tag = indexPath.row;
                
                [cell.contentView addSubview:mTextView];
                
                
                if(selectRowIndex == 1)
                {
                    if([self.mEditValue length])
                    {
                        mTextView.text = self.mEditValue;
                    }
                    else
                    {
                        mTextView.placeholder = @"填写健康状况";
                        
                    }
                    
                }
                else if (selectRowIndex == 2)
                {
                    if([self.mEditValue length])
                    {
                        mTextView.text = self.mEditValue;
                    }
                    else
                    {
                        mTextView.placeholder = @"填写常用药品";
                    }
                }
                
                cell.frame = CGRectMake(0, 0, cell.frame.size.width, mTextView.frame.origin.y+mTextView.frame.size.height+10);
            }
            
            
        }
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",indexPath.row);
    model *m = [[model alloc] init];
    m.m_name = indexPath.row;  //把数据赋给模型对象的一个属性
    if ([self.delegate respondsToSelector:@selector(viewControllerChangeInfo:)])  //用什么方法实现代理
    {
        [self.indexDelegate viewControllerChangeInfo:m];//把模型数据传给InfoModel里面
    }

    
    if (editType == editTypeSelectDevice)
    {
        
        if([mTableDataSource count])
        {
            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.row];
            
            DataObjectMyDeviceList *deviceInfo = (DataObjectMyDeviceList*)self.mEditObject;
            
            deviceInfo.strDeviceName = device.strDeviceName;
            deviceInfo.strDeviceId = device.strDeviceId;
            deviceInfo.strDeviceIMEI = device.strDeviceIMEI;
            deviceInfo.strDeviceMobile = device.strDeviceMobile;
         
            deviceInfo.strDeviceOwnerName = device.strDeviceOwnerName;
            
            [self delegateWithValue:deviceInfo];
            
        }
 
        
    }
    else if (editType == editTypeSelectPersonHealth)
    {
        
        if([mTableDataSource count])
        {
            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.row];
            
            if(device!=nil)
            {
                [delegate didFinishedEditWithValue:device.strDeviceOwnerName withIndex:indexPath.row];
                
                if([self.navigationController.viewControllers count]>1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }

        }
        
    }
    else if (editType == editTypeSelectPerson)// 添加监护人
    {
        if([mTableDataSource count])
        {
            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.row];
            
            DataObjectMedicineRemind *deviceInfo = (DataObjectMedicineRemind*)self.mEditObject;
            
            deviceInfo.strDeviceName = device.strDeviceName;
            deviceInfo.strDeviceID = device.strDeviceId;
            deviceInfo.strRelationPersonName = device.strDeviceOwnerName;
            
            [self delegateWithValue:deviceInfo];
            
        }
    }
    else if (editType == editTypeSelectMyDevice)
    {
        if([mTableDataSource count])
        {
            DataObjectMyDeviceList *device =[mTableDataSource objectAtIndex:indexPath.row];
            
            DataObjectMyDeviceList *deviceInfo = (DataObjectMyDeviceList*)self.mEditObject;
            
            deviceInfo.strDeviceName = device.strDeviceName;
            deviceInfo.strDeviceId = device.strDeviceId;
            deviceInfo.strDeviceOwnerName = device.strDeviceOwnerName;

            
            [self delegateWithValue:deviceInfo];
            
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


#pragma mark - textView delegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        SZTextView *thisTextView = (SZTextView*)textView;

        if(textView.tag == 0)
        {
            
            thisTextView.placeholder = @"填写健康状况";
            
        }
        else
        {
            thisTextView.placeholder = @"填写常用药品";
        }
        
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location > 99 || [textView.text length]>99)
        return NO;
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self delegateWithValue:textView.text];
    
    
}


#pragma mark -
#pragma mark - webService delegate
-(void)webServicDidStartWithRequest:(NetWebServiceRequest *)request
{
    DEBUG_NSLOG(@"\n\n start request \n\n ");
    
    [self showHUDViewWithString:@"加载中.." withHUDType:SVProgressHUDMaskTypeNone];
    
    
}

-(void)webServicDidFinishedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    
    id obj = [DataPaser returnObjectWithString:requestStr withType:jsonDataTypeMyDeviceList];
    
    if (obj!=nil)
    {
        SampleDataObject *tempObject =  (SampleDataObject *)obj;
        
        if (tempObject.intSuccess == 1000)
        {
            [SVProgressHUD dismiss];
            
            if([tempObject.arrObjects count])
            {
                if(mTableDataSource == nil)
                {
                    mTableDataSource = [[NSMutableArray alloc ]init];
                    
                }
                else
                {
                    [mTableDataSource removeAllObjects];
                }
                
                [mTableDataSource addObjectsFromArray:tempObject.arrObjects];
                
                 [self drawTableView];
                
                
            }
            
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:tempObject.strMessage];
            
            
        }
    }
    
}

-(void)webServicDidFailedWithRequest:(NetWebServiceRequest *)request requetString:(NSString *)requestStr
{
    [self dismissHUDViewWithString:requestStr];
}


#pragma mark-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
