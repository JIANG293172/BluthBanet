//
//  DirectionView.m
//  BluthBanet
//
//  Created by tao on 17/3/25.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "DirectionView.h"
@interface DirectionView ()
{
    UIButton *_topBtn;
    UIButton *_upBtn;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    
    UIButton *_forwardBtn;
    UIButton *_stopBtn;
    UIButton *_backBtn;
    
    UIButton *_historyBtn;
}

@end
@implementation DirectionView

// btu_blue_d
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        _historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historyBtn setBackgroundImage:[UIImage imageNamed:@"history_1102"] forState:UIControlStateNormal];
        [_historyBtn addTarget:self action:@selector(clickToGetHistory) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_historyBtn];
        
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn setBackgroundImage:[UIImage imageNamed:@"btu_up_highlight"] forState:UIControlStateNormal];
        _topBtn.tag = 1;
        [_topBtn addTarget:self action:@selector(clickToChooseDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topBtn];
        
        _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upBtn setBackgroundImage:[UIImage imageNamed:@"btu_down_highlight"] forState:UIControlStateNormal];
        _upBtn.tag = 2;
        [_upBtn addTarget:self action:@selector(clickToChooseDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_upBtn];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"btu_left_highlight"] forState:UIControlStateNormal];
        _leftBtn.tag = 3;
        [_leftBtn addTarget:self action:@selector(clickToChooseDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"btu_right_highlight"] forState:UIControlStateNormal];
        _rightBtn.tag = 4;
        [_rightBtn addTarget:self action:@selector(clickToChooseDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
        _forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forwardBtn.tag = 5;
        [_forwardBtn setBackgroundImage:[UIImage imageNamed:@"btu_blue_d"] forState:UIControlStateNormal];
        [_forwardBtn setTitle:@"前进" forState:UIControlStateNormal];
        [_forwardBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _forwardBtn.titleLabel.font = font(30);
        [_forwardBtn addTarget:self action:@selector(clickToChooseDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_forwardBtn];
        
        _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopBtn.tag = 6;
        [_stopBtn setBackgroundImage:[UIImage imageNamed:@"btu_blue_d"] forState:UIControlStateNormal];
        [_stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [_stopBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _stopBtn.titleLabel.font = font(30);
        [_stopBtn addTarget:self action:@selector(clickToChooseDirection:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_stopBtn];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.tag = 7;
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"btu_blue_d"] forState:UIControlStateNormal];
        [_backBtn setTitle:@"后退" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = font(30);
        [_backBtn addTarget:self action:@selector(clickToChooseDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];

        
        [_historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 40;
            make.height.offset = 40;
            make.left.offset = 15;
            make.top.offset = 0;
        }];
        
        [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 50;
            make.height.offset = 45;
            make.centerX.offset = 0;
            make.top.equalTo(_historyBtn.mas_bottom).offset = 8;
        }];
        
        [_upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topBtn.mas_bottom).offset = 20;
            make.centerX.equalTo(_topBtn.mas_centerX).offset = 0;
            make.width.offset = 50;
            make.height.offset = 45;
        }];
        
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 50;
            make.height.offset = 45;
            make.right.equalTo(_upBtn.mas_left).offset = -20;
            make.top.equalTo(_upBtn.mas_top).offset = 0;
        }];
        
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 50;
            make.height.offset = 45;
            make.left.equalTo(_upBtn.mas_right).offset = 20;
            make.top.equalTo(_upBtn.mas_top).offset = 0;
        }];
        
        
        [_stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 50;
            make.height.offset = 29;
            make.centerX.equalTo(_upBtn.mas_centerX).offset = 0;
            make.top.equalTo(_upBtn.mas_bottom).offset = 20;
        }];
        
        
        [_forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 50;
            make.height.offset = 29;
            make.right.equalTo(_stopBtn.mas_left).offset = -50;
            make.top.equalTo(_stopBtn.mas_top).offset = 0;
        }];
        
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 50;
            make.height.offset = 29;
            make.left.equalTo(_stopBtn.mas_right).offset = 50;
            make.top.equalTo(_stopBtn.mas_top).offset = 0;
        }];
        
        
    }
    return self;
}

- (void)clickToGetHistory{
    [self.delegate DirectionViewclickToGetHistory];
}

- (void)clickToChooseDirection:(UIButton *)btn{
    [self.delegate DirectionViewChooseDireciton:btn.tag];
}

@end
