//
//  LoadURLAppDelegate.m
//  LoadURL
//
//  Created by rayzhang on 3/26/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import "LoadURLAppDelegate.h"
#import "ShowView.h"
#import "fgcycyg.h"
@implementation LoadURLAppDelegate


@synthesize window=_window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    ShowView *showView = [[ShowView alloc] init];
//    [self.window addSubview:showView.view];
    NSMutableDictionary * aa = [[NSMutableDictionary alloc] init];
    [aa setValue:@"aa" forKey:@"aa"];
    [aa setValue:@"bb" forKey:@"bb"];
    [aa setValue:@"cc" forKey:@"cc"];
    NSArray *aaa = [aa allKeys];
    [aa removeObjectForKey:@"aa"];
    NSArray *bbb = [aa allKeys];
    
    
    
//    self.window.rootViewController = viewController;
    fgcycyg *bbbbbbbbbbb = [[fgcycyg alloc] init];
    self.window.rootViewController = bbbbbbbbbbb;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
