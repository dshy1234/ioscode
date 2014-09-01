//
//  SettingViewControlller.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GlobalData.h"
@interface SettingViewControlller : NSWindowController {
	IBOutlet NSTextField *_filePath;
	NSArray * m_filePaths;
	
}
- (void)ShowSettingView:(NSArray *)arr;

- (IBAction)ReferenceClick:(id)sender;
- (IBAction)OKClick:(id)sender;
- (IBAction)CancelClick:(id)sender;

@end
