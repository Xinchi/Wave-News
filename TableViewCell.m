//
//  TableViewCell.m
//  Wave News
//
//  Created by Max Gu on 12/30/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AbsDisplay.h"

@implementation TableViewCell

@synthesize tableViewInsideCell;
@synthesize data;
@synthesize bt;
@synthesize intOfRowForTagOfTheButton;
@synthesize viewController;

- (void)dealloc {
    [data release];
    [tableViewInsideCell release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    //    Remove the original subview
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    //    cell.textLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    //load img
    CGRect ButtonSize = CGRectMake(0, 0, 100, 100);
    bt = [[UIButton alloc] initWithFrame:ButtonSize];
    //
//    bt.layer.cornerRadius = 8.0f;
//    bt.layer.masksToBounds = NO;
//    bt.layer.borderWidth = 1.0f;
//    
//    bt.layer.shadowColor = [UIColor blackColor].CGColor;
//    bt.layer.shadowOpacity = 0.8;
//    bt.layer.shadowRadius = 4;
//    bt.layer.shadowOffset = CGSizeMake(6.0f, 6.0f);
    //
    NSString *newsURL;
    CGAffineTransform rotateImage = CGAffineTransformMakeRotation(M_PI_2);
    bt.transform = rotateImage;
    UILabel *label;
    if([[[data objectAtIndex:indexPath.row] objectForKey:@"media"] count] > 0)
    {
        newsURL = [[[data objectAtIndex:indexPath.row] objectForKey:@"media"] objectAtIndex:0];
//        NSLog(newsURL);
        [bt setImageWithURL:[NSURL URLWithString:newsURL] placeholderImage:[UIImage imageNamed:@"black.jpg"]];
        bt.imageView.contentMode = UIViewContentModeScaleAspectFill;
        bt.contentMode = UIViewContentModeScaleToFill;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0,55,100,45)];
        [label setFont:[UIFont boldSystemFontOfSize:11]]; 

        label.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        //self.label.font = [UIFont boldSytemFontofSize:8];
        //            self.label.textAlignment = UITextAlignmentCenter;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 5;
    }
    else
    {
        label = [[UILabel alloc ] initWithFrame:CGRectMake(5, 10, 90, 60)];
        [label setFont:[UIFont boldSystemFontOfSize:11]]; 
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = UILineBreakModeClip;
        label.numberOfLines = 8;
        UILabel *breaker = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 30, 1)];
        breaker.backgroundColor = [UIColor whiteColor];
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 85, 90, 10)];
        [authorLabel setFont:[UIFont boldSystemFontOfSize:7]]; 
        authorLabel.backgroundColor = [UIColor clearColor];
        authorLabel.textColor=[UIColor blueColor];
        authorLabel.text = (NSString *)[[data objectAtIndex:indexPath.row] objectForKey:@"author"];
        [bt addSubview:authorLabel];
        [bt addSubview:breaker];
        [breaker release];
        [authorLabel release];


    }

    int a = intOfRowForTagOfTheButton;
    int b = indexPath.row;
    int c = 100*a+b;
    NSInteger *tag = (NSInteger)c;
    [bt setTag:tag];
    [bt addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.textColor=[UIColor whiteColor];
    label.text = (NSString *)[[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    [bt addSubview:label];
    [label release];
    
    [cell.contentView addSubview:bt];
    [bt release];
    return cell;
}

- (void)buttonPressed:(id)sender
{
    [viewController buttonPressed:sender];
}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}

-(void)refresh
{
    NSLog(@"Refreshing");
}

@end