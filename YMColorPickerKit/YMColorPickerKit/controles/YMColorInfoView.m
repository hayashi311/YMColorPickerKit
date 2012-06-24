//
//  YMColorInfoView.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColorInfoView.h"
#import "HRCgUtil.h"

@interface YMColorInfoView() {
@private
    YMHSVAColor hsva_;
}
@end

@implementation YMColorInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        hsva_ = YMHSVAClearColor();
    }
    return self;
}

- (void)setManager:(__weak YMColorPickerManager*)manager
{
    
}

- (YMHSVAColor)HSVAColor
{
    return hsva_;
}

- (void)setHSVAColor:(YMHSVAColor)hsva
{
    hsva_ = hsva;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor* color = [UIColor colorWithHue:hsva_.h saturation:hsva_.s brightness:hsva_.v alpha:hsva_.a];
    [color set];
    HRSetRoundedRectanglePath(context, rect, 3.0f);
    CGContextDrawPath(context, kCGPathFill);
    
}


@end
