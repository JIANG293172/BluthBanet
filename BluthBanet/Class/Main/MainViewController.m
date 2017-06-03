//
//  MainViewController.m
//  WWId2016
//
//  Created by tao on 17/1/19.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "MainViewController.h"
#import "FirstPageViewController.h"
#import "MineViewController.h"
#import "RightPageViewController.h"
#import "NaviViewController.h"
@interface MainViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UITabBarItem *messageItem;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GTbackgroundColor;
    self.delegate = self;

    
    FirstPageViewController *firtvc = [[FirstPageViewController alloc] init];
    firtvc.title = @"首页";
    
    MineViewController *minevc = [[MineViewController alloc] init];
    minevc.title = @"我";
    
    RightPageViewController *messagevc = [[RightPageViewController alloc] init];
    messagevc.title = @"消息";
    
    self.viewControllers = @[[[NaviViewController alloc] initWithRootViewController:firtvc], [[NaviViewController alloc] initWithRootViewController:minevc], [[NaviViewController alloc] initWithRootViewController:messagevc]];

    UITabBar *tabBar = self.tabBar;
    
    tabBar.itemSpacing = 180;
    tabBar.itemWidth = 80;
    
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    self.messageItem = item2;
    
    // 对item设置相应地图片
    item0.image = [[UIImage imageNamed:@"tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item0.selectedImage = [[UIImage imageNamed:@"tabbar_homehl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    item1.image = [[UIImage imageNamed:@"tabbar_me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item1.selectedImage = [[UIImage imageNamed:@"tabbar_mehl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.image = [[UIImage imageNamed:@"tabbar_information"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item2.selectedImage = [[UIImage imageNamed:@"tabbar_informationHL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.selectedIndex = 1;
    // Do any additional setup after loading the view.
}

@end
