//
//  AbsDisplay.m
//  WaveNews
//
//  Created by GUYU XUE on 12/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import "AbsDisplay.h"
#import "JXTitleCell.h"
#import "JXAbsCell.h"
#import "UIImageView+WebCache.h"
#import "SaveAndShare.h"
#import "WebViewFullArticle.h"
#import "HTMLParser.h"
//#import "ViewFullArticle.h"
#import "JXActivityIndicatorView.h"

@implementation AbsDisplay

@synthesize newsInfo;
@synthesize saveAndSharePanel;
@synthesize newsDisplay;
//@synthesize fullArticleView;
@synthesize absCell;
@synthesize titleCell;
@synthesize myActIndicator;
@synthesize viewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    //[fullArticleView release];
    [absCell release];
    [titleCell release];
    [super dealloc];
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

    saveAndSharePanel=[[SaveAndShare alloc] init];
    saveAndSharePanel.newsInfo=self.newsInfo;
    saveAndSharePanel.parent=self;
    
    [self configureViewPortrait];
    
    ((UITableView*)self.view).scrollEnabled=FALSE;
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backButtonInact.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrevPage:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(2, 2, 28, 28)];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

- (void)backToPrevPage:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[newsInfo objectForKey:@"isSaved"] isEqualToString:@"YES"])
    {
        [self.saveAndSharePanel.saveButton setImage:[UIImage imageNamed:@"saveAct.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self configureViewRotate];
    }
    else
    {
        [self configureViewPortrait];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self configureViewRotate];
    }
    else
    {
        [self configureViewPortrait];
    }
}

#pragma mark - view
//view data 
int MARGIN_BETWEEN_DATE_TITLE;
int MARGIN_BETWEEN_TITLE_AUTHOR;
//int MARGIN_BETWEEN_IMAGE_AUTHOR;
int TITLE_MARGIN_BOTTOM;

int TITLE_IMAGE_X;
int TITLE_IMAGE_Y;
int TITLE_IMAGE_HEIGHT;
int TITLE_IMAGE_WIDTH;

int TITLE_TITLE_X;
int TITLE_TITLE_Y;
int TITLE_TITLE_HEIGHT;
int TITLE_TITLE_WIDTH;

int TITLE_AUTHOR_X;
int TITLE_AUTHOR_Y;
int TITLE_AUTHOR_HEIGHT;
int TITLE_AUTHOR_WIDTH;

int TITLE_DATE_X;
int TITLE_DATE_Y;
int TITLE_DATE_HEIGHT;
int TITLE_DATE_WIDTH;

int TITLE_ACCESS_X;
int TITLE_ACCESS_Y;
int TITLE_ACCESS_HEIGHT;
int TITLE_ACCESS_WIDTH;

int TITLE_BUTTON_X;
int TITLE_BUTTON_Y;
int TITLE_BUTTON_HEIGHT;
int TITLE_BUTTON_WIDTH;

int ABS_MARGIN_BETWEEN;
int ABS_MARGIN_BOTTOM;

int ABS_ABS_X;
int ABS_ABS_Y;
int ABS_ABS_WIDTH;
int ABS_ABS_HEIGHT;

int ABS_IMAGE_X;
int ABS_IMAGE_Y;
int ABS_IMAGE_WIDTH;
int ABS_IMAGE_HEIGHT;

int ABS_SCROLL_X;
int ABS_SCROLL_Y;
int ABS_SCROLL_WIDTH;
int ABS_SCROOL_HEIGHT;

int ABS_CELL_WIDTH;
int ABS_CELL_HEIGHT;

int TITLE_HEIGHT;

int INDICATOR_X;
int INDICATOR_Y;
int INDICATOR_WIDTH=120;
int INDICATOR_HEIGHT=100;

int TITLE_FONT=17;
int AUTHOR_FONT=11;
int DATE_FONT=13;

