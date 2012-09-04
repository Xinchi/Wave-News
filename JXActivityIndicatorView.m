//
//  JXActivityIndicatorView.m
//  RSSReader
//
//  Created by GUYU XUE on 22/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import "JXActivityIndicatorView.h"

@implementation JXActivityIndicatorView

@synthesize textInfo;
//@synthesize myTextView;
@synthesize myActivityIndicator;

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
    
    NSLog(@"AAAABBBBCCCC");
    // Do any additional setup after loading the view from its nib.
    
    /*
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        //[self configureViewRotated];
    }
    else
    {
        //[self configureView];
    }
     */
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

#pragma mark - configure view
/*
-(void) configureView
{
    int height=0;
    int MARGIN_BETWEEN=15;
    int TOP_MARGIN=100;
    
    //view
    CGRect tempFrame=self.view.frame;
    tempFrame.size.width=320;
    tempFrame.size.height=480;
    self.view.frame=tempFrame;
    
    //title
    //myTextView.text=textInfo;
    
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [textInfo sizeWithFont:myTextView.font constrainedToSize:maximumLabelSize lineBreakMode:myTextView.lineBreakMode]; 
    
    tempFrame = myTextView.frame;
    tempFrame.size.height = expectedLabelSize.height;
    tempFrame.origin.y=TOP_MARGIN;
    myTextView.frame = tempFrame;
    
    height+=TOP_MARGIN+tempFrame.size.height;
    
    //indicator
    tempFrame = myActivityIndicator.frame;
    tempFrame.origin.y=height+MARGIN_BETWEEN;
    myActivityIndicator.frame = tempFrame;
}


-(void)configureViewRotated
{
    int height=0;
    int MARGIN_BETWEEN=15;
    int TOP_MARGIN=50;
    
    //view
    CGRect tempFrame;
    
    NSLog(@"rotate");
    
    tempFrame=self.view.frame;
    tempFrame.size.width=460;
    tempFrame.size.height=320;
    self.view.frame=tempFrame;
    
    //title
    myTextView.text=textInfo;
    
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [textInfo sizeWithFont:myTextView.font constrainedToSize:maximumLabelSize lineBreakMode:myTextView.lineBreakMode]; 
    
    tempFrame = myTextView.frame;
    tempFrame.size.height = expectedLabelSize.height;
    tempFrame.origin.y=TOP_MARGIN;
    myTextView.frame = tempFrame;
    
    height+=TOP_MARGIN+tempFrame.size.height;
    
    //indicator
    tempFrame = myActivityIndicator.frame;
    tempFrame.origin.y=height+MARGIN_BETWEEN;
    myActivityIndicator.frame = tempFrame;
}
*/
#pragma mark - methods
-(void) waitingStart
{
    //[self configureView];
    
    [myActivityIndicator startAnimating];
}

-(void) waitingStop
{
    [myActivityIndicator stopAnimating];
}

-(BOOL) isAnimating
{
    return [myActivityIndicator isAnimating];
}

@end
