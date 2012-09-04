//
//  WebViewFullArticle.h
//  RSSReader
//
//  Created by GUYU XUE on 22/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import "AbsDisplay.h"

@class JXActivityIndicatorView;

@interface WebViewFullArticle : UIViewController <UIWebViewDelegate, UIActionSheetDelegate,FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
{
    NSString *urlString;
    NSMutableDictionary *newsInfo;
    NSData *webData;
    
    //view
    IBOutlet UIWebView *myWebView;
    JXActivityIndicatorView *myActIndicator;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIBarButtonItem *goBackButton;
    IBOutlet UIBarButtonItem *goForthButton;
    IBOutlet UIBarButtonItem *refreshButton;
    IBOutlet UIBarButtonItem *actionButton;
    
    Facebook *facebook;
    
    UIViewController *parent;
}

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSMutableDictionary *newsInfo;
@property (nonatomic, retain) NSData *webData;
@property (nonatomic, retain) UIWebView *myWebView;
@property (nonatomic, retain) JXActivityIndicatorView *myActIndicator;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic ,retain) Facebook *facebook;
@property (nonatomic, retain) UIBarButtonItem *refreshButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) UIViewController *parent;

-(void) loadWebView;

//button action
-(IBAction)clickGoBack:(id)sender;
-(IBAction)clickGoForward:(id)sender;
-(IBAction)clickRefresh:(id)sender;
-(IBAction)clickAction:(id)sender;
-(IBAction)backToPrevPage:(id)sender;

-(void) fbClicked;
-(void) emailClicked;

//view
-(void) configureView;
-(void) configureViewRotated;

@end
