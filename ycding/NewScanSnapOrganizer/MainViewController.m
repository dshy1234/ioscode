//
//  MainViewController.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


#define INFO_PLIST_NAME				  @"jp.co.pfu.ScanSnap.OrganizerInitInfo.dict"

#define KEYCHAIN_DATE_FORMAT		  @"%Y%m%d%H%M%S"

#define NAME_KEY                      @"Name"
#define CHILDREN_KEY                  @"Children"
#define SIMPLE_BPOARD_TYPE            @"MyCustomOutlineViewPboardType"
#define FILE_STROE_PATH				  @"Pictures/ScanSnapOrganizer"

#define START_MODEL_FINDER			  0
#define START_MODEL_SS				  1

#define MIN_VALUE					  1
#define MAX_VALUE					  10000

#pragma mark TB
//DB
#define DATABASE_NAME				  @"NSSOrgDataBase.sqlite3"
//#define TAB_NAME					  @"FileNames"
#define TABKEY_FILENAME				  @"FileName"
#define TABKEY_FILEGROUP			  @"FileGroup"
#define TAB_CREATE					  @"CREATE TABLE FileNames (ID INTEGER PRIMARY KEY, FileName TEXT, FileGroup TEXT);"
#define TAB_SELECT					  @"SELECT *  FROM FileNames ORDER BY FileGroup,ID;"
#define TAB_INSERT					  @"INSERT INTO FileNames (FileName,FileGroup)values('%@','%@');"

const int KEY_WINDOW_MAIN			= 0;
const int KEY_WINDOW_Setting		= 1;


const int IMAGE_WIDTH				= 100;
const int IMAGE_HEIGTH				= 100;
const int IMAGE_SPACE				= 10;

@implementation MainViewController



- (id) init
{
	self = [super init];
	if (self != nil) {
		m_allShowFiles = nil;
		rootTreeNode = nil;
		selectedNodeData = nil;
		m_currentShowFilesPath = nil;
		m_currentShowFilesData = nil;
		m_currentImageView = nil;
		m_currentPage = 0;
		m_isStarted = NO;
		m_transition = [CATransition animation];
		m_startModel = START_MODEL_FINDER;
		NSString *plistFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
		plistFilePath = [plistFilePath stringByAppendingPathComponent:INFO_PLIST_NAME];
		// Load our initial outline view data from the "InitInfo" dictionary.
		NSDictionary *dictionary = nil;
		if ([[NSFileManager defaultManager] fileExistsAtPath:plistFilePath]) {
			dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistFilePath];
			if ([[dictionary allKeys] count] == 0) {
				NSObjectReleaseToNil(dictionary);
				NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:INFO_PLIST_NAME ofType:nil];
				dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
			}
		}else{
		
		//*******************************************//
		// TODO:ユーザ下のツリー情報がないとツリー情報PListファイルが不正場合、デフォルト情報を使用
			NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:INFO_PLIST_NAME ofType:nil];
			dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
		}
		
       // NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[path ] ofType: @"dict"]];
        rootTreeNode = [[self treeNodeFromDictionary:dictionary] retain];
	}
	return self;
}

- (void) dealloc
{
	NSObjectReleaseToNil(rootTreeNode);
	NSObjectReleaseToNil(m_currentShowFilesPath);
	NSObjectReleaseToNil(m_currentShowFilesData);
	NSObjectReleaseToNil(m_currentImageView);

	NSObjectReleaseToNil(m_allShowFiles);

//	NSObjectReleaseToNil(m_imageNone);
//	NSObjectReleaseToNil(m_imageAvailable);
	[super dealloc];
}
@synthesize m_currentShowFilesPath, m_currentShowFilesData;

- (void)awakeFromNib {

//	//NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:@"NSStatusNone" ofType:@"png"];
//	//m_imageNone = [[NSWorkspace sharedWorkspace] iconForFile:path];
//	//m_imageNone = [[NSImage alloc] initByReferencingFile:path];
//	//m_imageNone = [[NSImage alloc] initWithContentsOfFile:path];
//	m_imageNone = [NSImage imageNamed:@"statusNone"];
//	[m_imageNone setSize:NSMakeSize(16.0, 12.0)];
//	[m_imageNone setScalesWhenResized:YES];
//	//[m_imageNone setName:@"statusNone"];
//	
//	//path = [[NSBundle bundleForClass:[self class]]pathForResource:@"NSStatusAvailable" ofType:@"png"];
//	//m_imageAvailable = [[NSWorkspace sharedWorkspace] iconForFile:path];
//
//	//m_imageAvailable = [[NSImage alloc] initWithContentsOfFile:path];
//	//m_imageAvailable = [[NSImage alloc] initByReferencingFile:path];
//	m_imageAvailable = [NSImage imageNamed:@"statusAvailable"];
//
//	[m_imageAvailable setSize:NSMakeSize(16.0, 12.0)];
//	[m_imageAvailable setScalesWhenResized:YES];
//	//[m_imageAvailable setName:@"statusAvailable"];
	
    // Register to get our custom type, strings, and filenames. Try dragging each into the view!
	
	if (m_allShowFiles == nil) {
		[self getAllShowFile];
	}

    [_outLineView setAutoresizesOutlineColumn:NO];
	
	_textCurrentPage.minNSSOrgTextFieldvalue = MIN_VALUE;
	
	splitInfoTree = (SSOrgSplitInfo*)malloc(sizeof(SSOrgSplitInfo));
	memset(splitInfoTree, 0, sizeof(SSOrgSplitInfo));
	splitInfoTree->splitView = _treeView;
	splitInfoTree->isOpened  = YES;
	splitInfoTree->oldWidth = [(NSView *)[[_treeView subviews] objectAtIndex:0] frame].size.width;
	
	//[_thumView setWantsLayer:YES];

	
	[_preImageView setWantsLayer:YES];
	NSString *transitionType = nil;
	transitionType = kCATransitionMoveIn;
	
   
	// We want to specify one of Core Animation's built-in transitions.
	[m_transition setType:transitionType];
	[m_transition setSubtype:kCATransitionFromLeft];
    
	
    // Specify an explicit duration for the transition.
    [m_transition setDuration:0.5];
	
    // Associate the CATransition we've just built with the "subviews" key for this SlideshowView instance, so that when we swap ImageView instances in our -transitionToImage: method below (via -replaceSubview:with:).
    [_preImageView setAnimations:[NSDictionary dictionaryWithObject:m_transition forKey:@"subviews"]];
	
	//NSArray *arr = [_treeView subviews];
	
	//splitInfo2 = (SSOrgSplitInfo*)malloc(sizeof(SSOrgSplitInfo));
//	memset(splitInfo2, 0, sizeof(SSOrgSplitInfo));
//	splitInfo2->splitView = _scanToView;
//	splitInfo2->isOpened  = YES;

	
	//splitInfoImage = (SSOrgSplitInfo*)malloc(sizeof(SSOrgSplitInfo));
//	memset(splitInfoImage, 0, sizeof(SSOrgSplitInfo));
//	splitInfoImage->splitView = _thumView;
//	splitInfoImage->isOpened  = NO;
//	splitInfoImage->oldWidth = splitInfoTree->oldWidth * 1.5;
//	NSRect rect = [[[_thumView subviews] objectAtIndex:2] frame];
//	[[[_thumView subviews] objectAtIndex:2] setFrame:NSMakeRect(rect.origin.x, rect.origin.y, 0, rect.size.height)];
	
//	[_outLineView setDoubleAction:@selector(OutlineViewDoubleAction:)];
	[_outLineView expandItem:nil expandChildren:YES];
	
	[_outLineView selectRow:0 byExtendingSelection:NO];
	selectedNodeData = [[_outLineView itemAtRow:0] representedObject];
}


