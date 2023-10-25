//
//  SVProgressView.m
//  Immers
//
//  Created by developer on 2022/6/7.
//

#import "SVProgressView.h"
#import "SVGlobalMacro.h"

@implementation SVProgressView {
    UILabel *_progressLabel;
    UIColor *_normalColor;
    UIColor *_completionColor;
    CGFloat _progressWidth;
    CGFloat _width;
}

-  (void)setProgress:(double)progress {
    if (_progress != progress || 0 == progress) {
        _progress = progress;
        if (progress >= 1.0 || progress <= 0) {
            if (progress >= 1.0) {
                // 延迟隐藏进度
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.hidden = YES;
                    self->_progressLabel.hidden = YES;
                });
            } else {
                self.hidden = YES;
                _progressLabel.hidden = YES;
            }

        } else {
            self.hidden = NO;
            _progressLabel.hidden = NO;
        }
        
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
        
        [self setNeedsDisplay];
    }
}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _progressWidth = kWidth(6);
        _normalColor = [UIColor colorWithHex:0xffffff alpha:0.8];
        _completionColor = [UIColor grassColor];
        _width = ((kScreenWidth - kWidth(10)) / 3.0);
        [self prepareSubviews];
    }
    return self;
}

- (void)prepareSubviews {
    _progressLabel = [UILabel labelWithTextColor:[UIColor grassColor] font:kBoldFont(24)];
    [self addSubview:_progressLabel];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_width, _width));
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *completionPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_width / 2.0, _width / 2.0) radius:(_width - _progressWidth * 2.0) / 2.0 startAngle:0 endAngle:M_PI * 2.0 clockwise:0];
    //设置线的宽度
    CGContextSetLineWidth(ctx, _progressWidth);
    // 线条的颜色
    [_completionColor setStroke];
    // 将路径添加到上下文
    CGContextAddPath(ctx, completionPath.CGPath);
    // 渲染路径
    CGContextStrokePath(ctx);
    
    
    CGFloat endAngle = -M_PI_2 + self.progress * (M_PI * 2);
    UIBezierPath *normalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_width / 2.0, _width / 2.0) radius:(_width - _progressWidth * 2.0) / 2.0 startAngle:-M_PI_2 endAngle:endAngle clockwise:0];
    // 设置线的宽度
    CGContextSetLineWidth(ctx, _progressWidth);
    //线条的颜色
    [_normalColor setStroke];
    // 将路径添加到上下文
    CGContextAddPath(ctx, normalPath.CGPath);
    // 渲染路径
    CGContextStrokePath(ctx);
}

@end
