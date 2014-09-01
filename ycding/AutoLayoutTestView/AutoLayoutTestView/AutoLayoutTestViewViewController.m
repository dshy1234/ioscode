//
//  AutoLayoutTestViewViewController.m
//  AutoLayoutTestView
//
//  Created by rayzhang on 6/14/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import "AutoLayoutTestViewViewController.h"
@implementation AutoLayoutTestViewViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    CTTestView *testView = [[CTTestView alloc] initWithFrame:CGRectInset(self.view.bounds, 100, 200) ];
    testView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testView];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
