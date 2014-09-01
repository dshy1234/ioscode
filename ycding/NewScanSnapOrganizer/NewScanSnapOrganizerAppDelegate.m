//
//  NewScanSnapOrganizerAppDelegate.m
//  NewScanSnapOrganizer
//
//  Created by psh on 11/07/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewScanSnapOrganizerAppDelegate.h"

#define	BUNDLE_PATH			@"debug/NSSOrgBundle.bundle"


@implementation NewScanSnapOrganizerAppDelegate

@synthesize window;
- (id) init
{
	self = [super init];
	if (self != nil) {
		isStarted = NO;
		m_STSFBundle = nil;
		m_STSFMainClass = nil;
		m_STSFBundleController = nil;
	}
	return self;
}

-(void)applicationWillFinishLaunching:(NSNotification *) notification
{	
	NSMutableArray *arr = [NSMutableArray new];
	[arr addObject:@"/11.jpg"];
	[arr addObject:@"/12.jpg"];
	[arr addObject:@"/13.jpg"];
	[arr addObject:@"/14.jpg"];
	[arr addObject:@"/15.jpg"];

    [self handleBundle:arr];
	return;
	static BOOL				bRegiste		= FALSE;
	
	if(bRegiste){
		return;
	}
	NSAppleEventManager *manager = [NSAppleEventManager sharedAppleEventManager];
		if (manager)
	{
		[manager setEventHandler:self 
					 andSelector:@selector(handleLaunchedEvent:withReplyEvent:) 
				   forEventClass:(AEEventClass)kAEInternetSuite 
					  andEventID:(AEEventID)kAEISGetURL];
		
		[manager setEventHandler:self 
					 andSelector:@selector(handleLaunchedEvent:withReplyEvent:) 
				   forEventClass:(AEEventClass)kCoreEventClass 
					  andEventID:(AEEventID)kAEOpenDocuments];
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	if (isStarted == NO) {
		[self handleBundle:nil];
	}
}

- (void)handleLaunchedEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
	
	AEDesc		*desc		=	nil;
	long		lCount		=	0;
	OSStatus	err			=	noErr;
	FSRef		fileRef		=	{{0}};
	CFURLRef	urlRef		=	NULL;
	CFStringRef strPOSIX	=	NULL;
	int			i			=	0;
	
	NSAppleEventDescriptor			*addrDesc		=	nil;
	ProcessSerialNumber				*psn			=	nil;
	NSMutableArray *refArray = [[NSMutableArray alloc] init];
	
		
	addrDesc = [event attributeDescriptorForKeyword:keyAddressAttr];
	psn = (ProcessSerialNumber*)[[[addrDesc coerceToDescriptorType:typeProcessSerialNumber] data] bytes];

	
    NSAppleEventDescriptor *directObjectDescriptor = [event paramDescriptorForKeyword:keyDirectObject];

	
    desc = (AEDesc*)[directObjectDescriptor aeDesc];

	err = AECountItems(desc, &lCount);
	
	for(i = 1; i <= lCount; i++)
	{
		err = AEGetNthPtr((AEDescList*) desc, i, typeFSRef, NULL, NULL, &fileRef, sizeof(FSRef) , NULL);
		
		urlRef = CFURLCreateFromFSRef(NULL ,&fileRef);
		
		
		strPOSIX = CFURLCopyFileSystemPath(urlRef,kCFURLPOSIXPathStyle);
		CFReleaseToNULL(urlRef);
		
		
		[refArray addObject:(NSString*)strPOSIX];
		
		CFReleaseToNULL(strPOSIX);
	}
	[self handleBundle:refArray];
}


- (void)handleBundle:(NSArray*)arrSTSFFileArray
{
	NSLog(@"handleBundle%d",isStarted);

	isStarted = YES;
	
	if (m_STSFBundle == nil) {
		//get the bundle by the path
		NSString		*strBundlePath		=	nil;
		strBundlePath=[NSString stringWithString:[[NSBundle mainBundle] bundlePath]];
		strBundlePath=[strBundlePath stringByDeletingLastPathComponent];
		strBundlePath=[strBundlePath stringByDeletingLastPathComponent];
		strBundlePath=[strBundlePath stringByAppendingPathComponent:BUNDLE_PATH];
		m_STSFBundle = [NSBundle bundleWithPath:strBundlePath];
	}
	if (m_STSFMainClass == nil) {
		m_STSFMainClass = [m_STSFBundle principalClass];
	}
	if (m_STSFBundleController == nil) {
		m_STSFBundleController = [[m_STSFMainClass alloc] init];

	}
	
	//[m_STSFBundle setAboutMenuItem:m_menuItemAbout];
	[m_STSFBundleController runORG:arrSTSFFileArray];
	
	
	
FUNC_END:

	return;
}
@end
