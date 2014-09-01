//
//  DRMDecodeAppDelegate.h
//  DRMDecode
//
//  Created by Ray Zhang on 12/26/11.
//  Copyright 2011 Flower Bridge Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRMDecodeAppDelegate : NSObject <UIApplicationDelegate> {
    NSOutputStream *fileStream;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
