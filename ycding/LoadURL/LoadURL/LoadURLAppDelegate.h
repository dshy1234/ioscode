//
//  LoadURLAppDelegate.h
//  LoadURL
//
//  Created by rayzhang on 3/26/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowView.h"
@interface LoadURLAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIViewController *viewController;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;

@end
