//
//  TELHomeDetailViewController.h
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TELHomeDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString * stringTitle;
@property (nonatomic, strong) NSString * stringDesc;
@property (nonatomic, strong) UIImage * image;
@end
