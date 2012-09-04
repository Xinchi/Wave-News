//
//  SavedNews.h
//  WaveNews
//
//  Created by GUYU XUE on 31/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AbsDisplay;

@interface SavedNews : UITableViewController
{
    NSArray *newsList;
    
    //next view
    AbsDisplay *absDisplay;
    
    //helpter
    BOOL isChanged;
    UIColor *viewColor;
    UIColor *viewColor2;
    
    /*
    CGRect titleFrame;
    CGRect dateFrame;
    CGRect imageFrame;
     */
}

@property (nonatomic, retain) NSArray *newsList;
@property (nonatomic, retain) AbsDisplay *absDisplay;
@property (nonatomic, retain) UIColor *viewColor;
@property (nonatomic, retain) UIColor *viewColor2;

-(NSArray *)retrieveNews;
-(IBAction)backToPrevPage:(id)sender;

@end
