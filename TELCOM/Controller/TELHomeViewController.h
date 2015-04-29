//
//  TELHomeViewController.h
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TELHomeViewDelegate <NSObject>

@required
/**
 To handle success response which is having multiple list of items
 This method will be invoked by Manager
 @param array
 @return
 */
-(void) requestWasSuccessfullWithResponse:(NSArray*) array;

/**
 To handle failure response which is having error information
 This method will be invoked by Manager
 @param error string
 @return
 */
-(void) requestWasFailureWithErrorString:(NSString*) errorString;

/**
 To handle success response which is having image data
 This method will be invoked by Manager
 @param data
 @param key
 @return
 */
-(void) imageDownloadSuccess:(NSData*)data key:(NSString*)key;

/**
 To handle failure response which is having error information
 This method will be invoked by Manager
 @param error string
 @param key
 @return
 */
-(void) imageDownloadFailure:(NSString*)errorString key:(NSString*)key;
@end

@interface TELHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TELHomeViewDelegate>

@end
