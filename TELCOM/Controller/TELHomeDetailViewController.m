//
//  TELHomeDetailViewController.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "TELHomeDetailViewController.h"
#import "Constant.h"
#import "TELHelper.h"

@interface TELHomeDetailViewController ()
{
    UILabel * labelTitle;
    UITextView * textViewDesc;
    UIImageView * imageView;
    BOOL isTableLoaded;
}
@end

@implementation TELHomeDetailViewController
@synthesize stringTitle;
@synthesize stringDesc;
@synthesize image;

#pragma view controller - life cycle---------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = kScreenTitleDetails;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    isTableLoaded = NO;
    [self showDetailsCustomUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Custom method implementaion ----------------------
/**
 To display the details view UI components
 */
-(void) showDetailsCustomUI
{
    if([TELHelper checkValidString:stringTitle])
    {
        self.navigationItem.title = stringTitle;
    }
    
    UITableView * tableViewDetail = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableViewDetail.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    tableViewDetail.dataSource = self;
    tableViewDetail.delegate = self;
    tableViewDetail.autoresizesSubviews = YES;
    tableViewDetail.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(kHeaderViewOrginX, kHeaderViewOrginY, kHeaderViewWidth, kHeaderViewHeight)];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((headerView.frame.size.width - kDetailImageWidth)/2, kDetailImageOrginY, kDetailImageWidth, kDetailImageHeight)];
    imageView.autoresizesSubviews = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
    imageView.layer.cornerRadius = 10.0f;
    imageView.layer.borderWidth = 5.0f;
    imageView.layer.borderColor = [UIColor grayColor].CGColor;
    if(image != nil)
    {
       [imageView setImage:image];
    }
    
    [headerView addSubview:imageView];
    [tableViewDetail setTableHeaderView:headerView];
    [self.view addSubview:tableViewDetail];
}

#pragma mark - UITableViewDataSource Methods ----------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDetailTableRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"UITableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    textViewDesc = [[UITextView alloc] initWithFrame:CGRectMake(kDetailTextViewOrginX, kDetailDescOrginY, cell.contentView.frame.size.width , kDetailTableRowHeight)];
    textViewDesc.font = [UIFont systemFontOfSize:20.0f];
    textViewDesc.autoresizesSubviews = YES;
    textViewDesc.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [textViewDesc setScrollEnabled:NO];
    [cell.contentView addSubview:textViewDesc];
    
    if([TELHelper checkValidString:stringDesc])
    {
        textViewDesc.text = stringDesc;
    }
    else
    {
        textViewDesc.text = kDescriptionNotAvailableText;
    }

    return cell;
}

@end
