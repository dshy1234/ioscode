//
//  SettingViewControlller.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewControlller.h"


@implementation SettingViewControlller
- (void) dealloc
{
	[m_filePaths release];
	[super dealloc];
}

- (void)ShowSettingView:(NSArray *)arr
{
	m_filePaths = [arr retain];
	[[self window] makeKeyAndOrderFront:nil];
	[[self window] center];
}

- (IBAction)ReferenceClick:(id)sender
{
	int	nRes			  = 0;
	NSString* strfilePath = nil;
	NSSavePanel* spExoprt = [NSSavePanel savePanel];
	
	nRes = [spExoprt runModalForDirectory:NSHomeDirectory() file:strfilePath];
	if (nRes != NSOKButton)
	{
		return;
	}
	strfilePath = [spExoprt filename];
	[_filePath setObjectValue:strfilePath];
	
}
- (IBAction)OKClick:(id)sender
{
	if ([_filePath stringValue] == nil || [[_filePath stringValue] isEqualToString:[NSString string]]) {
		NSRunAlertPanel(@"ERR", @" NO file path", nil, nil, nil);
		return;
	}
	[[self window] orderOut:nil];
	[GlobalData SetSSOrgKeyWindow:0];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSSORG_EVENT_SHOW_WINDOW object:nil];
}
- (IBAction)CancelClick:(id)sender
{
	[[self window] orderOut:nil];
	[GlobalData SetSSOrgKeyWindow:0];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSSORG_EVENT_SHOW_WINDOW object:nil];

}
@end
