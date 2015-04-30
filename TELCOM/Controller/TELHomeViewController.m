//
//  TELHomeViewController.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "TELHomeViewController.h"
#import "TELHomeListTableViewCell.h"
#import "TELHomeDetailViewController.h"
#import "Constant.h"
#import "TELHomeManager.h"
#import "TELHelper.h"

@interface TELHomeViewController ()
{
    UIRefreshControl *refreshControl;
    BOOL isTableLoaded;
}
@property (nonatomic, strong) UITableView * tableViewHome;
@property (nonatomic, strong) NSMutableArray * mArrayItemList;

//For Lazy Loading
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isDecliring;
@end

@implementation TELHomeViewController
@synthesize tableViewHome;
@synthesize mArrayItemList;
@synthesize isDecliring;
@synthesize isDragging;

#pragma View controller - life cycle methods--------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = kScreenTitleHome;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    isTableLoaded = NO;
    
#if 0
    UIBarButtonItem * clearBarButton = [[UIBarButtonItem alloc] initWithTitle:kClearCacheText style:UIBarButtonItemStylePlain target:self action:@selector(clearCacheButtonAction:)];
    self.navigationItem.rightBarButtonItem = clearBarButton;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
#endif
    [self fetchAndReloadData];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(isTableLoaded)
    {
        if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft)
        {
            tableViewHome.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        }
        else
        {
            tableViewHome.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods---------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mArrayItemList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //For dynamic height
    CGSize size = [self descriptionHeight:[TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseDescKey]]];
    
    float fHeight = size.height;
    if(fHeight > 25)
    {
        fHeight = size.height + 45;
        NSLog(@"Max");
    }
    else
    {
        fHeight = kTableViewRowHeight;
        NSLog(@"LOW");
    }
    NSLog(@"Cell Height %f", size.height);
    return fHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"TELHomeListTableViewCell";
    TELHomeListTableViewCell * cell = (TELHomeListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[TELHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        tableViewHome.separatorColor = [UIColor blackColor];
    }
    
    cell.labelTitle.text = [TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseTitleKey]];
    UIFont * boldFont = [UIFont boldSystemFontOfSize:17.0f];
    UIColor * foregroundColor = [UIColor blueColor];
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, foregroundColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:cell.labelTitle.text attributes:attrs];
    [cell.labelTitle setAttributedText:attributedText];
    cell.labelDesc.text = [TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseDescKey]];

    //For Lazy Loading...
    cell.iconView.image = [UIImage imageNamed:@"Placeholder.png"];
    NSString * keyString = [TELHelper checkValidImageURL:[TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] valueForKey:kResponseIconKey]] index:indexPath.row];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:keyString])
    {
        NSData * data = [[NSUserDefaults standardUserDefaults] valueForKey:keyString];
        cell.iconView.image = [UIImage imageWithData:data];
    }
    else
    {
        if (!isDragging && !isDecliring && ([[NSUserDefaults standardUserDefaults] valueForKey:keyString] == nil))
        {
            [self downloadImageFromURL:keyString];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 0
    [self showHomeDetailsViewWithSelectedIndexPath:indexPath];
#endif
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDragging = NO;
    [tableViewHome reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isDecliring = NO;
    [tableViewHome reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDragging = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.isDecliring = YES;
}

#pragma Custom method implementation
/**
 To clear the cache data
 */
-(void) clearCacheButtonAction:(id)sender
{
    if(mArrayItemList != nil)
    {
        for(NSDictionary * item in mArrayItemList)
        {
            if(item != nil)
            {
                NSString * keyString = [item valueForKey:kResponseIconKey];
                if([[NSUserDefaults standardUserDefaults] objectForKey:keyString])
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyString];
                }
            }
        }
    }
}

/**
 To calculate the length of the given label text
 It will be used to calculate the height of the tableview cell.
 @param sender
 */
-(CGSize) descriptionHeight:(NSString*)text
{
    text =  [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    text =  [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    CGSize size = CGSizeMake(150, 1000);
    NSAttributedString * attributedText =
    [[NSAttributedString alloc] initWithString:text
     attributes:@
     {
     NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]
     }];
    CGRect rect = [attributedText boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    rect.size.height = rect.size.height;
    CGSize size1 = rect.size;
    
    return size1;
}


/**
 To display the ui components if we get item(s) successfully.
 This method will be called from requestWasSuccessfullWithResponse
 */
-(void) showHomeCustomUI
{
    [self hideActivityIndicator];
    isTableLoaded = YES;
    if([mArrayItemList count] != 0)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        if(tableViewHome != nil)
        {
            [tableViewHome removeFromSuperview];
            tableViewHome = nil;
        }
        self.tableViewHome = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableViewHome.frame = CGRectMake(self.view.frame.origin.x, kNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height);
        tableViewHome.dataSource = self;
        tableViewHome.delegate = self;
        tableViewHome.autoresizesSubviews = YES;
        tableViewHome.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.tableViewHome];
        
        [self showPullToRefreshView];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kScreenTitleMain message:kDataNotAvailableMessage delegate:nil cancelButtonTitle:kAlertCancelButtonText otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 To display the pull to refresh UI on top
 This method will be called when we pulled the tableview from top of the screen
 */
-(void) showPullToRefreshView
{
    UIView * refreshView = [[UIView alloc] initWithFrame:CGRectMake(kRefreshViewOrginX, kRefreshViewOrginY, kRefreshViewWidth, kRefreshViewHeight)];
    [self.tableViewHome insertSubview:refreshView atIndex:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(fetchAndReloadData) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:kPullTorefreshText];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];
}

/**
 To call the webservice to get multiple items as a JSON string
 From here we calling manager.
 */
-(void) fetchAndReloadData
{
    [self showActivityIndicator:@"Fetching..."];
    [[TELHomeManager sharedManager] sendRequestWithURL:kTELServiceURLForContent delegate:self params:nil];
}

/**
 To display the detail screen of the selected cell
 */
-(void) showHomeDetailsViewWithSelectedIndexPath:(NSIndexPath*)indexPath
{
    TELHomeDetailViewController * homeDetailViewController = [[TELHomeDetailViewController alloc] init];
    homeDetailViewController.stringTitle = [TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseTitleKey]];
    homeDetailViewController.stringDesc = [TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseDescKey]];
    NSData * data = [[NSUserDefaults standardUserDefaults] valueForKey:[TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseIconKey]]];
    homeDetailViewController.image = [UIImage imageWithData:data];
    [self.navigationController pushViewController:homeDetailViewController animated:YES];
}