-(void)configureViewPortrait
{
    MARGIN_BETWEEN_DATE_TITLE=3;
    MARGIN_BETWEEN_TITLE_AUTHOR=5;
    //MARGIN_BETWEEN_IMAGE_AUTHOR=0;
    TITLE_MARGIN_BOTTOM=5;
    
    TITLE_IMAGE_X=10;
    TITLE_IMAGE_Y=15;
    TITLE_IMAGE_HEIGHT=55;
    TITLE_IMAGE_WIDTH=55;
    
    TITLE_TITLE_X=75;
    TITLE_TITLE_Y=10;
    TITLE_TITLE_HEIGHT=0;
    TITLE_TITLE_WIDTH=230;
    
    TITLE_AUTHOR_X=75;
    TITLE_AUTHOR_Y=0;
    TITLE_AUTHOR_HEIGHT=0;
    TITLE_AUTHOR_WIDTH=230;
    
    TITLE_DATE_X=75;
    TITLE_DATE_Y=5;
    TITLE_DATE_HEIGHT=10;
    TITLE_DATE_WIDTH=230;
    
    TITLE_ACCESS_X=290;
    TITLE_ACCESS_Y=0;
    TITLE_ACCESS_HEIGHT=20;
    TITLE_ACCESS_WIDTH=20;
    
    TITLE_BUTTON_X=0;
    TITLE_BUTTON_Y=0;
    TITLE_BUTTON_HEIGHT=460;
    TITLE_BUTTON_WIDTH=320;
    
    ABS_MARGIN_BETWEEN=5;
    ABS_MARGIN_BOTTOM=160;
    
    ABS_ABS_X=10;
    ABS_ABS_Y=0;
    ABS_ABS_WIDTH=300;
    ABS_ABS_HEIGHT=0;
    
    ABS_IMAGE_X=25;
    ABS_IMAGE_Y=15;
    ABS_IMAGE_WIDTH=250;
    ABS_IMAGE_HEIGHT=150;
    
    ABS_SCROLL_X=0;
    ABS_SCROLL_Y=0;
    ABS_SCROLL_WIDTH=320;
    ABS_SCROOL_HEIGHT=0;
    
    ABS_CELL_WIDTH=320;
    
    INDICATOR_X=100;
    INDICATOR_Y=115;
    
    //save and share panel
    CGRect saveAndShareFrame=saveAndSharePanel.view.frame;
    saveAndShareFrame.origin.x=171;
    saveAndShareFrame.origin.y=330;
    saveAndSharePanel.view.frame=saveAndShareFrame;
    saveAndSharePanel.view.backgroundColor=[UIColor grayColor];
    
    CALayer *tempLayer=[saveAndSharePanel.view layer];
    [tempLayer setMasksToBounds:YES];
    [tempLayer setCornerRadius:7.5];
    
    [self.view addSubview:saveAndSharePanel.view];
    
    //reload
    [self.tableView reloadData];
}

