//
//  TopView.h
//  BluthBanet
//
//  Created by tao on 17/5/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

- (void)TopClickToGetDevice;
- (void)TopClickToSeButteryUseHistory;
- (void)readBattery;

@end
@interface TopView : UIView

@property (nonatomic, strong) id<TopViewDelegate> delegate;
@property (nonatomic, strong) NSString *barreryString;
@end
