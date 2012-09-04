//
//  SaveAndShare.m
//  RSSReader
//
//  Created by GUYU XUE on 26/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import "SaveAndShare.h"
#import "AbsDisplay.h"

@implementation SaveAndShare

@synthesize newsInfo;
@synthesize saveButton;
@synthesize fbButton;
@synthesize twiButton;
@synthesize emailButton;
@synthesize facebook;
@synthesize parent;
@synthesize picker;
@synthesize tweetViewController;

BOOL articleIsSaved;

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

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    facebook = [[Facebook alloc] initWithAppId:@"YOUR_APP_ID" andDelegate:self];
    
    articleIsSaved=[self isSaved];
    
    if(articleIsSaved)
    {
        [self.saveButton setImage:[UIImage imageNamed:@"saveAct.png"] forState:UIControlStateNormal];
        
        [newsInfo setValue:@"YES" forKey:@"isSaved"];
    }
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
            || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - button clicked
-(IBAction)saveClicked:(id)sender
{
    if(!articleIsSaved)
    {
        NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *myDocPath = [myPaths objectAtIndex:0];
        NSString *filePath = [myDocPath stringByAppendingPathComponent:@"savedNews.plist"];
        
        //read from the file
        NSMutableArray *allSavedNews;
        BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if(fileExists)
        {
            allSavedNews=[NSMutableArray arrayWithContentsOfFile:filePath];
        }
        else
        {
            allSavedNews=[[[NSMutableArray alloc] init] autorelease];
        }
        
        //append
        if(!newsInfo)
        {
            NSLog(@"empty news");
            
            return;
        }
        
        NSDate *today=[NSDate date];
        
        [newsInfo setValue:@"YES" forKey:@"isSaved"];
        
        NSMutableDictionary *tempNews=[NSMutableDictionary dictionaryWithDictionary:newsInfo];
        [tempNews setObject:today forKey:@"saveDate"];
        
        [allSavedNews insertObject:tempNews atIndex:0];
        
        //write to the file
        BOOL successWrite=[allSavedNews writeToFile:filePath atomically:YES];
        
        if(successWrite)
        {
//            NSLog(@"save the news successfully");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"News saved!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];

            
            [self.saveButton setImage:[UIImage imageNamed:@"saveAct.png"] forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"fail to save the news");
        }
        
        articleIsSaved=TRUE;
    }
    else
    {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove from MyNews" otherButtonTitles:nil];
        actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        
        [actionSheet showInView:self.parent.view];
        
        [actionSheet release];
    }
}

-(IBAction)fbClicked:(id)sender
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

-(IBAction)emailClicked:(id)sender
{
    if(![MFMailComposeViewController canSendMail])
    {
        NSLog(@"Your device cannot send email");
        
        return;
    }
    
    picker = [[MFMailComposeViewController alloc] init];
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
    
    [self.parent presentModalViewController:picker animated:YES];
//    [picker release];
}

- (IBAction)twitterClicked:(id)sender {
    
    //twitter
    
    if ([TWTweetComposeViewController canSendTweet]) {   // to check if twitter is set on settings
        
        tweetViewController = [[TWTweetComposeViewController alloc] init];
        
        //Set Text
        
        NSString *text =[NSString stringWithFormat:@"From Wave News: %@", [newsInfo objectForKey:@"title"]];
        
        
        [tweetViewController setInitialText: text];
        
        //        logo-2.png
        if([[newsInfo objectForKey:@"media"] count]!=0)
        {
            NSURL *url = [NSURL URLWithString: 
                          [[newsInfo objectForKey:@"media"] objectAtIndex:0]];
            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            [tweetViewController addImage:image];
            
        }
        else
        {
            
            [tweetViewController addImage:[UIImage imageNamed:@"logo-2.png"]]; // add image. just as it says
            
        }
        
        [tweetViewController addURL:[NSURL URLWithString:[newsInfo objectForKey:@"url"]]]; // add url
        
        [self presentViewController:tweetViewController animated:YES completion:nil];
        
        // check on this part using blocks. no more delegates? :)
        tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult res) {
            if (res == TWTweetComposeViewControllerResultDone) {
                
                // Twitter sent successfully.
                
            } else if (res == TWTweetComposeViewControllerResultCancelled) {
                
                // Tweet cancelled.
                
            }
            [tweetViewController dismissModalViewControllerAnimated:YES];
            
            [tweetViewController release];
        };
    } else {
        NSLog(@"No Twitter Account");
        
        // no twitter set
        NSString *alertTitle =@"No Twitter Account has been set up";
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
                                                          message:alertTitle                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
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
    
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
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

#pragma mark - my methods
-(BOOL) isSaved
{
    NSString *curUrl=[newsInfo objectForKey:@"url"];
    
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    NSString *filePath = [myDocPath stringByAppendingPathComponent:@"savedNews.plist"];
    
    NSArray *temp=[NSArray arrayWithContentsOfFile:filePath];
    NSDictionary *eachNews;
    
    for(eachNews in temp)
    {
        NSString *urlTemp=[eachNews objectForKey:@"url"];
        
        if([urlTemp isEqualToString:curUrl])
        {
            return TRUE;
        }
    }
    
    return FALSE;
}

#pragma mark - action sheet view
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //save
        {
            NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *myDocPath = [myPaths objectAtIndex:0];
            NSString *filePath = [myDocPath stringByAppendingPathComponent:@"savedNews.plist"];
            
            //read from the file
            NSMutableArray *allSavedNews;
            BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
            
            if(fileExists)
            {
                allSavedNews=[NSMutableArray arrayWithContentsOfFile:filePath];
                
                NSDictionary *eachNews;
                NSString *curUrl=[newsInfo objectForKey:@"url"];
                
                for(eachNews in allSavedNews)
                {
                    NSString *urlTemp=[eachNews objectForKey:@"url"];
                    
                    if([urlTemp isEqualToString:curUrl])
                    {
                        [allSavedNews removeObject:eachNews];
                        
                        break;
                    }
                }
                
                BOOL successWrite=[allSavedNews writeToFile:filePath atomically:YES];
                
                if(successWrite)
                {
                    NSLog(@"delete the news successfully");
                    
                    [newsInfo setValue:@"NO" forKey:@"isSaved"];
                    
                    [self.saveButton setImage:[UIImage imageNamed:@"saveInact.png"] forState:UIControlStateNormal];
                }
                else
                {
                    NSLog(@"fail to delete the news");
                }
                
                articleIsSaved=FALSE;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Fail to delete news" message:@"Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                
                [alert release];
            }
            
            break;
        }
        default:
            break;
    }
}
@end
