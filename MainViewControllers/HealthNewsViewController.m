//
//  HealthNewsViewController.m
//  UISmartMeter
//
//  Created by RealTmac on 15-4-7.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import "TestNewsViewController.h"

#import "HealthNewsViewController.h"

@interface HealthNewsViewController ()

@end

@implementation HealthNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDataSource];
    
}


-(void)loadDataSource
{
    NSURL *urlPushConfig = [[[NSBundle mainBundle] URLForResource:@"healthNews"
                                                    withExtension:@"plist"] copy];
    NSDictionary *dictPushConfig =
    [NSDictionary dictionaryWithContentsOfURL:urlPushConfig];
    
    if (dictPushConfig) {
        
        self.dataSource = [NSMutableArray arrayWithArray:[dictPushConfig allKeys]];
        
        allValue = [[NSMutableArray alloc] initWithArray:[dictPushConfig allValues]];
    }
    
    
    
    
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.dataSource count])
    {
        if(indexPath.row == [self.dataSource count])
        {
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    if([self.dataSource count])
    {
        NSString *strkey  =[self.dataSource objectAtIndex:indexPath.row];
        
        cell.textLabel.text = strkey;
        
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([allValue count])
    {
        NSString *strkey  =[self.dataSource objectAtIndex:indexPath.row];
        
        NSString *strValue  =[allValue objectAtIndex:indexPath.row];
        
        TestNewsViewController *test = [[TestNewsViewController alloc]initWithDetailString:strValue];
        test.title = strkey;
        
        [self.navigationController pushViewController:test animated:YES];
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