-(void)configureViewRotate
{
    MARGIN_BETWEEN_DATE_TITLE=3;
    MARGIN_BETWEEN_TITLE_AUTHOR=0;
    //MARGIN_BETWEEN_IMAGE_AUTHOR=0;
    TITLE_MARGIN_BOTTOM=5;
    
    TITLE_IMAGE_X=10;
    TITLE_IMAGE_Y=15;
    TITLE_IMAGE_HEIGHT=55;
    TITLE_IMAGE_WIDTH=55;
    
    TITLE_TITLE_X=75;
    TITLE_TITLE_Y=10;
    TITLE_TITLE_HEIGHT=0;
    TITLE_TITLE_WIDTH=350;
    
    TITLE_AUTHOR_X=75;
    TITLE_AUTHOR_Y=0;
    TITLE_AUTHOR_HEIGHT=0;
    TITLE_AUTHOR_WIDTH=410;
    
    TITLE_DATE_X=75;
    TITLE_DATE_Y=0;
    TITLE_DATE_HEIGHT=10;
    TITLE_DATE_WIDTH=410;
    
    TITLE_ACCESS_X=425;
    TITLE_ACCESS_Y=0;
    TITLE_ACCESS_HEIGHT=20;
    TITLE_ACCESS_WIDTH=20;
    
    TITLE_BUTTON_X=0;
    TITLE_BUTTON_Y=0;
    TITLE_BUTTON_HEIGHT=320;
    TITLE_BUTTON_WIDTH=460;
    
    ABS_MARGIN_BETWEEN=5;
    ABS_MARGIN_BOTTOM=220;
    
    ABS_ABS_X=10;
    ABS_ABS_Y=0;
    ABS_ABS_WIDTH=440;
    ABS_ABS_HEIGHT=0;
    
    ABS_IMAGE_X=105;
    ABS_IMAGE_Y=15;
    ABS_IMAGE_WIDTH=250;
    ABS_IMAGE_HEIGHT=150;
    
    ABS_SCROLL_X=0;
    ABS_SCROLL_Y=0;
    ABS_SCROLL_WIDTH=460;
    ABS_SCROOL_HEIGHT=0;
    
    ABS_CELL_WIDTH=460;
    
    INDICATOR_X=180;
    INDICATOR_Y=60;
    
    //save and share panel
    CGRect saveAndShareFrame=saveAndSharePanel.view.frame;
    saveAndShareFrame.origin.x=311;
    saveAndShareFrame.origin.y=200;
    saveAndSharePanel.view.frame=saveAndShareFrame;
    saveAndSharePanel.view.backgroundColor=[UIColor grayColor];
    
    CALayer *tempLayer=[saveAndSharePanel.view layer];
    [tempLayer setMasksToBounds:YES];
    [tempLayer setCornerRadius:7.5];
    
    [self.view addSubview:saveAndSharePanel.view];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]==0)
    {
        int height=0;
        
        //create cell
        titleCell=[[[NSBundle mainBundle] loadNibNamed:@"JXTitleCell" owner:self options:nil] objectAtIndex:0];
        titleCell.contentView.backgroundColor = [UIColor grayColor];
        
        //date
        NSDate *pubDate=[newsInfo objectForKey:@"pubDate"];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        
        titleCell.articleDate.text=[dateFormatter stringFromDate:pubDate];
        titleCell.articleDate.backgroundColor=nil;
        
        [dateFormatter release];
        
        CGSize textSize = [titleCell.articleDate.text sizeWithFont:[UIFont systemFontOfSize:DATE_FONT+1] constrainedToSize:CGSizeMake(TITLE_DATE_WIDTH, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        
        CGRect tempFrame = titleCell.articleDate.frame;
        tempFrame.origin.y=TITLE_DATE_Y;
        tempFrame.size.height=textSize.height;
        tempFrame.size.width=TITLE_DATE_WIDTH;
        tempFrame.origin.x=TITLE_DATE_X;
        titleCell.articleDate.frame=tempFrame;
        
        height+=TITLE_DATE_Y+tempFrame.size.height;
        
        //title
        titleCell.articleTitle.text=[newsInfo objectForKey:@"title"];
        
        titleCell.articleTitle.editable=FALSE;
        titleCell.articleTitle.scrollEnabled=FALSE;
        titleCell.articleTitle.backgroundColor=nil;
        titleCell.articleTitle.contentInset = UIEdgeInsetsMake(-10,-8,0,0 );
        
        NSString *text = [self.newsInfo objectForKey:@"title"];
        
        textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:TITLE_FONT+1] constrainedToSize:CGSizeMake(TITLE_TITLE_WIDTH, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        
        tempFrame=titleCell.articleTitle.frame;
        tempFrame.size.height=textSize.height;
        tempFrame.origin.y=height+MARGIN_BETWEEN_DATE_TITLE;
        tempFrame.origin.x=TITLE_TITLE_X;
        tempFrame.size.width=TITLE_TITLE_WIDTH;
        titleCell.articleTitle.frame=tempFrame;
        
        height+=MARGIN_BETWEEN_DATE_TITLE+tempFrame.size.height;
        
        //author
        text=[newsInfo objectForKey:@"author"];
        
        if(text==nil || [text isEqualToString:@""])
        {
            text=[@"FROM " stringByAppendingString:[newsInfo objectForKey:@"source"]];
        }
         
        titleCell.articleAuthor.text=text;
        titleCell.articleAuthor.backgroundColor=nil;
        
        textSize = [text sizeWithFont:[UIFont systemFontOfSize:AUTHOR_FONT+1] constrainedToSize:CGSizeMake(TITLE_AUTHOR_WIDTH, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        
        tempFrame=titleCell.articleAuthor.frame;
        tempFrame.size.height=textSize.height;
        tempFrame.origin.y=height+MARGIN_BETWEEN_TITLE_AUTHOR;
        tempFrame.size.height=textSize.height;
        tempFrame.origin.x=TITLE_AUTHOR_X;
        tempFrame.size.width=TITLE_AUTHOR_WIDTH;
        
        titleCell.articleAuthor.frame=tempFrame;
        
        //shadow
        titleCell.layer.shadowColor = [UIColor blackColor].CGColor;
        titleCell.layer.shadowOffset = CGSizeMake(0, 1);
        titleCell.layer.shadowOpacity = 1;
        titleCell.layer.shadowRadius = 1.0;
        
        //image
        NSArray *imageUrls=[newsInfo objectForKey:@"media"];
        
        if([imageUrls count]!=0)
        {
            NSURL *imageURL=[NSURL URLWithString:[imageUrls objectAtIndex:0]];
            
            [titleCell.articleImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:[[newsInfo objectForKey:@"source"] stringByAppendingString:@".png"]]];
        
            titleCell.articleImage.contentMode=UIViewContentModeScaleAspectFill;
        }
        else
        {
//            NSArray *titleArray=[NSArray arrayWithObjects:@"NEW YORK TIMES",@"MSNBC",@"WALL STREET JOURNAL",@"USA TODAY",@"LOS ANGELES TIMES",@"SAN FRANCISCO CHRONICLE",@"WASHINGTON POST",@"NEW YORK POST",@"THE ATLANTA JOURNAL-CONSTITUTION",@"CHICAGO TRIBUNE",@"YAHOO",@"CNN",@"GOOGLE",@"FOX NEWS", nil];
//            
//            NSString *paperName=[newsInfo objectForKey:@"source"];
//            
//            BOOL isFromPaper=FALSE;
//            
//            for(NSString *curName in titleArray)
//            {
//                if([paperName isEqualToString:curName])
//                {
//                    isFromPaper=TRUE;
//                    break;
//                }
//            }
//            
//            if(isFromPaper)
//            {
//                UIImage *bigImage=[UIImage imageNamed:[[newsInfo objectForKey:@"source"] stringByAppendingString:@".png"]];
//                titleCell.articleImage.image=bigImage;
//            }
//            else
//            {
//                UIImage *bigImage=[UIImage imageNamed:@"logo_small.png"];
                  UIImage *bigImage=[UIImage imageNamed:@"logo-2.png"];

                titleCell.articleImage.image=bigImage;
//            }
        }
        
        CALayer *tempLayer=[titleCell.articleImage layer];
        [tempLayer setMasksToBounds:YES];
        [tempLayer setCornerRadius:5.0];
        tempLayer.borderColor=[UIColor whiteColor].CGColor;
        tempLayer.borderWidth=2.5;
        
        tempFrame = titleCell.articleImage.frame;
        tempFrame.origin.y=TITLE_IMAGE_Y;
        tempFrame.size.height=TITLE_IMAGE_HEIGHT;
        tempFrame.size.width=TITLE_IMAGE_WIDTH;
        tempFrame.origin.x=TITLE_IMAGE_X;
        titleCell.articleImage.frame=tempFrame;
        
        //accessory
        UIImage *accessoryImage=[UIImage imageNamed:@"accessory.png"];
        titleCell.myAccessory.image=accessoryImage;
        
        tempFrame=titleCell.myAccessory.frame;
        tempFrame.origin.y=TITLE_HEIGHT/2-TITLE_ACCESS_HEIGHT/2;
        tempFrame.size.height=TITLE_ACCESS_HEIGHT;
        tempFrame.origin.x=TITLE_ACCESS_X;
        tempFrame.size.width=TITLE_ACCESS_WIDTH;
        titleCell.myAccessory.frame=tempFrame;
        
        //button
        tempFrame=titleCell.viewFullButton.frame;
        tempFrame.size.height=TITLE_BUTTON_HEIGHT;
        tempFrame.origin.y=TITLE_BUTTON_Y;
        tempFrame.origin.x=TITLE_BUTTON_X;
        tempFrame.size.width=TITLE_BUTTON_WIDTH;
        titleCell.viewFullButton.frame=tempFrame;
        
        [titleCell.viewFullButton addTarget:self action:@selector(viewFullArticle:) forControlEvents:UIControlEventTouchUpInside];
        
        return titleCell;
    }
    else
    {
        int height=0;
        
        //create cell
        absCell=[[[NSBundle mainBundle] loadNibNamed:@"JXAbsCell" owner:self options:nil] objectAtIndex:0];
        
        //image
        NSArray *imageUrls=[newsInfo objectForKey:@"media"];
        
        if([imageUrls count]!=0)
        {
            NSURL *imageURL=[NSURL URLWithString:[imageUrls objectAtIndex:0]];
            
            [absCell.absImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:[[newsInfo objectForKey:@"source"] stringByAppendingString:@".png"]]];
        }
        else
        {
//            NSArray *titleArray=[NSArray arrayWithObjects:@"NEW YORK TIMES",@"MSNBC",@"WALL STREET JOURNAL",@"USA TODAY",@"LOS ANGELES TIMES",@"SAN FRANCISCO CHRONICLE",@"WASHINGTON POST",@"NEW YORK POST",@"THE ATLANTA JOURNAL-CONSTITUTION",@"CHICAGO TRIBUNE",@"YAHOO",@"CNN",@"GOOGLE",@"FOX NEWS", nil];
//            
//            NSString *paperName=[newsInfo objectForKey:@"source"];
//            
//            BOOL isFromPaper=FALSE;
//            
//            for(NSString *curName in titleArray)
//            {
//                if([paperName isEqualToString:curName])
//                {
//                    isFromPaper=TRUE;
//                    break;
//                }
//            }
//            
//            if(isFromPaper)
//            {
//                UIImage *bigImage=[UIImage imageNamed:[[newsInfo objectForKey:@"source"] stringByAppendingString:@".png"]];
//                absCell.absImage.image=bigImage;
//            }
//            else
//            {
                ABS_IMAGE_HEIGHT=0;
//            }
        }
        
        CGRect tempFrame=absCell.absImage.frame;
        tempFrame.origin.y=ABS_IMAGE_Y;
        tempFrame.size.height=ABS_IMAGE_HEIGHT;
        tempFrame.size.width=ABS_IMAGE_WIDTH;
        tempFrame.origin.x=ABS_IMAGE_X;
        absCell.absImage.frame=tempFrame;
        
        height+=ABS_IMAGE_Y+ABS_IMAGE_HEIGHT;
        
        //abstraction
        absCell.absView.delegate=self;
        
        NSString *text=[@"<b><font size=\"3\" face=\"ARIAL\">Briefing : </font></b><font size=\"3\" face=\"ARIAL\">" stringByAppendingString:[[newsInfo objectForKey:@"description"] stringByAppendingString:@"</font>"]];
        
        [absCell.absView loadHTMLString:text baseURL:nil];
        
        NSArray *sv = [NSArray arrayWithArray:[absCell.absView subviews]];
        UIScrollView *webScroller = (UIScrollView *)[sv objectAtIndex:0];
        
        webScroller.scrollEnabled=FALSE;
        
        tempFrame=absCell.absView.frame;
        tempFrame.origin.y=height+ABS_MARGIN_BETWEEN;
        tempFrame.size.width=ABS_ABS_WIDTH;
        tempFrame.origin.x=ABS_ABS_X;
        absCell.absView.frame=tempFrame;

        return absCell;
    }    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]==0)
    {
        int height=0;
        
        //title height
        NSString *text = [self.newsInfo objectForKey:@"title"];
    
        CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:TITLE_FONT+1] constrainedToSize:CGSizeMake(TITLE_TITLE_WIDTH, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        
        height+=textSize.height;
        
        //date height
        NSDate *pubDate=[newsInfo objectForKey:@"pubDate"];
        
        NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        
        text=[dateFormatter stringFromDate:pubDate];
        
        textSize = [text sizeWithFont:[UIFont systemFontOfSize:DATE_FONT+1] constrainedToSize:CGSizeMake(TITLE_DATE_WIDTH, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        
        height+=textSize.height;
        
        //author height
        text=[newsInfo objectForKey:@"author"];
        
        if(text==nil || [text isEqualToString:@""])
        {
            text=[@"From " stringByAppendingString:[newsInfo objectForKey:@"source"]];
        }
        
        textSize = [text sizeWithFont:[UIFont systemFontOfSize:AUTHOR_FONT+1] constrainedToSize:CGSizeMake(TITLE_AUTHOR_WIDTH, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        
        height+=textSize.height;
        
        height+=TITLE_MARGIN_BOTTOM+MARGIN_BETWEEN_DATE_TITLE+MARGIN_BETWEEN_TITLE_AUTHOR+TITLE_DATE_Y;
        
        if(height<TITLE_IMAGE_Y+TITLE_IMAGE_HEIGHT+TITLE_MARGIN_BOTTOM)
        {
            height=TITLE_IMAGE_Y+TITLE_IMAGE_HEIGHT+TITLE_MARGIN_BOTTOM;
        }
        
        TITLE_HEIGHT=height;
        
        return height;
    }
    else
    {
        if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            ABS_CELL_HEIGHT=320-44-TITLE_HEIGHT;
        }
        else
        {
            ABS_CELL_HEIGHT=460-44-TITLE_HEIGHT;
        }
        
        return ABS_CELL_HEIGHT;
    }
}

#pragma mark - web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    ABS_SCROOL_HEIGHT=ABS_IMAGE_Y+ABS_IMAGE_HEIGHT+ABS_MARGIN_BETWEEN+frame.size.height+ABS_MARGIN_BOTTOM;
    
    (absCell.displayView).contentSize=CGSizeMake(ABS_SCROLL_WIDTH,ABS_SCROOL_HEIGHT);
}

#pragma mark - button action
-(IBAction) viewFullArticle:(id) sender
{
    /*
    NSLog(@"%@",[newsInfo objectForKey:@"url"]);
    
    NSString *fullContent=nil;
    
    if([[newsInfo objectForKey:@"source"] isEqualToString:@"New York Times"])
    {
        myActIndicator=[[JXActivityIndicatorView alloc] init];
        
        CGRect tempFrame=self.myActIndicator.view.frame;
        tempFrame.origin.x=INDICATOR_X;
        tempFrame.origin.y=INDICATOR_Y;
        tempFrame.size.width=INDICATOR_WIDTH;
        tempFrame.size.height=INDICATOR_HEIGHT;
        self.myActIndicator.view.frame=tempFrame;
        
        [self.view addSubview:myActIndicator.view];
        
        [myActIndicator waitingStart];
        
        fullContent=[HTMLParser parseNYTimesNews:[newsInfo objectForKey:@"url"]];
        
        [myActIndicator waitingStop];
        
        [myActIndicator.view removeFromSuperview];
        
        [myActIndicator release];
    }
    
    if(fullContent!=nil)
    {
        fullArticleView=[[ViewFullArticle alloc] init];
        fullArticleView.newsInfo=self.newsInfo;
        fullArticleView.fullContent=fullContent;
        
        [self.navigationController pushViewController:fullArticleView animated:YES];
    }
    else {
     */
        newsDisplay=[[WebViewFullArticle alloc] init];
        newsDisplay.newsInfo=self.newsInfo;
        
        newsDisplay.urlString=[newsInfo objectForKey:@"url"];
        
        [self.navigationController pushViewController:newsDisplay animated:YES];
        
    //}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        UIImageView* backgroundImage = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
        backgroundImage.image = [UIImage imageNamed:@"navHomeRot.png"];
        
        backgroundImage.contentMode = UIViewContentModeLeft;
        
        
        //    [self.navigationController.navigationBar insertSubview:backgroundImage atIndex:0];
        
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage.image forBarMetrics:UIBarMetricsDefault];
        [backgroundImage release];
        
    }
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        UIImageView* backgroundImage = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
        backgroundImage.image = [UIImage imageNamed:@"homeNav.png"];
        
        backgroundImage.contentMode = UIViewContentModeLeft;
        
        
        //    [self.navigationController.navigationBar insertSubview:backgroundImage atIndex:0];
        
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage.image forBarMetrics:UIBarMetricsDefault];
        [backgroundImage release];
        
    }
}

@end
