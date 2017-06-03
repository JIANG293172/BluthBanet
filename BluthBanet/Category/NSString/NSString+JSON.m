//
//  NSString+JSON.m
//  WWClientOs
//
//  Created by tao on 16/11/28.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)


+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
+ (NSString *)parseNSDictionaryToJSONString:(NSDictionary *)dic{
    NSError *error;
    NSData *strData = [ NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    return str;
}

@end
