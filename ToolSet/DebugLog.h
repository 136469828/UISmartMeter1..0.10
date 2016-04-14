

//#ifdef DEBUG_MODE
//#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define DebugLog( s, ... ) 
//#endif

//  Created by RealTmac on 14-7-31.
//  Copyright (c) 2014年 RealTmac . All rights reserved.
//


#ifdef DEBUG_MODE

#define DEBUG_NSLOG(format, ...) NSLog(format, ## __VA_ARGS__)
#define MCRelease(x) [x release]

#else

#define DEBUG_NSLOG(format, ...)
#define MCRelease(x) [x release], x = nil

#endif