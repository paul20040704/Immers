//
//  SVAgreeView.m
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVAgreeView.h"

@implementation SVAgreeView {
    UIButton *_checkboxButton;
}

// MARK: - Action
- (void)checkboxClick:(UIButton *)button {
    button.selected = !button.selected;
    BOOL agree = button.selected;
    if (self.agreeCallback) {
        self.agreeCallback(agree);
    }
}

// MARK: - setter
- (void)setNormalName:(NSString *)normalName {
    _normalName = [normalName copy];
    [_checkboxButton setImage:[UIImage imageNamed:_normalName] forState:UIControlStateNormal];
}

// MARK: - 舒适化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

/// 子控件
- (void)prepareSubviews {
    // 创建视图
    _checkboxButton = [UIButton buttonWithNormalName:@"login_agree_normal_g" selectedName:@"login_agree_selected"];
    YYLabel *agreeLabel = [[YYLabel alloc] init];
    agreeLabel.preferredMaxLayoutWidth = kWidth(200);
    agreeLabel.numberOfLines = 0;
    
    // 添加视图
    [self addSubview:_checkboxButton];
    [self addSubview:agreeLabel];
    
    // 事件
    [_checkboxButton addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [_checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(30)));
    }];
    
    [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_checkboxButton);
        make.left.equalTo(_checkboxButton.mas_right);
        make.bottom.right.equalTo(self);
    }];
    
    // 设置文本
    NSString *agreement = SVLocalized(@"agreement");
    NSString *policy = SVLocalized(@"policy");
    NSString *text = [NSString stringWithFormat:SVLocalized(@"agreement_policy"), agreement, policy];
    
    NSRegularExpression *agreementRegular = [[NSRegularExpression alloc] initWithPattern:agreement
    options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRegularExpression *policyRegular = [[NSRegularExpression alloc] initWithPattern:policy
    options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSRange agreementRange = NSMakeRange(0, 0);
    NSRange policyRange = NSMakeRange(0, 0);

    NSArray *results = [agreementRegular matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *result in results) {
        agreementRange = result.range;
        break;
    }
    
    results = [policyRegular matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *result in results) {
        policyRange = result.range;
        break;
    }
    
    NSMutableAttributedString *attributedTextM = [[NSMutableAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName : kSystemFont(12), NSForegroundColorAttributeName : [UIColor grayColor5] }];
    kWself
    // 设置 用户协议 高亮/点击事件
    [attributedTextM yy_setTextHighlightRange:agreementRange color:[UIColor grassColor3] backgroundColor:nil tapAction:^(UIView * containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if (wself.webCallback) {
            wself.webCallback(SVButtonEventAgreement);
        }
    }];
    
    // 设置 隐私政策 高亮/点击事件
    [attributedTextM yy_setTextHighlightRange:policyRange color:[UIColor grassColor3] backgroundColor:nil tapAction:^(UIView * containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if (wself.webCallback) {
            wself.webCallback(SVButtonEventPrivacy);
        }
    }];
    
    // 设置 富文本
    agreeLabel.attributedText = [attributedTextM copy];
}

@end
