//
//  UILabel+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Extension)

/// 文本
/// @param lines 行数
+ (instancetype)labelWithLines:(NSInteger)lines;

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font;

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
/// @param lines 行数
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines;

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
/// @param alignment 对齐方式
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment;

/// 文本
/// @param textColor 文字颜色
/// @param font 字体
/// @param lines 行数
/// @param alignment 对齐方式
+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines alignment:(NSTextAlignment)alignment;


/// 文本
/// @param text 文字
/// @param font 字体
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font;

/// 文本
/// @param text 文字
/// @param font 字体
/// @param textColor 文字颜色
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor;

/// 文本
/// @param text 文字
/// @param font 字体
/// @param lines 行数
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines;

/// 文本
/// @param text 文字
/// @param font 字体
/// @param alignment 对齐方式
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font alignment:(NSTextAlignment)alignment;

/// 文本
/// @param text 文字
/// @param font 字体
/// @param lines 行数
/// @param alignment 对齐方式
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines alignment:(NSTextAlignment)alignment;

/// 文本
/// @param text 文字
/// @param textColor 文字颜色
/// @param font 字体
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

/// 文本
/// @param text 文字
/// @param textColor 文字颜色
/// @param font 字体
/// @param lines 行数
/// @param alignment 对齐方式
+ (instancetype)labelWithText:(nullable NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font lines:(NSInteger)lines alignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
