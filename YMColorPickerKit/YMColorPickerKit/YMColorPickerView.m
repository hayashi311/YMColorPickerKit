//
//  YMColorPickerView.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColorPickerView.h"
#import "YMColorPickerManager.h"
#import "UIColor+YMColor.h"
#import "YMColorInfoView.h"
#import "YMBrightnessSlider.h"
#import "YMColorMapView.h"
#import "YMTiledColorMapView.h"

@interface YMColorPickerView() {
@private
    YMColorPickerManager* manager_;
}
@end

@implementation YMColorPickerView

- (id)init{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        manager_ = [[YMColorPickerManager alloc] init];
        [manager_ updateHSVAColor:[UIColor greenColor].YMHSVAColor];
        self.backgroundColor = [UIColor whiteColor];
        
        YMColorInfoView* infoView = [[YMColorInfoView alloc] initWithFrame:CGRectMake(7.f, 27.f, 96.f, 46.f)];
        [manager_ addControl:infoView];
        [self addSubview:infoView];
        
        YMBrightnessSlider* brightnessSlider;
        brightnessSlider = [[YMBrightnessSlider alloc] initWithFrame:CGRectMake(110.f, 30.f, 200.f, 40.f)];
        [manager_ addControl:brightnessSlider];
        [self addSubview:brightnessSlider];
        
        /*
        YMColorMapView* colorMapView = [[YMColorMapView alloc] initWithFrame:CGRectMake(10.f, 106.f, 300.f, 300.f)];
        [manager_ addControl:colorMapView];
        [self addSubview:colorMapView];
        */
        
        YMTiledColorMapView* colorMapView;
        colorMapView = [[YMTiledColorMapView alloc] initWithFrame:CGRectMake(10.f, 106.f, 300.f, 300.f)];
        [manager_ addControl:colorMapView];
        [self addSubview:colorMapView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
