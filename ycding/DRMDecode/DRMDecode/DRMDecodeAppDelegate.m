//
//  DRMDecodeAppDelegate.m
//  DRMDecode
//
//  Created by Ray Zhang on 12/26/11.
//  Copyright 2011 Flower Bridge Technology. All rights reserved.
//

#import "DRMDecodeAppDelegate.h"
#import "DRMEncode.h"
#import "NetworkClient.h"


@implementation DRMDecodeAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *relUrlString  = [[NSString alloc] init];
    NSString *cebxUrlString = [[NSString alloc] init];
    NSData   *postData      = [[NSData alloc] init];
    [DRMEncode GetRelFile:&relUrlString CEBXUrlString:&cebxUrlString PostData:&postData];
    NSURL *url =  [NetworkClient smartURLForString:relUrlString];

    
    NetworkClient *networkClient;
    
    networkClient = [[NetworkClient alloc]initWithDelegate:self];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                           @"application/x-www-form-urlencoded",
                                                                           nil] 
                                                                  forKeys:[NSArray arrayWithObjects:
                                                                           @"Content-Type",
                                                                           nil]];
    
    networkClient.clientRequest.url = url;
    networkClient.tag = 0x101;
    [networkClient.clientRequest setRequestHeaders:dic];
    [networkClient startRequest:postData];
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void) client:(NetworkClient *)sender didReceiveData:(int)appID object:(id)object
{
    [fileStream close];    

}
- (void) client:(NetworkClient *)sender didReceiveDataError:(int)appID object:(id)object{
    [fileStream close];    

}
- (void) client:(NetworkClient *)sender didReceiveError:(NSError *)error{
    [fileStream close];    

}
- (void) client:(NetworkClient *)sender didReceiveFinish:(int)appID object:(id)object{
    [fileStream close];
    NSData *responseData = object;
    [DRMEncode ParseRelResponse:responseData];

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
