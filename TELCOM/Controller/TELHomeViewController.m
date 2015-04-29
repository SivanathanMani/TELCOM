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
@property (nonatomic, strong) NSMutableDictionary * mDictionary;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isDecliring;
@end

@implementation TELHomeViewController
@synthesize tableViewHome;
@synthesize mArrayItemList;
@synthesize mDictionary;
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
    return kTableViewRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"TELHomeListTableViewCell";
    TELHomeListTableViewCell * cell = (TELHomeListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[TELHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.labelTitle.text = [TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseTitleKey]];
    UIFont * boldFont = [UIFont boldSystemFontOfSize:17.0f];
    UIColor * foregroundColor = [UIColor blackColor];
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, foregroundColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:cell.labelTitle.text attributes:attrs];
    [cell.labelTitle setAttributedText:attributedText];
    cell.labelDesc.text = [TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseDescKey]];
    
    //For dynamic height
    //CGSize size = [self descriptionHeight:cell.labelDesc];
    //NSLog(@"Cell Height %f", size.height);
    
    //For Lazy Loading...
    cell.iconView.image=[UIImage imageNamed:@"Placeholder.png"];
    NSString * keyString = [TELHelper checkValidImageURL:[TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] valueForKey:kResponseIconKey]] index:indexPath.row];
    
    if ([mDictionary valueForKey:keyString])
    {
        cell.iconView.image = [mDictionary valueForKey:keyString];
    }
    else
    {
        if (!isDragging && !isDecliring)
        {
            [self downloadImageFromURL:keyString];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showHomeDetailsViewWithSelectedIndexPath:indexPath];
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
 To calculate the length of the given label text
 It will be used to calculate the height of the tableview cell.
 @param sender
 */
-(CGSize) descriptionHeight:(id)sender
{
    UILabel * label = (UILabel*)sender;
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:label.text
     attributes:@
     {
     NSFontAttributeName:label.font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize)
    {
        label.frame.size.width, CGFLOAT_MAX
    }
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    rect.size.height = rect.size.height / 20;
    CGSize size = rect.size;
    
    return size;
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
    homeDetailViewController.image = [mDictionary valueForKey:[TELHelper checkValidString:[[mArrayItemList objectAtIndex:indexPath.row] objectForKey:kResponseIconKey]]];
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
    [self showActivityIndicator:@"Downloading..."];
    
    if([urlString hasPrefix:@"https://"] || [urlString hasPrefix:@"http://"])
    {
        [[TELHomeManager sharedManager] sendRequestWithURL:urlString key:urlString delegate:self params:nil];
    }
}

/**
 To update the UI after getting the successful image data
 @param key
 @param image data
 */
-(void) updateUIWithDownloadedImageKey:(NSString*)key value:(UIImage*)image
{
    [mDictionary setObject:image forKey:key];
    dispatch_sync(dispatch_get_main_queue(), ^{
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
-(void) requestWasSuccessfullWithResponse:(NSArray*) array
{
    self.mArrayItemList = [[NSMutableArray alloc] initWithArray:array];
    self.mDictionary = [[NSMutableDictionary alloc] init];
    [self performSelectorOnMainThread:@selector(showHomeCustomUI) withObject:nil waitUntilDone:YES];
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
        [self.navigationController popViewControllerAnimated:YES];
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
    [mDictionary setObject:image forKey:key];
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
    UIImage * image = [UIImage imageNamed:@"Placeholder.png"];
    [mDictionary setObject:image forKey:key];
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
