//
//  UILabel+LeftTopAlign.m
//  bilibili
//
//  Created by tao on 16/7/14.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "UILabel+LeftTopAlign.h"

@implementation UILabel (LeftTopAlign)
- (void) textLeftTopAlign{
    NSDictionary *attrs = @{NSFontAttributeName:self.font};
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    if (rect.size.height<self.font.pointSize*2) {
        self.text = [self.text stringByAppendingString:@"\n"];
    }
}
@end

