//
//  TELHelper.h
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TELHelper : NSObject

/**
 To check given string is valid or not and it will return default string in case of null
 @param inputString
 @return valid string
 */
+(NSString *) checkValidString:(NSString*)inputString;

/**
 To check given url is valid or not and it will return default local path in case of wrong url
 @param inputUrlString
 @param key
 @return valid url string
 */
+(NSString *) checkValidImageURL:(NSString*)inputUrlString index:(NSInteger)index;

@end
