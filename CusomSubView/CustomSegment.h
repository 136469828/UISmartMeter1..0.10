//
//  CustomSegment.h
//  UIMobileBook
//
//  Created by Zhou Liang on 12-11-19.
//  Copyright (c) 2012年 new yulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegment : UISegmentedControl
{
    CGFloat arrowSize;
    NSMutableArray *_items;
    UIView *_selectedStainView;
}

@property (strong, nonatomic) NSMutableArray *_items;
@property (strong, nonatomic) UIView *_selectedStainView;

@property (assign, nonatomic) CGFloat arrowSize;

@end
