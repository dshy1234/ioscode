//
//  MainViewController.h
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimpleNodeData.h"
#import "ImageAndTextCell.h"
#import "SSOrgOutlineview.h"
#import "SettingViewControlller.h"
#import "GlobalData.h"
#import "NSSOrgImageView.h"
#import "NSSOrgFileInfomation.h"
#import "NSSOrgTextField.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CoreImage.h>
#import "CDbManger.h"


typedef struct
{
	NSSplitView	*splitView;
	CGFloat		 oldWidth;
	BOOL		 isOpened;
}SSOrgSplitInfo;

@interface MainViewController : NSWindowController {
    NSTreeNode						*rootTreeNode;
	NSRect							 m_tableViewRect;
	SSOrgSplitInfo					*splitInfoTree;
	//SSOrgSplitInfo					*splitInfoImage;
	//SSOrgSplitInfo					*splitInfoImage;
   
	SimpleNodeData					*selectedNodeData;
	
	NSImage							*m_imageNone;
	NSImage							*m_imageAvailable;
	NSImageView						*m_currentImageView;
	CATransition					*m_transition;
	
	IBOutlet SSOrgOutlineview		*_outLineView;
	IBOutlet NSSplitView			*_treeView;
	IBOutlet NSSplitView			*_scanToView;
	IBOutlet NSSplitView			*_thumView;
	IBOutlet NSTableView			*_tableView;
	IBOutlet NSTableHeaderView		*_tableHeaderView;
	IBOutlet NSScrollView			*_tableScrollView;
	IBOutlet NSScrollView			*_imageView;
	IBOutlet SettingViewControlller *_settingViewControlller;
	
	IBOutlet NSButton				*_butAddCell;
	IBOutlet NSButton				*_butRemoveCell;
	
	
	IBOutlet NSButton				*_butPrePage;
	IBOutlet NSButton				*_butNextPage;
	
	IBOutlet NSView					*_preImageView;
	
	IBOutlet NSTextField			*_labelTotalPage;
	IBOutlet NSSOrgTextField		*_textCurrentPage;

	//NSArray							*m_arrFilePath;

	NSArray							*m_currentShowFilesPath;
	NSMutableArray					*m_currentShowFilesData;

	NSMutableArray				    *m_allShowFiles;
	int								m_startModel;
	int								m_currentPage;
	BOOL							m_isStarted;
}
@property(readwrite, retain) NSArray *m_currentShowFilesPath;
@property(readwrite, retain) NSMutableArray *m_currentShowFilesData;

- (NSTreeNode *)treeNodeFromDictionary:(NSDictionary *)dictionary;
- (void)showMainView:(NSArray*)fileNames;
- (BOOL)CheckFileType:(NSArray *)arr;
- (void)ShowImageView:(NSArray *)filePaths;
- (void)ChangeImagePosition;
- (void)getAllShowFile;
- (void)imageViewClick:(id)sender;
- (void)preImageViewStartShow:(NSArray *)filepaths;
- (void)preImageViewShowImage:(int)imageNumber;
- (NSMutableDictionary *)DictionaryFromtreeNode:(NSTreeNode *)treeNode;
//- (void)OutlineViewDoubleAction:(id)sender;
- (NSImage *)getImageFromPath:(NSString *)path;
- (NSImage *)getThumbnailFromPath:(NSString *)path;

- (void)saveFilePathsToDB:(NSArray *)FilePaths;


- (IBAction)DoSaveFile:(id)sender;
- (IBAction)DoAbout:(id)sender;

//- (IBAction)DoLeftHide:(id)sender;
//
//- (IBAction)DoRightHide:(id)sender;
//
//- (IBAction)DoBottomHide:(id)sender;
- (IBAction)DoTableHide:(id)sender;

- (IBAction)AddCellClick:(id)sender;
- (IBAction)RemoveCellClick:(id)sender;
- (IBAction)prePageClick:(id)sender;
- (IBAction)nextPageClick:(id)sender;
- (IBAction)jampToPageClick:(id)sender;
- (IBAction)backButtonClick:(id)sender;


@end
