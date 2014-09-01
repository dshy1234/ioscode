//
//  NSSOrgTextField.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSSOrgTextField : NSTextField {
	int NSSOrgTextFieldvalue;
	int minNSSOrgTextFieldvalue;
	int maxNSSOrgTextFieldvalue;

}
@property(readwrite) int NSSOrgTextFieldvalue;
@property(readwrite) int minNSSOrgTextFieldvalue;
@property(readwrite) int maxNSSOrgTextFieldvalue;

@end