- (BOOL)CheckFileType:(NSArray *)arr
{
	if (arr == nil || [arr count] == 0) {
		return NO;
	}
	
	for (id item in arr) {
		if ([[item pathExtension] caseInsensitiveCompare:@"jpg"] != NSOrderedSame 
			&& [[item pathExtension] caseInsensitiveCompare:@"jpeg"] != NSOrderedSame
			&& [[item pathExtension] caseInsensitiveCompare:@"pdf"] != NSOrderedSame)
		{
			return NO;
		}
	}
	return YES;
}
- (void)showMainView:(NSArray*)fileNames
{	

	if (fileNames!=nil && [fileNames count] > 0) {
		[_outLineView selectRow:1 byExtendingSelection:NO];
		selectedNodeData = [[_outLineView itemAtRow:1] representedObject];
		[self saveFilePathsToDB:fileNames];
	}
	if ([self CheckFileType:fileNames]) {
		m_startModel = START_MODEL_SS;
		self.m_currentShowFilesPath = fileNames;
		[m_allShowFiles insertObject:m_currentShowFilesPath atIndex:0];
	}
	if ([m_allShowFiles count] > 0) {
		if (m_isStarted == NO) {
			[self ShowImageView:m_allShowFiles];
		}else {
			[self ChangeImagePosition];
		}

	}

	[[self window] makeKeyAndOrderFront:nil];
	[[self window] center];
	m_isStarted = YES;
}

- (void)getAllShowFile
{
	NSMutableArray * tempFileArray = [NSMutableArray new];
	m_allShowFiles = [NSMutableArray new];
	NSString *fileGroup = nil;
	NSString *filePath  = nil;
	
	
	CDbManger *dbManager = [[CDbManger alloc] initWithDbName:DATABASE_NAME];
	NSArray *arrfileNamesFromDB = [dbManager querryTable:TAB_SELECT];
	if ([arrfileNamesFromDB count] <= 0) {
		[dbManager createTable:TAB_CREATE];
		NSObjectReleaseToNil(dbManager);
		return;
	}

	
	for(NSMutableDictionary * fileDic in arrfileNamesFromDB)
	{
		
		filePath  = [fileDic objectForKey:TABKEY_FILENAME];
		if ([fileDic objectForKey:TABKEY_FILEGROUP] == nil || filePath == nil) {
			continue;
		}
		if (fileGroup != nil && ![fileGroup isEqualToString:(NSString*)[fileDic objectForKey:TABKEY_FILEGROUP]]) {
			if ([tempFileArray count] > 0) {
				[m_allShowFiles addObject:tempFileArray];
			}

			NSObjectReleaseToNil(tempFileArray);
			tempFileArray = [NSMutableArray new];
		}
		fileGroup = [fileDic objectForKey:TABKEY_FILEGROUP];

		if ([[filePath pathExtension] caseInsensitiveCompare:@"jpg"] == NSOrderedSame 
			|| [[filePath pathExtension] caseInsensitiveCompare:@"jpeg"] == NSOrderedSame
			|| [[filePath pathExtension] caseInsensitiveCompare:@"pdf"] == NSOrderedSame)
		{
			if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
				[tempFileArray addObject:filePath];
			}
			
		}
		//[m_allShowFiles insertObject:tempFileArray atIndex:0];
	}
	if ([tempFileArray count] > 0) {
		[m_allShowFiles addObject:tempFileArray];
	}
	NSObjectReleaseToNil(tempFileArray);
	NSObjectReleaseToNil(dbManager);

}


