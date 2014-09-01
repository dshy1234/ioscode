//
//  SecondViewController.m
//  CEBXReaderDemo
//
//  Created by Ray Zhang on 12/6/11.
//  Copyright 2011 Flower Bridge Technology. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
- (void)centerImageAndTitle:(float)spacing
{
  // get the size of the elements here for readability
  CGSize imageSize = testbtn.imageView.frame.size;
  CGSize titleSize = testbtn.titleLabel.frame.size;
  
  // get the height they will take up as a unit
  CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
  
  // raise the image and push it right to center it
  testbtn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
  
  // lower the text and push it left to center it
  testbtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
//  testbtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0, 20.0);

}

- (void)centerImageAndTitle
{
  const int DEFAULT_SPACING = 6.0f;
  [self centerImageAndTitle:DEFAULT_SPACING];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self centerImageAndTitle];
  //    [self a];
  //    NSLog(@"%d",[testString retainCount]);
  
  
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
