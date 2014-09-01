//
//  NSSOrgImageView.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSSOrgFileInfomation.h"
#import "GlobalData.h"
@interface NSSOrgImageView : NSImageView {
	NSSOrgFileInfomation *fileInfor;
	SEL _mouseDownAction;
}
//- (id)initWithFileInformation:(NSSOrgFileInfomation *)sender;
//+ (NSSOrgImageView *)viewWithFileInformation:(NSSOrgFileInfomation *)fileInformation;
- (void)setNSSOrgFileInfomation:(NSSOrgFileInfomation*)sender;
- (NSSOrgFileInfomation*)getNSSOrgFileInfomation;
- (void)setMouseDownAction:(SEL)active;
@end
