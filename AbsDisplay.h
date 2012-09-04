//
//  AbsDisplay.h
//  WaveNews
//
//  Created by GUYU XUE on 12/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@class SaveAndShare;
@class WebViewFullArticle;
@class HTMLParser;
//@class ViewFullArticle;
@class JXTitleCell;
@class JXAbsCell;
@class JXActivityIndicatorView;
@class ViewController;

@interface AbsDisplay : UITableViewController <UIWebViewDelegate>
{
    NSMutableDictionary *newsInfo;
    
    //views
    JXTitleCell *titleCell;
    JXAbsCell *absCell;
    
    SaveAndShare *saveAndSharePanel;
    WebViewFullArticle *newsDisplay;
    //ViewFullArticle *fullArticleView;
    
    JXActivityIndicatorView *myActIndicator;
}

@property (nonatomic, retain) NSMutableDictionary *newsInfo;
@property (nonatomic, retain) SaveAndShare *saveAndSharePanel;
@property (nonatomic, retain) WebViewFullArticle *newsDisplay;
//@property (nonatomic, retain) ViewFullArticle *fullArticleView;
@property (nonatomic, retain) JXTitleCell *titleCell;
@property (nonatomic, retain) JXAbsCell *absCell;
@property (nonatomic, retain) JXActivityIndicatorView *myActIndicator;
@property (nonatomic, retain) ViewController *viewController;

-(void)configureViewPortrait;
-(void)configureViewRotate;
- (void)backToPrevPage;


-(IBAction) viewFullArticle:(id) sender;

@end
