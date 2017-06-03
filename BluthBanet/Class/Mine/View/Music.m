//
//  Music.m
//  BluthBanet
//
//  Created by tao on 17/5/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "Music.h"
@interface Music ()

@end
@implementation Music

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.tag = 1;
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_512"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickToControlMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.tag = 2;
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"play_445"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(clickToControlMusic:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"stop_445"] forState:UIControlStateSelected];
        [self addSubview:_playBtn];
        
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.tag = 3;
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"Next_512"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(clickToControlMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBtn];
        
        _myMusic = [UIButton buttonWithType:UIButtonTypeCustom];
        _myMusic.tag = 4;
        [_myMusic setTitle:@"我的音乐" forState:UIControlStateNormal];
        [_myMusic setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _myMusic.titleLabel.font = font(28);
        [_myMusic addTarget:self action:@selector(clickToControlMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_myMusic];
        
        
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset = 0;
            make.width.height.offset = 35;
            make.centerY.offset = 0;
        }];
        
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_playBtn.mas_left).offset = -25;
            make.width.height.offset = 35;
            make.centerY.offset = 0;
        }];
        
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_playBtn.mas_right).offset = 25;
            make.width.height.offset = 35;
            make.centerY.offset = 0;
        }];
        
        [_myMusic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset = 0;
            make.width.offset =  200;
            make.height.offset = 44;
            make.top.equalTo(_playBtn.mas_bottom).offset = 8;
        }];
        
    }
    return self;
}


- (void)clickToControlMusic:(UIButton *)btn{
    if (btn.tag == 2) {
        _playBtn.selected = !_playBtn.isSelected;
        if (_playBtn.isSelected) {// 播放
            [self.delegate controlMusicWithIndex:5];
        }else{//暂停
            [self.delegate controlMusicWithIndex:6];
        }
    }else{
        [self.delegate controlMusicWithIndex:btn.tag];

    }
}


@end
