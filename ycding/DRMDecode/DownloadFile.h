//
//  DownloadFile.h
//  DownloadDataTrain
//
//  Created by Spark Zhu on 11-4-4.
//  Copyright 2011年 Showbox.mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class DownloadFile;
@protocol DownloadFileDelegate
@optional

- (void) client:(DownloadFile *)sender didReceiveData:(int)appID object:(id)object;
- (void) client:(DownloadFile *)sender didReceiveDataError:(int)appID object:(id)object;
- (void) client:(DownloadFile *)sender didReceiveError:(NSError *)error;
- (void) client:(DownloadFile *)sender didReceiveFinish:(int)appID object:(id)object;

@end


@class DownloadFileDelegate;
@interface DownloadFile: NSObject{
    ASIHTTPRequest *clientRequest;
    
	BOOL isRequest;
    id<DownloadFileDelegate> clientDelegate;
    
    int tag;
    int count;
    
    int totalSize;
    int downSize;
    int type;
    NSThread *_thread;
}

@property int totalSize;
@property int downSize;
@property BOOL isRequest;
@property int tag;
@property int type;
@property(nonatomic, retain)ASIHTTPRequest *clientRequest;
@property(nonatomic, assign)id<DownloadFileDelegate> clientDelegate;

- (id)initWithDelegate:(id)delegate;
- (void)startRequest:(id)sender;
+ (NSURL *)smartURLForString:(NSString *)str;
+ (NSString *)hexToString:(NSString *)str;
+(NSString *)stringToHex:(NSString *)str;
- (void)cancelRequest;
@end
