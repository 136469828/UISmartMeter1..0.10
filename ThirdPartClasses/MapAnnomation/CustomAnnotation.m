//
//  CustomAnnotation.m
//  Ministry of culture
//
//  Created by WeiJunheng on 14-5-13.
//  Copyright (c) 2014年 fengjing. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate, title, subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
	if (self = [super init]) {
		coordinate = coords;
	}
	return self;
}
@end