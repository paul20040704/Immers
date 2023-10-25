//
//  UIView+Extension.h
//  Photos
//
//  Created by developer on 2022/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)
/// 圆角
- (void)corner:(CGFloat)radius;

/// 圆角
- (void)corner;

/// 上边圆角
- (void)topCorner;

/// 贝塞尔画圆角
/// @param corners 圆角
/// @param radius 半径
- (void)corners:(UIRectCorner)corners radius:(CGFloat)radius;

/// 贝塞尔画弧线
/// @param radius 半径
- (void)drawRac:(CGFloat )width radius:(CGFloat )radius;
@end

NS_ASSUME_NONNULL_END
