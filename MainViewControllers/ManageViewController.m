//
//  ManageViewController.m
//  UIDoudouIn
//
//  Created by RealTmac on 14-9-25.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//

#import "Util.h"
#import "globalConfig.h"

#import "UIScrollView+TwitterCover.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AddViewController.h"



#import "ManageViewController.h"



@interface ManageViewController ()


@end

@implementation ManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    return self;
}



-(void)setSubView
{
    menuBtnArray = [[NSMutableArray alloc ] initWithObjects:
                    
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage1", @"image",@"会员查询",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage2", @"image",@"新增会员",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage6", @"image",@"意见反馈",@"titleName", nil],nil];
    
    [self drawScrollView];
    
    
}


-(void)addNotification
{
    
    // 是否需要刷新 服务界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentIsManager" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentIsManager:)
                                                 name: @"currentIsManager"
                                               object: nil];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentIsManager" object:nil];
}


#pragma mark-
#pragma mark -收到选中的项通知
-(void)currentIsManager:(NSNotification *)note
{
    if([menuBtnArray count])
    {
        [menuBtnArray removeAllObjects];
    }
    
    menuBtnArray = [[NSMutableArray alloc ] initWithObjects:
                    
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage1", @"image",@"会员查询",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage2", @"image",@"新增会员",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage3", @"image",@"店面信息",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage4", @"image",@"店员信息",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage5", @"image",@"广告查询",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage6", @"image",@"意见反馈",@"titleName", nil],nil];
    
    [self drawMenuSubViewWithFatherView:mScrollView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self setSubView];
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



#pragma mark-
#pragma mark -drawScrollView
-(void)drawScrollView
{
    
    if(mScrollView == nil)
    {
        mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        
        [mScrollView addTwitterCoverWithImage:[UIImage imageNamed:@"manageTopBackGroud"]];
        [self.view addSubview:mScrollView];
        
        mScrollView.userInteractionEnabled = YES;
    }
    else
    {
    
    }

    
    if(iPhone5)
    {
        [mScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 600)];
    }
    else
    {
        [mScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 520)];
    }
    
    
    [self drawMenuSubViewWithFatherView:mScrollView];
    
}



#pragma mark -
#pragma mark - 用户头像
-(void)imageViewTap:(UITapGestureRecognizer *)tap
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [sheet addButtonWithTitle:@"拍照"];
    [sheet addButtonWithTitle:@"相册选取"];
    [sheet addButtonWithTitle:@"取消"];
    
    sheet.delegate = self;
    
    sheet.actionSheetStyle = (UIActionSheetStyle)self.navigationController.navigationBar.barStyle;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    
}




#pragma mark-
#pragma mark-登录
-(void)loginBtn
{
    LoginViewController *login = [[LoginViewController alloc] init];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}








#pragma mark-
#pragma mark - 菜单事件
-(void)btnMenuClicked:(UIButton*)btn
{
    
    btn.frame =CGRectMake(btn.frame.origin.x+8, btn.frame.origin.y+8, btn.frame.size.width-16,btn.frame.size.height-16);
    
    
    //[self showViewControllerWithIndex:btn.tag];
}

#pragma mark-
#pragma mark - 顶部菜单事件
-(void)btnTopMenuClicked:(UIButton*)btn
{
    }


#pragma mark --
#pragma mark-- UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0 )
    {
        [self takePictureByCamera];
    }
    else if(buttonIndex == 1 )
    {
        [self selectPicture];
    }
    else if(buttonIndex == 2 )
    {
        
    }
    
    [actionSheet setAlpha:0.0];
    
}


-(void)takePictureByCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持拍照功能"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
#ifdef __IPHONE_6_0
        
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
#else
        [self presentModalViewController :imagePickerController animated:NO];
        
#endif
        
    }
}

-(void)selectPicture
{
    UIImagePickerController *imgPicker= [[UIImagePickerController alloc] init] ;
    
    imgPicker.delegate = self;
    
    imgPicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
    
    
#ifdef __IPHONE_6_0
    
    
    [self presentViewController:imgPicker animated:YES completion:nil];
    
#else
    [self presentModalViewController :imgPicker animated:NO];
    
#endif

}


#pragma mark -
#pragma mark -
// TODO:相机
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
	
#ifdef __IPHONE_6_0
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
#else
    [picker dismissModalViewControllerAnimated:YES];
    
#endif
    
    
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picker.allowsEditing = YES;
    
#ifdef __IPHONE_6_0
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
#else
    [picker dismissModalViewControllerAnimated:YES];
    
#endif
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    CGSize imagesize = image.size;
    imagesize.height =100;
    imagesize.width =100;
    //对图片大小进行压缩--
    image = [Util handleImage:image withSize:imagesize];
    NSData *imageData = UIImageJPEGRepresentation(image,0.25);
    
    // send to server

    
}



-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


