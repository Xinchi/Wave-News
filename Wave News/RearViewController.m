/* 
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may 
 be used to endorse or promote products derived from this software 
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "RearViewController.h"

@interface RearViewController()

// Private Properties:
@property BOOL firstTimeLoading;
// Private Methods:

@end

@implementation RearViewController
@synthesize table;
@synthesize searchBar;
@synthesize viewController;
@synthesize newsSelection;
@synthesize firstTimeLoading;
@synthesize lastSelectedCell;
@synthesize searchController;
@synthesize searchResultArray;
@synthesize picker;

- (void) viewDidLoad
{
//    rearViewController = [[RearViewController alloc] initWithNibName:@"RearViewController_iPhone" bundle:nil];
    firstTimeLoading = YES;
    
    //set up search bar
    searchBar.frame = CGRectMake(0, 0, 261, 44);
    searchBar.delegate = self;

    searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
        
//    [searchController setActive:YES animated:YES];
    
    UIImageView* back = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    back.image = [UIImage imageNamed:@"logo.png"];
    back.contentMode = UIViewContentModeLeft;
    
    
    //    [self.navigationController.navigationBar insertSubview:backgroundImage atIndex:0];
    
    [self.navigationController.navigationBar setBackgroundImage:back.image forBarMetrics:UIBarMetricsDefault];
    
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationController.navigationBar.layer.shadowOpacity = 1;
    self.navigationController.navigationBar.layer.shadowRadius = 2.0;


}
#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    searchBar.frame = CGRectMake(0, 0, 261, 44);
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    searchBar.frame = CGRectMake(0, 0, 261, 44);

}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    searchBar.frame = CGRectMake(0, 0, 261, 44);

}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    searchBar.frame = CGRectMake(0, 0, 261, 44);
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchResultArray = [[NSMutableArray alloc] initWithCapacity:100];
    NSLog(searchText);
    NSRange textRange;
    for(int i=0;i<[viewController.NewsCategories count];i++)
    {
        textRange =[[[[viewController.NewsCategories objectAtIndex:i] objectAtIndex:0] lowercaseString] rangeOfString:[searchText lowercaseString]];
        if(textRange.location != NSNotFound)
        {
            NSLog(@"Found!");
            [searchResultArray addObject:[[viewController.NewsCategories objectAtIndex:i] objectAtIndex:0]];
        }
        [searchController.searchResultsTableView reloadData];
        
    }
    NSLog(@"%d",[searchResultArray count]);

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(tableView == self.table)
    return 3;
    else 
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == self.table)
    {
        if(section == 0)
            return 13;
        //    return 10;
        else if(section ==1)
            return [viewController.NewsCategories count]-13;
        else
            return 1;
    }

    else     {
        return [searchResultArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(tableView == self.table)
    {
        if(indexPath.section == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            cell.textLabel.text = [[viewController.NewsCategories objectAtIndex:indexPath.row] objectAtIndex:0];
            
            if([cell.textLabel.text isEqualToString:viewController.currentSite])
            {
                cell.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
                lastSelectedCell = cell;
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        else if(indexPath.section ==1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            cell.textLabel.text = [[viewController.NewsCategories objectAtIndex:indexPath.row+13] objectAtIndex:0];
            if([cell.textLabel.text isEqualToString:viewController.currentSite])
            {
                cell.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
                lastSelectedCell = cell;
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
            
        }
        else
        {
            cell.textLabel.text = @"               E-mail us";
//            cell.textLabel.textAlignment = UITextAlignmentRight;

            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    else
    {
        cell.textLabel.text = [searchResultArray objectAtIndex:indexPath.row];
    }
    
    
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"The %d section and %d row has been tapped", indexPath.section, indexPath.row);
    newsSelection = [[NewsSelection alloc] initWithNibName:@"NewsSelection" bundle:nil];

    newsSelection.newsSite =  [[viewController.NewsCategories objectAtIndex:indexPath.row] objectAtIndex:0];
    newsSelection.viewController = viewController;
    newsSelection.navBar.topItem.title = newsSelection.newsSite;
    [self.navigationController pushViewController:newsSelection animated:YES];
    [newsSelection release];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if(indexPath.section != 2)
    {
        NSLog(@"The %d section and %d row has been tapped", indexPath.section, indexPath.row);
        newsSelection = [[NewsSelection alloc] initWithNibName:@"NewsSelection" bundle:nil];
        
        if(tableView == self.table)
        {
            newsSelection.newsSite =  [[viewController.NewsCategories objectAtIndex:13*indexPath.section+indexPath.row] objectAtIndex:0];
        }
        else
        {
            newsSelection.newsSite = [searchResultArray objectAtIndex:indexPath.row];
            
        }
        newsSelection.viewController = viewController;
        newsSelection.rearViewController = self;
        newsSelection.navBar.topItem.title = newsSelection.newsSite;
        [self.navigationController pushViewController:newsSelection animated:YES];
        [newsSelection release];

    }
    else
    {
        if(![MFMailComposeViewController canSendMail])
        {
            NSLog(@"Your device cannot send email");
            
            return;
        }
        
        picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setModalPresentationStyle:UIModalPresentationFormSheet];
        
        [picker setSubject:@"Wave News"];
        [picker setToRecipients:[NSArray arrayWithObject:@"wavenewsteam@gmail.com"]];
        
        NSString* imageUrl;
        
//        if([[newsInfo objectForKey:@"media"] count]!=0)
//        {
//            imageUrl=[[newsInfo objectForKey:@"media"] objectAtIndex:0];
//        }
//        else
//        {
//            imageUrl=@"http://3.bp.blogspot.com/_A3oFfKDC2E4/TUpcQ5QiVNI/AAAAAAAAJe0/iy6QhTeDxEw/s1600/beautiful+sunrise+3.jpg";
//        }
//        
//        NSString *content=[NSString stringWithFormat:@"<p>I want to share with you this news:</p><hr /><h3><a href=\"%@\">%@</a></h3><br /><img src=\"%@\" width=\"200\" height=\"180\" /><br /><p>%@</p><br /><hr /><h4>About WaveNews</h4><p>WaveNews is a rerolutionary way of reading news</p><p>Click <a href=\"http://www.google.com.sg\">here</a> to see more about WaveNews</p>", [newsInfo objectForKey:@"url"],[newsInfo objectForKey:@"title"],imageUrl,[newsInfo objectForKey:@"description"]];
        
        NSString *content = @"Hi Wave News Team, \n\n\n\n\n\n\n\n\n ";
        [picker setMessageBody:content isHTML:YES];
        
        //    [self.parentView presentModalViewController:picker animated:YES];
        [self presentModalViewController:picker animated:YES];
        //    [picker release];

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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Thanks for your suggestions!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
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




- (void)dealloc {
    [table release];
    [searchBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTable:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end