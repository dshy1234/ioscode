//
//  HomeViewController.m
//  Path2DemoPrj
//
//  Created by Ethan on 11-12-14.
//  Copyright (c) 2011年 Ethan. All rights reserved.
//  
//  个人承接iOS项目, QQ:44633450 / email: gaoyijun@gmail.com
//

#import "HomeViewController.h"
#import "SecondLevelViewController.h"
#import "AppDelegate.h"

#define kTriggerOffSet 100.0f

/////////////////////////////////////
@interface HomeViewController () 
- (void)restoreViewLocation;
- (void)moveToLeftSide;
- (void)moveToRightSide;
- (void)animateHomeViewToSide:(CGRect)newViewRect;
@end

/////////////////////////////////////
@implementation HomeViewController

#pragma mark -
#pragma mark Override touch methods

// Check touch position in this method (Add by Ethan, 2011-11-27)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    touchBeganPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
}

// Scale or move select view when touch moved (Add by Ethan, 2011-11-27)
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    CGFloat xOffSet = touchPoint.x - touchBeganPoint.x;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (xOffSet < 0) {
        [appDelegate makeRightViewVisible];
    }
    else if (xOffSet > 0) {
        [appDelegate makeLeftViewVisible];
    }
    
    self.navigationController.view.frame = CGRectMake(xOffSet, 
                                                      self.navigationController.view.frame.origin.y, 
                                                      self.navigationController.view.frame.size.width, 
                                                      self.navigationController.view.frame.size.height);
}

// reset indicators when touch ended (Add by Ethan, 2011-11-27)
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // animate to left side
    if (self.navigationController.view.frame.origin.x < -kTriggerOffSet) 
        [self moveToLeftSide];
    // animate to right side
    else if (self.navigationController.view.frame.origin.x > kTriggerOffSet) 
        [self moveToRightSide];
    // reset
    else 
        [self restoreViewLocation];
}

#pragma mark -
#pragma mark Other methods

// restore view location
- (void)restoreViewLocation {
    homeViewIsOutOfStage = NO;
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0, 
                                                                           self.navigationController.view.frame.origin.y, 
                                                                           self.navigationController.view.frame.size.width, 
                                                                           self.navigationController.view.frame.size.height);
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
                         [overView removeFromSuperview];
                     }];
}

// move view to left side
- (void)moveToLeftSide {
    homeViewIsOutOfStage = YES;
    [self animateHomeViewToSide:CGRectMake(-290.0f, 
                                           self.navigationController.view.frame.origin.y, 
                                           self.navigationController.view.frame.size.width, 
                                           self.navigationController.view.frame.size.height)];
}

// move view to right side
- (void)moveToRightSide {
    homeViewIsOutOfStage = YES;
    [self animateHomeViewToSide:CGRectMake(290.0f, 
                                           self.navigationController.view.frame.origin.y, 
                                           self.navigationController.view.frame.size.width, 
                                           self.navigationController.view.frame.size.height)];
}

// animate home view to side rect
- (void)animateHomeViewToSide:(CGRect)newViewRect {
    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.navigationController.view.frame = newViewRect;
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = [[UIControl alloc] init];
                         overView.tag = 10086;
                         overView.backgroundColor = [UIColor clearColor];
                         overView.frame = self.navigationController.view.frame;
                         [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                         [overView release];
                     }];
}

// handle push btn
- (IBAction)pushBtnTapped:(id)sender {
    SecondLevelViewController *nextViewController = [[SecondLevelViewController alloc] initWithNibName:@"SecondLevelViewController" 
                                                                                                bundle:nil];
    [self.navigationController pushViewController:nextViewController animated:YES];
    [nextViewController release];
}

// handle left bar btn
- (IBAction)leftBarBtnTapped:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] makeLeftViewVisible];
    [self moveToRightSide];
}

// handle right bar btn
- (IBAction)rightBarBtnTapped:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] makeRightViewVisible];
    [self moveToLeftSide];
}

@end
