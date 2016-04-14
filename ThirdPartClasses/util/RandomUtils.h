//
//  RandomUtils.h
//  Calculation24
//
//  Created by yangxi zou on 11-3-27.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RandomUtils : NSObject {

}

//产生随机数组
+(NSMutableArray*)randomArray:(int)start end:(int)end;
//产生随机整数
+(int)randomInt:(int)start offset:(int)offset;

@end
