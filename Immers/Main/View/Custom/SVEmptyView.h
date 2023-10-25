//
//  SVEmptyView.h
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVEmptyView : UIView

/// 空数据
/// @param text 提示文本
/// @param imageName 图片名
+ (instancetype)viewWithText:(nullable NSString *)text imageName:(nullable NSString *)imageName;

/// 空数据
/// @param text 提示文本
/// @param imageName 图片名
/// @param textColor 字体颜色
+ (instancetype)viewWithText:(nullable NSString *)text imageName:(nullable NSString *)imageName textColor:(UIColor *)textColor;
@end

NS_ASSUME_NONNULL_END
