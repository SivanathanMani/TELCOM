//
//  Constant.h
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#ifndef TELCOM_Constant_h
#define TELCOM_Constant_h

#pragma URL Constants ###########################################
#define kTELServiceURLForContent   @"https://dl.dropboxusercontent.com/u/746330/facts.json"

#pragma Application Feature Constants ###########################################
/**
 To clear the cache image data which are alreay stored and call the service to get all the images again.
 */
#define CLEAR_CACHE_ENABLED     0

/**
 To display the spalsh screen
 Note: Splash screen manualy we created and this is not default one.
 */
#define SPLASH_SCREEN_ENABLED   1

/**
 To diaplay the details screen
 */
#define DETAIL_SCREEN_ENABLED   0

#pragma Number Constants ###########################################
#define kHomeButtonSizeWidth    200
#define kHomeButtonSizeHeight   50
#define kNavigationBarHeight    64
#define kCellTitleOrginX        5
#define kCellTitleOrginY        5
#define kCellTitleSizeWidth     300
#define kCellTitleSizeHeight    30

#define kCellImageSizeWith      80
#define kCellImageSizeHeight    80

#define kCellDescSizeHeight     100
#define kCellTopSpaceForDesc    10

#define kCellTopSpaceForIcon    50

#define kTableViewRowHeight     100
#define kTableViewRowMin         25
#define kTableViewRowSpace       45

#define kRefreshViewOrginX      0
#define kRefreshViewOrginY      55
#define kRefreshViewHeight      0
#define kRefreshViewWidth       0

#define kDetailImageOrginY      50
#define kDetailImageWidth       200
#define kDetailImageHeight      200
#define kDetailDescOrginY       300

#define kDetailTextViewOrginX   0
#define kDetailTextViewOrginY   0
#define kDetailTextViewWidth    300
#define kDetailTextViewHeight   200
#define kDetailTextViewTopSpace 50

#define kHeaderViewOrginX       0
#define kHeaderViewOrginY       0
#define kHeaderViewWidth        0
#define kHeaderViewHeight       0

#define kScreenOrginY           0

#define kDetailTableRowHeight   400

#define kTimeOutSeconds         10

#define kSplashTitleWidth       300
#define kSplashTitleHeight      50

#define kSplashDescWidth       300
#define kSplashDescHeight      50

#pragma String Constants ###########################################
#define kProficiencyText            @"See My Proficiency"
#define kScreenTitleMain            @"TELCOM"
#define kCopyRightsText             @"Copyright (c) 2015 CTS. All rights reserved."
#define kScreenTitleHome            @"Home"
#define kScreenTitleDetails         @"Details"
#define kNetworkConnectionLostMsg   @"Network Connection Lost and Please Try Later!"

#define kPageTitleKey               @"title"
#define kResponseKey                @"rows"
#define kResponseTitleKey           @"title"
#define kResponseDescKey            @"description"
#define kResponseIconKey            @"imageHref"

#define kTextNotAvailableMsg        @"Not Available"
#define kAlertCancelButtonText      @"Ok"
#define kRequestFailureMessage      @"The request has been failure and Please try again later."
#define kDataNotAvailableMessage    @"Data is not available and Try again later."
#define kPullTorefreshText          @"Pull To Refresh"
#define kDescriptionNotAvailableText @"Description is not available."

#define kClearCacheText             @"Clear Cache"

#endif
