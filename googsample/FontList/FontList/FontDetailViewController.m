//
//  FontDetailViewController.m
//  FontList
//
//  Created by mac on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FontDetailViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation FontDetailViewController

- (id)initWithFontName:(NSString *)_fontName
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
		self.title= @"Font Detail";
		
		text = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		fontSizeSlider = [[UISlider alloc] init];
		fontSizeSlider.minimumValue = 5.0;
		fontSizeSlider.maximumValue = 72.0;
		fontSizeSlider.value = 17.0;
		[fontSizeSlider addTarget:self action:@selector(changeFontSize:) 
				 forControlEvents:UIControlEventValueChanged];
		font = [UIFont fontWithName:_fontName size:fontSizeSlider.value];
    }
    return self;
}

- (IBAction)changeFontSize:(id)sender{
	font = [font fontWithSize:fontSizeSlider.value];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.textLabel.font = font;
	
	NSIndexPath *labelIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
	cell = [self.tableView cellForRowAtIndexPath:labelIndexPath];
	cell.textLabel.text = [NSString stringWithFormat:@"%.0f",fontSizeSlider.value];
//	cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 
//							cell.frame.size.width, [cell.textLabel numberOfLines] * fontSizeSlider.value);
//cell.bounds = cell.textLabel.frame;
	
	NSArray *array = [NSArray arrayWithObject:indexPath];
	[self.tableView reloadRowsAtIndexPaths:array 
						  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 1) {
		return 2;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];

    }
    // Configure the cell...
	switch ([indexPath section]) {
		case 0:
			cell.textLabel.text = [font fontName];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.backgroundColor = [UIColor clearColor];
			break;
		case 1:
			cell.backgroundColor = [UIColor clearColor];
			if ([indexPath row] == 0) {
				[cell.contentView addSubview:fontSizeSlider];
				fontSizeSlider.frame = cell.bounds;
				fontSizeSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			} else {
				cell.textLabel.text = [NSString stringWithFormat:@"%.0f",fontSizeSlider.value];
				cell.textLabel.textAlignment = UITextAlignmentCenter;
			}
			break;
		case 2:
			cell.textLabel.text = text;
			cell.textLabel.font = font;
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		default:
			break;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([indexPath section] == 2) {
		/*
		CGFloat lableWidth = 280;
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
		{
			lableWidth = 650;
		}
		*/
		CGSize size = [text sizeWithFont:font 
		 constrainedToSize:CGSizeMake(280, FLT_MAX) 
			 lineBreakMode:UILineBreakModeWordWrap];
		return size.height;
	}
	return 44;
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	return nil;
}

@end
