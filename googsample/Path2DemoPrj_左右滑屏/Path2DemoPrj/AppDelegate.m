//
//  AppDelegate.m
//  Path2DemoPrj
//
//  Created by Ethan on 11-12-14.
//  Copyright (c) 2011年 Ethan. All rights reserved.
//  
//  个人承接iOS项目, QQ:44633450 / email: gaoyijun@gmail.com
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;

- (void)dealloc {
    [_window release];
    [_navController release];
    [_leftViewController release];
    [_rightViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // left view
    self.leftViewController = [[[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil] autorelease];
    self.leftViewController.view.frame = CGRectMake(0, 
                                                    20, 
                                                    self.leftViewController.view.frame.size.width, 
                                                    self.leftViewController.view.frame.size.height);
    [self.window addSubview:self.leftViewController.view];
    // right view
    self.rightViewController = [[[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil] autorelease];
    self.rightViewController.view.frame = CGRectMake(320-self.rightViewController.view.frame.size.width, 
                                                     20, 
                                                     self.rightViewController.view.frame.size.width, 
                                                     self.rightViewController.view.frame.size.height);
    [self.window addSubview:self.rightViewController.view];
    // invisible left and right view
    [self.leftViewController setVisible:NO];
    [self.rightViewController setVisible:NO];
    
    // main view (nav)
    [self.window addSubview:self.navController.view];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)makeLeftViewVisible {
    [self.leftViewController setVisible:YES];
    [self.rightViewController setVisible:NO];
}

- (void)makeRightViewVisible {
    [self.rightViewController setVisible:YES];
    [self.leftViewController setVisible:NO];
}

@end
