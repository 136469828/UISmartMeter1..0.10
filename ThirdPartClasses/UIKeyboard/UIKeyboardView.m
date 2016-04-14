//
//  UIKeyboardView.m
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardView.h"

@implementation UIKeyboardView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:frame];
		
		//keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
		
        if(IS_IOS_7)
        {
            keyboardToolbar.barTintColor = [UIColor whiteColor];
        }
        else
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
                
                //iOS 5
                UIImage *toolBarIMG = [UIImage imageNamed: @"BoutiqueImage_bottom.png"];
                
                if ([keyboardToolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
                    [keyboardToolbar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
                }
                
            } else {
                
                //iOS 4
                [keyboardToolbar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BoutiqueImage_bottom.png"]] autorelease] atIndex:0];
            }
        }
        
        
		UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"前一项", @"")
																			style:UIBarButtonItemStyleBordered
																		   target:self
																		   action:@selector(toolbarButtonTap:)];
		previousBarItem.tag=1;
		
		UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"后一项", @"")
																		style:UIBarButtonItemStyleBordered
																	   target:self
																	   action:@selector(toolbarButtonTap:)];
		nextBarItem.tag=2;
		
		UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					  target:nil
																					  action:nil];
		
		UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"")
																		style:UIBarButtonItemStyleDone
																	   target:self
																	   action:@selector(toolbarButtonTap:)];
		doneBarItem.tag=3;
		
		[keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
		[previousBarItem release];
		[nextBarItem release];
		[spaceBarItem release];
		[doneBarItem release];
		[self addSubview:keyboardToolbar];
		[keyboardToolbar release];
    }
    return self;
}

- (void)toolbarButtonTap:(UIButton *)button {
	if ([self.delegate respondsToSelector:@selector(toolbarButtonTap:)]) {
		[self.delegate toolbarButtonTap:button];
	}
}

@end

@implementation UIKeyboardView (UIKeyboardViewAction)

//根据index找出对应的UIBarButtonItem
- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex {
	if (itemIndex < [[keyboardToolbar items] count]) {
		return [[keyboardToolbar items] objectAtIndex:itemIndex];
	}
	return nil;
}

@end
