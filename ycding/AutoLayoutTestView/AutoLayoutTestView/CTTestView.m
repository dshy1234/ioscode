//
//  CTTestView.m
//  AutoLayoutTestView
//
//  Created by rayzhang on 6/14/12.
//  Copyright 2012 Flower Bridge Technology. All rights reserved.
//

#import "CTTestView.h"


@implementation CTTestView
@synthesize font, color, strokeColor, strokeWidth;


- (int)getAttributedStringHeightWithString:(NSAttributedString *)string  WidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 2000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 2000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}
-(UIImage*)getSubImage:(UIImage*)originImage WithBounds:(CGRect)rect 
{ 
    CGImageRef subImageRef = CGImageCreateWithImageInRect(originImage.CGImage, rect); 
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef)); 
    
    UIGraphicsBeginImageContext(smallBounds.size); 
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextDrawImage(context, smallBounds, subImageRef); 
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef]; 
    UIGraphicsEndImageContext(); 
    
    return smallImage; 
} 


-(int)GetTitlelinesWithWidthValue:(int) width{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"Arial-BoldMT",TITLE_FONT_SIZE, NULL);
    
    //apply the current text style //2
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName,
                           (id)fontRef, kCTFontAttributeName,
                           //(id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                           //(id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
    
    NSAttributedString* attString = [[[NSAttributedString alloc] initWithString:stritle attributes:attrs] autorelease];
    
    CFRelease(fontRef); //5
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 2000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
        
    return [linesArray count];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        isTopBigBlock = YES;
        showMode = 0;
        imageName = @"b1.png";
        imageName = @"js_img1.jpg";
        //imageName = Nil;

        stritle = @"中美两军防长商定年内举行反海盗联合演练中美两军防长商定年内举行反海盗联合演练中美两";
        fromIcon = @"163.png";
        fromName = @"新浪";
        dateUtilNow = @"2小时前";
        contentArr = [[NSArray alloc] initWithObjects:@"中国国防部长梁光烈5月7日在美国华盛顿五角大楼表示,中美两军关系应该适应中美新型的大国关系,摒弃“大国对抗”的传统思维。梁光烈5月4日至10日的美国之行是9年来中国国防部长首次访美,也标志着去年美国售台武器以来中美两军关系的\"转返\"。在美国军事战略部署重点\"转向亚太\",美国与日本、菲律宾等\"亚洲盟友\"动作不断的大背景下,中美两军的互动备受外界关注。",@"中国国防部长梁光烈5月7日在美国华盛顿五角大楼表示,中美两军关系应该适应中美新型的大国关系,摒弃“大国对抗”的传统思维。梁光烈5月4日至10日的美国之行是9年来中国国防部长首次访美,也标志着去年美国售台武器以来中美两军关系的\"转返\"。在美国军事战略部署重点\"转向亚太\",美国与日本、菲律宾等\"亚洲盟友\"动作不断的大背景下,中美两军的互动备受外界关注。",@"中国国防部长梁光烈5月7日在美国华盛顿五角大楼表示,中美两军关系应该适应中美新型的大国关系,摒弃“大国对抗”的传统思维。梁光烈5月4日至10日的美国之行是9年来中国国防部长首次访美,也标志着去年美国售台武器以来中美两军关系的\"转返\"。在美国军事战略部署重点\"转向亚太\",美国与日本、菲律宾等\"亚洲盟友\"动作不断的大背景下,中美两军的互动备受外界关注。",@"中国国防部长梁光烈5月7日在美国华盛顿五角大楼表示,中美两军关系应该适应中美新型的大国关系,摒弃“大国对抗”的传统思维。梁光烈5月4日至10日的美国之行是9年来中国国防部长首次访美,也标志着去年美国售台武器以来中美两军关系的\"转返\"。在美国军事战略部署重点\"转向亚太\",美国与日本、菲律宾等\"亚洲盟友\"动作不断的大背景下,中美两军的互动备受外界关注。", nil];
        
        
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        
        titleFont = [[UIFont fontWithName:@"Arial-BoldMT" size:TITLE_FONT_SIZE] retain];
        fromFont = [[UIFont fontWithName:@"Arial" size:FROM_FONT_SIZE] retain];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,TITLE_FONT_SIZE )];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = titleFont;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = stritle;
        [self addSubview:titleLabel];
        
        fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, self.bounds.size.width,FROM_FONT_SIZE )];
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.font = fromFont;
        fromLabel.textColor = [UIColor grayColor];
        fromLabel.text = [NSString stringWithFormat:@"%@  %@",fromName,dateUtilNow];
        [self addSubview:fromLabel];
        
        if (imageName) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.backgroundColor = [UIColor yellowColor];
            [self insertSubview:imageView atIndex:0];

        }else{
            imageView = Nil;
        }
    }
    return self;
}
 


