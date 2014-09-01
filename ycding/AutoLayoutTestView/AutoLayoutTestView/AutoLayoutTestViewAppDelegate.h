//
//  AutoLayoutTestViewAppDelegate.h
//  AutoLayoutTestView
//
//  Created by rayzhang on 6/14/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoLayoutTestViewViewController;

@interface AutoLayoutTestViewAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AutoLayoutTestViewViewController *viewController;

@end
