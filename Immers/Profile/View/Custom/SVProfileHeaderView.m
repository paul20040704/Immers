//
//  SVProfileHeaderView.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVProfileHeaderView.h"
#import "SVUserButton.h"
#import "SVGlobalMacro.h"

@implementation SVProfileHeaderView

// MARK: - Action
- (void)userClick {
    if (self.didSelectedCallback) {
        self.didSelectedCallback();
    }
}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, kScreenWidth, kHeight(200));
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor gradientFromColor:[UIColor textColor] toColor:[UIColor themeColor] gradientType:SVGradientTypeLeftToRight size:frame.size];
        [self prepareSubviews];
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    // 底部视图
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    // 用户按钮
    SVUserButton *userButton = [[SVUserButton alloc] init];
    
    // 添加子视图
    [self addSubview:bottomView];
    [self addSubview:userButton];
    
    // 事件
    [userButton addTarget:self action:@selector(userClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(83));
    }];
    
    [userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(bottomView.mas_top);
    }];
    
    [self layoutIfNeeded];
    [bottomView topCorner];
}

@end
