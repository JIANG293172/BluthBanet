//
//  UIColor+String.h
//  bilibili
//
//  Created by tao on 16/8/11.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(String)


+(instancetype)colorWithString:(NSString*)string;
//-(instancetype)initWithString:(NSString*)string;

//字符串变现形式
@property(nonatomic,strong,readonly)NSString* stringRepresentation;

@end
