//
//  NewScanSnapOrganizerAppDelegate.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BundleController.h"

@interface NewScanSnapOrganizerAppDelegate : NSObject{
    NSWindow			*window;
	BundleController	*m_STSFBundleController;
	BOOL				isStarted;
	NSBundle			*m_STSFBundle;
	Class				m_STSFMainClass;
}

@property (assign) IBOutlet NSWindow *window;
- (void)handleBundle:(NSArray*)arrSTSFFileArray;
- (void)handleLaunchedEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent;
@end
