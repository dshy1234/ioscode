//
//  WebColorViewController.m
//  FontList
//
//  Created by mac on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WebColorViewController.h"


@implementation WebColorViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
		self.title = @"Web Color";
		self.tabBarItem.image = [UIImage imageNamed:@"doubleicon.png"];
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
			NSString *filePath = [[NSBundle mainBundle] pathForResource:@"colormap" ofType:@"txt"];
			NSString *fileContent = [NSString stringWithContentsOfFile:filePath
															  encoding:NSUTF8StringEncoding
																 error:nil];
			dispatch_async(dispatch_get_main_queue(), ^{
				colorArray = [[fileContent componentsSeparatedByString:@"\n"] retain];
			});
		});
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
	[colorArray release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return colorArray.count;
}

static NSArray *getColor(NSString *hex){
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	range.location = 0;
	[[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
	[[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&green];
	range.location = 4;
	[[NSScanner scannerWithString:[hex substringWithRange:range]] scanHexInt:&blue];
	
	UIColor *color = [UIColor colorWithRed:(float)red/255.0f green:(float)green/255.0f blue:(float)blue/255.0f alpha:1.0];
	NSString *disc = [NSString stringWithFormat:@"R:%d G:%d B:%d",red,green,blue];
	return [NSArray arrayWithObjects:color, disc, nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
									   reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSArray *data = [[colorArray objectAtIndex:[indexPath row]] componentsSeparatedByString:@"#"];
	NSString *text = [[NSString alloc] initWithFormat:@"#%@",[data objectAtIndex:1]];
	NSArray *colorRGB = getColor([data objectAtIndex:1]);
	cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)\n%@",
								 [colorRGB objectAtIndex:1],[data objectAtIndex:0]];
	cell.detailTextLabel.numberOfLines = 2;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.detailTextLabel.textColor = [colorRGB objectAtIndex:0];
	cell.textLabel.text = text;
	[text release];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate



@end
