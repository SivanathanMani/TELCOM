//
//  TELHelper.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "TELHelper.h"
#import "Constant.h"

@implementation TELHelper
/**
 To check given string is valid or not and it will return default string in case of null
 @param inputString
 @return valid string
 */
+(NSString *) checkValidString:(NSString*)inputString
{
    NSString * string = kTextNotAvailableMsg;
    if(inputString != nil && inputString != (id)[NSNull null] && [inputString length] != 0)
    {
        string = inputString;
    }
    
    return string;
}

/**
 To check given url is valid or not and it will return default local path in case of wrong url
 @param inputUrlString
 @param key
 @return valid url string
 */
+(NSString *) checkValidImageURL:(NSString*)inputUrlString index:(NSInteger)index
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:inputUrlString]];
    BOOL isValid = [NSURLConnection canHandleRequest:request];
    
    if(!isValid)
    {
        inputUrlString = [[NSBundle mainBundle] pathForResource:@"Placeholder" ofType:@"png"];
        inputUrlString = [NSString stringWithFormat:@"%li", (long)index];
    }
    return inputUrlString;
}


@end
