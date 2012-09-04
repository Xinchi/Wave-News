//
//  ViewController.h
//  Wave News
//
//  Created by Max Gu on 12/30/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSParser.h"
#import "PullRefreshTableViewController.h"
#import "AbsDisplay.h"
#import "HeaderCell.h"
#import "OpenFlowViewController.h"
#import "SavedNews.h"
#import <iAd/iAd.h>
#import "MBProgressHUD.h"
#import "ZUUIRevealController.h"

//#import "TableViewCell.h"

@class TableViewCell;
@class TableFormCell;
@class ZUUIRevealController;

@interface ViewController : PullRefreshTableViewController <ADBannerViewDelegate, UITabBarDelegate>
{
    NSArray *dataArray;
    TableViewCell *tableViewCellWithTableView;
    HeaderCell *headerCell;
    //    NSString *currentSite;
    NSMutableArray *NewsCategories;
    NSDictionary *database;
    NSInteger sitesLimit;
    NSInteger fieldsLimit;
    NSMutableDictionary *urlSource;
    NSArray *newsList;
    BOOL isloading;
    //    NSMutableDictionary *newsContentsDic;
    SavedNews *savedNews;
    MBProgressHUD *_hud;
}

@property BOOL isInWaveForm;
@property (retain) MBProgressHUD *hud;
@property BOOL isloading;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet TableViewCell *tableViewCellWithTableView;

@property (retain, nonatomic) IBOutlet HeaderCell *headerCell;
@property (nonatomic, retain) NSString *currentSite;
@property (nonatomic, retain) NSMutableArray *NewsCategories;
@property (nonatomic, retain) NSMutableArray *CopyOfNewsCategories;
@property (nonatomic, retain) NSDictionary *database;
@property NSInteger sitesLimit;
@property NSInteger fieldsLimit;
@property (nonatomic, retain) NSMutableDictionary *urlSource;
@property (nonatomic, retain) NSArray *newsList;
@property (nonatomic, retain) NSMutableDictionary *newsContentsDic;
@property (nonatomic, retain) SavedNews *savedNews;
@property BOOL isRefreshing;
//@property (retain, nonatomic) IBOutlet UIScrollView *navigator;
@property (retain, nonatomic) IBOutlet UIImageView *bakImgView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (retain, nonatomic) ZUUIRevealController *revealController;
@property (retain, nonatomic) AbsDisplay *display;
@property (retain, nonatomic) IBOutlet UITabBarItem *TabOfWaveForm;


- (IBAction)navigationPressed:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UITabBarItem *TabOfTableForm;

@property (retain, nonatomic) IBOutlet UIScrollView *navigator;
@property (retain, nonatomic) IBOutlet TableFormCell *TableFormCell;
@property BOOL enableADCountDown;

- (void)buttonPressed:(id)sender;


@end