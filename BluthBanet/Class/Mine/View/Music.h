//
//  Music.h
//  BluthBanet
//
//  Created by tao on 17/5/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicDelegate <NSObject>

- (void)controlMusicWithIndex:(NSInteger)index;

@end
@interface Music : UIView

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *myMusic;

@property (nonatomic, strong) id<MusicDelegate> delegate;

@end

