//
//  MarkupParser.h
//  AutoLayoutTestView
//
//  Created by rayzhang on 6/14/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MarkupParser : NSObject {
    NSString* font;
    UIColor* color;
    UIColor* strokeColor;
    float strokeWidth;
    
    NSMutableArray* images;
}
@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (retain, nonatomic) NSMutableArray* images;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;
@end