-(void)drawViewUnLoginWithFatherView:(UIView*)view
{
    CGFloat height = 200.0;
    
    if (iPhone5) {
        
        height = 260;
    }
    
    
    menuBtnArray = [[NSMutableArray alloc ] initWithObjects:
                    
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage1", @"image",@"会员查询",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage2", @"image",@"新增会员",@"titleName", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"iconManage6", @"image",@"意见反馈",@"titleName", nil],nil];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, height, view.bounds.size.width, view.frame.size.height - height)];
    tmpView.tag = 10010;
    tmpView.backgroundColor = self.view.backgroundColor;
    [view addSubview:tmpView];
    
    float xCoordinate, yCoordinate;
    
    for(int i=0;i<[menuBtnArray count];i++)
    {
        
        NSMutableDictionary *mdict = [menuBtnArray objectAtIndex:i];
        
        xCoordinate = (i%3)*(100+5) + 5;
        yCoordinate = (i/3)*(105+5) + 5;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xCoordinate, yCoordinate, 100, 105);
        btn.tag = i;
        btn.showsTouchWhenHighlighted = YES;
        [btn addTarget:self action:@selector(btnMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor =  [UIColor whiteColor];
        [tmpView addSubview:btn];
        
        UIImage *img = [UIImage imageNamed:[mdict valueForKey:@"image"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, img.size.width, img.size.height)];
        imageView.userInteractionEnabled = NO;
        imageView.image = img;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn addSubview:imageView];
        
        NSString *ss = [mdict valueForKey:@"titleName"];
        
        //按钮标题
        CGSize sizeTitle = [ss sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200.0f, 1000.0f) lineBreakMode:kUILineBreakModeWordWrap];
        
        int labelWidth = sizeTitle.width;
        
        UILabel  *Lable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + (imageView.frame.size.width - labelWidth )/ 2,imageView.frame.origin.y+imageView.frame.size.height+5,labelWidth,NAVIGATION_LABEL_HEIGHT)];
        [Lable setTextAlignment:kUITextAlignmentCenter];
        [Lable setText:ss];
        [Lable setBackgroundColor:[UIColor clearColor]];
        [Lable setTextColor:[UIColor darkGrayColor]];
        [Lable setFont:[UIFont systemFontOfSize:13.0]];
        [btn addSubview:Lable];
        
        
        
    }

}

#pragma mark- menu view
-(void)drawMenuSubViewWithFatherView:(UIView*)view
{
    CGFloat height = 200.0;
    
    if (iPhone5) {
        
        height = 260;
    }
    
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, height, view.bounds.size.width, view.frame.size.height - height)];
    tmpView.tag = 10010;
    tmpView.backgroundColor = self.view.backgroundColor;
    [view addSubview:tmpView];
    
    float xCoordinate, yCoordinate;
    
    for(int i=0;i<[menuBtnArray count];i++)
    {
        
        NSMutableDictionary *mdict = [menuBtnArray objectAtIndex:i];
        
        xCoordinate = (i%3)*(100+5) + 5;
        yCoordinate = (i/3)*(105+5) + 5;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xCoordinate, yCoordinate, 100, 105);
        btn.tag = i;
        btn.showsTouchWhenHighlighted = YES;
        [btn addTarget:self action:@selector(btnMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor =  [UIColor whiteColor];
        [tmpView addSubview:btn];
        
        UIImage *img = [UIImage imageNamed:[mdict valueForKey:@"image"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, img.size.width, img.size.height)];
        imageView.userInteractionEnabled = NO;
        imageView.image = img;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn addSubview:imageView];
        
        NSString *ss = [mdict valueForKey:@"titleName"];
        
        //按钮标题
        CGSize sizeTitle = [ss sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200.0f, 1000.0f) lineBreakMode:kUILineBreakModeWordWrap];
        
        int labelWidth = sizeTitle.width;
        
        UILabel  *Lable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + (imageView.frame.size.width - labelWidth )/ 2,imageView.frame.origin.y+imageView.frame.size.height+5,labelWidth,NAVIGATION_LABEL_HEIGHT)];
        [Lable setTextAlignment:kUITextAlignmentCenter];
        [Lable setText:ss];
        [Lable setBackgroundColor:[UIColor clearColor]];
        [Lable setTextColor:[UIColor darkGrayColor]];
        [Lable setFont:[UIFont systemFontOfSize:13.0]];
        [btn addSubview:Lable];
        

        
    }

}


#pragma mark- TableView Delegate and DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId =@"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell ==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    for(id v in cell.contentView.subviews) [v removeFromSuperview];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.backgroundColor  =[UIColor blackColor];
    cell.selectionStyle  =UITableViewCellSelectionStyleBlue;
    
    [self drawMenuSubViewWithFatherView:cell.contentView];
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 220);
    
    return cell;
    
}





#pragma mark-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
