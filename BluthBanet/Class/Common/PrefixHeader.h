//
//  PrefixHeader.h
//  bilibili fake
//
//  Created by 翟泉 on 2016/7/4.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h
#import "Macro.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "UIView+Frame.h"
#import "Function.h"
#import "UIColor+Mark.h"
#import "NSString+JSON.h"

#define LYNavi(vc) [[UniversalNavigation alloc]initWithRootViewController:vc]
//#define LYGreenColor [UIColor colorWithRed:62.0/255 green:180.0/255 blue:62.0/255 alpha:1]

//#define LYBlueColor [UIColor colorWithRed:40.0/255 green:118.0/255 blue:236.0/255 alpha:1]
#define LYSW [UIScreen mainScreen].bounds.size.width
#define LYSH [UIScreen mainScreen].bounds.size.height
#define LYAccountPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userLoginInfo.plist"]

// 设备类型
#define DeviceIsIpad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define LYTextSize 12
#define LYMargin 10
#define LYImageSize 112
#define LYGrayColor [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]
// 768 568
//#define handleWidth [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height
//#define handleHeight [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width * 9 / 16 : [UIScreen mainScreen].bounds.size.height * 9 / 16

#define smallWidth SSize.width < SSize.height ? SSize.width : SSize.height
#define verticalLeftMargin 47
#define horizontalLeftMargin 173
#define hypotenuse 160.00 * self.ZoomScale

#define ScreenDirection [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? YES : NO
#endif /* PrefixHeader_h */
// font
#define SystemFontWithPx(x) x*0.5
#define font(x) [UIFont systemFontOfSize:SystemFontWithPx(x)]
// color
#define GTbackgroundColor [UIColor colorWithHexString:@"#f0f2f5"]
#define GTblueColor [UIColor colorWithHexString:@"#3391e8"]
#define GTgrayColor [UIColor colorWithHexString:@"#b8bcbf"]
#define GTblackColor [UIColor colorWithHexString:@"#1f2933"]


#define realWidth(x) x*[UIScreen mainScreen].bounds.size.width/ 375
#define realHeight(x) x*[UIScreen mainScreen].bounds.size.height/ 667
/******************** 测试接口 ********************/

#define urlHeader @"http://j5221zju.wicp.io:9077/dev/A/"

// 首页http://j5221zju.wicp.io:9087/dev/A/upload     
#define urllogin [urlHeader stringByAppendingString:@"log"]

// 引导图
#define urlcfgquery [urlHeader stringByAppendingString:@"cfgquery"]

// 查询功能
#define urlbrnquery [urlHeader stringByAppendingString:@"brnquery"]
// 喜欢
#define urlfavorite [urlHeader stringByAppendingString:@"favorite"]


// 收藏
#define urlcollection [urlHeader stringByAppendingString:@"favorite"]

// 定制
#define urldiy [urlHeader stringByAppendingString:@"diy"]

// 查看组

// 图片上传
#define urlupload [urlHeader stringByAppendingString:@"upload"]

// 使用
#define urlbrain [urlHeader stringByAppendingString:@"brain"]


// 系统公告
#define urlmessage [urlHeader stringByAppendingString:@"message"]



