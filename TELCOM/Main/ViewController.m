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
    self.title = kScreenTitleMain;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self showProficiencyButton];
    
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
-(void) showProficiencyButton
{
    UIButton * buttonExcercise = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonExcercise setFrame:CGRectMake((self.view.frame.size.width - kHomeButtonSizeWidth)/2, (self.view.frame.size.height - kHomeButtonSizeHeight)/2, kHomeButtonSizeWidth, kHomeButtonSizeHeight)];
    buttonExcercise.autoresizesSubviews = YES;
    buttonExcercise.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    buttonExcercise.layer.cornerRadius = 5.0f;
    [buttonExcercise setBackgroundColor:[UIColor brownColor]];
    [buttonExcercise setTitle:kProficiencyText forState:UIControlStateNormal];
    [buttonExcercise addTarget:self action:@selector(showHomeTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonExcercise];
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
