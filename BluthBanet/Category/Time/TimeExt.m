//
//  TimeExt.m
//  郎群科技
//
//  Created by tao on 16/10/18.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "TimeExt.h"

@implementation TimeExt

// 格林威治 时间 北京属于东8区，时间多8个小时
+ (NSDate *)getGelinTime{
    // 创建当前的时间对象
    NSDate *date = [NSDate date];
    return date;
}

// 本地时间
+ (NSDate *)getLocalTime{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 获取时间间隔
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    // 东八区时间
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}

// 消息发送时间间隔
+(NSString *)parseTimeWithTimeStap:(float)timestap{
    
    //    timestap/=1000;
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timestap];
    
    //获取当前时间对象
    NSDate *nowDate = [NSDate date];
    
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime-timestap;
    if (time<60) {
        return @"刚刚";
    }else if (time<3600){
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if (time<3600*24){
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
    
}

+ (void)time{
//    // 世界标准时间慢8小时
//    NSDate *date = [[NSDate alloc]init];
//    // 时间间隔
//    NSTimeInterval  second  =  [date  timeIntervalSince1970];
//    NSTimeInterval  second2  =  [date  timeIntervalSinceNow];
//    
//    // 明天时间(标准时间)
//    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
//    // 昨天时间(标准时间)
//    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
//    // 时间差值
//    second = [tomorrow timeIntervalSinceDate:yesterday];
//    NSLog(@"时间差值： %f",second);
//    //比较哪个时间更早
//
//    NSDate *earlierDate = [tomorrow earlierDate:yesterday];//[time laterDatetime1];
//    //两个时间是否相同
//    BOOL isFlag = [tomorrow isEqualToDate:yesterday];
}

// NSDate -> NSString
+ (NSString *)getStringWithDate:(NSDate*)date{
    //时间格式化对象，按照指定格式输出时间信息
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    //hh小时 mm分钟 ss秒 yyyy年 MM月 dd日
    df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *strDate = [df stringFromDate:date];
    return strDate;
}

// NSString -> NSDate
+ (NSDate *)getDateWithString:(NSString *)strings{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //日期格式化类
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //设置时间格式
    NSString *string = @"2016-10-18 16:42:31";
    // 注意这里获取打印的时间是0时区的date  2016-10-18 08:42:31 +0000
    // 转换成东八区时间,NSDate时间
    NSDate *date = [formatter dateFromString:string];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger seconds = [zone secondsFromGMTForDate:date];
    NSDate *date8 = [date dateByAddingTimeInterval:seconds];
    return date8;
}



@end
