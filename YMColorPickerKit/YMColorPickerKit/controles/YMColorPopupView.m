//
//  YMColorPopupView.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/25.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColorPopupView.h"
#import <QuartzCore/QuartzCore.h>

@interface YMColorPopupView() {
@private
    UIColor* color_;
    BOOL hidden_;
    CAShapeLayer* colorLayer_;
}
@end

@implementation YMColorPopupView
@synthesize color = color_;

- (id)init
{
    return [self initWithFrame:CGRectMake(0.f, 0.f, 60.f, 100.f)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        color_ = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        
        colorLayer_ = [CAShapeLayer layer];
        colorLayer_.frame = self.bounds;
        
        CGMutablePathRef path = CGPathCreateMutable();
        float margin = 6.f;
        CGAffineTransform transform = self.transform;
        
        CGRect ellipseRect = CGRectMake(margin,
                                        0,
                                        self.frame.size.width-margin*2.f,
                                        self.frame.size.width-margin*2.f);
        ellipseRect.origin.y = (self.frame.size.height-ellipseRect.size.height)/2.f;
        
        CGPathAddEllipseInRect(path, &transform, ellipseRect);
        
        colorLayer_.path = path;
        CGPathRelease(path);
        
        [self.layer addSublayer:colorLayer_];
        
        colorLayer_.fillColor = color_.CGColor;
    }
    return self;
}

- (BOOL)isHidden
{
    return [super isHidden];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    /*
    if (self.isHidden != hidden) {
        if (hidden) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
                                 self.alpha = 0.f;
                             } 
                             completion:^(BOOL finished) {
                                 [super setHidden:hidden];
                             }];
        }else{
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.transform = CGAffineTransformMakeScale(1.f, 1.f);
                                 self.alpha = 1.f;
                             } 
                             completion:^(BOOL finished) {
                                 [super setHidden:hidden];
                             }];
        }
        
        
    }
    
    */
}

- (void)setColor:(UIColor *)color
{
    color_ = color;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
    colorLayer_.fillColor = color_.CGColor;
    [CATransaction commit];
    //[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGRect popupRect = CGRectInset(rect, 4.f, 4.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //[self.color setFill];
    [[UIColor whiteColor] set];
    
    CGContextMoveToPoint(context, CGRectGetMidX(popupRect), CGRectGetMaxY(popupRect));
    
    CGContextAddArc(context, CGRectGetMidX(popupRect), CGRectGetMidY(popupRect), popupRect.size.width/2.f, M_PI*.25f, M_PI*0.75f, 1);
    
    CGContextClosePath(context);
    CGContextSetShadowWithColor(context, 
                                CGSizeMake(0.f, 0.f),
                                3.f,
                                [UIColor colorWithWhite:0.f alpha:0.2f].CGColor);
    CGContextSetLineWidth(context, 2.f);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
