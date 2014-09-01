//
//  HardFlipperView.m
//  HardFlipper
//
//  Created by guoyu on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HardFlipperView.h"

@interface HardFlipperView()

@property (assign) CGSize pageSize;

- (void) allocLayers;
- (void) initialize;
- (void) didFlipPageForward;

@end

@implementation HardFlipperView

@synthesize dataSource, delegate, pageSize;

- (void) allocLayers {
    self.clipsToBounds = YES;
    
	leftLayer = [[CALayer alloc] init];
	leftLayer.masksToBounds = YES;
	leftLayer.contentsGravity = kCAGravityLeft;
	leftLayer.backgroundColor = [[UIColor whiteColor] CGColor];
	
	leftCoverLayer = [[CALayer alloc] init];
    leftCoverLayer.masksToBounds = YES;
	leftCoverLayer.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
	leftCoverLayer.hidden = YES;
    [leftLayer addSublayer:leftCoverLayer];
    
    rightLayer = [[CALayer alloc] init];
	rightLayer.masksToBounds = YES;
	rightLayer.contentsGravity = kCAGravityLeft;
	rightLayer.backgroundColor = [[UIColor whiteColor] CGColor];

	rightCoverLayer = [[CALayer alloc] init];
    rightCoverLayer.masksToBounds = YES;
	rightCoverLayer.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
	rightCoverLayer.hidden = YES;
    [rightLayer addSublayer:rightCoverLayer];
    
	shadowLayer = [[CAGradientLayer alloc] init];
	shadowLayer.colors = [NSArray arrayWithObjects:
							(id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
							(id)[[UIColor clearColor] CGColor],
							nil];
	shadowLayer.startPoint = CGPointMake(0.5f, 0.5f);
	shadowLayer.endPoint = CGPointMake(1.0f, 0.5f);
    
    bottomLayer = [[CALayer alloc] init];
	bottomLayer.masksToBounds = YES;
	bottomLayer.contentsGravity = kCAGravityLeft;
	bottomLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    [self.layer addSublayer:bottomLayer];
    [self.layer addSublayer:leftLayer];
    [self.layer addSublayer:rightLayer];
    [self.layer addSublayer:shadowLayer];
    
    self.layer.backgroundColor = [[UIColor brownColor] CGColor];
    
}

- (void) initialize {
    [self allocLayers];
	pageCacheDic = [[NSMutableDictionary alloc]initWithCapacity:16];
    self.pageSize = self.bounds.size;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
    [self initialize];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [leftLayer release];
    [leftCoverLayer release];
    [rightLayer release];
    [rightLayer release];
    [rightCoverLayer release];
    [shadowLayer release];
    [bottomLayer release];
    
    [pageCacheDic release];
    
    [super dealloc];
}


- (CGImageRef)loadPageImageAt:(NSUInteger)pageIndex {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSNumber *objIndex = [NSNumber numberWithUnsignedInt:pageIndex];
    UIImage *uiImage = [pageCacheDic objectForKey:objIndex];
    if (!uiImage) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, 
                                                     pageSize.width * 0.5f, 
                                                     pageSize.height, 
                                                     8,						/* bits per component*/
                                                     pageSize.width * 0.5f * 4.0f, 	/* bytes per row */
                                                     colorSpace, 
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width, pageSize.height));
        
        [dataSource renderPageAtIndex:pageIndex context:context];
        
        CGImageRef cgImage = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        uiImage = [UIImage imageWithCGImage:cgImage];
        [pageCacheDic setObject:uiImage forKey:objIndex];
    }
    
    [pool drain];
    
    return (uiImage.CGImage);
}

- (void) refreshLayers {
    if (!pageNumber) {
        return;
    }
    
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
    
    leftLayer.frame = leftFrame;
    if(curPageIndex > 0 ) {
        leftLayer.contents = (id)[self loadPageImageAt:curPageIndex-1];
    } else {
        leftLayer.contents = nil;
    }
    leftCoverLayer.frame = leftLayer.bounds;
    leftCoverLayer.hidden = YES;
    
    rightLayer.frame = rightFrame;
    rightLayer.anchorPoint = CGPointMake(0.f, 0.5f);
    rightLayer.position = CGPointMake(rightFrame.origin.x, 
                                      rightFrame.size.height * 0.5f);
    if (curPageIndex < pageNumber) {
        rightLayer.contents = (id) [self loadPageImageAt:curPageIndex];
    } else {
        rightLayer.contents = nil;
    }
    rightCoverLayer.frame = rightLayer.bounds;
    rightCoverLayer.hidden = YES;
    
    shadowLayer.frame = self.bounds;
    shadowLayer.hidden = YES;
    
    bottomLayer.frame = rightFrame;
    bottomLayer.hidden = YES;
    
    [CATransaction commit];
}

- (void) refresh {
    [pageCacheDic removeAllObjects];
    pageNumber = [self.dataSource numberOfPagesInFlipperView:self];
    [self refreshLayers];
}

