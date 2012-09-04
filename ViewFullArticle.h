//
//  ViewFullArticle.h
//  WaveNews
//
//  Created by GUYU XUE on 19/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFullArticle : UIViewController <UIWebViewDelegate>
{
    NSDictionary *newsInfo;
    NSString *fullContent;
    
    IBOutlet UIScrollView *displayView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *label1;
    // UILabel *label2;
    IBOutlet UIImageView *articleSource;
    IBOutlet UIWebView *fullArticle;
    IBOutlet UIImageView *articleImage;
}

@property (nonatomic, retain) NSDictionary *newsInfo;
@property (nonatomic, retain) NSString *fullContent;

@property (nonatomic, retain) UIScrollView *displayView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *label1;
//@property (nonatomic, retain) UILabel *label2;
@property (nonatomic, retain) UIImageView *articleSource;
@property (nonatomic, retain) UIWebView *fullArticle;
@property (nonatomic, retain) UIImageView *articleImage;

-(void)configureViewPortrait;
-(void)configureViewRotate;
-(void)configureView;

@end
