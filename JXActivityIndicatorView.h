//
//  JXActivityIndicatorView.h
//  RSSReader
//
//  Created by GUYU XUE on 22/12/11.
//  Copyright (c) 2011 Nanyang Technological University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXActivityIndicatorView : UIViewController
{
    NSString *textInfo;
    
    //view
    IBOutlet UIActivityIndicatorView *myActivityIndicator;
}

@property (nonatomic, retain) NSString *textInfo;
//@property (nonatomic, retain) UILabel *myTextView;
@property (nonatomic, retain) UIActivityIndicatorView *myActivityIndicator;

//-(void) configureView;
//-(void) configureViewRotated;

-(void) waitingStart;
-(void) waitingStop;
-(BOOL) isAnimating;

@end
