//
//  YMCGUtil.h
//  YMColorPickerKit
//
//  Created by 亮太 林 on 7/1/12.
//  Copyright (c) 2012 Hayashi Ryota. All rights reserved.
//

#ifdef __cplusplus
extern "C" {
#endif
    
    UIImage* YMImageFromBlocks(CGSize size,void(^renderToContext)(CGContextRef,CGRect));
    
#ifdef __cplusplus
}
#endif
