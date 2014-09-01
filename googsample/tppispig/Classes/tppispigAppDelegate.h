//
//  tppispigAppDelegate.h
//  tppispig
//
//  Created by gao wei on 10-7-15.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tppispigViewController;

@interface tppispigAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    tppispigViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet tppispigViewController *viewController;

@end

