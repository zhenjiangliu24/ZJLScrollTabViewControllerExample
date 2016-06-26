//
//  UILabel+ZJLScale.m
//  ZJLScrollTabViewControllerExample
//
//  Created by ZhongZhongzhong on 16/6/26.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "UILabel+ZJLScale.h"
#import <objc/runtime.h>

static void * ZJLLabelScaleKey = &ZJLLabelScaleKey;
@implementation UILabel (ZJLScale)
- (void)setZJLScale:(CGFloat)ZJLScale
{
    self.textColor = [UIColor colorWithRed:MIN(1, ZJLScale) green:0 blue:0 alpha:1.0];
    CGFloat transformScale = 1+0.2*ZJLScale;
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
    objc_setAssociatedObject(self, ZJLLabelScaleKey, [NSNumber numberWithFloat:ZJLScale], OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)ZJLScale
{
    NSNumber *scale = objc_getAssociatedObject(self, ZJLLabelScaleKey);
    return [scale floatValue];
}
@end
