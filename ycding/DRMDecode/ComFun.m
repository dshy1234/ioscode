//
//  ComFun.m
//  BookFMHD
//
//  Created by Ray Zhang on 9/21/11.
//  Copyright 2011 Showbox.mobi. All rights reserved.
//

#import "ComFun.h"
#import "ComData.h"
#import <MessageUI/MessageUI.h>
#include <sys/types.h>
#include <sys/sysctl.h>
static Boolean   isInReading = NO;
@implementation ComFun
+ (void)SetisInReading:(Boolean)sender
{
    isInReading = sender;
}
+ (Boolean)GetisInReading
{
    return isInReading;
}
+ (BOOL)DeviceIsiPad
{
    NSString *deviceType = [[UIDevice currentDevice] model];
    
    NSRange range = [deviceType rangeOfString:DEVICE_TYPE_IPAD];
    if (range.location == NSNotFound) {
        return NO;
    }
    else {
        return YES;
    }
}
+ (BOOL) isIPodTouch
{
    int model = [ComFun detectDevice];
    if (model == MODEL_IPOD_TOUCH || model == MODEL_IPAD){
        //|| model == MODEL_IPHONE_SIMULATOR){
        return YES;
    }    
    else {
        return NO;
    }
    
}

+ (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (int) detectModel{
    NSString *platform = [ComFun platform];
    
    if ([platform isEqualToString:@"iPhone1,1"])   
        return MODEL_IPHONE;
    
    if ([platform isEqualToString:@"iPhone1,2"])   
        return MODEL_IPHONE_3G;
    
    if ([platform isEqualToString:@"iPhone2,1"])
        return MODEL_IPHONE_3GS;
    
    if ([platform isEqualToString:@"iPhone3,1"])    
        return MODEL_IPHONE_4G;
    
    if ([platform isEqualToString:@"iPod1,1"])      
        return MODEL_IPOD_TOUCH;
    
    if ([platform isEqualToString:@"iPod2,1"])      
        return MODEL_IPOD_TOUCH_2G;
    
    if ([platform isEqualToString:@"iPod3,1"])      
        return MODEL_IPOD_TOUCH_3G;
    
    if ([platform isEqualToString:@"iPod4,1"])      
        return MODEL_IPOD_TOUCH_4G;
    
    if ([platform isEqualToString:@"iPad1,1"])      
        return MODEL_IPAD;
    
    if ([platform isEqualToString:@"i386"])         
        return MODEL_IPHONE_SIMULATOR;
    
    return MODEL_UNKNOWN;
}


+ (uint) detectDevice {
    NSString *model= [[UIDevice currentDevice] model];
    
    // Some iPod Touch return "iPod Touch", others just "iPod"
    
    NSString *iPodTouch = @"iPod Touch";
    NSString *iPodTouchLowerCase = @"iPod touch";
    NSString *iPodTouchShort = @"iPod";
    NSString *iPad = @"iPad";
    
    NSString *iPhoneSimulator = @"iPhone Simulator";
    
    uint detected;
    
    if ([model compare:iPhoneSimulator] == NSOrderedSame) {
        // iPhone simulator
        detected = MODEL_IPHONE_SIMULATOR;
    }
    else if ([model compare:iPad] == NSOrderedSame) {
        // iPad
        detected = MODEL_IPAD;
    } else if ([model compare:iPodTouch] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else if ([model compare:iPodTouchLowerCase] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else if ([model compare:iPodTouchShort] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else {
        // Could be an iPhone V1 or iPhone 3G (model should be "iPhone")
        struct utsname u;
        
        // u.machine could be "i386" for the simulator, "iPod1,1" on iPod Touch, "iPhone1,1" on iPhone V1 & "iPhone1,2" on iPhone3G
        
        uname(&u);
        
        if (!strcmp(u.machine, "iPhone1,1")) {
            detected = MODEL_IPHONE;
        } else if (!strcmp(u.machine, "iPhone1,2")){
            detected = MODEL_IPHONE_3G;
        } else if (!strcmp(u.machine, "iPhone2,1")){
            detected = MODEL_IPHONE_3GS;
        } else if (!strcmp(u.machine, "iPhone3,1")){
            detected = MODEL_IPHONE_4G;
        }
    }
    return detected;
}

+ (NSString *) returnDeviceName:(BOOL)ignoreSimulator {
    NSString *returnValue = @"Unknown";
    
    switch ([ComFun detectDevice]) {
        case MODEL_IPHONE_SIMULATOR:
            if (ignoreSimulator) {
                returnValue = @"iPhone 3G";
            } else {
                returnValue = @"iPhone Simulator";
            }
            break;
        case MODEL_IPOD_TOUCH:
            returnValue = @"iPod Touch";
            break;
        case MODEL_IPHONE:
            returnValue = @"iPhone";
            break;
        case MODEL_IPHONE_3G:
            returnValue = @"iPhone 3G";
            break;
        default:
            break;
    }
    return returnValue;
}
+ (NSString *)GetTimeStamp
{
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
   // NSString *string = [dateFormatter stringFromDate:[NSDate date]];
    return [dateFormatter stringFromDate:[NSDate date]];
}
+ (wchar_t *)NSStringToWChar:(NSString*)sender
{
    return (wchar_t *)[sender cStringUsingEncoding:NSUTF32StringEncoding];
}
@end
