//
//  FontDetailViewController.h
//  FontList
//
//  Created by mac on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontDetailViewController : UITableViewController{
	UIFont *font;
	NSString *text;
	UISlider *fontSizeSlider;
}
- (id)initWithFontName:(NSString *)fontName;
@end
