//
//  NaviViewController.m
//  WWClientOs
//
//  Created by tao on 16/11/15.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "NaviViewController.h"

@interface NaviViewController ()

@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#3391e8"];
    self.navigationBar.tintColor = [UIColor whiteColor];
    if (DeviceIsIpad) {
        // 设置UIBarButtonItem文字
        UIBarButtonItem *item = [UIBarButtonItem appearance];
        NSMutableDictionary *itemNormalDict = [[NSMutableDictionary alloc]init];
        itemNormalDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        itemNormalDict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
        [item setTitleTextAttributes:itemNormalDict forState:UIControlStateNormal];
        
        // title设置
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"], NSFontAttributeName:[UIFont systemFontOfSize:SystemFontWithPx(36)]};
        
    }else{
        // 设置UIBarButtonItem文字
        UIBarButtonItem *item = [UIBarButtonItem appearance];
        NSMutableDictionary *itemNormalDict = [[NSMutableDictionary alloc]init];
        itemNormalDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        itemNormalDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        [item setTitleTextAttributes:itemNormalDict forState:UIControlStateNormal];
        
        // title设置
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"], NSFontAttributeName:[UIFont systemFontOfSize:SystemFontWithPx(38)]};
        
    }
    
    self.navigationBar.translucent = NO;
    

}
// push的时候隐藏底部tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
