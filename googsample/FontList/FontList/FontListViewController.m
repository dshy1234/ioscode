//
//  FontListViewController.m
//  FontList
//
//  Created by mac on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FontListViewController.h"
#import "FontDetailViewController.h"

@implementation FontListViewController
@synthesize searchDisplayController;

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithStyle:UITableViewStylePlain];
	if (self) {
		self.title = @"Font List";
		self.tableView.rowHeight = 60;
		allFontDict = [[NSMutableDictionary alloc] init];
		NSArray *familyArray = [UIFont familyNames];
		for (NSString *familyName in familyArray) {
			NSArray *fontOfFamily = [UIFont fontNamesForFamilyName:familyName];
			[allFontDict setObject:fontOfFamily forKey:familyName];
		}
		allFontFamily = [[NSArray alloc] initWithArray:[[allFontDict allKeys] 
														sortedArrayUsingSelector:@selector(compare:)]];
		currentDisplayArray = [allFontFamily mutableCopy];
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.contentOffset = CGPointMake(0, 44);
	UISearchBar *searchBar = [[UISearchBar alloc] 
							  initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)]; 
	searchBar.delegate = self; 
	searchBar.showsCancelButton = YES; 
	[searchBar sizeToFit]; 
	self.tableView.tableHeaderView = searchBar; 
	searchDisplayController = [[UISearchDisplayController alloc] 
							   initWithSearchBar:searchBar contentsController:self];
	[searchBar release];
	[self setSearchDisplayController:searchDisplayController]; 
	searchDisplayController.searchBar.placeholder = @"Family name";
	[searchDisplayController setDelegate:self]; 
	[searchDisplayController setSearchResultsDataSource:self];
	[searchDisplayController setSearchResultsDelegate:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.searchDisplayController = nil;
}

- (void)dealloc{
	[allFontFamily release];
	[currentDisplayArray release];
	[allFontDict release];
	[searchDisplayController release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView Delegate And DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [currentDisplayArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSString *familyName = [currentDisplayArray objectAtIndex:section];
	return [[allFontDict objectForKey:familyName] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellReuseableIdentifier = @"CellReuseableIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellReuseableIdentifier] autorelease];
	}
	NSString *familyName = [currentDisplayArray objectAtIndex:[indexPath section]];
	NSArray *fontListOfFamily = [allFontDict objectForKey:familyName];
	NSString *fontName = [fontListOfFamily objectAtIndex:[indexPath row]];
    NSLog(fontName);

	cell.textLabel.font = [UIFont fontWithName:fontName size:19];
	cell.textLabel.text = fontName;
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSString *familyName = [currentDisplayArray objectAtIndex:section];
	return familyName;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
	if (tableView != self.tableView) {
		return nil;
	}
	NSMutableArray *initialArray = [[[NSMutableArray alloc] initWithCapacity:[currentDisplayArray count]] autorelease];
	[initialArray addObject:UITableViewIndexSearch];
	NSString *lastInitial = @"";
	for (NSString *familyName in currentDisplayArray) {
		NSString *initial = [familyName substringToIndex:1];
		if (![initial isEqualToString:lastInitial]) {
			[initialArray addObject:[initial uppercaseString]];
			lastInitial = initial;
		}
	}
	return initialArray;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
	if (index == 0) {
		[tableView setContentOffset:CGPointZero animated:YES];
		return NSNotFound;
	}
	NSInteger section = 0;
	for (NSString *familyName in currentDisplayArray) {
		if ([[[familyName substringToIndex:1] uppercaseString] isEqualToString:title]) {
			return section;
		}
		section++;
	}
	return currentDisplayArray.count - 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSInteger section = [indexPath section];
	NSString *familyName = [currentDisplayArray objectAtIndex:section];
	NSArray *fontListOfFamily = [allFontDict objectForKey:familyName];
	NSString *fontName = [fontListOfFamily objectAtIndex:[indexPath row]];
	FontDetailViewController *subController = [[FontDetailViewController alloc] initWithFontName:fontName];
	[self.navigationController pushViewController:subController animated:YES];
	[subController release];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	[currentDisplayArray release];
	currentDisplayArray = [allFontFamily mutableCopy];
	NSMutableArray *toRemoved = [[NSMutableArray alloc] init];
	for (NSString *familyName in currentDisplayArray) {
		if ([familyName rangeOfString:searchString options:NSCaseInsensitiveSearch].location == NSNotFound) {
			[toRemoved addObject:familyName];
		}
	}
	[currentDisplayArray removeObjectsInArray:toRemoved];
	[toRemoved release];
	return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView{
	[currentDisplayArray release];
	currentDisplayArray = [allFontFamily mutableCopy];
}

@end