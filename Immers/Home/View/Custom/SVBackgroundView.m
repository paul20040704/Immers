//
//  SVBackgroundView.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVBackgroundView.h"
#import "SVGlobalMacro.h"

@interface SVBackgroundView ()

@property (nonatomic, strong) CAGradientLayer *backgroundGradientLayer;

@end

@implementation SVBackgroundView {
    UIImageView *_backgroundView;
    UIView *_effectview;
    UIView *_backgroundEffectview;
}

// MARK: - setter
- (void)setCover:(NSString *)cover {
    if (nil == cover) {
        _effectview.hidden = YES;
        _backgroundEffectview.hidden = NO;
        _backgroundView.image = nil;
        return;
    }
    _cover = [cover copy];
    
    UIImage *image = [[YYImageCache sharedCache] getImageForKey:cover];
    if (image) {
        _backgroundView.image = [image blurLevel:10];
    } else {
        
        kWself
        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:cover] options:YYWebImageOptionAvoidSetImage progress:nil transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil == error) {
                    kSself
                    sself->_backgroundView.image = [image blurLevel: 10];
                }
            });
        }];
    }
    _effectview.hidden = NO;
    _backgroundEffectview.hidden = YES;
}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

/// 准备子控件
- (void)prepareSubviews {
    _backgroundEffectview = [[UIView alloc] init];
    // 背景
    _backgroundView = [UIImageView imageView];
    // 渐变视图
    _effectview = [[UIView alloc] init];
    // 渐变Layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, kHeight(60));
    gradientLayer.startPoint =  CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    gradientLayer.colors = @[(id)[UIColor colorWithHex:0xffffff alpha:0.0].CGColor,
                             (id)[UIColor colorWithHex:0xffffff alpha:0.1].CGColor,
                             (id)[UIColor colorWithHex:0xffffff alpha:0.2].CGColor,
                             (id)[UIColor colorWithHex:0xffffff alpha:0.3].CGColor,
                             (id)[UIColor colorWithHex:0xffffff alpha:0.4].CGColor,
                             (id)[UIColor colorWithHex:0xffffff alpha:0.6].CGColor,
                             (id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@(0.0), @(0.1), @(0.2), @(0.3), @(0.4), @(0.5), @(1.0)];
    // 添加Layer
    [_effectview.layer addSublayer:gradientLayer];
    [_backgroundEffectview.layer addSublayer:self.backgroundGradientLayer];
    
    // 添加视图
    [self addSubview:_backgroundEffectview];
    [self addSubview:_backgroundView];
    [self addSubview:_effectview];
    
    // 约束
    [_backgroundEffectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(60));
    }];
}

- (CAGradientLayer *)backgroundGradientLayer {
    if (!_backgroundGradientLayer) {

        _backgroundGradientLayer = [CAGradientLayer layer];
        _backgroundGradientLayer.startPoint =  CGPointMake(0.0, 0.0);
        _backgroundGradientLayer.endPoint = CGPointMake(0.0, 1.0);
        _backgroundGradientLayer.colors = @[(id)[UIColor colorWithHex:0x000000 alpha:1.0].CGColor,
                                 (id)[UIColor colorWithHex:0x000000 alpha:0.9].CGColor,
                                 (id)[UIColor colorWithHex:0x000000 alpha:0.8].CGColor,
                                 (id)[UIColor colorWithHex:0x000000 alpha:0.7].CGColor,
                                 (id)[UIColor colorWithHex:0x000000 alpha:0.6].CGColor,
                                 (id)[UIColor colorWithHex:0x000000 alpha:0.5].CGColor,
                                 (id)[UIColor colorWithHex:0x000000 alpha:0.0].CGColor];
        _backgroundGradientLayer.locations = @[@(0.0), @(0.1), @(0.2), @(0.3), @(0.5), @(0.7), @(1.0)];
    }
    return _backgroundGradientLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundGradientLayer.frame = self.bounds;
}

@end
