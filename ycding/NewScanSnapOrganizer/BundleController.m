//
//  BundleController.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BundleController.h"
#define NIB_NAME						@"NSSOrgBundle"
#import "GlobalData.h"

@implementation BundleController
- (id) init
{
	self = [super init];
	if (self != nil) {
		m_isStarted = NO;
	}
	return self;
}

- (void)awakeFromNib {
	m_isStarted = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ShowNSSOrgWindow:) 
												 name:NSSORG_EVENT_SHOW_WINDOW object:nil];
}
- (void)ShowNSSOrgWindow:(NSNotification*)notification
{
	if ([GlobalData GetSSOrgKeyWindow] == 0) {
		[[_mainController window] makeKeyAndOrderFront:nil];
		[[_mainController window] center];
	}
	
}
- (void)runORG:(NSArray*)arrFileArray
{
	if (m_isStarted == NO ) {
		[NSBundle loadNibNamed:NIB_NAME owner:self];
	}

	[_mainController showMainView:arrFileArray];

}
@end
