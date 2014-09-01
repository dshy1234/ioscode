//
//  HardFlipperView.h
//  HardFlipper
//
//  Created by guoyu on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol HardFlipperViewDataSource;
@protocol HardFlipperViewDelegate;

//
// - 
//
@interface HardFlipperView : UIView {
    // -- Layers
    CALayer *leftLayer;
    CALayer *leftCoverLayer;
    CALayer *rightLayer;
    CALayer *rightCoverLayer;
    CAGradientLayer *shadowLayer;
    CALayer *bottomLayer;
    
    // -- Delegates
    id<HardFlipperViewDataSource> dataSource;
    id<HardFlipperViewDelegate> delegate;
    
    // -- Cache
    NSMutableDictionary *pageCacheDic;
    
    // --
    CGSize pageSize;
    CGRect leftFrame, rightFrame;
    NSUInteger pageNumber;
    NSUInteger curPageIndex;
    
    BOOL lockUserInteraction;
}

@property (assign) id<HardFlipperViewDataSource> dataSource;
@property (assign) id<HardFlipperViewDelegate> delegate;

- (void) loadInitPage;
- (void) flipPageForward;
//- (void) flipPageBackward;

@end

//
// -
//
@protocol HardFlipperViewDataSource <NSObject>

- (NSUInteger) numberOfPagesInFlipperView:(HardFlipperView*)hfView;
- (void) renderPageAtIndex:(NSUInteger)index context:(CGContextRef)ctx;

@end


//
// -
//
@protocol HardFlipperViewDelegate <NSObject>
@optional
- (void) hardFlipperView:(HardFlipperView *)hfView willTurnToPageAtIndex:(NSUInteger)pageIndex;
- (void) hardFlipperView:(HardFlipperView *)hfView didTurnToPageAtIndex:(NSUInteger)pageIndex;


@end
