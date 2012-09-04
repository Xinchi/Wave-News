//
//  TableViewCell.h
//  Wave News
//
//  Created by Max Gu on 12/30/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "PullRefreshTableViewController.h"

@interface TableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource> {
    NSArray *data;
    NSString *urlString;
    UIButton *bt;
    NSInteger *intOfRowForTagOfTheButton;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewInsideCell;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) UIButton *bt;
@property NSInteger *intOfRowForTagOfTheButton;
@property ViewController *viewController;


@end