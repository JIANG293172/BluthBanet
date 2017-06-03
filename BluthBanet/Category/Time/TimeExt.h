//
//  TimeExt.h
//  郎群科技
//
//  Created by tao on 16/10/18.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeExt : NSObject
// 标准时间
+ (NSDate *)getGelinTime;
// 本地时间
+ (NSDate *)getLocalTime;
// 消息发送时间间隔
+(NSString *)parseTimeWithTimeStap:(float)timestap;

// 基本用法
+ (void)time;

// NSDate -> NSString
+ (NSString *)getStringWithDate:(NSDate*)date;

// NSString -> NSDate
+ (NSDate *)getDateWithString:(NSString *)strings;
@end

