//
//  GlobalData.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define NSObjectReleaseToNil(a)	\
do {						\
if (a != nil) {			\
[a release];			\
a = nil;				\
}						\
} while(false)

#define CFReleaseToNULL(a)  		\
do { 				\
if (a != NULL) {		\
CFRelease(a);		\
a = NULL;		\
}				\
} while(false)

#pragma mark NSSORG_EVENT
#define NSSORG_EVENT_SHOW_WINDOW				@"NSSORG_EVENT_SHOW_WINDOW"

#pragma mark NSSORG_EVENT
//#define KEY_NAME				@"NSSORG_EVENT_SHOW_WINDOW"


@interface GlobalData : NSObject {
}
+ (void)SetSSOrgKeyWindow:(int)sender;
+ (int)GetSSOrgKeyWindow;
@end
