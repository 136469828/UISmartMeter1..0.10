//
//  RandomUtils.m
//  Calculation24
//
//  Created by yangxi zou on 11-3-27.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//
/*
1 随机数的使用

头文件的引用
#import <time.h>
#import <mach/mach_time.h>

srandom()的使用
srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));

直接使用 random() 来调用随机数
 
 srand(time(NULL));
 rand();
 
 random();
 
 arc4random();
 
 */


#import "RandomUtils.h"


@implementation RandomUtils

+(int)randomInt:(int)start offset:(int)offset
{
	return start+abs(arc4random()%offset);
}

+(int)randomNum:(int)yz
{
	int cx=arc4random();
	if (cx>0) {
		return cx%yz; 
	}else {
		return 0;
	}

}
+(NSMutableArray*)randomArray:(int)start end:(int)end
{
	//rand() % 1000;
	//NSLog(@"1;%d",rand() % 1000);
	
	int c = end-start;
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:c];
	
	int count;
	for(count = 0; count <= c; count ++)
	{
		[array addObject:[NSNumber numberWithInt:start+count]];
		//dlog(@"%d",start+count);
	}
	for(count = 0; count <= c; count ++)
	{
		//srand(time(NULL));
		//int position = arc4random()%c;//
		int position1 =[self randomNum:c];
		//NSLog(@"a:%d b:%d",count,position1);
		//NSLog(@"2;%d",position1);
		[array exchangeObjectAtIndex:count withObjectAtIndex: position1];
	}
	/**/
	for(count = 0; count <= c; count ++)
	{
		//srand(time(NULL));
		int position = [self randomNum:c];//arc4random()%c;
		//int position1 = arc4random()%c;
		//NSLog(@"1;%d",position);
		//NSLog(@"2;%d",position1);
		[array exchangeObjectAtIndex:count withObjectAtIndex: position];
	}
	for(count = 0; count <= c; count ++)
	{
		int position = arc4random()%c;
		[array exchangeObjectAtIndex:count withObjectAtIndex: position];
	}
	int position =[self randomNum:c];// rand()%c 
	[array exchangeObjectAtIndex:(end-1) withObjectAtIndex: position];
	/*
	for(count = 0; count <= c; count ++)
	{
		NSLog(@"%d",[[array objectAtIndex:count] intValue]);
	}*/
	NSMutableArray *na = [NSMutableArray arrayWithArray:array];
	[array release];
	return na;
}

@end
