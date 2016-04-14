//
//  JingDianMapCell.h
//  fengjingIOSnew
//
//  Created by Xu Guo on 12/4/12.
//
//

#import <UIKit/UIKit.h>
#import "EGOCache.h"
#import "EGOImageView.h"

@interface JingDianMapCell : UIView
{
    //UIImageView *scenicimge;
    EGOImageView *scenicimge;
    UITextView *myNote;
    UITextView *myOnlyNote;
}

@property (retain, nonatomic) IBOutlet EGOImageView *scenicimge;//UIImageView *scenicimge;
@property (retain, nonatomic) IBOutlet UITextView *myNote;
@property (retain, nonatomic) IBOutlet UITextView *myOnlyNote;
@end
