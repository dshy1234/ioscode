//
//  SSOrgOutlineview.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SSOrgOutlineview.h"


@implementation SSOrgOutlineview

- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row
{
	if (row == 0) {
		return NSZeroRect;
	}
	return [super frameOfOutlineCellAtRow:row];
	
}

//- (void)highlightSelectionInClipRect:(NSRect)clipRect
//{
//	
//}

- (NSArray *)selectedItems {
    NSMutableArray *items = [NSMutableArray array];
    NSIndexSet *selectedRows = [self selectedRowIndexes];
    if (selectedRows != nil) {
        for (NSInteger row = [selectedRows firstIndex]; row != NSNotFound; row = [selectedRows indexGreaterThanIndex:row]) {
            [items addObject:[self itemAtRow:row]];
        }
    }
    return items;
}

- (void)setSelectedItems:(NSArray *)items {
    // If we are extending the selection, we start with the existing selection; otherwise, we create a new blank set of the indexes.
    NSMutableIndexSet *newSelection = [[NSMutableIndexSet alloc] init];
    
    for (NSInteger i = 0; i < [items count]; i++) {
        NSInteger row = [self rowForItem:[items objectAtIndex:i]];
        if (row >= 0) {
            [newSelection addIndex:row];
        }
    }
    
    [self selectRowIndexes:newSelection byExtendingSelection:NO];
    
    [newSelection release];
}
@end
