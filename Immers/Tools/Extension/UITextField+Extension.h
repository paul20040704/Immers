//
//  UITextField+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Extension)

/// 设置最大字符长度
/// @param length 长度
- (void)textMaxLength:(NSInteger)length;

+ (instancetype)textFieldWithPlaceholder:(NSString *)placeholder type:(UIKeyboardType)type textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
