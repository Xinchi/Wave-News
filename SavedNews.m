//
//  SavedNews.m
//  WaveNews
//
//  Created by GUYU XUE on 31/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import "SavedNews.h"
#import "AbsDisplay.h"
#import "UIImageView+WebCache.h"

@implementation SavedNews

@synthesize newsList;
@synthesize absDisplay;
@synthesize viewColor;
@synthesize viewColor2;

- (void) dealloc
{
    [absDisplay release];
    [newsList release];
    [viewColor release];
    [viewColor2 release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    /*
     titleFrame=CGRectMake(5, 5, 300, 30);
     dateFrame=CGRectMake(5, 35, 200, 15);
     imageFrame=CGRectMake(10, 10, 45, 40);
     */
    
    viewColor=[[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] retain];
    viewColor2=[[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1] retain];
    
    [(UITableView *)self.view setSeparatorColor:[UIColor clearColor]];
    
    isChanged=NO;
    
    //navigation bar
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backButtonInact.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrevPage:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(2, 2, 28, 28)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
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
    
    newsList=[[self retrieveNews] retain];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(isChanged)
    {
        NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *myDocPath = [myPaths objectAtIndex:0];
        NSString *filePath = [myDocPath stringByAppendingPathComponent:@"savedNews.plist"];
        
        [newsList writeToFile:filePath atomically:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            ||  interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            ||  interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    UIColor *thisCellColor;
    
    if(([indexPath section]+[indexPath row])%2==0)
    {
        thisCellColor=viewColor;
    }
    else
    {
        thisCellColor=viewColor2;
    }
    
    [[self.tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:thisCellColor];
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *curNews=[[newsList objectAtIndex:[indexPath row]] retain];
    
    /*
     if([[curNews objectForKey:@"media"] count]==0)
     {
     titleFrame.origin.x=5;
     dateFrame.origin.x=5;
     }
     else
     {
     titleFrame.origin.x=65;
     dateFrame.origin.x=65;
     titleFrame.size.width-=65;
     
     imageFrame.origin.x=10;
     imageFrame.origin.y=10;
     }
     */
    
    int title_x=5, title_y=5, date_x=5, date_y=55, image_x=0, image_y=0;
    int title_width=300, title_height=50;
    int date_width=200, date_height=15;
    int image_width=65, image_height=60;
    
//    if([[curNews objectForKey:@"media"] count]==0)
//    {
//        title_x=5;
//        date_x=5;
//    }
//    else
//    {
        title_x=85;
        date_x=85;
        title_width-=85;
        
        image_x=10;
        image_y=10;
//    }
    
    //title
    //UILabel *titleLabel=[[[UILabel alloc] initWithFrame:titleFrame] autorelease];
    UILabel *titleLabel;
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        titleLabel=[[[UILabel alloc] initWithFrame:CGRectMake(title_x, title_y, 230, title_height)] autorelease];
    }
    else
    {
        titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(title_x, title_y, 360, title_height)] autorelease];
    }
    titleLabel.font=[UIFont fontWithName:@"Arial" size:16.0];
    titleLabel.backgroundColor=thisCellColor;
    titleLabel.textAlignment=UITextAlignmentLeft;
    titleLabel.numberOfLines=2;
    titleLabel.baselineAdjustment=UIBaselineAdjustmentNone;
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.adjustsFontSizeToFitWidth=FALSE;
    titleLabel.lineBreakMode=UILineBreakModeTailTruncation;
    titleLabel.text=[curNews objectForKey:@"title"];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:titleLabel];
    
    //date
    //UILabel *dateLable=[[[UILabel alloc] initWithFrame:dateFrame] autorelease];
    UILabel *dateLable=[[[UILabel alloc] initWithFrame:CGRectMake(date_x, date_y, date_width, date_height)] autorelease];
    dateLable.font=[UIFont systemFontOfSize:12.0];
    dateLable.backgroundColor=thisCellColor;
    dateLable.textAlignment=UITextAlignmentLeft;
    dateLable.textColor=[UIColor grayColor];
    //titleLabel.adjustsFontSizeToFitWidth=TRUE;
    //titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    
    NSDate *dateOfNews=[curNews objectForKey:@"saveDate"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:dateOfNews];
    NSInteger day = [components day];    
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSString *dateString=[NSString stringWithFormat:@"saved on %d-%d-%d",year,month,day];
    
    dateLable.text=dateString;
    
    [cell.contentView addSubview:dateLable];
    
    //image
    UIImageView *labelImage=[[[UIImageView alloc] initWithFrame:CGRectMake(image_x, image_y, image_width, image_height)] autorelease];
    if([[curNews objectForKey:@"media"] count]!=0)
    {
        NSArray *urls=[curNews objectForKey:@"media"];
        
        NSURL *tempUrl=[NSURL URLWithString:[urls objectAtIndex:0]];
        
        NSLog(@"AAAAAAAAAAAAAAAAA");
        
        [labelImage setImageWithURL:tempUrl placeholderImage:[UIImage imageNamed:@"black.jpg"]];
        
    }
    else
    {
        [labelImage setImage:[UIImage imageNamed:@"logo-2.png"]];
    }
    
    [cell.contentView addSubview:labelImage];

    [curNews release];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support editing the table view.
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray *tempNewsList=[NSMutableArray arrayWithArray:newsList];
        
        [tempNewsList removeObjectAtIndex:[indexPath row]];
        
        [newsList release];
        newsList=[[NSArray alloc] initWithArray:tempNewsList];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        isChanged=YES;
        
        [self.tableView reloadData];
    }   
}
 */

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *thisCellColor;
    
    if(([indexPath section]+[indexPath row])%2==0)
    {
        thisCellColor=viewColor;
    }
    else
    {
        thisCellColor=viewColor2;
    }
    
    [cell setBackgroundColor:thisCellColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    absDisplay=[[AbsDisplay alloc] init];
    
    absDisplay.newsInfo=(NSDictionary *)[newsList objectAtIndex:[indexPath row]];
    
    [self.navigationController pushViewController:absDisplay animated:YES];
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *titleView;
    
    titleView=[[self.tableView cellForRowAtIndexPath:indexPath].contentView.subviews objectAtIndex:0];
    
    if(titleView && titleView.frame.size.height==50)
    {
        CGRect tempRect=titleView.frame;
        
        tempRect.size.width-=50;
        
        titleView.frame=tempRect;
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *titleView;
    
    titleView=[[self.tableView cellForRowAtIndexPath:indexPath].contentView.subviews objectAtIndex:0];
    
    if(titleView && titleView.frame.size.height==50)
    {
        CGRect tempRect=titleView.frame;
        
        tempRect.size.width+=50;
        
        titleView.frame=tempRect;
    }
}

#pragma mark - my methods
-(NSArray *)retrieveNews
{
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    NSString *filePath = [myDocPath stringByAppendingPathComponent:@"savedNews.plist"];
    
    NSArray *temp=[NSArray arrayWithContentsOfFile:filePath];
    
    return temp;
}

-(IBAction) backToPrevPage:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
