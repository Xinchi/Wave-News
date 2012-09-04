//
//  ViewController.h
//  Open Flow
//
//  Created by Max Gu on 12/26/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"
#import "ViewController.h"

@class ViewController;
@interface OpenFlowViewController : UIViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource>
{
    NSOperationQueue *loadImagesOperationQueue;
    ViewController *viewController;
}

@property (nonatomic, retain) ViewController *viewController;
@end
