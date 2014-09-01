
//
//  HardFlipperAppDelegate.h
//  HardFlipper


#import <UIKit/UIKit.h>
#import "ImageFlipperController.h"

@interface HardFlipperAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ImageFlipperController *imageCntrlr;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

