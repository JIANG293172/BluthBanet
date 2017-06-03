//
//  Function.h
//  bilibili
//
//  Created by tao on 2016/7/21.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
//#import "ValueConversion.h"

/**
 *  提示框  成功
 *
 *  @param message 提示信息
 *
 *  @return MBProgressHUD 对象
 */
MBProgressHUD * HUDSuccess(NSString *message);

MBProgressHUD * HUDSuccessInView(NSString *message, UIView *inView);

/**
 *  提示框  失败
 *
 *  @param message 提示信息
 *
 *  @return MBProgressHUD 对象
 */
MBProgressHUD * HUDFailure(NSString *message);

MBProgressHUD * HUDFailureInView(NSString *message, UIView *inView);




MBProgressHUD * HUDLoading(NSString *message);

MBProgressHUD * HUDLoadingInView(NSString *message, UIView *inView);

void HUDLoadingHidden(void);

void HUDLoadingHiddenInView(UIView *inView);

