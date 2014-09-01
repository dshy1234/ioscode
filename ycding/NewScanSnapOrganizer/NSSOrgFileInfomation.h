//
//  NSSOrgFileInfomation.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSSOrgFileInfomation : NSObject {
	NSArray *paths;
}
@property(readwrite, retain) NSArray *paths;

@end
