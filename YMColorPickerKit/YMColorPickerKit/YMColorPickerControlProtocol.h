//
//  YMColorPickerControlProtocol.h
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMColor.h"

@class YMColorPickerManager;

@protocol YMColorPickerControlProtocol <NSObject>

@required

- (void)setManager:(__weak YMColorPickerManager*)manager;

- (YMHSVAColor)HSVAColor;
- (void)setHSVAColor:(YMHSVAColor)hsva;

@end
