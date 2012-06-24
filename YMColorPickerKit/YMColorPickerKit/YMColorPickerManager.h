//
//  YMColorPickerManager.h
//  YMColorPickerKit
//
//  Created by 林 亮太 on 12/06/24.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMColorPickerControlProtocol.h"

@interface YMColorPickerManager : NSObject 

- (void)addControl:(UIView<YMColorPickerControlProtocol>*)control;

- (void)updateHSVAColor:(YMHSVAColor)hsva;

@end