- (int)DrawImageContextRef:(CGContextRef)context WithImage:(UIImage*)image StartOriginY:(int)originY{

    if (showMode == SHOW_MODE_SMALL_IMAGE) {
        CGRect imageRect = CGRectZero;
        imageRect.origin.x = self.bounds.size.width - image.size.width;
        imageRect.size.width = image.size.width;
        imageRect.size.height = MIN(image.size.height, self.bounds.size.height - originY);
        imageRect.origin.y = self.bounds.size.height - originY - imageRect.size.height;
       
        if (imageRect.size.height < image.size.height) {
            image = [self getSubImage:image WithBounds:CGRectMake(0, 0, imageRect.size.width, imageRect.size.height)];
        }
        CGContextDrawImage(context, imageRect, image.CGImage);
        return (int)imageRect.size.height + 1;
    }
    return 0;
}


- (int)DrawTitleContextRef:(CGContextRef)context MutablePathRef:(CGMutablePathRef)path{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,TITLE_FONT_SIZE, NULL);
    
    //apply the current text style //2
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName,
                           (id)fontRef, kCTFontAttributeName,
                           //(id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                           //(id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
    
    NSAttributedString* attString = [[[NSAttributedString alloc] initWithString:stritle attributes:attrs] autorelease];
    
    CFRelease(fontRef); //5

    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    
    NSArray *lines = (NSArray *)CTFrameGetLines(frame); 
    if ([lines count] > 2) {
        for (int i = 2; i < [lines count]; i++) {
            //[lines ]
        }
    }
    CTFrameDraw(frame, context); //4
    CFRelease(frame); //5
    CFRelease(framesetter);
    return [self getAttributedStringHeightWithString:attString WidthValue:self.bounds.size.width];
}

- (int)DrawFromContextRef:(CGContextRef)context MutablePathRef:(CGMutablePathRef)path{
//    int retHeight = 0;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,FROM_FONT_SIZE, NULL);
    
    //apply the current text style //2
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)[UIColor grayColor].CGColor, kCTForegroundColorAttributeName,
                           (id)fontRef, kCTFontAttributeName,
                           //(id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                           //(id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
    
    NSAttributedString* attString = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",fromName,dateUtilNow] attributes:attrs] autorelease];
    
    CFRelease(fontRef); //5
        
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    
        CTFrameDraw(frame, context); //4
    CFRelease(frame); //5
    CFRelease(framesetter);
    return [self getAttributedStringHeightWithString:attString WidthValue:self.bounds.size.width];
}

