//
//  ComFun.h
//  BookFMHD
//
//  Created by Ray Zhang on 9/21/11.
//  Copyright 2011 Showbox.mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <sys/utsname.h>

enum {
    MODEL_UNKNOWN,
    MODEL_IPHONE_SIMULATOR,
    MODEL_IPOD_TOUCH,
    MODEL_IPOD_TOUCH_2G,
    MODEL_IPOD_TOUCH_3G,
    MODEL_IPOD_TOUCH_4G,
    MODEL_IPHONE,
    MODEL_IPHONE_3G,
    MODEL_IPHONE_3GS,
    MODEL_IPHONE_4G,
    MODEL_IPAD
};

#define NSObjectReleaseToNil(a)	\
do {						\
if (a != nil) {			\
[a release];			\
a = nil;				\
}						\
} while(false)

#define CFReleaseToNULL(a)  		\
do { 				\
if (a != NULL) {		\
CFRelease(a);		\
a = NULL;		\
}				\
} while(false)

#define degreesToRadian(x)(M_PI*(x)/180.0)

@interface ComFun : NSObject {
    
}

+ (wchar_t *)NSStringToWChar:(NSString*)sender;

@end