#pragma mark Main Window delegate
- (void)windowDidBecomeKey:(NSNotification *)notification
{
	if ([GlobalData GetSSOrgKeyWindow] == 1) {
		if (m_startModel == START_MODEL_SS) {
			[_settingViewControlller ShowSettingView:[m_allShowFiles objectAtIndex:0]];
		}else {
			[_settingViewControlller ShowSettingView:nil];
		}

	}
}
- (void)windowWillClose:(NSNotification *)notification
{
	//***************//
	//読み取ったファイル保存
	//if (m_startModel == START_MODEL_SS) {
//		int returnCode = NSRunAlertPanel(@"確認", @"読み取ったファイルを保存したか", @"はい", @"いいえ", nil);
//		if (returnCode == NSAlertDefaultReturn) {
//			NSFileManager *fileManager = [NSFileManager defaultManager];
//			NSString *preFilePath = [NSHomeDirectory() stringByAppendingPathComponent:FILE_STROE_PATH];
//			NSString* currentDate = [[NSDate date] descriptionWithCalendarFormat:KEYCHAIN_DATE_FORMAT timeZone:nil locale:nil];
//			preFilePath = [preFilePath stringByAppendingPathComponent:currentDate];
//			BOOL isDirectory;
//			BOOL isExists = [fileManager fileExistsAtPath:preFilePath isDirectory:&isDirectory];
//			if (!isDirectory || !isExists) {
//				[fileManager createDirectoryAtPath:preFilePath withIntermediateDirectories:YES attributes:nil error:nil];
//			}
//			
//			for(NSString *filepath in [m_allShowFiles objectAtIndex:0])
//			{
//				[fileManager copyItemAtPath:filepath toPath:[preFilePath stringByAppendingPathComponent:[filepath lastPathComponent]] error:nil];
//			}
//		}
//	}
	//ツリービュー情報保存
	NSString *plistFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	plistFilePath = [plistFilePath stringByAppendingPathComponent:INFO_PLIST_NAME];
	NSMutableDictionary *dic = [self DictionaryFromtreeNode:rootTreeNode];
	[dic writeToFile:plistFilePath atomically:NO];
	//app　終了
	[NSApp terminate:[NSBundle mainBundle]];
	
}
#pragma mark NSOutlineView delegate

// ================================================================
//  NSOutlineView data source methods. (The required ones)
// ================================================================

// The NSOutlineView uses 'nil' to indicate the root item. We return our root tree node for that case.
- (NSArray *)childrenForItem:(id)item {
    if (item == nil) {
        return [rootTreeNode childNodes];
    } else {
        return [item childNodes];
    }
}

// Required methods. 
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    // This will return an NSTreeNode with our model object as the representedObject
    return [children objectAtIndex:index];
}
- (BOOL) outlineView: (NSOutlineView *) outlineView isItemExpandable: (id) item
{
	/* Root */
	if (item == nil)
		return YES;
	
	/* Others */
	if ([[item childNodes] count])
		return YES;
	else
		return NO;

}
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    return [children count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    id objectValue = nil;
    SimpleNodeData *nodeData = [item representedObject];
    
    // The return value from this method is used to configure the state of the items cell via setObjectValue:
	objectValue = nodeData.name;
    return objectValue;
}
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {    
	SimpleNodeData *nodeData = [item representedObject];
	if (nodeData.isEditable == YES) {
		[cell setEditable:YES];
	}
	else {
		[cell setEditable:NO];
	}
//	if (item != nil && nodeData.image != nil) {
		ImageAndTextCell *imageAndTextCell = (ImageAndTextCell *)cell;
		[imageAndTextCell setImage:nodeData.image];
//	}
		
	
		
	
////	if (nodeData.image == nil) {
////		NSImage *image nil;
//////		if (item == nil || [[item childNodes] count]) {
//////			[image initWithContentsOfFile:[[NSBundle bundleForClass:[self class]]pathForResource:@"doc" ofType:@"png"]];
//////		}
//////		else {
//////			[image initWithContentsOfFile:[[NSBundle bundleForClass:[self class]]pathForResource:@"file" ofType:@"png"]];
//////		}
//////		[image setSize:NSMakeSize(15.0, 15.0)];
//////		[image setScalesWhenResized:YES];
//////		nodeData.image = image;
//////	}
////	
	//SimpleNodeData *nodeData = [item representedObject];
//	if (nodeData.image == nil) {
//		nodeData.image = m_imageNone;
//	}
//	ImageAndTextCell *imageAndTextCell = (ImageAndTextCell *)cell;
//	[imageAndTextCell setImage:nodeData.image];
//	// We know that the cell at this column is our image and text cell, so grab it 
//
//	// Set the image here since the value returned from outlineView:objectValueForTableColumn:... didn't specify the image part...
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
//	int selectRow = [_outLineView selectedRow];
	//if (selectRow <= 0 ) {
//		[_butAddCell setEnabled:NO];
//	}
//	else {
//		[_butAddCell setEnabled:YES];
//	}
	
	NSArray *arr = [_outLineView selectedItems];
	if (arr == nil || [arr count] <= 0) {
		return;
	}
	
	SimpleNodeData *nodeData = [[arr objectAtIndex:0] representedObject];

	if (nodeData.isEditable == YES) {
		[_butRemoveCell setEnabled:YES];
	}
	else {
		[_butRemoveCell setEnabled:NO];

	}

//	nodeData.
}
//- (void)outlineViewSelectionDidChange:(NSNotification *)notification
//{
//	if (selectedNodeData != nil) {
//		
//		selectedNodeData.image = m_imageNone;
//	}
//	selectedNodeData = [[_outLineView itemAtRow:[_outLineView selectedRow]] representedObject];
//	selectedNodeData.image = m_imageAvailable;
//	
//	[_outLineView reloadData];
//	//NSInteger selectedRow = [_outLineView selectedRow];
////	NSImage *image = nil;
////
////	if (selectedCell != nil) {
////		image = [NSImage imageNamed:NSImageNameStatusNone];
////		[image setSize:NSMakeSize(15.0, 15.0)];
////		[image setScalesWhenResized:YES];
////		[selectedCell setImage:image];
////	}
////	NSArray *arr = [_outLineView tableColumns];
////	selectedCell = (ImageAndTextCell *)[(NSTableColumn *)[arr objectAtIndex:0] dataCellForRow:selectedRow];
////	
////	image = [NSImage imageNamed:NSImageNameStatusAvailable];
////	[image setSize:NSMakeSize(15.0, 15.0)];
////	[image setScalesWhenResized:YES];
////	[selectedCell setImage:image];
//	//[_outLineView reloadData];
//}

//- (void)OutlineViewDoubleAction:(id)sender
//{
//	NSIndexSet *selectedRows = [_outLineView selectedRowIndexes];
//	 if (selectedRows != nil) {
//		 NSInteger row = [selectedRows firstIndex];
//		 if (row != NSNotFound) {
//			 id item = [_outLineView itemAtRow:row];
//			 if (item == nil || [[item childNodes] count]) {
//				 BOOL isExpandable = [_outLineView isItemExpanded:item];
//				 if (isExpandable) {
//					 [_outLineView collapseItem:item];
//				 }
//				 else {
//					 [_outLineView expandItem:item];
//				 }
//
//			 }
//		 }
//	 }
//	
//}



//- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
//	/* Root */
//	if (item == nil)
//		return YES;
//	
//	/* Others */
//	if ([[item childNodes] count])
//		return YES;
//	else
//		return NO;
//}

// Optional method: needed to allow editing.
- (void)outlineView:(NSOutlineView *)ov setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item  {
    SimpleNodeData *nodeData = [item representedObject];
        nodeData.name = object;
}

#pragma mark NSSplitView delegate
- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
    	// Push an NSAnimationContext on the animation context stack, and set its duration to the desired amount of time (expressed in seconds).  All animations initiated within this grouping will be given the same implied start time and duration.
	//[NSAnimationContext beginGrouping];
//	[[NSAnimationContext currentContext] setDuration:1.5];
	

	[self ChangeImagePosition];
	// Pop the NSAnimationContext, triggering execution of the animations we just grouped in a single time-syncrhonized batch.
//	[NSAnimationContext endGrouping];
}


#pragma mark Utility
- (void)saveFilePathsToDB:(NSArray *)FilePaths
{
	CDbManger *dbManager = [[CDbManger alloc] initWithDbName:DATABASE_NAME];
	NSString *fileGroup  =[[NSDate date] descriptionWithCalendarFormat:KEYCHAIN_DATE_FORMAT timeZone:nil locale:nil];

	for(NSString *filePath in FilePaths)
	{
		[dbManager updateTable:[NSString stringWithFormat:TAB_INSERT,filePath,fileGroup]];
	}
	
}
//- (NSImage *)randomIconImage {
//    // The first time through, we create a random array of images to use for the items.- (id)initByReferencingFile:(NSString *)filename
//
//    if (iconImages == nil) {
//        iconImages = [[NSMutableArray alloc] init]; // This is properly released in -dealloc
//        // There is a set of images with the format "Image<number>.tiff" in the Resources directory. We go through and add them to the array until we are out of images.
//        NSInteger i = 1;
//        while (1) {
//            // The typcast to a long and the use of %ld allows this application to easily be compiled as 32-bit or 64-bit
//
//			NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:[NSString stringWithFormat:@"Image%ld.tiff", (long)i] ofType:nil];
//			if (path != nil) {
//				NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
//				[image setScalesWhenResized:YES];
//				[image setSize:NSMakeSize(10, 10)];
//                // Add the image to our array and loop to the next one
//                [iconImages addObject:image];
//				NSObjectReleaseToNil(image);
//                i++;
//            } else {
//                // If the result is nil, then there are no more images
//                break;
//            }            
//        }
//    }
//	
//    // We systematically iterate through the image array and return a result. Keep track of where we are in the array with a static variable.
//    static NSInteger imageNum = 0;
//    NSImage *result = [iconImages objectAtIndex:imageNum];
//    imageNum++;
//    // Once we are at the end of the array, start over
//    if (imageNum == [iconImages count]) {
//        imageNum = 0;
//    }
//    return result;
//}

- (void)ShowImageView:(NSArray *)filePaths
{
	//NSArray *imageViews = [[_imageView documentView] subviews];
//	if ([imageViews count] != [filePaths count]) {
//		for(NSImageView *view in imageViews){
//			[view removeFromSuperview];
//		}
//	}
	
	int iCount = 0;
	if ([filePaths count] <= 0) {
		return;
	}
	
	NSRect rect= [_imageView bounds];
	iCount = rect.size.width / (IMAGE_WIDTH + IMAGE_SPACE);
	NSSOrgImageView			*imageview = nil;
	NSImage					*image = nil;
	NSSOrgFileInfomation	*fileInfor = nil;
	
	
	if (iCount <= 0) {
		iCount = 1;
	}
	NSRect docRect = [[_imageView documentView] frame];
	if (rect.size.height < (([filePaths count] / iCount + ([filePaths count] % iCount == 0 ? 0 :1)) * (IMAGE_HEIGTH + IMAGE_SPACE))) {
		
		[[_imageView documentView] setFrame:NSMakeRect(docRect.origin.x, docRect.origin.y, docRect.size.width, (([filePaths count] / iCount + ([filePaths count] % iCount == 0 ? 0 :1)) * (IMAGE_HEIGTH + IMAGE_SPACE)))];
		//[[_imageView contentView] setBounds:NSMakeRect([[_imageView contentView] frame].origin.x, [[_imageView contentView] frame].origin.y, rect.size.width, (([imageViews count] / iCount + 1) * (IMAGE_HEIGTH + IMAGE_SPACE)))];
	}
	else {
		[[_imageView documentView] setFrame:NSMakeRect(docRect.origin.x, docRect.origin.y, docRect.size.width, rect.size.height)];
	}
	rect = [[_imageView documentView] bounds];
	
	for (int i = [filePaths count] -1; i >= 0; i--) {
		NSRect rect = [[_imageView documentView] bounds];
		image = [self getThumbnailFromPath:[[filePaths objectAtIndex:i] objectAtIndex:0]];
		fileInfor = [[NSSOrgFileInfomation alloc] init];
		fileInfor.paths = (NSArray *)[filePaths objectAtIndex:i];
		
		imageview = [[NSSOrgImageView alloc] initWithFrame:NSMakeRect(IMAGE_SPACE + (i % iCount) * (IMAGE_WIDTH + IMAGE_SPACE), rect.size.height - (IMAGE_HEIGTH + IMAGE_SPACE)* ((i / iCount) + 1), IMAGE_WIDTH, IMAGE_HEIGTH)];
		
		[imageview setNSSOrgFileInfomation:fileInfor];
		[imageview setImage:image];
		[imageview setImageScaling:NSScaleProportionally];
		
		[imageview setEditable:YES];
		[imageview setImageFrameStyle:NSImageFramePhoto];
		
		[imageview setTarget:self];

		[imageview setMouseDownAction:@selector(imageViewClick:)];
		
		[[_imageView documentView]addSubview:imageview];
		
		NSObjectReleaseToNil(imageview);
		NSObjectReleaseToNil(fileInfor);
		
	}
	
	//[_imageView setVerticalPageScroll:0.0];
	[_imageView setNeedsDisplay:YES];
	[self preImageViewStartShow:[filePaths objectAtIndex:0]];
}