- (void)DrawTextContextRef:(CGContextRef)context MutablePathRef:(CGMutablePathRef)path{
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,TEXT_FONT_SIZE, NULL);
    
    //apply the current text style //2
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)[UIColor blackColor].CGColor, kCTForegroundColorAttributeName,
                           (id)fontRef, kCTFontAttributeName,
                           //(id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                           //(id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
    
    NSMutableString * strText = [[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"     %@",(NSString *)[contentArr objectAtIndex:0]]] autorelease];
    for (int i = 1; i < [contentArr count]; i++) {
        [strText appendFormat:@"\n     %@",(NSString *)[contentArr objectAtIndex:i]];
    }
    
    NSMutableAttributedString * attString = [[[NSMutableAttributedString alloc] initWithString:strText attributes:attrs] autorelease];
    
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)paragraphStyle, (NSString*)kCTParagraphStyleAttributeName,
                                    nil];
    
    [attString addAttributes:attrDictionary range:NSMakeRange(0, [attString length])];
    
    

    CFRelease(fontRef); //5
    
    
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    
    
    CTFrameDraw(frame, context); //4
    CFRelease(frame); //5
    CFRelease(framesetter);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    

    
    CGRect viewRect = self.bounds;
    
    if (imageName == Nil) {
        if (isTopBigBlock == NO) {
            titleLabel.frame = CGRectMake(0, 0, viewRect.size.width, TITLE_FONT_SIZE);
        }else{
            int lineCount = [self GetTitlelinesWithWidthValue:viewRect.size.width];
            if (lineCount == 1) {
                titleLabel.numberOfLines = 1;
                titleLabel.frame = CGRectMake(0, 0, viewRect.size.width, TITLE_FONT_SIZE);
            }else{
                titleLabel.numberOfLines = 2;
                titleLabel.frame = CGRectMake(0, 0, viewRect.size.width, TITLE_FONT_SIZE * 2 + 5);
            }
        }
        fromLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, viewRect.size.width, FROM_FONT_SIZE);
        
        CGMutablePathRef path = CGPathCreateMutable(); //1
        //            CGPathAddRect(path, NULL, viewRect );
        int totalHeight = CGRectGetMaxY(fromLabel.frame ) + 5;
        
        CGPoint point[5];
        point[0] = CGPointMake(0, viewRect.size.height - totalHeight);
        point[1] = CGPointMake(viewRect.size.width, viewRect.size.height - totalHeight);
        point[2] = CGPointMake(viewRect.size.width, 0);
        point[3] = CGPointMake(0, 0);
        point[4] = CGPointMake(0, viewRect.size.height - totalHeight);
        CGPathAddLines(path, NULL, point, 5);
        [self DrawTextContextRef:context MutablePathRef:path];
        CGPathRelease(path);
        showMode = SHOW_MODE_NO_IMAGE;
        return;
    }
    UIImage *mainImage = [UIImage imageNamed:imageName];
    CGSize imageSize = mainImage.size;
    CGSize adjustsedSize = imageSize;
    if (imageSize.width <= viewRect.size.width) {
        if (imageSize.width * MAX_MIN_SCALE < viewRect.size.width) {
            showMode = SHOW_MODE_SMALL_IMAGE;
            if (isTopBigBlock == NO) {
                titleLabel.frame = CGRectMake(0, 0, viewRect.size.width, TITLE_FONT_SIZE);
            }else{
                int lineCount = [self GetTitlelinesWithWidthValue:viewRect.size.width];
                if (lineCount == 1) {
                    titleLabel.numberOfLines = 1;
                    titleLabel.frame = CGRectMake(0, 0, viewRect.size.width, TITLE_FONT_SIZE);
                }else{
                    titleLabel.numberOfLines = 2;
                    titleLabel.frame = CGRectMake(0, 0, viewRect.size.width, TITLE_FONT_SIZE * 2 + 5);
                }
                fromLabel.textColor = [UIColor blackColor];
                
            }
            fromLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, viewRect.size.width, FROM_FONT_SIZE);
            fromLabel.textColor = [UIColor grayColor];
            int totalHeight = CGRectGetMaxY(fromLabel.frame) + 5;
            CGRect imageRect = CGRectZero;
            imageRect.origin.x = viewRect.size.width - imageSize.width;
            imageRect.origin.y = totalHeight;
            imageRect.size.width = imageSize.width;
            imageRect.size.height = MIN(imageSize.height, viewRect.size.height - imageRect.origin.y);
            imageView.frame = imageRect;
            
            //            //Draw Title
            //            CGMutablePathRef path = CGPathCreateMutable(); //1
            //            CGPathAddRect(path, NULL, viewRect );
            //            int totalHeight = [self DrawTitleContextRef:context MutablePathRef:path];
            //            
            //            CGPathRelease(path);
            //            totalHeight += 5;
            //            
            //            
            //            //Draw from
            //            path = CGPathCreateMutable(); //1
            //            CGPathAddRect(path, NULL, CGRectMake(0,viewRect.size.height - totalHeight - FROM_FONT_SIZE - 5, viewRect.size.width, FROM_FONT_SIZE + 5) );
            //           totalHeight += [self DrawFromContextRef:context MutablePathRef:path];
            //            totalHeight += 5;
            //            CGPathRelease(path);
            //
            //            //Draw image
            //             int imageHeight = [self DrawImageContextRef:context WithImage:mainImage StartOriginY:totalHeight];
            //
            
            //Draw content
            CGMutablePathRef path = CGPathCreateMutable(); //1
            //            CGPathAddRect(path, NULL, viewRect );
            
            CGPoint point[7];
            point[0] = CGPointMake(0, viewRect.size.height - totalHeight);
            point[1] = CGPointMake(viewRect.size.width - mainImage.size.width - 5, viewRect.size.height - totalHeight);
            point[2] = CGPointMake(viewRect.size.width - mainImage.size.width - 5, viewRect.size.height - totalHeight - imageRect.size.height);
            point[3] = CGPointMake(viewRect.size.width, viewRect.size.height - totalHeight - imageRect.size.height);
            point[4] = CGPointMake(viewRect.size.width, 0);
            point[5] = CGPointMake(0, 0);
            point[6] = CGPointMake(0, viewRect.size.height - totalHeight);
            
            CGPathAddLines(path, NULL, point, 7);
            [self DrawTextContextRef:context MutablePathRef:path];
            CGPathRelease(path);
            return;
            
        }else{
            adjustsedSize.height = adjustsedSize.height * viewRect.size.width / adjustsedSize.width; 
            adjustsedSize.width = viewRect.size.width;
            int titleHeight = TITLE_FONT_SIZE;
            if (isTopBigBlock && [self GetTitlelinesWithWidthValue:viewRect.size.width] > 1) {
                titleHeight = TITLE_FONT_SIZE * 2 + 5;
                titleLabel.numberOfLines = 2;
            }else{
                titleLabel.numberOfLines = 1;
            }
            if (viewRect.size.height - adjustsedSize.height < titleHeight + 5) {
                showMode = SHOW_MODE_JUST_IMAGE;
                CGRect imageRect = CGRectZero;
                imageRect.origin.x = 0;
                imageRect.origin.y = 0;
                imageRect.size.width = viewRect.size.width;
                imageRect.size.height = MIN(adjustsedSize.height, viewRect.size.height);
                imageView.frame = imageRect;
                
                fromLabel.frame = CGRectMake(5, imageRect.size.height - FROM_FONT_SIZE - 5, viewRect.size.width - 10, FROM_FONT_SIZE);
                fromLabel.textColor = [UIColor whiteColor];
                titleLabel.frame = CGRectMake(5, CGRectGetMinY(fromLabel.frame) - 5 - titleHeight, viewRect.size.width - 10, titleHeight);
                titleLabel.textColor = [UIColor whiteColor];
                return;
                
            }else{
                showMode = SHOW_MODE_BIG_IMAGE;
                CGRect imageRect = CGRectZero;
                imageRect.origin.x = 0;
                imageRect.origin.y = 0;
                imageRect.size.width = viewRect.size.width;
                imageRect.size.height = adjustsedSize.height;
                imageView.frame = imageRect;
                titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, viewRect.size.width, titleHeight);
                titleLabel.textColor = [UIColor blackColor];
                if (viewRect.size.height - CGRectGetMaxY(titleLabel.frame) > FROM_FONT_SIZE + 5) {
                    fromLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, viewRect.size.width, FROM_FONT_SIZE);
                    
                }else{
                    return;
                }
                if (viewRect.size.height - CGRectGetMaxY(fromLabel.frame) > TEXT_FONT_SIZE + 5) {
                    CGMutablePathRef path = CGPathCreateMutable(); //1
                    //            CGPathAddRect(path, NULL, viewRect );
                    int totalHeight = CGRectGetMaxY(fromLabel.frame) + 5;
                    CGPoint point[5];
                    point[0] = CGPointMake(0, viewRect.size.height - totalHeight);
                    point[1] = CGPointMake(viewRect.size.width, viewRect.size.height - totalHeight);
                    point[2] = CGPointMake(viewRect.size.width, 0);
                    point[3] = CGPointMake(0, 0);
                    point[4] = CGPointMake(0, viewRect.size.height - totalHeight);
                    CGPathAddLines(path, NULL, point, 5);
                    [self DrawTextContextRef:context MutablePathRef:path];
                    CGPathRelease(path);
                    
                }else{
                    return;
                }
                return; 
            }
            
        }
    }else {
        if (imageSize.width / MAX_MIN_SCALE > viewRect.size.width) {
            adjustsedSize.height = imageSize.height; 
            adjustsedSize.width = viewRect.size.width;
        }else{
            adjustsedSize.height = adjustsedSize.height * viewRect.size.width / adjustsedSize.width; 
            adjustsedSize.width = viewRect.size.width;
        }
        int titleHeight = TITLE_FONT_SIZE;
        if (isTopBigBlock && [self GetTitlelinesWithWidthValue:viewRect.size.width] > 1) {
            titleHeight = TITLE_FONT_SIZE * 2 + 5;
            titleLabel.numberOfLines = 2;
        }else{
            titleLabel.numberOfLines = 1;
        }
        if (viewRect.size.height - adjustsedSize.height < titleHeight + 5) {
            showMode = SHOW_MODE_JUST_IMAGE;
            CGRect imageRect = CGRectZero;
            imageRect.origin.x = 0;
            imageRect.origin.y = 0;
            imageRect.size.width = viewRect.size.width;
            imageRect.size.height = MIN(adjustsedSize.height, viewRect.size.height);
            imageView.frame = imageRect;
            
            fromLabel.frame = CGRectMake(5, imageRect.size.height - FROM_FONT_SIZE - 5, viewRect.size.width - 10, FROM_FONT_SIZE);
            fromLabel.textColor = [UIColor whiteColor];
            titleLabel.frame = CGRectMake(5, CGRectGetMinY(fromLabel.frame) - 5 - titleHeight, viewRect.size.width - 10, titleHeight);
            titleLabel.textColor = [UIColor whiteColor];
            return;
            
        }else{
            showMode = SHOW_MODE_BIG_IMAGE;
            CGRect imageRect = CGRectZero;
            imageRect.origin.x = 0;
            imageRect.origin.y = 0;
            imageRect.size.width = viewRect.size.width;
            imageRect.size.height = adjustsedSize.height;
            imageView.frame = imageRect;
            titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, viewRect.size.width, titleHeight);
            titleLabel.textColor = [UIColor blackColor];
            if (viewRect.size.height - CGRectGetMaxY(titleLabel.frame) > FROM_FONT_SIZE + 5) {
                fromLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, viewRect.size.width, FROM_FONT_SIZE);
                
            }else{
                return;
            }
            if (viewRect.size.height - CGRectGetMaxY(fromLabel.frame) > TEXT_FONT_SIZE + 5) {
                CGMutablePathRef path = CGPathCreateMutable(); //1
                //            CGPathAddRect(path, NULL, viewRect );
                int totalHeight = CGRectGetMaxY(fromLabel.frame) + 5;
                CGPoint point[5];
                point[0] = CGPointMake(0, viewRect.size.height - totalHeight);
                point[1] = CGPointMake(viewRect.size.width, viewRect.size.height - totalHeight);
                point[2] = CGPointMake(viewRect.size.width, 0);
                point[3] = CGPointMake(0, 0);
                point[4] = CGPointMake(0, viewRect.size.height - totalHeight);
                CGPathAddLines(path, NULL, point, 5);
                [self DrawTextContextRef:context MutablePathRef:path];
                CGPathRelease(path);
                
            }else{
                return;
            }
            return; 
        }
        
    }
}
- (void)dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    
    [titleLabel release];
    [fromLabel release];
    [titleFont release];
    [fromFont release];
    if (imageName)
        [imageName release];
    
    [super dealloc];
}



@end