- (void) loadInitPage {
    [pageCacheDic removeAllObjects];
    pageNumber = [dataSource numberOfPagesInFlipperView:self];
    curPageIndex = 0;
    [self refreshLayers];
}

- (void) willFlipPageForward {
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
    
    bottomLayer.frame = rightFrame;
    if (curPageIndex < (pageNumber - 1)) {
        bottomLayer.contents = (id) [self loadPageImageAt:(curPageIndex+1)];
    } else {
        bottomLayer.contents = nil;
    }
    bottomLayer.hidden = NO;
    
    shadowLayer.startPoint = CGPointMake(0.5f, 0.5f);
    shadowLayer.endPoint = CGPointMake(1.0f, 0.5f);
    shadowLayer.hidden = NO;
    [CATransaction commit];
}

- (void) doingFlipPageForward {
    
    rightCoverLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:2.0f]
					 forKey:kCATransactionAnimationDuration];
    [CATransaction setCompletionBlock:^(void){
        [self didFlipPageForward];
        }];

    float clipRdn = 0.0;
    float disRdn = M_PI / 48;
    CAKeyframeAnimation *imgKeyAnima = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *imgKeyAnimaClipArray = [[NSMutableArray alloc]initWithCapacity:64];
    for (clipRdn = 0.0; clipRdn < M_PI; clipRdn += disRdn) {
        CATransform3D t = CATransform3DIdentity;
        t.m11 =  cosf(clipRdn);
        t.m12 = -sinf(clipRdn);
        [imgKeyAnimaClipArray addObject:[NSValue valueWithCATransform3D:t]];
    }
    [imgKeyAnima setValues:imgKeyAnimaClipArray];
    [imgKeyAnimaClipArray release];
    //[imgKeyAnima setDuration:3.0]; 
    //[imgKeyAnima setDelegate:self];
    [rightLayer addAnimation:imgKeyAnima forKey:@"transform"];
    
    
    CAKeyframeAnimation *shdKeyAnima = [CAKeyframeAnimation animationWithKeyPath:@"endPoint"];
    NSMutableArray *shdKeyAnimaClipArray = [[NSMutableArray alloc]initWithCapacity:64];
    //shadowLayer.startPoint = CGPointMake(0.5f, 0.5f);
    //shadowLayer.endPoint = CGPointMake(1.0f, 0.5f);
    for (clipRdn = 0.0; clipRdn < M_PI; clipRdn += disRdn) {
        float animEndPointX = 0.5f + 0.5f*cosf(clipRdn);
        NSLog(@"animEndPointX = %f", animEndPointX);
        CGPoint animEndPoint = CGPointMake(animEndPointX, 0.5f);
        [shdKeyAnimaClipArray addObject:[NSValue valueWithCGPoint:animEndPoint]];
    }
    [shdKeyAnima setValues:shdKeyAnimaClipArray];
    [shdKeyAnimaClipArray release];
    [shadowLayer addAnimation:shdKeyAnima forKey:@"endPoint"];
    
	[CATransaction commit];
}

- (void) didFlipPageForward {
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
    
    leftLayer.contents = (id) [self loadPageImageAt:curPageIndex];
    leftLayer.transform = CATransform3DMakeScale(-1, 1, 1);
    if (curPageIndex < (pageNumber - 1)) {
        rightLayer.transform = CATransform3DIdentity;
        rightLayer.contents = (id) [self loadPageImageAt:(curPageIndex+1)];
    } else {
        rightLayer.transform = CATransform3DIdentity;
        rightLayer.contents = nil;
    }
    rightCoverLayer.hidden = YES;
    
    shadowLayer.hidden = YES;
    bottomLayer.hidden = YES;
    
    [CATransaction commit];
    
    curPageIndex++;
    
    lockUserInteraction = NO;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self didFlipPageForward];
}

- (void) flipPageForward {
    if (!pageNumber || curPageIndex >= pageNumber) {
        return;
    }
    [self willFlipPageForward];
    [self doingFlipPageForward];
}

#pragma mark - Accessors
- (void) setDataSource:(id <HardFlipperViewDataSource>)ds {
    dataSource = ds;
}

- (void) setDelegate:(id <HardFlipperViewDelegate>) delg {
    delegate = delg;
}

- (void) setPageSize:(CGSize)cgSize {
    pageSize = cgSize;
    leftFrame = CGRectMake(0.0f,
                           0.0f,
                           pageSize.width * 0.5,
                           pageSize.height);
    rightFrame = CGRectMake(pageSize.width * 0.5,
                            0.0f,
                            pageSize.width * 0.5,
                            pageSize.height);
}

#pragma mark Event responding
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (lockUserInteraction) {
        return;
    }
    if (curPageIndex >= pageNumber - 1) {
        [self loadInitPage];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (lockUserInteraction) {
        return;
    }
    lockUserInteraction = YES;
    [self flipPageForward];
}

- (void) layoutSubviews {
	[super layoutSubviews];
    if (!CGSizeEqualToSize(pageSize, self.bounds.size)) {
		self.pageSize = self.bounds.size;
        [self refresh];
	}
}



@end
