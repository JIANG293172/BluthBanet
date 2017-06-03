//
//  UIViewController+GetViewController.h
//  bilibili
//
//  Created by tao on 2016/7/20.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GetViewController)

/**
 *  获取根控制器
 *
 *
 */
+ (__kindof UIViewController *)rootViewController;

/**
 *  获取当前导航控制器
 *
 *
 */
+ (__kindof UINavigationController*)currentNavigationViewController;

/**
 *  获取当前控制器
 *
 *
 */
+ (__kindof UIViewController *)currentViewController;

@end
