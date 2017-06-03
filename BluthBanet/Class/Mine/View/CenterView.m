//
//  CenterView.m
//  BluthBanet
//
//  Created by tao on 17/5/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "CenterView.h"

@interface CenterView ()
{
    UIImageView *_speedHead;
    UIButton *_speedBtn;
    UIButton *_setNotifiyBtn;
}

@end

@implementation CenterView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setSpeed:(NSInteger)speed{
    _speed = speed;
    [_speedBtn setTitle:[NSString stringWithFormat:@"%ld KM", speed] forState:UIControlStateNormal];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        _speedHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speed"]];
        [self addSubview:_speedHead];
        [_speedHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset = 50;
            make.centerY.offset = 0;
            make.left.offset = SSize.width / 4;
        }];
        
        _speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _speedBtn.titleLabel.font = font(34);
        _speedBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_speedBtn];
        
        [_speedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 100;
            make.height.offset = 50;
            make.left.equalTo(_speedHead.mas_right).offset = 25;
            make.centerY.offset = 0;
        }];
        
//        _setNotifiyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_setNotifiyBtn setTitle:@"打开通知" forState:UIControlStateNormal];
//        [_setNotifiyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        _setNotifiyBtn.titleLabel.font = font(30);
//        
//        [_setNotifiyBtn addTarget:self action:@selector(setNotifiy:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_setNotifiyBtn];
//        [_setNotifiyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_speedBtn.mas_centerY).offset = 0;
//            make.left.equalTo(_speedBtn.mas_right).offset = 15;
//            make.width.offset = 64;
//            make.height.offset = 15;
//        }];
        

    }
    return self;
}

- (void)setNotifiy:(UIButton *)btn{
    [self.delegate changedSpeedWith:btn];
}

@end
