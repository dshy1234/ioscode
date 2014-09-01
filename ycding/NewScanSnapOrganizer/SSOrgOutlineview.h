//
//  SSOrgOutlineview.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SSOrgOutlineview : NSOutlineView {

}
- (NSArray *)selectedItems;
- (void)setSelectedItems:(NSArray *)items;
@end
