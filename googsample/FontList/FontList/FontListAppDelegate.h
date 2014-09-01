//
//  FontListAppDelegate.h
//  FontList
//
//  Created by mac on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FontListViewController;
//@class ColorListViewController;
@class TabBarController;

@interface FontListAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UINavigationController *rootController;

@property (nonatomic, retain) IBOutlet FontListViewController *fontListViewController;

//@property (nonatomic, retain) ColorListViewController *colorListViewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
