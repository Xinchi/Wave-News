//
//  OffLineMode.m
//  WaveNews
//
//  Created by GUYU XUE on 29/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import "OffLineMode.h"
#import "Reachability.h"

@implementation OffLineMode
{
    BOOL alerted;
}

@synthesize internetReachable;
@synthesize hostReachable;

-(void) dealloc
{
    NSLog(@"end");
    
    [internetReachable release];
    [hostReachable release];
    [super dealloc];
}

+(BOOL) isConnected
{
    Reachability *tempTest=[[Reachability reachabilityForInternetConnection] retain];
    [tempTest startNotifier];
    
    NetworkStatus internetStatus = [tempTest currentReachabilityStatus];
    
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            return FALSE;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"Connected!");

            return TRUE;
            
            break;
        }
        case ReachableViaWWAN:
        {
            
            return TRUE;
            
            break;
        }
        default:
        {
            return FALSE;
        }
    }

    [tempTest release];
}

#pragma mark - notify network change
-(void) startTestNetwork
{
    NSLog(@"++++++++++start");
    alerted = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:)name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName:@"www.google.com"] retain];
    [hostReachable startNotifier];
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            if(alerted==NO)
            {
                NSLog(@"The internet is down.");
                NSString *alertTitle = @"Please check if you have internet access.";
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network disconnected..."
                                                                  message:alertTitle                                                         delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                
                [message show];
                alerted = YES;
            }

            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            
             
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            
             
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            
             
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            
            break;
            
        }
    }
}
 
#pragma mark - get saved news
+(NSArray *) getStoredNews:(NSString *) newspaper withSection:(NSString *) section
{
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    
    newspaper=[newspaper stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    section=[section stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSString *fileName=[NSString stringWithFormat:@"%@_%@.plist",newspaper,section];
    
    NSString *filePath = [myDocPath stringByAppendingPathComponent:fileName];
    
    BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if(!fileExists)
    {
        return nil;
    }
    
    NSArray *resultToReturn=[NSArray arrayWithContentsOfFile:filePath];
    
    return resultToReturn;
}

@end
