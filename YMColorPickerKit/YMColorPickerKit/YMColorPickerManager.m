//
//  YMColorPickerManager.m
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import "YMColorPickerManager.h"

@interface YMColorPickerManager() {
@private
    NSMutableArray* controles_;
    YMHSVAColor hsva_;
}
@end

@implementation YMColorPickerManager

- (id)init
{
    self = [super init];
    if (self) {
        controles_ = [NSMutableArray array];
        hsva_ = YMHSVAClearColor();
    }
    return self;
}

- (void)addControl:(UIView<YMColorPickerControlProtocol>*)control
{
    [control setManager:self];
    [control setHSVAColor:hsva_];
    [controles_ addObject:control];
}

- (void)updateHSVAColor:(YMHSVAColor)hsva
{
    hsva_ = hsva;
    for (UIView<YMColorPickerControlProtocol>* control in controles_) {
        if (!YMHSVAColorEqualToColor([control HSVAColor], hsva_)) {
            [control setHSVAColor:hsva_];
        }
    }
}


@end
