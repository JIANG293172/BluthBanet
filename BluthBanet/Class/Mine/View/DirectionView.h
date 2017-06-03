//
//  DirectionView.h
//  BluthBanet
//
//  Created by tao on 17/3/25.
//  Copyright © 2017年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectionViewDelegate <NSObject>

- (void)DirectionViewclickToGetHistory;

- (void)DirectionViewChooseDireciton:(NSInteger)direction;
@end
@interface DirectionView : UIView

@property (nonatomic, strong) id<DirectionViewDelegate> delegate;
@end
