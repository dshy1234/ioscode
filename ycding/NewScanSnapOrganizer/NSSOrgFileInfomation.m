//
//  NSSOrgFileInfomation.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSSOrgFileInfomation.h"


@implementation NSSOrgFileInfomation
- (id) init
{
	self = [super init];
	if (self != nil) {
		paths = nil;
	}
	return self;
}

- (void)dealloc {
    [paths release];
    [super dealloc];
}
@synthesize paths;

@end
