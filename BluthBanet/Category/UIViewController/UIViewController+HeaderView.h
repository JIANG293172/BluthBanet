//
//  UIViewController+HeaderView.h
//  bilibili
//
//  Created by tao on 2016/8/4.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBar : UINavigationBar

@end


@interface UIViewController (HeaderView)

/**
 *  自定义视图控制器头部视图  根据控制器navigationItem属性设置界面
 */
@property (strong, nonatomic, readonly) NavigationBar *navigationBar;

@end

