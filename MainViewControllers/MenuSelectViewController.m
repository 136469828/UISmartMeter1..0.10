//
//  MenuSelectViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 14-10-9.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "MenuSelectViewController.h"

@interface MenuSelectViewController ()

@end

@implementation MenuSelectViewController

-(id)initWithMenuSelectType:(menuSelectType)sType
{
    self = [super init];
    if (self) {
        
        menuType = sType;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.title;
    
    [self setRightButtonWithTitle:@"取消" textFont:16 withBackGroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] withBackImage:nil withFrame:CGRectZero isRightButton:NO];
    
    if(menuType == menuTypeCommunication)
    {
        mTableviewArr = [[NSMutableArray alloc] initWithObjects:@"待沟通",@"已沟通",@"全部",nil];
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(mTableView == nil)
    {
        [self drawTableView];
    }
    
}


-(void)drawTableView
{
    
    if(mTableView == nil)
    {
        mTableView = [[UITableView alloc]  initWithFrame:CGRectMake(0,0, self.view.frame.size.width ,self.view.frame.size.height) style: UITableViewStylePlain];
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



#pragma mark -
#pragma mark - TableView delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([mTableviewArr count])
    {
        return [mTableviewArr count];
    }
    
    return 0;
    
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
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if(mTableviewArr!=nil && [mTableviewArr count]>0)
    {
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.text = [mTableviewArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
