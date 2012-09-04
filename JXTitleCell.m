//
//  JXTitleCell.m
//  WaveNews
//
//  Created by GUYU XUE on 12/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import "JXTitleCell.h"

@implementation JXTitleCell

@synthesize articleDate;
@synthesize articleImage;
@synthesize articleTitle;
@synthesize articleAuthor;
@synthesize myAccessory;
@synthesize viewFullButton;

#pragma mark - view life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{
    [articleImage release];
    [articleTitle release];
    [articleDate release];
    [articleAuthor release];
    [myAccessory release];
    [viewFullButton release];
    [super dealloc];
}

#pragma mark - other predefined
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
