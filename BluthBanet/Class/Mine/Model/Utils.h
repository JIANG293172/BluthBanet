//
//  Utils.h
//  音乐播放器
//
//  Created by tarena on 16/4/19.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+(NSDictionary *)getMusicInfoByPath:(NSString *)path;

+(NSDictionary *)parseLrcWithPath:(NSString *)path;
 
@end
