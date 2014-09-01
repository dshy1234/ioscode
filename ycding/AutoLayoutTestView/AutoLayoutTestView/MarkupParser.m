//
//  MarkupParser.m
//  AutoLayoutTestView
//
//  Created by rayzhang on 6/14/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import "MarkupParser.h"


@implementation MarkupParser

@synthesize font, color, strokeColor, strokeWidth;
@synthesize images;
-(id)init
{
    self = [super init];
    if (self) {
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    return self;
}


-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    
}

-(void)dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.images = nil;
    
    [super dealloc];
}
@end
