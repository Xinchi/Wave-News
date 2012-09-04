//
//  JXTitleCell.h
//  WaveNews
//
//  Created by GUYU XUE on 12/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXTitleCell : UITableViewCell
{
    IBOutlet UITextView *articleTitle;
    IBOutlet UILabel *articleAuthor;
    IBOutlet UILabel *articleDate;
    IBOutlet UIImageView *articleImage;
    IBOutlet UIImageView *myAccessory;
    
    IBOutlet UIButton *viewFullButton;
}

@property (nonatomic, retain) UITextView *articleTitle;
@property (nonatomic, retain) UILabel *articleAuthor;
@property (nonatomic, retain) UILabel *articleDate;
@property (nonatomic, retain) UIImageView *articleImage;
@property (nonatomic, retain) UIImageView *myAccessory;
@property (nonatomic, retain) UIButton *viewFullButton;

@end
