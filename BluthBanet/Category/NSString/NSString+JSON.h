//
//  NSString+JSON.h
//  WWClientOs
//
//  Created by tao on 16/11/28.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
+ (NSString *)parseNSDictionaryToJSONString:(NSDictionary *)dic;

@end
