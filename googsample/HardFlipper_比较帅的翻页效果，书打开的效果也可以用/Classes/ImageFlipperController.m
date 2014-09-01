    //
//  ImageFlipperController.m
//  HardFlipper
//
//  Created by guoyu on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageFlipperController.h"

CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect)
{
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	CGAffineTransform translation = CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x,(outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}

@implementation ImageFlipperController

- (id) init {
    if (self = [super init]) {
		imageArray = [[NSArray alloc] initWithObjects:
                      [UIImage imageNamed:@"image001.jpg"],
                      [UIImage imageNamed:@"image002.jpg"],
                      [UIImage imageNamed:@"image003.jpg"],
                      [UIImage imageNamed:@"image004.jpg"],
                      [UIImage imageNamed:@"image005.jpg"],
                      nil];
        
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(orientationChanged:)
//                                                     name:UIDeviceOrientationDidChangeNotification
//                                                   object:nil];
    }
    return self;
}

//- (void)orientationChanged:(NSNotification *)notification {
//    NSLog(@"afterOri %@", NSStringFromCGRect(self.view.bounds));
//}


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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
/*
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
*/

- (void)dealloc {
    [imageArray release];
    [super dealloc];
}

#pragma mark - HardFlipperViewDataSource, HardFlipperViewDelegate
//
//
- (NSUInteger) numberOfPagesInFlipperView:(HardFlipperView*)hfView {
    return ([imageArray count]);
}
//
//
- (void) renderPageAtIndex:(NSUInteger)index context:(CGContextRef)ctx {
    UIImage *image = [imageArray objectAtIndex:index];
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGAffineTransform transform = aspectFit(imageRect, CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawImage(ctx, imageRect, [image CGImage]);
}

@end
