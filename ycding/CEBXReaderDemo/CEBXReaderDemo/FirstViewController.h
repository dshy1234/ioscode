//
//  FirstViewController.h
//  CEBXReaderDemo
//
//  Created by Ray Zhang on 12/6/11.
//  Copyright 2011 Flower Bridge Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController {
    CFRunLoopRef currentLoop;
    NSString *testString;
}
@property (nonatomic,retain)NSString *testString;
- (IBAction)ClickBut:(id)sender;
- (void)a;
@end
