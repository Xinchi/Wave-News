//
//  NewsSelection.m
//  Wave News
//
//  Created by Max Gu on 1/14/12.
//  Copyright (c) 2012 guxinchi2000@gmail.com. All rights reserved.
//

#import "NewsSelection.h"

@implementation NewsSelection
@synthesize navBar;
@synthesize viewController;
@synthesize newsSite;
@synthesize rearViewController;

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
    NSLog(newsSite);
    navBar.topItem.title = newsSite;

    // Do any additional setup after loading the view from its nib.
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backButtonInact.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrevPage:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(2, 2, 28, 28)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

}

- (void)backToPrevPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
        return [[viewController.database objectForKey:newsSite] count];
//    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.text = [[[viewController.database objectForKey:newsSite] allKeys] objectAtIndex:indexPath.row];
//    cell.textLabel.text = @"Hello";
    
    //check if the section exists in the NewsCategories
    
    BOOL sectionExists = NO;
    NSArray *sectionNamesArray;
    for(int i=0;i<[viewController.NewsCategories count];i++)
    {
        if([[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:navBar.topItem.title])
        {
            sectionNamesArray = [[viewController.NewsCategories objectAtIndex:i]objectAtIndex:1];
            break;
        }
    }
    for(int i=0;i<[sectionNamesArray count];i++)
    {
        if([[sectionNamesArray objectAtIndex:i] isEqual:cell.textLabel.text])
            sectionExists = YES;
    }
    
    if(sectionExists == YES)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    NSArray *sectionNamesArray;
    for(int i=0;i<[viewController.NewsCategories count];i++)
    {
        if([[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:navBar.topItem.title])
        {
            sectionNamesArray = [[viewController.NewsCategories objectAtIndex:i]objectAtIndex:1];
            break;
        }
    }

    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
        //check if the section already exist
        BOOL sectionAlreadyExist = NO;
        
        for(int i=0;i<[sectionNamesArray count];i++)
        {
            if([[sectionNamesArray objectAtIndex:i] isEqual:cell.textLabel.text])
                sectionAlreadyExist = YES;
        }
        
        if(sectionAlreadyExist == NO)
        {
            for(int i=0;i<[viewController.NewsCategories count];i++)
            {
                if([[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:navBar.topItem.title])
                {
                    [[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:1] addObject:cell.textLabel.text];
                    NSLog(@"NewsCategories   %d", [[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:1]count]);
                    NSLog(@"CopyOfNewsCategories   %d", [[[viewController.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1]count]);
                    
                    //testing
                    NSArray *sectionNamesArray;
                    for(int i=0;i<[viewController.CopyOfNewsCategories count];i++)
                    {
                        if([[[viewController.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:viewController.currentSite])
                        {
                            sectionNamesArray = [[viewController.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1];
                            //                break;
                        }
                    }
                    NSLog(@"sectionNamesArray    %d", [sectionNamesArray count]);



                }
            }

        }


        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        for(int i=0;i<[sectionNamesArray count];i++)
        {
            if([[sectionNamesArray objectAtIndex:i] isEqual:cell.textLabel.text])
            {
                for(int i=0;i<[viewController.NewsCategories count];i++)
                {
                    if([[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:navBar.topItem.title])
                    {
                        [[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:1] removeObject:cell.textLabel.text];
                        
                        NSLog(@"NewsCategories   %d", [[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:1]count]);
                        NSLog(@"CopyOfNewsCategories   %d", [[[viewController.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1]count]);
                        
                        //testing
                        NSArray *sectionNamesArray;
                        for(int i=0;i<[viewController.CopyOfNewsCategories count];i++)
                        {
                            if([[[viewController.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:viewController.currentSite])
                            {
                                sectionNamesArray = [[viewController.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1];
                                //                break;
                            }
                        }
                        NSLog(@"sectionNamesArray    %d", [sectionNamesArray count]);
                        
                    }
                }

            }
        }
    }
}


- (void)dealloc {
    [navBar release];
    [super dealloc];
}
- (IBAction)Go:(id)sender {
    
    NSLog(@"Go button pushed");
    
    NSArray *NewsIdentification;
    for(int i=0;i<[viewController.CopyOfNewsCategories count];i++)
    {
        if([[[viewController.NewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:newsSite])
        {
            NewsIdentification = [[viewController.NewsCategories objectAtIndex:i]objectAtIndex:1];
            //                break;
        }
    }
    NSLog(@"After selection, %d sections", [NewsIdentification count]);
    
    
    if([NewsIdentification count] == 0)
    {
        
        NSString *alertTitle = [NSString stringWithFormat:@"0 news section has been selected",viewController.currentSite];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Opps..."
                                                          message:alertTitle                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

    }
    else
    {
        [viewController.navigationController.parentViewController revealToggle];
        
        if(viewController.isRefreshing == NO)
        {
            viewController.currentSite =newsSite;
            viewController.isInWaveForm = YES;
            [viewController.tabBar setSelectedItem:viewController.TabOfWaveForm];

            NSLog(@"Now in the news selection after pressing go button, %@ has been pushed", viewController.currentSite);
            [viewController refresh];
            [rearViewController.table reloadData];
        }
        else
        {
            NSLog(@"Sorry");
            
            NSString *alertTitle = [NSString stringWithFormat:@"%@ is still loading",viewController.currentSite];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Wait..."
                                                              message:alertTitle                                                         delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
            
            
            
        }

    }

    
    
}
- (IBAction)go:(id)sender {
    NSLog(@"go button pressed");
}
@end
