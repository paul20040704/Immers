//
//  SVStepView.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVStepView.h"
#import "SVGlobalMacro.h"

/// key
static NSString *const kStepKey = @"stepKey";

@implementation SVStepView

// MARK: - 初始化
+ (instancetype)show {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kStepKey]) {
        return nil;
    }
    return [[self alloc] initWithShow];
}

- (instancetype)initWithShow {
    if (self = [super init]) {
        [self prepareSubviews];
    }
    return self;
}

// MARK: - Action
- (void)dismissClick {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kStepKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}

/// 子控件
- (void)prepareSubviews {
    // 气泡
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bubble"]];
    // 提示文本
    UILabel *tipLabel = [UILabel labelWithText:SVLocalized(@"home_add_here") font:kSystemFont(16) color:[UIColor grayColor8]];
    // 最大宽度
    tipLabel.preferredMaxLayoutWidth = kWidth(260);
    // 背景颜色
    self.backgroundColor = [UIColor grayColor7];
    
    // 添加子控件
    [bubbleView addSubview:tipLabel];
    [self addSubview:bubbleView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    // 事件
    [self addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bubbleView).insets(UIEdgeInsetsMake(kHeight(26), kWidth(12), kHeight(15), kWidth(12)));
    }];
    
    [bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(kWidth(-30));
        make.top.equalTo(self).offset(kNavBarHeight);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

@end
