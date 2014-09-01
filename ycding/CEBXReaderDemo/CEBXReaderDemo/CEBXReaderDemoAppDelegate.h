//
//  CEBXReaderDemoAppDelegate.h
//  CEBXReaderDemo
//
//  Created by Ray Zhang on 12/6/11.
//  Copyright 2011 Flower Bridge Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEBXReaderDemoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
