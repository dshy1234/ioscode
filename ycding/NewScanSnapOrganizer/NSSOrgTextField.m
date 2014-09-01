//
//  NSSOrgTextField.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSSOrgTextField.h"


@implementation NSSOrgTextField
- (id) init
{
	self = [super init];
	if (self != nil) {
		NSSOrgTextFieldvalue = 0;
		minNSSOrgTextFieldvalue = 0;
		maxNSSOrgTextFieldvalue = 0;
	}
	return self;
}

@synthesize NSSOrgTextFieldvalue, minNSSOrgTextFieldvalue, maxNSSOrgTextFieldvalue;

- (void)textDidChange:(NSNotification *)aNotification
{
	int value = [[self stringValue] intValue];
	[self setIntValue:value];	
}
- (BOOL)textShouldEndEditing:(NSText *)textObject
{
	int value = [[self stringValue] intValue];

	if (value > maxNSSOrgTextFieldvalue || value < minNSSOrgTextFieldvalue) {
		[self setIntValue:NSSOrgTextFieldvalue];
		NSRunAlertPanel(@"ERROR", [NSString stringWithFormat:@"%dから%dまでの整数を入力ください。",minNSSOrgTextFieldvalue,maxNSSOrgTextFieldvalue], nil, nil, nil);
		return NO;
	}
	return YES;
}
- (void)textDidBeginEditing:(NSNotification *)aNotification
{
	NSSOrgTextFieldvalue = [[self stringValue] intValue];
}
@end
