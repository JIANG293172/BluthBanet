//
//  UIView+CornerRadius.m
//  UIViewTest
//
//  Created by Artron_LQQ on 16/2/20.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)cornerRoundingCorners:(UIRectCorner)RoundingCorners withCornerRadius:(CGFloat)cornerRadius{
    
    CGSize cornerSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:RoundingCorners
                                           cornerRadii:cornerSize];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    self.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
    [self.layer setMasksToBounds:YES];
}
@end
