    //
//  HardFlipperController.m
//  HardFlipper
//
//  Created by guoyu on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HardFlipperController.h"


@implementation HardFlipperController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    flipperView = [[HardFlipperView alloc] initWithFrame:self.view.bounds];
	flipperView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:flipperView];
    
	flipperView.dataSource = self;
	flipperView.delegate = self;
	[flipperView loadInitPage];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [flipperView release];
    [super dealloc];
}

#pragma mark - HardFlipperViewDataSource, HardFlipperViewDelegate
//
//
- (NSUInteger) numberOfPagesInFlipperView:(HardFlipperView*)hfView {
    return (0);
}
//
//
- (void) renderPageAtIndex:(NSUInteger)index context:(CGContextRef)ctx {
    return;
}



@end
