//
//  JingDianMapCell.m
//  fengjingIOSnew
//
//  Created by Xu Guo on 12/4/12.
//
//


#import "JingDianMapCell.h"
#import "Util.h"

@implementation JingDianMapCell
@synthesize scenicimge;
@synthesize myNote;
@synthesize myOnlyNote;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *img = [Util setCustomImage:@"zujibgList" andExt:@"jpg"];
        self.scenicimge.image = img;
        self.scenicimge.placeholderImage = img;
        myNote.editable = NO;
        myOnlyNote.editable = NO;
        
        
    }
    return self;
}

-(void)dealloc
{
    [scenicimge release],scenicimge = nil;
    [myNote release],myNote = nil;
    [myOnlyNote release],myOnlyNote = nil;
    [super dealloc];
}

@end
