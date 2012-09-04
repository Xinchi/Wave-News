//
//  SaveAndShare.h
//  RSSReader
//
//  Created by GUYU XUE on 26/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import <Twitter/TWTweetComposeViewController.h> 


@interface SaveAndShare : UIViewController <FBSessionDelegate, FBDialogDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
{
    NSMutableDictionary *newsInfo;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *fbButton;
    IBOutlet UIButton *twiButton;
    IBOutlet UIButton *emailButton;
    
    Facebook *facebook;
    
    //view
    UIViewController *parent;
}

@property (nonatomic, retain) NSMutableDictionary *newsInfo;

@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *fbButton;
@property (nonatomic, retain) UIButton *twiButton;
@property (nonatomic, retain) UIButton *emailButton;
@property (nonatomic, retain) Facebook *facebook;

@property (nonatomic, retain) UIViewController *parent;
@property (nonatomic, retain) MFMailComposeViewController *picker;
@property (nonatomic, retain) TWTweetComposeViewController *tweetViewController;


-(IBAction)saveClicked:(id)sender;
-(IBAction)fbClicked:(id)sender;
//-(IBAction)twiClicked:(id)sender;
-(IBAction)emailClicked:(id)sender;
- (IBAction)twitterClicked:(id)sender;

-(BOOL) isSaved;
@end
