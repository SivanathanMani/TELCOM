//
//  TELHomeOperation.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "TELHomeOperation.h"
#import "Constant.h"
#import "TELHomeManager.h"

@interface TELHomeOperation ()
{
    NSTimer * timer;
}
@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, strong) id manager;
@end

@class HomeManagerDelegate;
@implementation TELHomeOperation
@synthesize manager;

/**
 To get the shared object of TELHomeOperation
 */
+ (TELHomeOperation *)sharedManager
{
    static TELHomeOperation *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TELHomeOperation new];
    });
    return instance;
}

/**
 To invoke request to get number of items from the server.
 This method will be called from Manager class.
 @param Type
 @param url
 @param params
 @param sender
 @return
 */
-(void) invokeRequestType:(NSString*)type serverURL:(NSString*)url params:(NSDictionary*)params sender:(id)sender
{
    self.manager = sender;
    NSURLRequest *request = [[NSURLRequest alloc]
                             initWithURL: [NSURL URLWithString:url]
                             cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                             timeoutInterval: 30
                             ];
    self.receivedData = [[NSMutableData alloc] init];
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
     {
         [self.receivedData appendData:data];
         NSHTTPURLResponse * receivedResponse = (NSHTTPURLResponse*)response;
         
         if(receivedResponse.statusCode == 200)
         {
             NSString * jsonString = [[NSString alloc] initWithData:self.receivedData encoding:NSASCIIStringEncoding];
             NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary * dictItems = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             [self requestWasSuccessfulWithResponse:dictItems];
         }
         else
         {
             [self requestWasFailureWithError:error.description];
         }
     }];
    
}

/**
 To handle success part of respone
 @param arrayResponse
 */
-(void) requestWasSuccessfulWithResponse:(NSDictionary *)dictItems
{
    id <HomeManagerDelegate> delegate = self.manager;
    if([delegate respondsToSelector:@selector(requestWasSuccessWithResponse:)])
    {
        [delegate requestWasSuccessWithResponse:dictItems];
    }
}

/**
 To handle failure part of response
 @param errorString
 */
-(void) requestWasFailureWithError:(NSString *)errorString
{
    id <HomeManagerDelegate> delegate = self.manager;
    if([delegate respondsToSelector:@selector(requestWasFailureWithError:)])
    {
        [delegate requestWasFailureWithError:errorString];
    }
    
}

/**
 To invoke request to download image from the server.
 This method will be called from Manager class.
 @param url
 @param sender
 @return
 */
-(void) invokeRequestToDownloadImageFromURL:(NSString*)url sender:(id)sender
{
    self.manager = sender;
        
    NSURLRequest *request = [[NSURLRequest alloc]
                             initWithURL: [NSURL URLWithString:url]
                             cachePolicy: NSURLRequestReloadRevalidatingCacheData
                             timeoutInterval:kTimeOutSeconds
                             ];
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
     {
         NSHTTPURLResponse * receivedResponse = (NSHTTPURLResponse*)response;
         
         if(receivedResponse.statusCode == 200)
         {
             [self imageDownloadSuccessData:data key:url];
         }
         else
         {
             [self imageDownloadFailure:error.description key:url];
         }
     }];
}

/**
 To handle success part of respone
 @param arrayResponse
 */
-(void) imageDownloadSuccessData:(NSData*)data key:(NSString*)key
{
    id <HomeManagerDelegate> delegate = self.manager;
    if([delegate respondsToSelector:@selector(imageDownloadSuccess:key:)])
    {
        [delegate imageDownloadSuccess:data key:key];
    }
}

/**
 To handle failure part of response
 @param errorString
 */
-(void) imageDownloadFailure:(NSString*)errorString key:(NSString *)key
{
    id <HomeManagerDelegate> delegate = self.manager;
    if([delegate respondsToSelector:@selector(imageDownloadFailure:key:)])
    {
        [delegate imageDownloadFailure:errorString key:key];
    }
}

@end