- (void)ChangeImagePosition
{
	NSArray *tempImageViews = [[_imageView documentView] subviews];
	NSMutableArray *imageViews;
	if ([tempImageViews count]!= [m_allShowFiles count]) {
		imageViews = [[NSMutableArray alloc] initWithArray:tempImageViews];
		
		
		NSImage *image = [self getThumbnailFromPath:[[m_allShowFiles objectAtIndex:0] objectAtIndex:0]];
		NSSOrgFileInfomation *fileInfor = [[NSSOrgFileInfomation alloc] init];
		fileInfor.paths = (NSArray *)[m_allShowFiles objectAtIndex:0];
		NSSOrgImageView *imageview = [[NSSOrgImageView alloc] init];
		[imageview setNSSOrgFileInfomation:fileInfor];
		[imageview setImage:image];
		[imageview setImageScaling:NSScaleProportionally];
		[imageview setEditable:YES];
		[imageview setImageFrameStyle:NSImageFramePhoto];
		[imageview setTarget:self];
		[imageview setMouseDownAction:@selector(imageViewClick:)];
		[imageViews insertObject:imageview atIndex:0];
		NSObjectReleaseToNil(imageview);
		NSObjectReleaseToNil(fileInfor);
		[[_imageView documentView] setSubviews:imageViews];
		[[self window] makeFirstResponder:[imageViews objectAtIndex:0]];
		[self preImageViewStartShow:[m_allShowFiles objectAtIndex:0]];
		
	}else {
		imageViews = (NSMutableArray*)tempImageViews;
	}

	
	if ([imageViews count] <= 0) {
		return;
	}
	int iCount = 0;
	NSRect rect= [_imageView bounds];
	iCount = rect.size.width / (IMAGE_WIDTH + IMAGE_SPACE);
	if (iCount <= 0) {
		iCount = 1;
	}
	NSRect docRect = [[_imageView documentView] frame];
	if (rect.size.height < (([imageViews count] / iCount + ([imageViews count] % iCount == 0 ? 0 :1)) * (IMAGE_HEIGTH + IMAGE_SPACE))) {
		
		[[_imageView documentView] setFrame:NSMakeRect(docRect.origin.x, docRect.origin.y, docRect.size.width, (([imageViews count] / iCount + ([imageViews count] % iCount == 0 ? 0 :1)) * (IMAGE_HEIGTH + IMAGE_SPACE)))];
		//[[_imageView contentView] setBounds:NSMakeRect([[_imageView contentView] frame].origin.x, [[_imageView contentView] frame].origin.y, rect.size.width, (([imageViews count] / iCount + 1) * (IMAGE_HEIGTH + IMAGE_SPACE)))];
	}
	else {
		[[_imageView documentView] setFrame:NSMakeRect(docRect.origin.x, docRect.origin.y, docRect.size.width, rect.size.height)];
	}
	rect = [[_imageView documentView] bounds];
	for (int i = 0; i < [imageViews count]; i++)
	{
		[(NSImageView *)[imageViews objectAtIndex:i] setFrame:NSMakeRect(IMAGE_SPACE + (i % iCount) * (IMAGE_WIDTH + IMAGE_SPACE), rect.size.height - (IMAGE_HEIGTH + IMAGE_SPACE)* ((i / iCount) + 1), IMAGE_WIDTH, IMAGE_HEIGTH)];
	}
	[_imageView setNeedsDisplay:YES];
}

- (NSMutableDictionary *)DictionaryFromtreeNode:(NSTreeNode *)treeNode{
	SimpleNodeData *nodeData = [treeNode representedObject];
	NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:nodeData.name forKey:NAME_KEY];
	NSMutableArray *childArr = [NSMutableArray new];
	[dic setObject:childArr forKey:CHILDREN_KEY];
	NSArray * arr = [treeNode childNodes];
	for(NSTreeNode * item in arr){
		NSMutableDictionary *childDic;
		if ([[item childNodes] count] >0) {
			childDic = [self DictionaryFromtreeNode:item];
			[childArr addObject:childDic];
		}
		else {
			SimpleNodeData *childNodeData = [item representedObject];
			[childArr addObject:childNodeData.name];
		}
	}
	NSObjectReleaseToNil(childArr);
	return dic;
}

