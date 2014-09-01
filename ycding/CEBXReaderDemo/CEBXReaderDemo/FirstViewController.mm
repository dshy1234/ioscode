//
//  FirstViewController.m
//  CEBXReaderDemo
//
//  Created by Ray Zhang on 12/6/11.
//  Copyright 2011 Flower Bridge Technology. All rights reserved.
//

#import "FirstViewController.h"
#import "CEBXEditorAPI.h"
#import "Quartzcore/CALayer.h"
#import "XEKPage.h"
#import "XEKDoc.h"
#import "ComFun.h"
#define MCEBX_MAX(a,b) a>b?a:b
#define MCEBX_MIN(a,b) a>b?b:a

@implementation FirstViewController
@synthesize testString;
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(ShowFile:) withObject:nil afterDelay:1];
//    [self a];
//    NSLog(@"%d",[testString retainCount]);

    
}
- (void)a
{
    testString = [[[NSString alloc] initWithString:@"aa"] autorelease];
    NSLog(@"%d",[testString retainCount]);
}
- (void)b{
    
}
- (void)ShowFile:(id)sender{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CEBX_M_v1.2_Spec" ofType:@"cebx"];
    NSString *sourcePath = [filePath stringByDeletingLastPathComponent];
    NSString *workPath = [[documentFolderPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"tmp"];
    
    long retu =  XEK_Initialize((wchar_t*)[sourcePath cStringUsingEncoding:NSUTF32StringEncoding],(wchar_t *)[workPath cStringUsingEncoding:NSUTF32StringEncoding]);
    
    IXEKCEBXFile *pfile = DK_NULL;
    retu = XEK_CreateCEBXFile(pfile);
    retu = pfile->Open((wchar_t *)[filePath cStringUsingEncoding:NSUTF32StringEncoding]);
    IXEKDoc *pdoc = DK_NULL;
    retu = pfile->OpenDoc(pdoc);
    DK_UINT pageNo =  pdoc->GetPageCount();
    
    NSString *fontPath1 = [[NSBundle mainBundle] pathForResource:@"DroidSansFallback" ofType:@"ttf"];
    NSString *fontPath2 = [[NSBundle mainBundle] pathForResource:@"DroidSerif-Regular" ofType:@"ttf"];
    
    retu = XEK_RegisterFontFaceName([ComFun NSStringToWChar:@"DefaultAnsiFontName"], [ComFun NSStringToWChar:fontPath2]);
    retu = XEK_RegisterFontFaceName([ComFun NSStringToWChar:@"DefaultGBFontName"], [ComFun NSStringToWChar:fontPath1]);
    
    pdoc->SetDefaultFontFaceName([ComFun NSStringToWChar:@"DefaultAnsiFontName"], DK_CHARSET_ANSI);
    pdoc->SetDefaultFontFaceName([ComFun NSStringToWChar:@"DefaultGBFontName"], DK_CHARSET_GB);
    
    int aa = 600;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100.0, 100.0, 305, 438)];
    [imageView setBackgroundColor:[UIColor yellowColor]];
    //[imageView setImage:image];
    [self.view addSubview:imageView];
    
    IXEKStructureDoc* pStructDoc = pdoc->GetStructureDoc(); 
    DK_BOOL a = pStructDoc->IsEmpty();
    
    // 输出设备区域 
    int x = 305; 
    int y = 438; 
    DK_LONG lImageSize = x * y * 4; 
    DK_BYTE* pbyImage = new DK_BYTE[lImageSize]; 
    memset(pbyImage, 0xFF, lImageSize); 
    
    DK_BITMAPBUFFER_DEV dev; 
    dev.lWidth = x; 
    dev.lHeight = y; 
    dev.lStride = x * 4; 
    dev.nDPI = 96; 
    dev.nPixelFormat = DK_PIXELFORMAT_RGB32; 
    dev.pbyData = pbyImage; 
    
    DK_FLOWRENDEROPTION option; 
    // 设置输出设备类型 
    option.nDeviceType = DK_OUTPUTDEV_BITMAPBUFFER; 
    // 设置输出设备对象 
    option.pDevice = &dev; 
    // 设置设备上的输出区域 
    option.rcDispBox = DK_BOX(0, 0, x, y); 
    // 绘制的基准流式位置 
    DK_FLOWPOSITION posStart; 
    // …获取posStart 值 
    option.posBase = posStart; 
    // 基准流式位置在设备空间上的输出Y坐标 
    option.dBaseYPos = 0; 
    // 缩放比（>0） 
    option.dScale = 1.5; 
    // 平滑参数 
    option.dwSmoothTag = DK_SMOOTH_IMAGE | DK_SMOOTH_GRAPH | DK_SMOOTH_TEXT; 
    //第一行对齐方式,推荐：向下翻页时设为DK_TOPALIGN_DOWN，向上翻页时设为 
    // DK_TOPALIGN_UP 
    option.nTopAlign = DK_TOPALIGN_DOWN;    // 当行高>0.0时,显示不完全的行 
    option.dMinPartRow= 1024.0; 
    // 开始绘制第一屏 
    DK_FLOWRENDERRESULT result;
     while (pStructDoc->Render(option, result) == DKR_OK) {
//    if(pStructDoc->Render(option, result) == DKR_OK){
       if (result.bDocEnd)
       {
         NSLog(@"已经到达全文末尾。");
         return;
       }
       else{
         CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
         CGContextRef context = CGBitmapContextCreate(pbyImage,dev.lWidth,dev.lHeight,8,dev.lWidth * 4,colorSpace,kCGImageAlphaPremultipliedLast);
         
         CGImageRef myImage = CGBitmapContextCreateImage(context);
         UIImage *image = [[UIImage alloc] initWithCGImage:myImage];
         [imageView setImage:image];
         option.posBase = result.posEnd;
         memset(pbyImage, 0xFF, lImageSize);
         CFReleaseToNULL(colorSpace);
         CFReleaseToNULL(context);
         CFReleaseToNULL(myImage);
         currentLoop = CFRunLoopGetCurrent();
         CFRunLoopRun();
         // sleep(2);
       }
        //         MessageBox(L"已经到达全文末尾。");
    }
}
- (IBAction)ClickBut:(id)sender{
    CFRunLoopStop(currentLoop);
}
- (void)ShowImage:(id)sender{
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
