//
//  TELNetworkManager.h
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TELNetworkManager : NSObject

/**
 To get shared network manager
 */
+ (TELNetworkManager *)sharedManager;

/**
 To get the status of the network availability
 */
-(BOOL) isInternetAvailable;
@end
