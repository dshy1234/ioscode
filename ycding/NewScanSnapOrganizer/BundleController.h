//
//  BundleController.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainViewController.h"

@interface BundleController : NSObject {
	IBOutlet  MainViewController *_mainController;
	BOOL      m_isStarted;
}
- (void)runORG:(NSArray*)arrFileArray;
- (void)ShowNSSOrgWindow:(NSNotification*)notification;

@end
