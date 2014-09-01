//
//  ShowView.h
//  LoadURL
//
//  Created by Ray Zhang on 7/13/12.
//  Copyright (c) 2012 Flower Bridge Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowView : UIViewController
{
    IBOutlet UITextField *urlText;
    IBOutlet UIWebView   *webView;
}
@property(nonatomic,retain)IBOutlet UITextField *urlText;
@property(nonatomic,retain)IBOutlet UIWebView   *webView;

- (IBAction)RefreshWebView:(id)sender;
@end
