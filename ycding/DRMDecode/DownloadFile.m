//
//  NetworkClient.m
//  DownloadDataTrain
//
//  Created by Spark Zhu on 11-4-4.
//  Copyright 2011年 Showbox.mobi. All rights reserved.
//

#import "DownloadFile.h"

@implementation DownloadFile

@synthesize isRequest;
@synthesize clientDelegate;
@synthesize clientRequest;
@synthesize tag;
@synthesize type;
@synthesize totalSize;
@synthesize downSize;

+ (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
	
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

+(NSString *)hexToString:(NSString *)str
{
    
    int length = [str length]/2;
    char buf[length+1];
    buf[length]=0;
    
    for (int i=0; i<length; i++) {
        NSRange range;
        range.location= i*2;
        range.length=2;
        
        NSString *charStr = [NSString stringWithFormat:@"0x%@",[str substringWithRange:range]];
        
        unsigned int value;
        NSScanner *scanner = [NSScanner scannerWithString:charStr];
        [scanner scanHexInt:&value];
        //[scanner release];
        
        buf[i]=value;
    }
    
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}

+(NSString *)stringToHex:(NSString *)str
{
    char HEX[16] = { '0', '1', '2', '3', '4', '5',
		'6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    
    const char* buf = [str UTF8String];
    int buflen = strlen(buf);
    
    char buf1[buflen*2+1];
    buf1[buflen*2]=0;
    
    for (int i=0; i<buflen; i++) {
        buf1[i*2] = HEX[buf[i]>>4&0x0f];
        buf1[i*2+1] = HEX[buf[i]&0x0f];
    }
    
    return [NSString stringWithCString:buf1 encoding:NSASCIIStringEncoding];
}

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        // Custom initialization.
		
		self.clientDelegate = delegate;
        self.clientRequest = [ASIHTTPRequest requestWithURL:nil];
    }
	isRequest = NO;
    return self;
}
- (void)cancelRequest
{
    if ([clientRequest isExecuting]) {
        [clientRequest clearDelegatesAndCancel];
    }
}
- (void)startRequest:(id)sender
{	

    if (sender!=nil) {
        [clientRequest setRequestMethod:@"POST"];
        [clientRequest appendPostData:sender];
    }
    else
    {
        [clientRequest setRequestMethod:@"GET"];
    }
    /*
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    */
    /*
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                           @"gzip,deflate",
                                                                           [NSString stringWithFormat:@"ver=2.0&lang=%@", preferredLang],
                                                                           nil] 
                                                                  forKeys:[NSArray arrayWithObjects:
                                                                           @"Accept-Encoding",
                                                                           @"Application",
                                                                           nil]];
    
    [clientRequest setRequestHeaders:dic];
    */
    _thread = [NSThread currentThread];
    
	[clientRequest setTimeOutSeconds:30];
	[clientRequest setDelegate:self];
	[clientRequest start];

	isRequest = YES;
}

#pragma mark -
#pragma mark NetworkClientDelegate

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"%@", responseHeaders);
    totalSize = [[responseHeaders objectForKey:@"Content-Length"] intValue];
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    /*
    if (count == 0) {
        //char buf[4];
        //[data getBytes:buf length:3];
        
        //buf[3]=0;
        
        //NSString *rc = [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
        
        //if (![rc isEqualToString:@"305"]) 
        {
            if (clientDelegate != nil) {
                [clientDelegate client:self didReceiveDataError:tag object:nil];
            }
            
            return;
        }
        
    }
     */
    [clientDelegate client:self didReceiveData:tag*0x10000+count++ object:data];
    downSize += [data length];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	isRequest = NO;
	// Use when fetching text data
	NSString *responseString = [request responseString];
    NSLog(@"收到数据\r\n%@", responseString);
	// Use when fetching binary data
	NSData *responseData = [request responseData];

	if (responseData!=nil)
	{
        if (clientDelegate!=nil)
            [clientDelegate client:self didReceiveFinish:tag object:nil];
	}	
    else
    {
        if (clientDelegate!=nil)
            [clientDelegate client:self didReceiveDataError:tag object:nil];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	isRequest = NO;
	NSError *error = [request error];
	
	//NSLog(@"%@", error);
	
    if (clientDelegate!=nil)
        [clientDelegate client:self didReceiveError:error];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[super dealloc];
}

@end
