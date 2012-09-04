//
//  NewsSelection.h
//  Wave News
//
//  Created by Max Gu on 1/14/12.
//  Copyright (c) 2012 guxinchi2000@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "RearViewController.h"
@class RearViewController;
@interface NewsSelection : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) ViewController *viewController;
@property (retain, nonatomic) NSString *newsSite;
@property (retain, nonatomic) RearViewController *rearViewController;
- (IBAction)go:(id)sender;
@end
