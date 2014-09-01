//
//  DRMEncode.h
//  BookFMHD
//
//  Created by Ray Zhang on 12/26/11.
//  Copyright 2011 Showbox.mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRMEncode : NSObject {
    
}
+ (void)GetRelFile:(NSString**)relUrlString CEBXUrlString:(NSString**)cebxUrlString PostData:(NSData**)postData;
+ (bool)ParseRelResponse:(NSData*)responseData;
@end
