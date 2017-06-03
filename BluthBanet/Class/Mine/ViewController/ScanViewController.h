//
//  ScanViewController.h
//  BluthBanet
//
//  Created by tao on 2017/5/16.
//  Copyright © 2017年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "MineViewController.h"
@interface ScanViewController : UIViewController

@property (nonatomic, weak) MineViewController *mainVc;
@end
