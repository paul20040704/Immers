//
//  SVFieldViewController.h
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVFieldViewController : UIAlertController

/// AlertViewController
/// @param title 标题
/// @param placeholder 占位
/// @param cancelText 取消文本
/// @param confirmText 确认文本
+ (instancetype)fieldControllerWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancelText:(nullable NSString *)cancelText confirmText:(NSString *)confirmText;

/// 处理事件
/// @param cancelAction 取消事件
/// @param confirmAction 确认事件
- (void)handler:(nullable void(^)(void))cancelAction confirmAction:(nullable void(^)(NSString *text))confirmAction;

/// 标题文本颜色 默认 [UIColor grayColor6]
@property (nonatomic, strong) UIColor *titleTextColor;

/// 取消按钮文本颜色 默认 [UIColor grayColor5]
@property (nonatomic, strong) UIColor *cancelTextColor;

/// 确认按钮文本颜色 默认 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *confirmTextColor;

/// 取消按钮背景颜色 默认 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *cancelBackgroundColor;

/// 确认按钮背景颜色 默认 [UIColor grayColor8]
@property (nonatomic, strong) UIColor *confirmBackgroundColor;

/// 取消按钮边框颜色 当BorderColor有值 背景颜色失效
@property (nonatomic, strong) UIColor *cancelBorderColor;

/// 容器视图背景颜色 默认 [UIColor colorWithHex:0x6f6f6f alpha:0.1]
@property (nonatomic, strong) UIColor *backgroundColor;

/// 是否显示关闭按钮
@property (nonatomic, assign) BOOL showClose;

/// 输入最大长度
@property (nonatomic, assign) NSUInteger maxLength;

@end

NS_ASSUME_NONNULL_END
