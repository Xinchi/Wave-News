//
//  ViewFullArticle.m
//  WaveNews
//
//  Created by GUYU XUE on 19/1/12.
//  Copyright (c) 2012 Nanyang Technological University. All rights reserved.
//

#import "ViewFullArticle.h"
#import "UIImageView+WebCache.h"

@implementation ViewFullArticle

@synthesize newsInfo;
@synthesize fullContent;

@synthesize displayView;
@synthesize label1;
//@synthesize label2;
@synthesize articleSource;
@synthesize titleLabel;
@synthesize fullArticle;
@synthesize articleImage;

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
-(void)dealloc
{
    [newsInfo release];
    [fullContent release];
    
    [displayView release];
    //[label2 release];
    [label1 release];
    [fullArticle release];
    [titleLabel release];
    [articleSource release];
    [articleImage release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureViewPortrait];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

int MARGIN_BOTTOM;
int MARGIN_BETWEEN_TITLE_IMAGE;
int MARGIN_BETWEEN_IMAGE_TEXT;
int MARGIN_BETWEEN_TEXT_LABEL;
int MARGIN_BETWEEN_LABEL_LOGO;

int TITLE_X;
int TITLE_Y;
int TITLE_WIDTH;
int TITLE_HEIGHT;

int IMAGE_X;
int IMAGE_Y;
int IMAGE_WIDTH;
int IMAGE_HEIGHT;

int TEXT_X;
int TEXT_Y;
int TEXT_WIDTH;
int TEXT_HEIGHT;

int LABEL_X;
int LABEL_Y;

int LOGO_X;
int LOGO_Y;
int LOGO_WIDTH;
int LOGO_HEIGHT;

int SCROLL_X;
int SCROLL_Y;
int SCROLL_WIDTH;

-(void)configureView
{
    int height=0;
    
    //background
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BlackLeather.jpg"]];
    self.displayView.backgroundColor = background;
    [background release];
    
    //title
    NSString *text=[newsInfo objectForKey:@"title"];
    self.titleLabel.text=text;
    self.titleLabel.backgroundColor=nil;
    
    CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:self.titleLabel.font.pointSize+1] constrainedToSize:CGSizeMake(TITLE_WIDTH, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect tempFrame=self.titleLabel.frame;
    tempFrame.size.height=textSize.height;
    tempFrame.origin.y=TITLE_Y;
    tempFrame.origin.x=TITLE_X;
    tempFrame.size.width=TITLE_WIDTH;
    self.titleLabel.frame=tempFrame;
    
    height+=TITLE_Y+tempFrame.size.height;
    TITLE_HEIGHT=tempFrame.size.height;
    
    //image
    NSArray *imageUrls=[newsInfo objectForKey:@"media"];
    
    if([imageUrls count]!=0)
    {
        NSLog(@"aaa");
        
        NSURL *imageURL=[NSURL URLWithString:[imageUrls objectAtIndex:0]];
        
        [self.articleImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"black.jpg"]];
    }
    else {
        NSLog(@"bbb");
        
        IMAGE_HEIGHT=0;
    }
    
    tempFrame=self.articleImage.frame;
    tempFrame.origin.y=height+MARGIN_BETWEEN_TITLE_IMAGE;
    tempFrame.size.height=IMAGE_HEIGHT;
    tempFrame.size.width=IMAGE_WIDTH;
    tempFrame.origin.x=IMAGE_X;
    self.articleImage.frame=tempFrame;
    
    height+=MARGIN_BETWEEN_TITLE_IMAGE+IMAGE_HEIGHT;
    
    //text
    self.fullArticle.delegate=self;
    
    NSString *contentString=[@"<font color=\"white\">" stringByAppendingString:fullContent];
    contentString=[contentString stringByAppendingString:@"</font>"];
    
    [self.fullArticle loadHTMLString:contentString baseURL:nil];
    self.fullArticle.backgroundColor=[UIColor clearColor];
    
    NSArray *sv = [NSArray arrayWithArray:[self.fullArticle subviews]];
    UIScrollView *webScroller = (UIScrollView *)[sv objectAtIndex:0];
    
    webScroller.scrollEnabled=FALSE;
    
    tempFrame=self.fullArticle.frame;
    tempFrame.origin.y=height+MARGIN_BETWEEN_IMAGE_TEXT;
    tempFrame.size.width=TEXT_WIDTH;
    tempFrame.origin.x=TEXT_X;
    self.fullArticle.frame=tempFrame;
}

-(void)configureViewPortrait
{
    MARGIN_BOTTOM=20;
    MARGIN_BETWEEN_TITLE_IMAGE=5;
    MARGIN_BETWEEN_TEXT_LABEL=10;
    MARGIN_BETWEEN_LABEL_LOGO=5;
    MARGIN_BETWEEN_IMAGE_TEXT=5;
    
    TITLE_X=5;
    TITLE_WIDTH=310;
    TITLE_Y=50;
    
    IMAGE_WIDTH=250;
    IMAGE_HEIGHT=150;
    IMAGE_X=25;
    
    TEXT_WIDTH=300;
    TEXT_X=10;
    
    LABEL_X=10;
    
    LOGO_HEIGHT=60;
    LOGO_WIDTH=280;
    LOGO_X=20;
    
    [self configureView];
}

-(void)configureViewRotate
{
    
}

#pragma mark - web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    int height=TITLE_Y+TITLE_HEIGHT+MARGIN_BETWEEN_TITLE_IMAGE+IMAGE_HEIGHT+MARGIN_BETWEEN_IMAGE_TEXT+frame.size.height;
    
    //label
    frame=self.label1.frame;
    frame.origin.y=height+MARGIN_BETWEEN_TEXT_LABEL;
    frame.origin.x=LABEL_X;
    self.label1.frame=frame;
    
    height+=frame.size.height+MARGIN_BETWEEN_TEXT_LABEL;
    
    //logo
    [UIImage imageNamed:@"msnbc.jpg"];
    self.articleSource.image=[UIImage imageNamed:@"msnbc.jpg"];;
    
    frame=self.articleSource.frame;
    frame.origin.y=height+MARGIN_BETWEEN_LABEL_LOGO;
    frame.size.height=LOGO_HEIGHT;
    frame.size.width=LOGO_WIDTH;
    frame.origin.x=LOGO_X;
    self.articleSource.frame=frame;
    
    height+=MARGIN_BETWEEN_LABEL_LOGO+LOGO_HEIGHT+MARGIN_BOTTOM;
    
    //scroll view
    self.displayView.contentSize=CGSizeMake(SCROLL_WIDTH,height);
}
@end
