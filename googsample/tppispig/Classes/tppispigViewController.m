//
//  tppispigViewController.m
//  tppispig
//
//  Created by gao wei on 10-7-15.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "tppispigViewController.h"
#import "WebViewAdditions.h"
@implementation tppispigViewController



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
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.163.com"]];
	[webView loadRequest:request];
	[self.view addSubview:webView];
	webView.delegate = self;
	[request release];
	[webView release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
	
    [super viewDidLoad];
}

- (void)openContextualMenuAt:(CGPoint)pt
{
	// Load the JavaScript code from the Resources and inject it into the web page
	NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
	NSLog(@"%@",path);
	
	NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	NSLog(@"%@!!",jsCode);
	[webView stringByEvaluatingJavaScriptFromString: jsCode];
	
	
	
	
	// get the Tags at the touch location
	NSString *tags = [NSString stringWithString:[webView stringByEvaluatingJavaScriptFromString:
					  [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]]];
	
	
	NSLog(@"%@,%d,%d~~~~~~~~",tags,(NSInteger)pt.x,(NSInteger)pt.y);
	
	// create the UIActionSheet and populate it with buttons related to the tags
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Contextual Menu"
													   delegate:self cancelButtonTitle:@"Cancel"
										 destructiveButtonTitle:nil otherButtonTitles:nil];
	
	// If a link was touched, add link-related buttons
	if ([tags rangeOfString:@",A,"].location != NSNotFound) {
		[sheet addButtonWithTitle:@"Open Link"];
		[sheet addButtonWithTitle:@"Open Link in Tab"];
		[sheet addButtonWithTitle:@"Download Link"];
	}
	// If an image was touched, add image-related buttons
	if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
		[sheet addButtonWithTitle:@"Save Picture"];
	}
	// Add buttons which should be always available
	[sheet addButtonWithTitle:@"Save Page as Bookmark"];
	[sheet addButtonWithTitle:@"Open Page in Safari"];
	
	[sheet showInView:webView];
	[sheet release];
}

- (void)contextualMenuAction:(NSNotification*)notification
{
	CGPoint pt;
	NSDictionary *coord = [notification object];
	pt.x = [[coord objectForKey:@"x"] floatValue];
	pt.y = [[coord objectForKey:@"y"] floatValue];
	
	// convert point from window to view coordinate system
	pt = [webView convertPoint:pt fromView:nil];
	
	// convert point from view to HTML coordinate system
	CGPoint offset  = [webView scrollOffset];
	CGSize viewSize = [webView frame].size;
	CGSize windowSize = [webView windowSize];
	
	CGFloat f = windowSize.width / viewSize.width;
	pt.x = pt.x * f + offset.x;
	pt.y = pt.y * f + offset.y;
	
	[self openContextualMenuAt:pt];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	 [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [super dealloc];
}

@end
