//
//  AppDelegate.m
//  BluthBanet
//
//  Created by tao on 17/3/24.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSArray *centralManagerIdentifiers = launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    NSLog(@"%@",centralManagerIdentifiers);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController *vc = [[MainViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    

//    for (int i = 0; i < 10; i++) {
//        NSInteger get = random()%100;
//        [self recordCurrentTimeWithBattery:[NSString stringWithFormat:@"%ld", (long)get]];
//    }
    
    
    return YES;
}

- (void)recordCurrentTimeWithBattery:(NSString *)battery{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [NSLocale currentLocale];
    
    dateFormatter.dateStyle = kCFDateFormatterFullStyle;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *nowDateStr= [dateFormatter stringFromDate:currentDate];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[df objectForKey:@"locationTime"] mutableCopy];
    if (arr.count==0) {
        arr = [NSMutableArray array];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:battery forKey:nowDateStr];
    
    [arr addObject:dic];
    
    [df setObject:arr forKey:@"locationTime"];
    [df synchronize];
    
    NSLog(@"%@", nowDateStr);
    NSLog(@"%@", nowDateStr);
    
}
//- (void)getCurrentTime{
//    NSDate *currentDate = [NSDate date];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    dateFormatter.locale = [NSLocale currentLocale];
//    
//    dateFormatter.dateStyle = kCFDateFormatterFullStyle;
//    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSString *nowDateStr= [dateFormatter stringFromDate:currentDate];
//    
//    NSLog(@"%@", nowDateStr);
//    NSLog(@"%@", nowDateStr);
//
//}

//- (void)currentTime{
//    // 时间字符串 @"2012-03-11 06:44:11 +0800"
////    NSString *str = [_data.Time stringByAppendingString:@" +0800"];
//    NSDate *currentDate = [NSDate date];
//
//    // 1.创建一个时间格式化对象
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    
//    // 2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
//    
//    // 3.字符串转换成时间/自动转换0时区/东加西减
//    NSDate *date = [formatter dateFromString:currentDate];
//    NSDate *now = [NSDate date];
//    
//    // 注意获取calendar,应该根据系统版本判断
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSCalendarUnit type = NSCalendarUnitYear |
//    NSCalendarUnitMonth |
//    NSCalendarUnitDay |
//    NSCalendarUnitHour |
//    NSCalendarUnitMinute |
//    NSCalendarUnitSecond;
//    
//    // 4.获取了时间元素
//    NSDateComponents *cmps = [calendar components:type fromDate:date toDate:now options:0];
////    if (cmps.day >= 1) {
////        _timeLB.text = [_data.Time substringToIndex:10];
////    }else{
////        _timeLB.text = [_data.Time substringFromIndex:11];
////    }
////    CGRect rect = [_timeLB textRectForBounds:CGRectMake(0, 0, SSize.width - 100, 100) limitedToNumberOfLines:0];
////    [_timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
////        make.top.offset = 10;
////        make.width.offset = rect.size.width;
////        make.height.offset = rect.size.height;
////        make.right.offset = -15;
////    }];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
