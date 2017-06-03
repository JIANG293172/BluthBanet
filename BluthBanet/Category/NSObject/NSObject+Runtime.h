//
//  NSObject+Runtime.h
//  bilibili
//
//  Created by tao on 2016/8/27.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
