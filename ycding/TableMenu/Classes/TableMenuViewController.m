//
//  TableMenuViewController.m
//  TableMenu
//
//  Created by apple on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TableMenuViewController.h"

@implementation TableMenuViewController

@synthesize itemArray;
@synthesize openItemArray;
@synthesize menuTable;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.itemArray = [NSMutableArray arrayWithCapacity:0] ;
	self.openItemArray = [NSMutableArray arrayWithCapacity:0] ;
	[self readPlistToArray];
	
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(void)readPlistToArray
{
	if ([self.itemArray count]) {
		[self.itemArray removeAllObjects] ;
	}
	
	NSString * path= [[NSBundle mainBundle] pathForResource:@"MenuOrder" ofType:@"plist"] ;
	NSArray *dicArray=[NSArray arrayWithContentsOfFile:path];
	
	//一级菜单
	for (int i = 0 ; i < [dicArray count]; i++) {
		NSMutableDictionary * menuDic_1 = [NSMutableDictionary dictionaryWithCapacity:0] ;
		[menuDic_1 setObject:@"0" forKey:@"level"] ;
		[menuDic_1 setObject:[[dicArray objectAtIndex:i] objectAtIndex:0] forKey:@"name"] ;
		[self.itemArray addObject:menuDic_1] ;
		
		if (![self.openItemArray count]) {
			//如果没有打开项
			continue ;
		}
		//判断打开的菜单
		for (int j = 0 ; j < [self.openItemArray count]; j++) {
			if ([[[self.openItemArray objectAtIndex:j] objectForKey:@"name"] 
				 isEqualToString:[[dicArray objectAtIndex:i] objectAtIndex:0] ]) {
				
				//二级菜单
				NSArray *twoDic = [dicArray objectAtIndex:i] ;
				for (int k = 1 ; k < [twoDic count] ; k++) {
					NSMutableDictionary * menuDic_2 = [NSMutableDictionary dictionaryWithCapacity:0] ;
					[menuDic_2 setObject:@"2" forKey:@"level"] ;
					[menuDic_2 setObject:[twoDic objectAtIndex:k] forKey:@"name"] ;
					
					[self.itemArray addObject:menuDic_2] ;
					
				}
			}
		}
	}
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray count];
}

- (NSInteger)tableView:(UITableView *)tableView 
indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[[self.itemArray objectAtIndex:[indexPath row]] objectForKey:@"level"] intValue];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    //}
	
	
	NSDictionary *dic = [self.itemArray objectAtIndex:[indexPath row]] ;
	
	if(![[dic objectForKey:@"level"] intValue])//菜单项
	{
		//如果为0则为主菜单
		cell.selectionStyle = UITableViewCellSelectionStyleNone ;
		
		UIImageView *menubackView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menubackgroud.png"]];
		[cell setBackgroundView:menubackView];
		
		cell.textLabel.text = [dic objectForKey:@"name"];
		
		
	}// Configure the cell.
	else {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue ;
		
		cell.textLabel.text = [dic objectForKey:@"name"];
		
		UIImageView *menubackView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"itembackgroud.png"]];
		[cell setBackgroundView:menubackView];
		
	}
	
	
    return cell;
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row=[indexPath row];
	
	NSDictionary *dic = [self.itemArray objectAtIndex:row] ;
	NSString *key=[dic objectForKey:@"name"];
	if(![[dic objectForKey:@"level"] intValue])
	{
		//如果为0则为主菜单
		for (int i = 0 ; i < [self.openItemArray count]; i++) {
			if ([[[self.openItemArray objectAtIndex:i] objectForKey:@"name"] isEqualToString:key]) {
				if ([key isEqualToString:@"全部拍卖品"]) {
					NSLog(@"选中\"全部拍卖品\"");
				}
				[self.openItemArray removeObjectAtIndex:i] ;
				[self readPlistToArray] ;
				[self.menuTable reloadData] ;
				
				return ;
			}
		}
		
		//
		[self.openItemArray addObject:dic] ;
		[self readPlistToArray] ;
		[self.menuTable reloadData] ;
	}
	else {
		//如果是菜单项处理相关操作
		
		NSLog(@"按在:%@",key);
	}
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[itemArray release];
	[openItemArray release];
	[menuTable release];
	
    [super dealloc];
}

@end
