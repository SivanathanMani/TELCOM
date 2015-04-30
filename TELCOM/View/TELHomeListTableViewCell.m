//
//  TELHomeListTableViewCell.m
//  TELCOM
//
//  Created by Admin on 28/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "TELHomeListTableViewCell.h"
#import "Constant.h"
@implementation TELHomeListTableViewCell
@synthesize labelTitle;
@synthesize labelDesc;
@synthesize iconView;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(kCellTitleOrginX, kCellTitleOrginX, kCellTitleSizeWidth, kCellTitleSizeHeight)];
        labelTitle.autoresizesSubviews = YES;
        labelTitle.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.numberOfLines = 1;
        labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [labelTitle setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [self.contentView addSubview:labelTitle];
        
        self.labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(labelTitle.frame.origin.x, labelTitle.frame.origin.y + labelTitle.frame.size.height + kCellTopSpaceForDesc, self.frame.size.width - (kCellImageSizeWith + (kCellTopSpaceForDesc * 2)), self.frame.size.height - (labelTitle.frame.origin.y + labelTitle.frame.size.height + kCellTopSpaceForDesc))];
        labelDesc.autoresizesSubviews = YES;
        labelDesc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        labelDesc.textAlignment = NSTextAlignmentLeft;
        labelDesc.numberOfLines = 0;
        labelDesc.font = [UIFont systemFontOfSize:17.0f];
        labelDesc.lineBreakMode = NSLineBreakByWordWrapping;
        labelDesc.textColor = [UIColor blackColor];
        [self.contentView addSubview:labelDesc];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - (kCellImageSizeWith + kCellTopSpaceForDesc) , (self.frame.size.height - kCellImageSizeHeight)/2, kCellImageSizeWith, kCellImageSizeHeight)];
        iconView.layer.cornerRadius = 5.0f;
        iconView.layer.borderWidth = 2.0f;
        iconView.layer.borderColor = [UIColor blackColor].CGColor;
        iconView.autoresizesSubviews = YES;
        iconView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:iconView];
    }
    return  self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
