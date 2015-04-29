//
//  TELHomeOperation.h
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TELHomeOperation : NSObject

/**
 To get the shared object of TELHomeOperation
 */
+ (TELHomeOperation *)sharedManager;

/**
 To invoke request to get number of items from the server.
 This method will be called from Manager class.
 @param Type
 @param url
 @param params
 @param sender
 @return
 */
-(void) invokeRequestType:(NSString*)type serverURL:(NSString*)url params:(NSDictionary*)params sender:(id)sender;

/**
 To invoke request to download image from the server.
 This method will be called from Manager class.
 @param url
 @param sender
 @return
 */
-(void) invokeRequestToDownloadImageFromURL:(NSString*)url sender:(id)sender;
@end
