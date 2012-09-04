//
//  JXAbsCell.m
//  WaveNews
//
//  Created by GUYU XUE on 12/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import "JXAbsCell.h"

@implementation JXAbsCell

@synthesize displayView;
@synthesize absView;
@synthesize absImage;

#pragma mark - view life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) dealloc
{
    [absView release];
    [absImage release];
    [super dealloc];
}

#pragma mark - other prefined method
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
