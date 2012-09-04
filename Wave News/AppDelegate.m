//
//  AppDelegate.m
//  Wave News
//
//  Created by Max Gu on 12/30/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "OpenFlowViewController.h"
#import "ZUUIRevealController.h"
#import "RearViewController.h"


@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation AppDelegate

@synthesize localNotif;
@synthesize window = _window;
@synthesize coverFlow = _coverFlow;
@synthesize viewController = _viewController;
@synthesize newsList;

- (void)dealloc
{
    [_window release];
    [_coverFlow release];
    [super dealloc];
}

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:@"RWHAZ7QW1AH672CFI64D"];
    [FlurryAnalytics setUserID:@"USER_ID"];
    [FlurryAnalytics setAge:21];
    [FlurryAnalytics setGender:@"m"];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    //    UINavigationController *nav = [[UINavigationController alloc] init];
    //    self.coverFlow = [[[OpenFlowViewController alloc] initWithNibName:@"OpenFlowViewController" bundle:nil] autorelease];
    //    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    //    [nav pushViewController:self.viewController animated:NO];
    //    self.window.rootViewController = nav;
    //    [self.window makeKeyAndVisible];
    //    return YES;
    
    ViewController *frontViewController;
	RearViewController *rearViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
		frontViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
		rearViewController = [[RearViewController alloc] initWithNibName:@"RearViewController_iPhone" bundle:nil];
	}
	else
	{
        //for future iPad use
	}
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    UINavigationController *navBack = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    ZUUIRevealController *revealController = [[ZUUIRevealController alloc] initWithFrontViewController:navigationController rearViewController:navBack];
    revealController.nav = navigationController;
	self.viewController = revealController;
    frontViewController.revealController = revealController;
    revealController.delegate = frontViewController;
    rearViewController.viewController = frontViewController;
    
    
    
    
    
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        //        NSString *itemName = [localNotif.userInfo objectForKey:ToDoItemKey];
        //        [viewController displayItem:itemName];  // custom method
        NSLog(@"Now cancelling the badge");
        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
    }
    
	
	[navigationController release];
	[frontViewController release];
	[rearViewController release];
	[revealController release];
    
    
    
    
    self.window.rootViewController = self.viewController;
//    self.window.rootViewController = frontViewController;
	[self.window makeKeyAndVisible];
    
    
    RSSParser *rss = [[RSSParser alloc] init];
    
    newsList = [rss getRssRawData:@"http://feeds.latimes.com/MostEmailed?format=xml" newspaper:@"LOS ANGELES TIMES" section:@"MOST EMAILED"];
    
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    //
    //    self.window.rootViewController = navigationController;
    //    [self.window makeKeyAndVisible];
    //    return YES;
    
    OffLineMode *offlineMode = [[OffLineMode alloc] init];
    [offlineMode startTestNetwork];
    return YES;
    
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //        application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber-1;
    application.applicationIconBadgeNumber += 1;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    NSDate *itemDate = [NSDate date];
//    localNotif = [[UILocalNotification alloc] init];
//    if (localNotif == nil)
//        return;
//    localNotif.fireDate = [itemDate addTimeInterval:-(10)];
//    localNotif.timeZone = [NSTimeZone localTimeZone];
//    localNotif.repeatInterval = NSDayCalendarUnit;
//    
//    localNotif.alertBody =[[newsList objectAtIndex:0] objectForKey:@"title"];
//    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
//    
//    localNotif.soundName = UILocalNotificationDefaultSoundName;
//    localNotif.applicationIconBadgeNumber += 1;
//    
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"MOST EMAILED" forKey:@"LOS ANGELES TIMES"];
//    localNotif.userInfo = infoDict;
//    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
