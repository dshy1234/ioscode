//
//  CTTestView.h
//  AutoLayoutTestView
//
//  Created by rayzhang on 6/14/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"

#define SHOW_MODE_JUST_IMAGE        1
#define SHOW_MODE_BIG_IMAGE         2
#define SHOW_MODE_SMALL_IMAGE       3
#define SHOW_MODE_NO_IMAGE          4

#define TITLE_FONT_SIZE             20
#define TEXT_FONT_SIZE              15
#define FROM_FONT_SIZE              10

#define MAX_MIN_SCALE               1.5


@interface CTTestView : UIView {
    NSString *imageName;

    NSString *stritle;
    NSString *fromIcon;
    NSString *fromName;
    NSString *dateUtilNow;
    NSArray  *contentArr;
    NSMutableAttributedString *aString;
    int showMode;
    
    Boolean isTopBigBlock;
    
    
    
    NSString* font;
    UIColor* color;
    UIColor* strokeColor;
    float strokeWidth;
        
    UILabel *titleLabel;
    UILabel *fromLabel;
    UIImageView *imageView;
    
    UIFont  *titleFont;
    UIFont  *fromFont;
}
@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@end
