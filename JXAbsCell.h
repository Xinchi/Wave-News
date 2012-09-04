//
//  JXAbsCell.h
//  WaveNews
//
//  Created by GUYU XUE on 12/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXAbsCell : UITableViewCell <UIWebViewDelegate>
{
    IBOutlet UIScrollView *displayView;
    
    IBOutlet UIWebView *absView;
    IBOutlet UIImageView *absImage;
}

@property (nonatomic, retain) UIScrollView *displayView;
@property (nonatomic, retain) UIWebView *absView;
@property (nonatomic, retain) UIImageView *absImage;

@end
