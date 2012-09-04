//
//  ViewController.m
//  Open Flow
//
//  Created by Max Gu on 12/26/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import "OpenFlowViewController.h"

@implementation OpenFlowViewController
@synthesize viewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	// loading images into the queue
    
	loadImagesOperationQueue = [[NSOperationQueue alloc] init];
    
	NSString *imageName;
	for (int i=0; i<10; i++) {
//		imageName = [[NSString alloc] initWithFormat:@"cover_%d.jpg", i];
        imageName = @"try.jpg";
		[(AFOpenFlowView *)self.view setImage:[UIImage imageNamed:imageName] forIndex:i];
		[imageName release];
		NSLog(@"%d is the index",i);
        ((AFOpenFlowView *)self.view).viewDelegate = self;
        ((AFOpenFlowView *)self.view).dataSource = self;

	}
	[(AFOpenFlowView *)self.view setNumberOfImages:10];
}

//delegate protocols

// delegate protocol to tell which image is selected
- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index{
    
	NSLog(@"%d is selected",index);
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView click:(int)index
{
    NSLog(@"%d is clicked", index);
    viewController.currentSite = @"NEW YORK TIMES";
    [viewController displayNews];
    [self.navigationController popViewControllerAnimated:YES];
}

// setting the image 1 as the default pic
- (UIImage *)defaultImage{
    
	return [UIImage imageNamed:@"cover_1.jpg"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
