//
//  UIDevice-Reachability.h
//  FengjingIOS
//
//  Created by zhao yang on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  this class is test the network is available or not 

#import <UIKit/UIKit.h>

@protocol ReachabilityWatcher <NSObject>
- (void) reachabilityChanged;
@end

@interface UIDevice (Reachability)
+ (NSString *) stringFromAddress: (const struct sockaddr *) address;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;

+ (NSString *) hostname;
+ (NSString *) getIPAddressForHost: (NSString *) theHost;
+ (NSString *) localIPAddress;
+ (NSString *) localWiFiIPAddress;
+ (NSString *) whatismyipdotcom;

+ (BOOL) hostAvailable: (NSString *) theHost;
+ (BOOL) networkAvailable;
+ (BOOL) activeWLAN;
+ (BOOL) activeWWAN;
+ (BOOL) performWiFiCheck;

+ (BOOL) scheduleReachabilityWatcher: (id) watcher;
+ (void) unscheduleReachabilityWatcher;
@end