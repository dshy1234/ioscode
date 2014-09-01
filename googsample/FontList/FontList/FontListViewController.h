//
//  FontListViewController.h
//  FontList
//
//  Created by mac on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontListViewController : UITableViewController
<UISearchDisplayDelegate, UISearchBarDelegate>{
	NSMutableDictionary *allFontDict;
	NSArray *allFontFamily;
	NSMutableArray *currentDisplayArray;
	UISearchDisplayController *searchDisplayController;
}
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@end
