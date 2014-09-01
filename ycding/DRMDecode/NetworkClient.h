//
//  NetworkClient.h
//  DownloadDataTrain
//
//  Created by Spark Zhu on 11-4-4.
//  Copyright 2011年 Showbox.mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class NetworkClient;
@protocol NetworkClientDelegate
@optional

- (void) client:(NetworkClient *)sender didReceiveData:(int)appID object:(id)object;
- (void) client:(NetworkClient *)sender didReceiveDataError:(int)appID object:(id)object;
- (void) client:(NetworkClient *)sender didReceiveError:(NSError *)error;
- (void) client:(NetworkClient *)sender didReceiveFinish:(int)appID object:(id)object;

@end


@class NetworkClientDelegate;
@interface NetworkClient: NSObject{
    ASIHTTPRequest *clientRequest;
    
	BOOL isRequest;
    id<NetworkClientDelegate> clientDelegate;
    
    int tag;
    int count;
    
    int type;
}

@property BOOL isRequest;
@property int tag;
@property int type;
@property(nonatomic, retain)ASIHTTPRequest *clientRequest;
@property(nonatomic, assign)id<NetworkClientDelegate> clientDelegate;

- (id)initWithDelegate:(id)delegate;
- (void)startRequest:(id)sender;
- (void)cancelRequest;
+ (NSURL *)smartURLForString:(NSString *)str;
+ (NSString *)hexToString:(NSString *)str;
+(NSString *)stringToHex:(NSString *)str;
@end
