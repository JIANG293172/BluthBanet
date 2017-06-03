//
//  TopView.m
//  BluthBanet
//
//  Created by tao on 17/5/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "TopView.h"
@interface TopView ()

{
    UIButton *_scanDevcieBtn;
    UIButton *_butteryBtn;
    UILabel *_batteryLB;
    UIButton *_readBattry;
}
@end
@implementation TopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBarreryString:(NSString *)barreryString{
    _barreryString = barreryString;
    _batteryLB.text = barreryString;
    CGRect rect = [_batteryLB textRectForBounds:CGRectMake(0, 0, SSize.width, 100) limitedToNumberOfLines:0];
    [_batteryLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset = rect.size.width;

    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scanDevcieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanDevcieBtn setBackgroundImage:[UIImage imageNamed:@"settings_bluetooth_128px"] forState:UIControlStateNormal];
        [_scanDevcieBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _scanDevcieBtn.titleLabel.font = font(40);
        [_scanDevcieBtn addTarget:self action:@selector(clickToGetDevice) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scanDevcieBtn];
        
        _butteryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_butteryBtn setBackgroundImage:[UIImage imageNamed:@"battery1"] forState:UIControlStateNormal];
        [_butteryBtn addTarget:self action:@selector(clickToSeButteryUseHistory) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_butteryBtn];
        
        _batteryLB = [[UILabel alloc] init];
//        _batteryLB.text = @"未知";
        _batteryLB.text = @"79%";
        _batteryLB.font = font(30);
        _batteryLB.textColor = [UIColor blackColor];
        _batteryLB.textAlignment = NSTextAlignmentRight;
        [self addSubview:_batteryLB];
        
        _readBattry = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readBattry setTitle:@"获取电量" forState:UIControlStateNormal];
        [_readBattry setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _readBattry.titleLabel.font = font(28);
        [_readBattry addTarget:self action:@selector(clickToGetBattery) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_readBattry];
  
        
        [_butteryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 20;
            make.height.offset = 37;
            make.right.offset = -15;
            make.top.offset = 8;
        }];
        
        [_scanDevcieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.top.offset = 8;
            make.width.offset = 40;
            make.height.offset = 37;

        }];
        
        CGRect rect = [_batteryLB textRectForBounds:CGRectMake(0, 0, SSize.width, 100) limitedToNumberOfLines:0];
        [_batteryLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_butteryBtn.mas_left).offset = -15;
            make.height.offset = 15;
            make.width.offset = rect.size.width;
            make.centerY.equalTo(_butteryBtn.mas_centerY).offset = 0;
        }];
        
        
//        [_readBattry mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.offset = 120;
//            make.height.offset = 44;
//            make.centerY.equalTo(_batteryLB.mas_centerY).offset = 0;
//            make.right.equalTo(_batteryLB.mas_left).offset = -15;
//        }];
    }
    return self;
}

- (void)clickToGetDevice{
    [self.delegate TopClickToGetDevice];
}

- (void)clickToSeButteryUseHistory{
    [self.delegate TopClickToSeButteryUseHistory];
}

- (void)clickToGetBattery{
    [self.delegate readBattery];
}

@end
