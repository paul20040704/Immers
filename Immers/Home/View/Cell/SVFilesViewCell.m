//
//  SVFilesViewCell.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVFilesViewCell.h"

@implementation SVFilesViewCell {
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UIButton *_removeButton;
}

// MARK: - Action
- (void)removeClick {
    if (self.removeCallback) {
        self.removeCallback(self.asset.aid);
    }
}

// MARK: - setter
- (void)setAsset:(SVAsset *)asset {
    _asset = asset;
    
    _iconView.image = [UIImage imageNamed:asset.icon];
    _titleLabel.text = asset.name;
    _removeButton.hidden = !asset.show;
    
    asset.show ? [self shakingAnimation] : [self.contentView.layer removeAllAnimations];
    self.contentView.layer.borderColor = asset.selected ? [UIColor grassColor3].CGColor : [UIColor clearColor].CGColor;
}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    _iconView = [UIImageView imageView];
    _titleLabel = [UILabel labelWithTextColor:[UIColor grayColor7] font:kSystemFont(14) alignment:NSTextAlignmentCenter];
    _removeButton = [UIButton buttonWithImageName:@"home_file_remove"];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_removeButton];
    
    // 事件
    [_removeButton addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(kWidth(6));
        make.size.mas_equalTo(CGSizeMake(kWidth(70), kWidth(67)));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_bottom).offset(kWidth(10));
        make.centerX.width.equalTo(self.contentView);
    }];
    
    [_removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconView.mas_left);
        make.centerY.equalTo(_iconView.mas_top).offset(kHeight(4));
        make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(30)));
    }];
    
    self.contentView.layer.borderWidth = kWidth(1);
    self.contentView.layer.cornerRadius = kHeight(2);
    self.contentView.layer.masksToBounds = YES;
}

/// 抖动动画
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
- (void)shakingAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";

    anim.values = @[@(Angle2Radian(-5)), @(Angle2Radian(5)), @(Angle2Radian(-5))];
    anim.duration = 0.25;

    // 动画次数设置为最大
    anim.repeatCount = MAXFLOAT;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;

    [self.contentView.layer addAnimation:anim forKey:@"shake"];
}

@end