- (NSTreeNode *)treeNodeFromDictionary:(NSDictionary *)dictionary {
    // We will use the built-in NSTreeNode with a representedObject that is our model object - the SimpleNodeData object.
    // First, create our model object.
    NSString *nodeName = [dictionary objectForKey:NAME_KEY];
    SimpleNodeData *nodeData = [SimpleNodeData nodeDataWithName:nodeName];
    // The image for the nodeData is lazily filled in, for performance.
    
    // Create a NSTreeNode to wrap our model object. It will hold a cache of things such as the children.
    NSTreeNode *result = [NSTreeNode treeNodeWithRepresentedObject:nodeData];
    
    // Walk the dictionary and create NSTreeNodes for each child.
    NSArray *children = [dictionary objectForKey:CHILDREN_KEY];
    
    for (id item in children) {
        // A particular item can be another dictionary (ie: a container for more children), or a simple string
        NSTreeNode *childTreeNode;
        if ([item isKindOfClass:[NSDictionary class]]) {
            // Recursively create the child tree node and add it as a child of this tree node
            childTreeNode = [self treeNodeFromDictionary:item];
        } else {
            // It is a regular leaf item with just the name
            SimpleNodeData *childNodeData = [[SimpleNodeData alloc] initWithName:item];
			if ([nodeName isEqualToString:@"My Lists"]) {
				childNodeData.isEditable = YES;
			}
			NSString *imagePath;
			if ([nodeName isEqualToString:@"All Scanned Documents"]) {
				if ([item isEqualToString:@"S2500(Just Scanned)"]) {
					imagePath = [[NSBundle bundleForClass:[self class]]pathForResource:@"PfuSsMon.ico" ofType:nil];
				}
				else if([item isEqualToString:@"Trash"]){
					imagePath = [[NSBundle bundleForClass:[self class]]pathForResource:@"SSOrgTrashEmpty.png" ofType:nil];
				}

			}else if ([nodeName isEqualToString:@"My Lists"]) {
				imagePath = [[NSBundle bundleForClass:[self class]]pathForResource:@"SSOrgMultipleDocuments.jpg" ofType:nil];
			}else if ([nodeName isEqualToString:@"Document Type"]) {
				imagePath = [[NSBundle bundleForClass:[self class]]pathForResource:@"SSOrgNSFolder.png" ofType:nil];
			}
			childNodeData.image = [self getImageFromPath:imagePath];
            childTreeNode = [NSTreeNode treeNodeWithRepresentedObject:childNodeData];
            [childNodeData release];
        }
        // Now add the child to this parent tree node
        [[result mutableChildNodes] addObject:childTreeNode];
    }
    return result;
    
}
- (NSImage *)getImageFromPath:(NSString *)path{
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		return nil;
	}
	NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
	[image setSize:NSMakeSize(15.0, 15.0)];
	[image setScalesWhenResized:YES];
	return [image autorelease];
}
- (NSImage *)getThumbnailFromPath:(NSString *)path
{
	NSImage *returnImage = nil;
	if ([[path pathExtension] caseInsensitiveCompare:@"jpg"] == NSOrderedSame 
		|| [[path pathExtension] caseInsensitiveCompare:@"jpeg"] == NSOrderedSame) {
		returnImage = [[NSImage alloc] initWithContentsOfFile:path];
	}else if ([[path pathExtension] caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
		NSPDFImageRep *pdfImage = [NSPDFImageRep imageRepWithContentsOfFile:path];
		if ([pdfImage pageCount] > 0) {
			[pdfImage setCurrentPage:0];
			returnImage = [[NSImage alloc] init];
			[returnImage addRepresentation:pdfImage];
		}
	}
	return [returnImage autorelease];
}
- (void)preImageViewShowImage:(int)imageNumber
{
	if (m_currentPage == imageNumber) {
		return;
	}
	
	if (m_currentPage > imageNumber) {
		[m_transition setSubtype:kCATransitionFromRight];

	}
	else {
		[m_transition setSubtype:kCATransitionFromLeft];
	}
	m_currentPage = imageNumber;
	NSImageView *newImageView = nil;
	newImageView = [[NSImageView alloc] initWithFrame:[_preImageView bounds]];
	[newImageView setImage:[m_currentShowFilesData objectAtIndex:imageNumber - 1]];
	[newImageView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	//[newImageView setImageScaling:NSScaleProportionally];

    if (m_currentImageView && newImageView) {
        [[_preImageView animator] replaceSubview:m_currentImageView with:newImageView];
    } else {
        if (m_currentImageView) [[m_currentImageView animator] removeFromSuperview];
        if (newImageView) [[_preImageView animator] addSubview:newImageView];
    }
	NSObjectReleaseToNil(m_currentImageView);;
    m_currentImageView = [newImageView retain];
	
	
	if (imageNumber - 1 == 0) {
		[_butPrePage setEnabled:NO];
	}
	else {
		[_butPrePage setEnabled:YES];
	}

	if (imageNumber == [self.m_currentShowFilesData count]) {
		[_butNextPage setEnabled:NO];
	}
	else {
		[_butNextPage setEnabled:YES];
	}
	[_textCurrentPage setObjectValue:[NSString stringWithFormat:@"%d",imageNumber]];
	_textCurrentPage.NSSOrgTextFieldvalue = imageNumber;
}

#pragma mark IBAction Function-----------


- (IBAction)DoSaveFile:(id)sender
{
	[GlobalData SetSSOrgKeyWindow:1];
	if (m_startModel == START_MODEL_SS) {
		[_settingViewControlller ShowSettingView:[m_allShowFiles objectAtIndex:0]];
	}else {
		[_settingViewControlller ShowSettingView:nil];
	}
}
- (IBAction)DoAbout:(id)sender
{
	[[NSApplication sharedApplication] orderFrontStandardAboutPanel:nil];

}

//- (IBAction)DoLeftHide:(id)sender
//{
//	if (splitInfoTree->isOpened) {
//		splitInfoTree->oldSize	  = [(NSView *)[[_treeView subviews] objectAtIndex:0] frame].size.width;
//		NSRect rectLeft = [(NSView *)[[_treeView subviews] objectAtIndex:0] frame];
//		NSRect rectRight= [(NSView *)[[_treeView subviews] objectAtIndex:1] frame];
//
//		[(NSView *)[[_treeView subviews] objectAtIndex:0] setFrame:NSMakeRect(rectLeft.origin.x, rectLeft.origin.y, 0, rectLeft.size.height)];
//		[(NSView *)[[_treeView subviews] objectAtIndex:1] setFrame:NSMakeRect(rectRight.origin.x, rectRight.origin.y, rectRight.size.width + splitInfoTree->oldSize, rectRight.size.height)];
//		splitInfoTree->isOpened = NO;
//	}
//	else {
//		NSRect rectLeft = [(NSView *)[[_treeView subviews] objectAtIndex:0] frame];
//		NSRect rectRight= [(NSView *)[[_treeView subviews] objectAtIndex:1] frame];
//		
//		[(NSView *)[[_treeView subviews] objectAtIndex:0] setFrame:NSMakeRect(rectLeft.origin.x, rectLeft.origin.y, splitInfoTree->oldSize, rectLeft.size.height)];
//		[(NSView *)[[_treeView subviews] objectAtIndex:1] setFrame:NSMakeRect(rectRight.origin.x, rectRight.origin.y, rectRight.size.width - splitInfoTree->oldSize, rectRight.size.height)];
//		splitInfoTree->isOpened = YES;
//	}
//
//}
//
//- (IBAction)DoRightHide:(id)sender
//{
//	if (splitInfoImage->isOpened) {
//		splitInfoImage->oldSize	  = [(NSView *)[[_thumView subviews] objectAtIndex:1] frame].size.width;
//		NSRect rectLeft = [(NSView *)[[_thumView subviews] objectAtIndex:0] frame];
//		NSRect rectRight= [(NSView *)[[_thumView subviews] objectAtIndex:1] frame];
//		
//		[(NSView *)[[_thumView subviews] objectAtIndex:0] setFrame:NSMakeRect(rectLeft.origin.x, rectLeft.origin.y, rectRight.size.width + splitInfoImage->oldSize, rectLeft.size.height)];
//		[(NSView *)[[_thumView subviews] objectAtIndex:1] setFrame:NSMakeRect(rectRight.origin.x, rectRight.origin.y, 0, rectRight.size.height)];
//		splitInfoImage->isOpened = NO;
//	}
//	else {
//		NSRect rectLeft = [(NSView *)[[_thumView subviews] objectAtIndex:0] frame];
//		NSRect rectRight= [(NSView *)[[_thumView subviews] objectAtIndex:1] frame];
//		
//		[(NSView *)[[_thumView subviews] objectAtIndex:0] setFrame:NSMakeRect(rectLeft.origin.x, rectLeft.origin.y, rectLeft.size.width - splitInfoImage->oldSize, rectLeft.size.height)];
//		[(NSView *)[[_thumView subviews] objectAtIndex:1] setFrame:NSMakeRect(rectRight.origin.x, rectRight.origin.y, splitInfoImage->oldSize, rectRight.size.height)];
//		splitInfoImage->isOpened = YES;
//	}
//}
//
//- (IBAction)DoBottomHide:(id)sender
//{
//	if (splitInfo2->isOpened) {
//		splitInfo2->oldSize	  = [(NSView *)[[_scanToView subviews] objectAtIndex:1] frame].size.height;
//		NSRect rectTop = [(NSView *)[[_scanToView subviews] objectAtIndex:0] frame];
//		NSRect rectBottom= [(NSView *)[[_scanToView subviews] objectAtIndex:1] frame];
//		
//		[(NSView *)[[_scanToView subviews] objectAtIndex:0] setFrame:NSMakeRect(rectTop.origin.x, rectTop.origin.y, rectTop.size.width, rectTop.size.height + splitInfo2->oldSize)];
//		[(NSView *)[[_scanToView subviews] objectAtIndex:1] setFrame:NSMakeRect(rectBottom.origin.x, rectBottom.origin.y, rectBottom.size.width, 0)];
//		splitInfo2->isOpened = NO;
//	}
//	else {
//		NSRect rectTop = [(NSView *)[[_scanToView subviews] objectAtIndex:0] frame];
//		NSRect rectBottom= [(NSView *)[[_scanToView subviews] objectAtIndex:1] frame];
//		
//		[(NSView *)[[_scanToView subviews] objectAtIndex:0] setFrame:NSMakeRect(rectTop.origin.x, rectTop.origin.y, rectTop.size.width, rectTop.size.height - splitInfo2->oldSize)];
//		[(NSView *)[[_scanToView subviews] objectAtIndex:1] setFrame:NSMakeRect(rectBottom.origin.x, rectBottom.origin.y, rectBottom.size.width,  splitInfo2->oldSize)];
//		splitInfo2->isOpened = YES;
//	}
//	
//}
- (IBAction)DoTableHide:(id)sender
{
	//if ([_tableView isHidden]) {
//		[_tableView setHidden:NO];
//		[_tableHeaderView setHidden:NO];
//		[_tableScrollView setHidden:NO];
//	}
//	else {
//		[_tableView setHidden:YES];
//		[_tableHeaderView setHidden:YES];
//		[_tableScrollView setHidden:YES];
//	}
	NSRect rectTree = [[[_treeView subviews] objectAtIndex:0] frame];
	NSRect rectThum = [[[_thumView subviews] objectAtIndex:2] frame];
	if (splitInfoTree ->isOpened == YES) {
		rectThum.size.width = splitInfoTree->oldWidth * 1.4;
		rectTree.size.width = 0;
		[[[_treeView subviews] objectAtIndex:0] setFrame:rectTree];
		[[[_thumView subviews] objectAtIndex:2] setFrame:rectThum];
		splitInfoTree ->isOpened = NO;
	}
	else {
		rectThum.size.width = 0;
		rectTree.size.width = splitInfoTree->oldWidth;
		[[[_treeView subviews] objectAtIndex:0] setFrame:rectTree];
		[[[_thumView subviews] objectAtIndex:2] setFrame:rectThum];
		splitInfoTree ->isOpened = YES;
	}


}

- (IBAction)backButtonClick:(id)sender;
{
	NSRect rectTree = [[[_treeView subviews] objectAtIndex:0] frame];
	NSRect rectThum = [[[_thumView subviews] objectAtIndex:2] frame];
	
	rectThum.size.width = 0;
	rectTree.size.width = splitInfoTree->oldWidth;
	[[[_treeView subviews] objectAtIndex:0] setFrame:rectTree];
	[[[_thumView subviews] objectAtIndex:2] setFrame:rectThum];
	splitInfoTree ->isOpened = YES;
	
}
- (IBAction)AddCellClick:(id)sender
{
	SimpleNodeData *childNodeData = [[SimpleNodeData alloc] initWithName: @"Untitled"];
	NSString *imagePath = [[NSBundle bundleForClass:[self class]]pathForResource:@"SSOrgMultipleDocuments.jpg" ofType:nil];
	childNodeData.image = [self getImageFromPath:imagePath];
	childNodeData.isEditable = YES;
	NSTreeNode *childTreeNode = [NSTreeNode treeNodeWithRepresentedObject:childNodeData];
	[childNodeData release];

	// Now add the child to this parent tree node
	NSTreeNode *result = (NSTreeNode *)[[[[rootTreeNode childNodes] objectAtIndex:0] childNodes] objectAtIndex:1];
	[[result mutableChildNodes] addObject:childTreeNode];
	[_outLineView reloadData];
	[_outLineView editColumn:0 row:(2 + [[result childNodes] count]) withEvent:nil select:YES];
}
- (IBAction)RemoveCellClick:(id)sender
{
	int returnCode = NSRunAlertPanel(@"確認", @"Do you want to delete seleted list?", @"はい", @"いいえ", nil);
	if (returnCode != NSAlertDefaultReturn) {
		return;
	}
	int seletedRow = [_outLineView selectedRow];
	if (seletedRow <= 2) {
		return;
	}
	 NSTreeNode *result = (NSTreeNode *)[[[[rootTreeNode childNodes] objectAtIndex:0] childNodes] objectAtIndex:1];
	[[result mutableChildNodes] removeObjectAtIndex:seletedRow - 2 -1];
	[_outLineView reloadData];
	[_outLineView selectRow:2 byExtendingSelection:NO];
}

- (IBAction)prePageClick:(id)sender
{
	int pageNumber = _textCurrentPage.NSSOrgTextFieldvalue;
	if (pageNumber < MIN_VALUE || pageNumber > [self.m_currentShowFilesData count]) {
		NSRunAlertPanel(@"ERROR", [NSString stringWithFormat:@"%dから%dまでの整数を入力ください。",MIN_VALUE,[self.m_currentShowFilesData count]], nil, nil, nil);
		return;
	}
	[self preImageViewShowImage:pageNumber - 1];
}
- (IBAction)nextPageClick:(id)sender
{
	int pageNumber = _textCurrentPage.NSSOrgTextFieldvalue;
	if (pageNumber < MIN_VALUE || pageNumber > [self.m_currentShowFilesData count]) {
		NSRunAlertPanel(@"ERROR", [NSString stringWithFormat:@"%dから%dまでの整数を入力ください。",MIN_VALUE,[self.m_currentShowFilesData count]], nil, nil, nil);
		return;
	}
	[self preImageViewShowImage:pageNumber + 1];

}
- (IBAction)jampToPageClick:(id)sender
{
	int pageNumber = [_textCurrentPage intValue];
	if (pageNumber < MIN_VALUE || pageNumber > [self.m_currentShowFilesData count]) {
		NSRunAlertPanel(@"ERROR", [NSString stringWithFormat:@"%dから%dまでの整数を入力ください。",MIN_VALUE,[self.m_currentShowFilesData count]], nil, nil, nil);
		return;
	}
	else {
		[self preImageViewShowImage:pageNumber];
	}

}

#pragma mark  NSSOrgImageView action
- (void)imageViewClick:(id)sender
{
	NSSOrgImageView *imageview = (NSSOrgImageView *)sender;
	if (self.m_currentShowFilesPath == [imageview getNSSOrgFileInfomation].paths) {
		return;
	}
	
	[self preImageViewStartShow:[imageview getNSSOrgFileInfomation].paths];
	
}
- (void)preImageViewStartShow:(NSArray *)filepaths
{
	self.m_currentShowFilesPath = filepaths;
	//*************************//
	//Get JPG/PDF Image data 
	NSMutableArray *tempImageArr = [[NSMutableArray alloc] init];
	NSImage *tempImage = nil;
	for(NSString * filePath in filepaths){
		if ([[filePath pathExtension] caseInsensitiveCompare:@"jpg"] == NSOrderedSame 
			|| [[filePath pathExtension] caseInsensitiveCompare:@"jpeg"] == NSOrderedSame) {
			tempImage = [[NSImage alloc] initWithContentsOfFile:filePath];
			[tempImageArr addObject:tempImage];
			NSObjectReleaseToNil(tempImage);
		}else if ([[filePath pathExtension] caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
			NSPDFImageRep *pdfImage = [NSPDFImageRep imageRepWithContentsOfFile:filePath];
			int count = [pdfImage pageCount];
			for(int i = 0 ; i < count; i++)
			{
				NSPDFImageRep *pdfImagetemp = [NSPDFImageRep imageRepWithContentsOfFile:filePath];
				[pdfImagetemp setCurrentPage:i];
				
				tempImage = [NSImage new];
				[tempImage addRepresentation:pdfImagetemp];
				[tempImageArr addObject:tempImage];
				NSObjectReleaseToNil(tempImage);

				
				//[pdfImage setCurrentPage:i];
//				tempImage = [NSImage new];
//				[tempImage addRepresentation:pdfImage];
//				NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:[tempImage TIFFRepresentation]];
//				NSData *imageData = [rep representationUsingType:NSJPEGFileType properties:nil];
//				NSObjectReleaseToNil(tempImage);
//				tempImage = [NSImage new];
//				[tempImage initWithData:imageData];
//				[tempImageArr addObject:tempImage];
//				NSObjectReleaseToNil(tempImage);
			}
		}
	}
	if (self.m_currentShowFilesData != nil) {
		[self.m_currentShowFilesData removeAllObjects];
		[self.m_currentShowFilesData release];
		self.m_currentShowFilesData = nil;
	}
	self.m_currentShowFilesData = tempImageArr;
	//[tempImageArr removeAllObjects];
//	NSObjectReleaseToNil(tempImageArr);
	//*************************//
	//TODO: m_currentShowFilesDataがnilだかどうかのチェックが必要です。

	[m_transition setSubtype:kCATransitionFromLeft];
	NSImageView *newImageView = nil;
	newImageView = [[NSImageView alloc] initWithFrame:[_preImageView bounds]];
	[newImageView setImage:[m_currentShowFilesData objectAtIndex:0]];
	[newImageView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    //[newImageView setImageScaling:NSScaleProportionally];
	
    if (m_currentImageView && newImageView) {
        [[_preImageView animator] replaceSubview:m_currentImageView with:newImageView];
    } else {
        if (m_currentImageView) [[m_currentImageView animator] removeFromSuperview];
        if (newImageView) [[_preImageView animator] addSubview:newImageView];
    }
	NSObjectReleaseToNil(m_currentImageView);;
    m_currentImageView = [newImageView retain];
	m_currentPage = 1;
	
	[_butPrePage setEnabled:NO];
	if ([self.m_currentShowFilesData count] == MIN_VALUE) {
		[_butNextPage setEnabled:NO];
	}
	else {
		[_butNextPage setEnabled:YES];
	}
	[_labelTotalPage setObjectValue:[NSString stringWithFormat:@"%d",[self.m_currentShowFilesData count]]];
	[_textCurrentPage setObjectValue:[NSString stringWithFormat:@"%d",MIN_VALUE]];
	_textCurrentPage.maxNSSOrgTextFieldvalue = [self.m_currentShowFilesData count];
	_textCurrentPage.NSSOrgTextFieldvalue = MIN_VALUE;
}
@end
