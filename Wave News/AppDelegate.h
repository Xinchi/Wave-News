//
//  AppDelegate.h
//  Wave News
//
//  Created by Max Gu on 12/30/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenFlowViewController.h"
#import "OffLineMode.h"
//#import "FlurryAnalytics.h"

//@class ViewController;
@class ZUUIRevealController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) OpenFlowViewController *coverFlow;
@property (strong, nonatomic) ZUUIRevealController *viewController;
@property (nonatomic,retain) NSArray *newsList;
@property (nonatomic, retain)     UILocalNotification *localNotif;

@end
