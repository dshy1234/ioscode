//
//  TableMenuAppDelegate.h
//  TableMenu
//
//  Created by apple on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableMenuViewController;

@interface TableMenuAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TableMenuViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TableMenuViewController *viewController;

@end

