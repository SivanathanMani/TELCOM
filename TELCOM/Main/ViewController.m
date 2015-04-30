//
//  ViewController.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "TELHomeViewController.h"
#import "TELNetworkManager.h"

@interface ViewController ()
@end

@implementation ViewController

#pragma View controller - life cycle ---------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"";
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
#if SPLASH_SCREEN_ENABLED
    [self showLoadingScreen];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Custom methods ------------------------------------------------------------

/**
 To display the button to push the Home screen
 */
-(void) showLoadingScreen
{
    
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kSplashTitleWidth)/2, (self.view.frame.size.height - kSplashTitleHeight)/2, kSplashTitleWidth, kSplashTitleHeight)];
    labelTitle.text = kScreenTitleMain;
    labelTitle.autoresizesSubviews = YES;
    labelTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.numberOfLines = 1;
    labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labelTitle.textColor = [UIColor blueColor];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:22.0f]];
    [self.view addSubview:labelTitle];
    
    UILabel * labelDesc = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kSplashDescWidth)/2, self.view.frame.size.height - kSplashDescHeight, kSplashDescWidth, kSplashDescHeight)];
    labelDesc.text = kCopyRightsText;
    labelDesc.autoresizesSubviews = YES;
    labelDesc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    labelDesc.textAlignment = NSTextAlignmentCenter;
    labelDesc.numberOfLines = 1;
    labelDesc.font = [UIFont systemFontOfSize:15.0f];
    labelDesc.lineBreakMode = NSLineBreakByWordWrapping;
    labelDesc.textColor = [UIColor blueColor];
    [self.view addSubview:labelDesc];
}

/**
 To dispaly the Home table view
 We are using the tableview to display the items
 @param sender
 */
-(void) showHomeTableView:(id)sender
{
    if([[TELNetworkManager sharedManager] isInternetAvailable])
    {
        TELHomeViewController * homeViewController = [[TELHomeViewController alloc] init];
        [self.navigationController pushViewController:homeViewController animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kScreenTitleMain message:kNetworkConnectionLostMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

@end
