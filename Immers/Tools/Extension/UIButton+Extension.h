//
//  UIButton+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 枚举类型
typedef NS_ENUM(NSInteger, SVButtinStyle) {
    SVButtinStyleDefault, // 默认样式
    SVButtinStyleRight, // 图片在右边
    SVButtinStyleTop, // 图片在上面
    SVButtinStyleBottom // 图片在下面
};

@interface UIButton (Extension)

/// 修改按钮样式
/// @param style 样式
/// @param space 间距
- (void)resetButtonStyle:(SVButtinStyle)style space:(CGFloat)space;

/// 设置图片
/// @param url 图片链接
/// @param placeholder 占位图片
- (void)setImageWithURL:(NSString *)url placeholder:(nullable UIImage *)placeholder;

/// 设置背景颜色
/// @param backgroundColor 背景颜色
/// @param state 状态
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/// 设置样式
- (void)setStyle;

/// 设置状态
- (void)setButtonEnabled:(BOOL)enabled;

/// 按钮
/// @param title 标题
/// @param titleColor 标题颜色
/// @param font 字体大小
+ (instancetype)buttonWithTitle:(nullable NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

/// 按钮
/// @param title 默认标题
/// @param normalColor 默认字体颜色
/// @param font 字体大小
+ (instancetype)buttonWithTitle:(nullable NSString *)title normalColor:(UIColor *)normalColor font:(UIFont *)font;

/// 按钮
/// @param title 默认标题
/// @param selectedTitle 选中标题
/// @param normalColor 默认字体颜色
/// @param selectedColor 选中字体颜色
/// @param font 字体大小
+ (instancetype)buttonWithTitle:(nullable NSString *)title selectedTitle:(nullable NSString *)selectedTitle normalColor:(UIColor *)normalColor selectedColor:(nullable UIColor *)selectedColor font:(UIFont *)font;

/// 按钮
/// @param imageName 图片名
+ (instancetype)buttonWithImageName:(NSString *)imageName;

/// 按钮
/// @param normalName 默认图片名
/// @param selectedName 选中图片名
+ (instancetype)buttonWithNormalName:(NSString *)normalName selectedName:(nullable NSString *)selectedName;


/// 关闭【X】按钮
+ (instancetype)buttonClose;

@end

NS_ASSUME_NONNULL_END
