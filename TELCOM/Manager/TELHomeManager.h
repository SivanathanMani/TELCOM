//
//  TELHomeManager.h
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeManagerDelegate <NSObject>

@required
/**
 To handle success response which is having multiple list of items
 This method will be invoked by operation class
 @param dictionary
 @return
 */
-(void) requestWasSuccessWithResponse:(NSDictionary*) dictItems;

/**
 To handle failure response which is having error information
 This method will be invoked by operation class
 @param error string
 @return
 */
-(void) requestWasFailureWithError:(NSString*) errorString;

/**
 To handle success response which is having image data
 This method will be invoked by operation class
 @param data
 @param key
 @return
 */
-(void) imageDownloadSuccess:(NSData*)data key:(NSString*)key;

/**
 To handle failure response which is having error information
 This method will be invoked by operation class
 @param error string
 @param key
 @return
 */
-(void) imageDownloadFailure:(NSString*)errorString key:(NSString*)key;
@end


@interface TELHomeManager : NSObject<HomeManagerDelegate>

/**
 To get shared instance of TELHomeManager
 */
+ (TELHomeManager *)sharedManager;

/**
 To invoke request to get list items
 This method will be called from view controller
 @param url string
 @param sender
 @param params
 */
-(void) sendRequestWithURL:(NSString*)url delegate:(id)sender params:(NSDictionary*)params;

/**
 To invoke request to download image
 This method will be called from view controller into the manager class
 @param url string
 @param key
 @param sender
 @param params
 */
-(void) sendRequestWithURL:(NSString*)url key:(NSString*)key delegate:(id)sender params:(NSDictionary*)params;

@end
