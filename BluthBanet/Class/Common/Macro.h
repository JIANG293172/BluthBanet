//
//  Macro.h
//  bilibili
//
//  Created by tao on 16/6/23.
//  Copyright © 2016年 tao. All rights reserved.
//

#ifndef Macro_h
#define Macro_h





#define SSize   [UIScreen mainScreen].bounds.size



#pragma mark - Color

#define ColorRGBA(r, g, b, a)               [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define ColorRGB(r, g, b)                   ColorRGBA((r), (g), (b), 1.0)
#define ColorWhiteAlpha(white, _alpha)      [UIColor colorWithWhite:(white)/255.0 alpha:_alpha]
#define ColorWhite(white)                   ColorWhiteAlpha(white, 1.0)

#define colora4a4a4 [UIColor colorWithHexString:@"#a4a4a4"]
#define colordbdbdb [UIColor colorWithHexString:@"#dbdbdb"]
#define colorffffff [UIColor colorWithHexString:@"#ffffff"]
#define color0095ff [UIColor colorWithHexString:@"#0095ff"]
#define colord9d9d9 [UIColor colorWithHexString:@"#d9d9d9"]
#define colorf4f4f4 [UIColor colorWithHexString:@"#f4f4f4"]
#define color303233 [UIColor colorWithHexString:@"#303233"]
#define color66bcfa [UIColor colorWithHexString:@"#66bcfa"]
#define colorbcbcbc [UIColor colorWithHexString:@"#bcbcbc"]
#define colorededed [UIColor colorWithHexString:@"#ededed"]
#define color999999 [UIColor colorWithHexString:@"#999999"]


//#define Font(fontSize) [UIFont fontWithName:@"ArialMT" size:fontSize]


#define ImageWithName(name)  [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[name stringByAppendingString:@".png"]]]


#pragma mark - Defult UI

#define CRed ColorRGB(253,129,164)




#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
static void DeferBlock(__strong void(^*block)(void)) {
    (*block)();
}
#pragma clang diagnostic pop


/**
 *  作用域结束后会调用Block   后进先出
 *  Defer {
 *      printf("...");
 *  };
 */
#define Defer __strong void(^deferBlock)(void) __attribute__((cleanup(DeferBlock), unused)) = ^

// 标志子类继承这个方法时需要调用 super，否则给出编译警告
#define RequiresSuper __attribute__((objc_requires_super))


// 弱引用对象
#define WeakObject(object) __weak typeof(object) weakobject = object;


#endif /* Macro_h */
