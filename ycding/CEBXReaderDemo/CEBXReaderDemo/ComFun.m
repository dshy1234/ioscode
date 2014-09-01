//
//  ComFun.m
//  BookFMHD
//
//  Created by Ray Zhang on 9/21/11.
//  Copyright 2011 Showbox.mobi. All rights reserved.
//

#import "ComFun.h"
#include <sys/types.h>
#include <sys/sysctl.h>
@implementation ComFun

+ (wchar_t *)NSStringToWChar:(NSString*)sender
{
    return (wchar_t *)[sender cStringUsingEncoding:NSUTF32StringEncoding];
}
@end
