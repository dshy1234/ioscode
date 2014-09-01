//
//  ShowView.m
//  LoadURL
//
//  Created by Ray Zhang on 7/13/12.
//  Copyright (c) 2012 Flower Bridge Technology. All rights reserved.
//

#import "ShowView.h"

@implementation ShowView
@synthesize urlText,webView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)RefreshWebView:(id)sender{
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlText text]]]];
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlText text]]]];

    // Do any additional setup after loading the view from its nib.
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
