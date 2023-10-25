//
//  SVMoreLoginView.m
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVMoreLoginView.h"

@implementation SVMoreLoginView

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

// MARK: - Action
- (void)clickButton:(UIButton *)button {
    if (self.loginCallback) {
        self.loginCallback(button.tag);
    }
}

// MARK:-  UI
/// 准备视图
- (void)prepareSubviews {
    // 分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor3];
    
    // 提示文本
    UILabel *otherLabel = [UILabel labelWithText:SVLocalized(@"login_more") font:kSystemFont(12) color:[UIColor grayColor6]];
    otherLabel.backgroundColor = [UIColor whiteColor];
    
    // 添加子视图
    [self addSubview:lineView];
    [self addSubview:otherLabel];
    
    // 添加约束
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self);
        make.top.equalTo(self).offset(kHeight(10));
        make.height.mas_equalTo(kHeight(1));
    }];
    
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(lineView);
    }];
    
    // 第三方登录 按钮布局
    NSArray <UIButton *> *types = [self prepareLoginButtons];
    if (types.count > 1) {
        [types mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kWidth(40) leadSpacing:kWidth(30) tailSpacing:kWidth(30)];
        [types mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.top.equalTo(otherLabel.mas_bottom).offset(kHeight(28));
        }];
    } else if (types.count > 0) {
        UIButton *button = types.firstObject;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(self);
            make.top.equalTo(otherLabel.mas_bottom).offset(kHeight(28));
        }];
    } else {
        lineView.hidden = YES;
        otherLabel.hidden = YES;
    }
}

/// 准备视图
- (NSArray <UIButton *> *)prepareLoginButtons {
     // 保存登录类型
    NSMutableArray <NSDictionary *> *items = [NSMutableArray arrayWithCapacity:2];
    if (@available(iOS 13.0, *)) { // iOS 13.0 支持苹果登录
        NSDictionary *dict0 = @{ @"name" : @"login_apple", @"tag" : @(SVButtonEventApple) };
        [items addObject:dict0];
    }
    
    if ([WXApi isWXAppInstalled]) { // 用户是否安装微信
        NSDictionary *dict1 = @{ @"name" : @"login_wechat", @"tag" : @(SVButtonEventWechat) };
        [items addObject:dict1];
    }
    
//    NSDictionary *dict2 = @{ @"name" : @"login_fackbook", @"tag" : @(SVButtonEventFacebook) };
//    [items addObject:dict2];
    
    NSMutableArray <UIButton *> *types = [NSMutableArray arrayWithCapacity:items.count];
    
    for (NSDictionary *dict in items) {
        UIButton *button = [UIButton buttonWithImageName:dict[@"name"]];
        button.tag = [dict[@"tag"] integerValue];
        [self addSubview:button];
        [types addObject:button];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [types copy];
}


@end
