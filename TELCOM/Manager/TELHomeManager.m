//
//  TELHomeManager.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "TELHomeManager.h"
#import "TELHomeOperation.h"
#import "TELHomeViewController.h"

@interface TELHomeManager()

@property (nonatomic, strong) id controller;
@end

@class TELHomeViewDelegate;
@implementation TELHomeManager
@synthesize controller;

/**
 To get shared instance of TELHomeManager
 */
+ (TELHomeManager *)sharedManager
{
    static TELHomeManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TELHomeManager new];
    });
    return instance;
}

/**
 To invoke request to get list items
 This method will be called from view controller
 @param url string
 @param sender
 @param params
 */
-(void) sendRequestWithURL:(NSString*)url delegate:(id)sender params:(NSDictionary*)params
{
    self.controller = sender;
    
    [[TELHomeOperation sharedManager] invokeRequestType:@"GET" serverURL:url params:nil sender:self];
}

/**
 To invoke request to download image
 This method will be called from view controller into the manager class
 @param url string
 @param key
 @param sender
 @param params
 */
-(void) sendRequestWithURL:(NSString*)url key:(NSString*)key delegate:(id)sender params:(NSDictionary*)params
{
    self.controller = sender;
    [[TELHomeOperation sharedManager] invokeRequestToDownloadImageFromURL:url sender:self];
}

#pragma HomeManagerDelegate methods--------------------------------------
/**
 To handle success response which is having multiple list of items
 This method will be invoked by operation class
 @param array
 @return
 */
-(void) requestWasSuccessWithResponse:(NSArray*) array
{
    id <TELHomeViewDelegate> delegate = self.controller;
    if([delegate respondsToSelector:@selector(requestWasSuccessfullWithResponse:)])
    {
        [delegate requestWasSuccessfullWithResponse:array];
    }
}

/**
 To handle failure response which is having error information
 This method will be invoked by operation class
 @param error string
 @return
 */
-(void) requestWasFailureWithError:(NSString*) errorString
{
    id <TELHomeViewDelegate> delegate = self.controller;
    if([delegate respondsToSelector:@selector(requestWasFailureWithErrorString:)])
    {
        [delegate requestWasFailureWithErrorString:errorString];
    }
}

/**
 To handle success response which is having image data
 This method will be invoked by operation class
 @param data
 @param key
 @return
 */
-(void) imageDownloadSuccess:(NSData*)data key:(NSString*)key
{
    id <TELHomeViewDelegate> delegate = self.controller;
    if([delegate respondsToSelector:@selector(imageDownloadSuccess:key:)])
    {
        [delegate imageDownloadSuccess:data key:key];
    }
}

/**
 To handle failure response which is having error information
 This method will be invoked by operation class
 @param error string
 @param key
 @return
 */
-(void) imageDownloadFailure:(NSString*)errorString key:(NSString*)key
{
    id <TELHomeViewDelegate> delegate = self.controller;
    if([delegate respondsToSelector:@selector(imageDownloadFailure:key:)])
    {
        [delegate imageDownloadFailure:errorString key:key];
    }
}

@end
