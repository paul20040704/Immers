//
//  SVWiFiHeaderView.m
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVWiFiHeaderView.h"
#import "SVGlobalMacro.h"

@implementation SVWiFiHeaderView

// MARK: - Action
- (void)switchChanged:(UISwitch *)openSwitch {
    if (self.valueChangedCallback) {
        self.valueChangedCallback(openSwitch.on);
    }
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
    // 样式
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowColor = [UIColor colorWithHex:0x000000 alpha:0.06].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = kHeight(10);
    // 子控件
    UILabel *textLabel = [UILabel labelWithText:@"WiFi" textColor:[UIColor grayColor8] font:kSystemFont(14)];
    UISwitch *openSwitch = [[UISwitch alloc] init];
    openSwitch.onTintColor = [UIColor grassColor];
    openSwitch.on = YES;
    
    // 添加控件
    [self addSubview:textLabel];
    [self addSubview:openSwitch];
    
    // 事件
    [openSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 约束
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(43));
        make.centerY.equalTo(self);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(43));
        make.centerY.equalTo(self);
    }];
    
    [openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kWidth(-43));
        make.centerY.equalTo(self);
    }];
}

@end