/**
 To display the activity indicator
 */
-(void) showActivityIndicator:(NSString *)message
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/**
 To hide the activity indicator
 */
-(void) hideActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma Image downloading custom methods--------------------------------------------------
/**
 To call the webservice to download the image from the remote place.
 @param urlString
 */
-(void) downloadImageFromURL:(NSString *)urlString
{
    if([urlString hasPrefix:@"https://"] || [urlString hasPrefix:@"http://"])
    {
        [self showActivityIndicator:@"Downloading..."];
        [[TELHomeManager sharedManager] sendRequestWithURL:urlString key:urlString delegate:self params:nil];
    }
    else
    {
        UIImage * image = [UIImage imageNamed:@"Failed.png"];
        [self updateUIWithDownloadedImageKey:urlString value:image];
    }
}

/**
 To update the UI after getting the successful image data
 @param key
 @param image data
 */
-(void) updateUIWithDownloadedImageKey:(NSString*)key value:(UIImage*)image
{
    NSData * data = UIImagePNGRepresentation(image);
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideActivityIndicator];
        [tableViewHome reloadData];
    });
    
}

#pragma TELHomeViewDelegate methods--------------------------------------------------------
/**
 To handle success response which is having multiple list of items
 This method will be invoked by Manager
 @param array
 @return
 */
-(void) requestWasSuccessfullWithResponse:(NSDictionary*) dictItems
{
    NSArray * arrayItems = [dictItems objectForKey:kResponseKey];
    self.mArrayItemList = [[NSMutableArray alloc] initWithArray:arrayItems];
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.navigationItem.title = [dictItems objectForKey:kPageTitleKey];
        [self showHomeCustomUI];
    });
}

/**
 To handle failure response which is having error information
 This method will be invoked by Manager
 @param error string
 @return
 */
-(void) requestWasFailureWithErrorString:(NSString*) errorString
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self hideActivityIndicator];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kScreenTitleMain message:kRequestFailureMessage delegate:nil cancelButtonTitle:kAlertCancelButtonText otherButtonTitles:nil];
        [alert show];
    });
    
}

/**
 To handle success response which is having image data
 This method will be invoked by Manager
 @param data
 @param key
 @return
 */
-(void) imageDownloadSuccess:(NSData*)data key:(NSString*)key
{
    UIImage * image = [[UIImage alloc] initWithData:data];
    [self updateUIWithDownloadedImageKey:key value:image];
}

/**
 To handle failure response which is having error information
 This method will be invoked by Manager
 @param error string
 @param key
 @return
 */
-(void) imageDownloadFailure:(NSString*)errorString key:(NSString*)key
{
    UIImage * image = [UIImage imageNamed:@"Failed.png"];
    [self updateUIWithDownloadedImageKey:key value:image];
}

#pragma Interface orientation method-----------------------------------------------------
/**
 To handle interface orientation
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //Landscape into Portrait
    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        tableViewHome.frame = CGRectMake(self.view.frame.origin.x, kScreenOrginY, self.view.frame.size.width, self.view.frame.size.height);
    }
    else
    {
        tableViewHome.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }
}

@end
