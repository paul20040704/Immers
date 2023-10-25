//
//  UILabel+Extension.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

/// 文本
/// @param lines 行数
+ (instancetype)labelWithLines:(NSInteger)lines {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = lines;
    return label;
}

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font {
    return [self labelWithTextColor:textColor font:font lines:1];
}

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
/// @param lines 行数
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines {
    return [self labelWithTextColor:textColor font:font lines:lines alignment:NSTextAlignmentLeft];
}

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
/// @param alignment 对齐方式
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    return [self labelWithTextColor:textColor font:font lines:1 alignment:alignment];
}

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
/// @param lines 行数
/// @param alignment 对齐方式
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines alignment:(NSTextAlignment)alignment {
    return [self labelWithText:nil textColor:textColor font:font lines:lines alignment:alignment];
}

/// 文本
/// @param text 文字
/// @param font 字体
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font {
    return [self labelWithText:text font:font lines:1];
}

/// 文本
/// @param text 文字
/// @param font 字体
/// @param textColor 文字颜色
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor {
    return [self labelWithText:text textColor:textColor font:font lines:0 alignment:NSTextAlignmentLeft];
}

/// 文本
/// @param text 文字
/// @param font 字体
/// @param lines 行数
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines {
    return [self labelWithText:text font:font lines:lines alignment:NSTextAlignmentLeft];
}

/// 文本
/// @param text 文字
/// @param font 字体
/// @param alignment 对齐方式
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    return [self labelWithText:text font:font lines:1 alignment:alignment];
}

/// 文本
/// @param text 文字
/// @param font 字体
/// @param lines 行数
/// @param alignment 对齐方式
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines alignment:(NSTextAlignment)alignment {
    return [self labelWithText:text textColor:[UIColor blackColor] font:font lines:lines alignment:alignment];
}

/// 文本
/// @param text 文字
/// @param textColor 文字颜色
/// @param font 字体
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    return [self labelWithText:text textColor:textColor font:font lines:0 alignment:NSTextAlignmentLeft];
}

/// 文本
/// @param text 文字
/// @param textColor 文字颜色
/// @param font 字体
/// @param lines 行数
/// @param alignment 对齐方式
+ (instancetype)labelWithText:(nullable NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    if (text) {
        label.text = text;
    }
    label.textColor = textColor;
    label.font = font;
    label.numberOfLines = lines;
    label.textAlignment = alignment;
    return label;
}

@end
