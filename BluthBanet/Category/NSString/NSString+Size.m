//
//  NSString+Size.m
//  bilibili
//
//  Created by tao on 2016/7/21.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)widthWithFont:(UIFont *)font maxHeight:(CGFloat)maxHeight {
    return [self boundingRectWithSize:CGSizeMake(9999, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:NULL].size;
}

@end
