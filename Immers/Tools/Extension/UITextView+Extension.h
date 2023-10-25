//
//  UITextView+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Extension)

/// 设置 UITextView 占位文字
/// @param placeholder 占位文字
/// @param fontSzie 字体大小
/// @param textColor 字体颜色
- (void)placeholderWith:(NSString *)placeholder szie:(NSInteger)fontSzie color:(UIColor *)textColor;


/// 设置最大字符长度
/// @param length 长度
- (void)textMaxLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
