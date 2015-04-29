//
//  TELNetworkManager.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "TELNetworkManager.h"
#import "SystemConfiguration/SCNetworkReachability.h"

@implementation TELNetworkManager
/**
 To get shared network manager
 */
+ (TELNetworkManager *)sharedManager
{
    static TELNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TELNetworkManager new];
    });
    return instance;
}

/**
 To get the status of the network availability
 */
-(BOOL) isInternetAvailable
{
    BOOL isNetworkAvailable = NO;
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    
    isNetworkAvailable = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
   return isNetworkAvailable;
}
@end
