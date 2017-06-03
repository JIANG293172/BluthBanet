//
//  MusicViewController.h
//  BluetoothStubOnIOS
//
//  Created by tao on 2017/5/20.
//  Copyright © 2017年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineViewController.h"
@class MineViewController;
@interface MusicViewController : UIViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *fillPaths;

@property (nonatomic, weak) MineViewController *mainVc;

+ (MusicViewController *)sharePlayingVC;

- (void)lastMusic;
- (void)nextMusic;
- (void)playStopMusic;

- (void)getMuicTotalTime:(NSInteger)totalTime;
- (void)getCurrentTime:(NSInteger)currentTime;

- (void)getCurrentVoice:(CGFloat)voice;
@end
