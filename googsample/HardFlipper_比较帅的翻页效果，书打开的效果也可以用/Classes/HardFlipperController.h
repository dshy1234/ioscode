//
//  HardFlipperController.h
//  HardFlipper
//
//  Created by guoyu on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HardFlipperView.h"

@interface HardFlipperController : UIViewController<HardFlipperViewDataSource, HardFlipperViewDelegate> {
    HardFlipperView *flipperView;
}

@end
