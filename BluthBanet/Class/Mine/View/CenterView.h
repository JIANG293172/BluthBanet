//
//  CenterView.h
//  BluthBanet
//
//  Created by tao on 17/5/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterViewDelegate <NSObject>

- (void)changedSpeedWith:(UIButton *)btn;

@end
@interface CenterView : UIView
@property (nonatomic, assign) NSInteger speed;

@property (nonatomic, weak) id<CenterViewDelegate> delegate;
@end
