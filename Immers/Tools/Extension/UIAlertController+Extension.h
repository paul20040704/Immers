//
//  UIAlertController+Extension.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Extension)

/// 弹窗
/// @param title 标题
/// @param message 信息
/// @param cancelText 取消文本
/// @param doneText 确定文本
/// @param cancelAction 取消事件
/// @param doneAction 确定事件
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelText:(nullable NSString *)cancelText doneText:(nullable NSString *)doneText cancelAction:(nullable void(^)(UIAlertAction *action))cancelAction doneAction:(nullable void(^)(UIAlertAction *action))doneAction;

@end

NS_ASSUME_NONNULL_END
