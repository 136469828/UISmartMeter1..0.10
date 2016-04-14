//
//  NSDictionary+Helpers.m
//  newstock
//
//  Created by yangxi zou on 11-1-3.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import "NSDictionary+Helpers.h"


@implementation NSDictionary(Helpers) 

- (NSArray *)allsordtedKeys
{
	//NSArray *myKeys = ;
	NSArray *sortedKeys = [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	return sortedKeys;
}

- (int)countAll
{
	int x=0;
	for (int i=0;i<[self count];i++) {
		x=x+[[[self allValues] objectAtIndex:i] count];
	}
	return x;
}

@end
