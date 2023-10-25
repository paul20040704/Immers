//
//  UIColor+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RandomColor [UIColor randomColor]

typedef NS_ENUM(NSUInteger, SVGradientType) { // 渐变方向
    SVGradientTypeTopToBottom      = 0, // 从上到下
    SVGradientTypeLeftToRight      = 1, // 从左到右
    SVGradientTypeUpleftToLowright = 2, // 左上到右下
    SVGradientTypeUprightToLowleft = 3, // 右上到左下
};

@interface UIColor (Extension)

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
- (NSString *)HEXString;
/// 值不需要除以255.0
+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;
/// 值不需要除以255.0
+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;

/// 随机颜色
+ (UIColor *)randomColor;

/// 文本颜色
+ (UIColor *)textColor;

/// 主题颜色
+ (UIColor *)themeColor;

/// 草绿色
+ (UIColor *)grassColor;

/// 草绿色
+ (UIColor *)grassColor3;

/// 灰色 0x000000 0.3
+ (UIColor *)grayColor3;

/// 灰色 0x000000 0.4
+ (UIColor *)grayColor4;

/// 灰色 0x000000 0.5
+ (UIColor *)grayColor5;

/// 灰色 0x000000 0.6
+ (UIColor *)grayColor6;

/// 灰色 0x000000 0.7
+ (UIColor *)grayColor7;

/// 灰色 0x000000 0.8
+ (UIColor *)grayColor8;

/// 背景颜色 0xF8F8F8
+ (UIColor *)backgroundColor;

/// 不可点击颜色 0xA8A8A8
+ (UIColor *)disableColor;

///
+ (UIColor *)redButtonColor;

/// 渐变颜色
/// @param c1 从 c1 颜色
/// @param c2 到 c2 颜色
/// @param gradientType 渐变方式
/// @param size 渐变大小
+ (UIColor*)gradientFromColor:(UIColor *)c1 toColor:(UIColor *)c2 gradientType:(SVGradientType)gradientType size:(CGSize)size;

/// 默认渐变颜色
/// @param gradientType 渐变方式
/// @param size 渐变大小
+ (UIColor *)gradientType:(SVGradientType)gradientType size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
