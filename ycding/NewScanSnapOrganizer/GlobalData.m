//
//  GlobalData.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlobalData.h"
static int SSorgKeyWindow;

@implementation GlobalData
+ (void)SetSSOrgKeyWindow:(int)sender
{
	SSorgKeyWindow = sender;
}
+ (int)GetSSOrgKeyWindow
{
	return SSorgKeyWindow;
}
@end
