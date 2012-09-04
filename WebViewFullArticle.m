//
//  WebViewFullArticle.m
//  RSSReader
//
//  Created by GUYU XUE on 22/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import "WebViewFullArticle.h"
#import "JXActivityIndicatorView.h"
#import "SaveAndShare.h"

@implementation WebViewFullArticle

BOOL loadingFinished;

@synthesize urlString;
@synthesize newsInfo;
@synthesize webData;
@synthesize myWebView;
@synthesize myActIndicator;
@synthesize toolBar;
@synthesize facebook;
@synthesize refreshButton;
@synthesize actionButton;
@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [refreshButton release];
    [actionButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myActIndicator=[[JXActivityIndicatorView alloc] init];
    
    //navigation bar
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backButtonInact.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrevPage:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(2, 2, 28, 28)];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    loadingFinished=FALSE;
    
    [self loadWebView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            ||  interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            ||  interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        [self configureViewRotated];
    }
    else
    {
        [self configureView];
    }
}

-(void)configureView
{
    CGRect tempFrame=self.myActIndicator.view.frame;
    tempFrame.origin.x=130;
    tempFrame.origin.y=135;
    tempFrame.size.width=60;
    tempFrame.size.height=60;
    self.myActIndicator.view.frame=tempFrame;
    
    self.myActIndicator.view.layer.cornerRadius=5;
}

-(void)configureViewRotated
{
    CGRect tempFrame=self.myActIndicator.view.frame;
    tempFrame.origin.x=210;
    tempFrame.origin.y=67;
    tempFrame.size.width=60;
    tempFrame.size.height=60;
    self.myActIndicator.view.frame=tempFrame;
    
    self.myActIndicator.view.layer.cornerRadius=5;
}

#pragma mark - load webview
- (void)loadWebView
{
    myWebView.delegate=self;
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
}

#pragma mark - button actions
-(IBAction)clickGoBack:(id)sender
{
    if(myWebView.canGoBack)
    {
        [myWebView goBack];
    }
}

-(IBAction)clickGoForward:(id)sender
{
    if(myWebView.canGoForward)
    {
        [myWebView goForward];
    }
}

-(IBAction)clickRefresh:(id)sender
{
    [myWebView reload];
}

-(IBAction)clickAction:(id)sender
{
    UIActionSheet *actionSheet;
    
    if([[newsInfo objectForKey:@"isSaved"] isEqualToString:@"NO"])
    {
        actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", @"Share to facebook", @"Email", nil];
    }
    else
    {
        actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share to facebook", @"Email", nil];
    }
    
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showFromToolbar:toolBar];
    
    [actionSheet release];
}

-(IBAction) backToPrevPage:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - web view delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        [self configureViewRotated];
    }
    else
    {
        [self configureView];
    }
    
    //add subview
    
    if(!loadingFinished)
    {
        [self.view addSubview:myActIndicator.view];
        
        [myActIndicator waitingStart];
        
        //disable all buttons
        self.refreshButton.enabled=FALSE;
        self.actionButton.enabled=FALSE;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //remove from top
    if(!loadingFinished)
    {
        [myActIndicator.view removeFromSuperview];
    
        [myActIndicator waitingStop];
        
        self.refreshButton.enabled=TRUE;
        self.actionButton.enabled=TRUE;
        
        loadingFinished=TRUE;
    }
    
    //go forth and back button
    [goBackButton setEnabled:[myWebView canGoBack]];
    
    [goForthButton setEnabled:[myWebView canGoForward]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Fail to load page" message:@"Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
    if(myActIndicator!=nil && [myActIndicator isAnimating])
    {
        [myActIndicator.view removeFromSuperview];
        
        [myActIndicator waitingStop];
        
        loadingFinished=TRUE;
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    [alert release];
}

#pragma mark - action sheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[newsInfo objectForKey:@"isSaved"] isEqualToString:@"NO"])
    {
        SaveAndShare *saveAndShare=[[SaveAndShare alloc] init];
        
        saveAndShare.newsInfo=self.newsInfo;
        saveAndShare.parent=self;
        
        switch (buttonIndex) {
            case 0: //save
            {
                [saveAndShare saveClicked:saveAndShare.saveButton];
                break;
            }
            case 1: //facebook
            {
                [self fbClicked];
                
                break;
            }
            case 2: //email
            {
                [self emailClicked];
                
                break;
            }
            default:
                break;
        }
        
        [saveAndShare release];
    }
    else
    {
        switch (buttonIndex) {
            case 0: //facebook
            {
                [self fbClicked];
                
                break;
            }
            case 1: //email
            {
                [self emailClicked];
                
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - button clicked
-(void)fbClicked
{
    facebook = [[Facebook alloc] initWithAppId:@"302465109791604" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:nil];
    }
    
    NSArray *images=[newsInfo objectForKey:@"media"];
    NSString *imageUrl;
    if([images count]!=0)
    {
        imageUrl=[images objectAtIndex:0];
    }
    else
    {
        imageUrl=@"http://www-deadline-com.vimg.net/wp-content/uploads/2011/01/msnbc-logo.jpg";
    }
    
    NSString *productPromote=@"{\"WaveNews\":\"A revolutionary way of reading news. Search WaveNews for more details\"}";
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"302465109791604", @"app_id",
                                   @"page",@"display",
                                   [newsInfo objectForKey:@"url"], @"link",
                                   imageUrl, @"picture",
                                   [newsInfo objectForKey:@"title"], @"name",
                                   [newsInfo objectForKey:@"author"], @"caption",
                                   [newsInfo objectForKey:@"description"], @"description",
                                   productPromote,@"properties",
                                   nil];
    
    [facebook dialog:@"feed" andParams:params andDelegate:self];
    
    [facebook release];
}

-(void)emailClicked
{
    if(![MFMailComposeViewController canSendMail])
    {
        NSLog(@"Your device cannot send email");
        
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [picker setSubject:[NSString stringWithFormat:@"WaveNews share - %@",[newsInfo objectForKey:@"title"]]];
    
    NSString* imageUrl;
    
    if([[newsInfo objectForKey:@"media"] count]!=0)
    {
        imageUrl=[[newsInfo objectForKey:@"media"] objectAtIndex:0];
    }
    else
    {
        imageUrl=@"http://3.bp.blogspot.com/_A3oFfKDC2E4/TUpcQ5QiVNI/AAAAAAAAJe0/iy6QhTeDxEw/s1600/beautiful+sunrise+3.jpg";
    }
    
    NSString *content=[NSString stringWithFormat:@"<p>I want to share with you this news:</p><hr /><h3><a href=\"%@\">%@</a></h3><br /><img src=\"%@\" width=\"200\" height=\"180\" /><br /><p>%@</p><br /><hr /><h4>About WaveNews</h4><p>WaveNews is a rerolutionary way of reading news</p><p>Click <a href=\"http://www.google.com.sg\">here</a> to see more about WaveNews</p>", [newsInfo objectForKey:@"url"],[newsInfo objectForKey:@"title"],imageUrl,[newsInfo objectForKey:@"description"]];
    
    [picker setMessageBody:content isHTML:YES];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark - email delegate
// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
        {
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        }
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    return;
}

#pragma mark - facebook delegate
// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}
@end
