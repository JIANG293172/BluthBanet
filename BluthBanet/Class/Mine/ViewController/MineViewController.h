//
//  MineViewController.h
//  BluthBanet
//
//  Created by tao on 17/3/24.
//  Copyright © 2017年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
#import "SVProgressHUD.h"
#import "MusicViewController.h"
@class MusicViewController;

@interface MineViewController : UIViewController{
@public
    BabyBluetooth *baby;
    NSMutableArray *sect;
    __block  NSMutableArray *readValueArray;
    __block  NSMutableArray *descriptors;
}

@property (nonatomic, weak) MusicViewController *musicVC;

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic, assign) BOOL isplaying;
@property (nonatomic, assign) BOOL firstPlay;
// music
-(void)setMusicNotifiyBool:(BOOL)iSNoti;


- (void)connectToPerhips;

- (void)playMusicStateChangedWithButtonTag:(NSInteger)tag;

- (void)getTotalTime;

- (void)writeCurrentTime:(NSInteger)time;

- (void)writeCurrentVoice:(CGFloat)voice;

- (void)getCurrentVoice;
@end
