//
//  NSSOrgImageView.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSSOrgImageView.h"


@implementation NSSOrgImageView
//- (id)initWithFileInformation:(NSSOrgFileInfomation *)sender {
//    self = [self init];
//    self.fileInfor = sender;
//    return self;
//}
//+ (NSSOrgImageView *)viewWithFileInformation:(NSSOrgFileInfomation *)fileInformation
//{
//	return [[[NSSOrgImageView alloc] initWithFileInformation:fileInformation] autorelease];
//
//}
- (id) init
{
	self = [super init];
	if (self != nil) {
		fileInfor = nil;
	}
	return self;
}
- (void)setMouseDownAction:(SEL)active
{
	_mouseDownAction=active;
}
- (void)dealloc {
	NSObjectReleaseToNil(fileInfor);
    [super dealloc];
}
- (void)setNSSOrgFileInfomation:(NSSOrgFileInfomation*)sender
{
	NSObjectReleaseToNil(fileInfor);
	fileInfor= [sender retain];
}
- (NSSOrgFileInfomation*)getNSSOrgFileInfomation
{
	return fileInfor;
}
- (void)mouseDown:(NSEvent *)theEvent
{
	[self sendAction:_mouseDownAction to:[self target]];
	[super mouseDown:theEvent];
}
@end
