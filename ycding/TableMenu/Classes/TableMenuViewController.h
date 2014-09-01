//
//  TableMenuViewController.h
//  TableMenu
//
//  Created by apple on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
	NSMutableArray * itemArray;
	NSMutableArray * openItemArray;
	UITableView *menuTable;
}

@property (nonatomic,retain) NSMutableArray * itemArray;
@property (nonatomic,retain) NSMutableArray * openItemArray;
@property (nonatomic,retain) IBOutlet UITableView *menuTable;


-(void)readPlistToArray;

@end

