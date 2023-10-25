//
//  UIView+Extension.m
//  Photos
//
//  Created by developer on 2022/3/23.
//

#import "UIView+Extension.h"
#import "SVGlobalMacro.h"

@implementation UIView (Extension)

/// 圆角
- (void)corner:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}


/// 圆角
- (void)corner {
    self.layer.cornerRadius = kHeight(6);
    self.layer.masksToBounds = YES;
}

/// 上边圆角
- (void)topCorner {
    [self corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kHeight(10)];
}

/// 贝塞尔画圆角
/// @param corners 圆角
/// @param radius 半径
- (void)corners:(UIRectCorner)corners radius:(CGFloat)radius {
    // 画圆角 设置路径画布
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *layer =  [[CAShapeLayer alloc] init];
    layer.path = bezierPath.CGPath;
    [self.layer addSublayer:layer];
    self.layer.mask = layer;
}

- (void)drawRac:(CGFloat )width radius:(CGFloat )radius {
    // 画圆弧
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0, 0)];
    [bezierPath addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:CGPointMake(width/2, radius)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.strokeColor = [UIColor colorWithHex:0x26ee9f].CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.lineWidth = kWidth(3);
    layer.cornerRadius = kWidth(1.5);
    [self.layer addSublayer:layer];
}

@end
