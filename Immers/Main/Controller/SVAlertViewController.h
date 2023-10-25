//
//  SVAlertViewController.h
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAlertViewController : UIAlertController

/// AlertViewController
/// @param title 标题
/// @param message 内容
/// @param cancelText 取消文本
/// @param confirmText 确认文本
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelText:(nullable NSString *)cancelText confirmText:(nullable NSString *)confirmText;

/// AlertViewController 默认样式 侧重确认按钮
/// @param title 标题
/// @param message 内容
/// @param cancelText 取消文本
/// @param confirmText 确认文本
+ (instancetype)defaultWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelText:(nullable NSString *)cancelText confirmText:(nullable NSString *)confirmText;

/// AlertViewController 默认样式 侧重取消按钮
/// @param title 标题
/// @param message 内容
/// @param cancelText 取消文本
/// @param confirmText 确认文本
+ (instancetype)weakWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelText:(nullable NSString *)cancelText confirmText:(nullable NSString *)confirmText;

/// 处理事件
/// @param cancelAction 取消事件
/// @param confirmAction 确认事件
- (void)handler:(nullable void(^)(void))cancelAction confirmAction:(nullable void(^)(void))confirmAction;

/// 处理事件
/// @param cancelAction 取消事件
/// @param confirmAction 确认事件
/// @param closeAction 关闭事件
- (void)handler:(nullable void(^)(void))cancelAction confirmAction:(nullable void(^)(void))confirmAction closeAction:(nullable void(^)(void))closeAction;

/// 标题文本颜色 默认 [UIColor grayColor6]
@property (nonatomic, strong) UIColor *titleTextColor;

/// 取消按钮文本颜色 默认 [UIColor grayColor5]
@property (nonatomic, strong) UIColor *cancelTextColor;

/// 确认按钮文本颜色 默认 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *confirmTextColor;

/// 取消按钮背景颜色 默认 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *cancelBackgroundColor;

/// 确认按钮背景颜色 默认 [UIColor grayColor7]
@property (nonatomic, strong) UIColor *confirmBackgroundColor;

/// 取消按钮边框颜色 当BorderColor有值 背景颜色失效
@property (nonatomic, strong) UIColor *cancelBorderColor;

/// 容器视图背景颜色 默认 [UIColor colorWithHex:0x6f6f6f alpha:0.1]
@property (nonatomic, strong) UIColor *backgroundColor;

/// 内容对其方式 默认 NSTextAlignmentCenter
@property (nonatomic, assign) NSTextAlignment messageAlignment;

/// 内容文本颜色 默认 [UIColor grayColor6]
@property (nonatomic, strong) UIColor *messageTextColor;

/// 内容文本字体大小 默认 kSystemFont(12)
@property (nonatomic, strong) UIFont *messageTextFont;

/// 文本离顶部最小间距
@property (nonatomic, assign) CGFloat textMinTopMargin;

/// 按钮离文本最小距离
@property (nonatomic, assign) CGFloat buttonMinTopMargin;

/// 是否显示关闭按钮
@property (nonatomic, assign) BOOL showClose;

/// 按钮大小
@property (nonatomic, assign) CGSize buttonSize;

/// 先回调再dismiss
@property (nonatomic, assign) BOOL actionFirst;
@end

NS_ASSUME_NONNULL_END
