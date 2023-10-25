//
//  SVUpdateVersionView.m
//  Immers
//
//  Created by developer on 2022/12/24.
//

#import "SVUpdateVersionView.h"
#import "SVGlobalMacro.h"
@interface SVUpdateVersionView()
@property(nonatomic, strong) UILabel *titleLabel; // 标题
@property(nonatomic, strong) UILabel *contentLabel;// 更新内容
@property(nonatomic, strong) UIButton *updateButton;// 更新按钮
@property (nonatomic, strong) UIButton *closeButton; // 关闭按钮
@end
@implementation SVUpdateVersionView
{
    UIView *_alertBGView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self prepareSubView];
    }
    return self;
}

// MARK: - Action
- (void)toUpdate {
    NSString *str = [NSString stringWithFormat:@"https://apps.apple.com/cn/app/id1631264709"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    
    if(!self.appVersion.updateForce){
        [self dismiss];
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}


// MARK: - SubViews
- (void)prepareSubView {
    self.backgroundColor = UIColor.grayColor6;
    
    UIView *alertBGView = [UIView new];
    alertBGView.backgroundColor = UIColor.whiteColor;
    [alertBGView corner];
    _alertBGView = alertBGView;
    [self addSubview:alertBGView];
    
    [alertBGView addSubview:self.titleLabel];
    [alertBGView addSubview:self.contentLabel];
    [alertBGView addSubview:self.updateButton];
    [alertBGView addSubview:self.closeButton];
    
    
    [alertBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(42));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertBGView).offset(kWidth(26));
        make.top.equalTo(alertBGView).offset(kHeight(22));
        make.height.mas_equalTo(kHeight(30));
        make.centerX.equalTo(alertBGView);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertBGView).offset(kWidth(26));
        make.right.equalTo(alertBGView).offset(kWidth(-26));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kHeight(10));
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertBGView);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(kHeight(38));
        make.size.mas_equalTo(CGSizeMake(kWidth(208), kWidth(34)));
        make.bottom.equalTo(alertBGView).offset(-kHeight(24));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertBGView);
        make.top.equalTo(self.updateButton.mas_bottom).offset(kHeight(14));
        make.size.mas_equalTo(CGSizeMake(kWidth(208), kWidth(34)));
        
    }];
    self.closeButton.hidden = YES;
}

- (void)setAppVersion:(SVAppVersion *)appVersion {
    _appVersion = appVersion;
    self.titleLabel.text =  [NSString stringWithFormat:@"%@:  %@",SVLocalized(@"tip_new_version"),appVersion.apkVersion];
    [self updateContent:appVersion.content];
    self.closeButton.hidden = appVersion.updateForce;
    [_updateButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_alertBGView).offset(appVersion.updateForce?-kHeight(26):-kHeight(68));
    }];
}
- (void)updateContent:(NSString *)content {
    if (nil == content || content.length <= 0) {
        return;
    }
    //换行，接口不返回换行符，用;代替换行符
    content = [content stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    
    // 设置行间距：
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    style.lineSpacing = kHeight(6);
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:content
                                                                                    attributes:@{
        NSParagraphStyleAttributeName: style,
        NSForegroundColorAttributeName : [UIColor grayColor7],
        NSFontAttributeName : kSystemFont(12)} ];
    _contentLabel.attributedText = attriString;
}
// MARK: - Lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16);
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kSystemFont(12);
        _contentLabel.textColor = [UIColor grayColor7];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithTitle:SVLocalized(@"tip_update_later") titleColor:UIColor.grayColor5 font:kSystemFont(12)];

        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (UIButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithTitle:SVLocalized(@"tip_update_version_now") titleColor:UIColor.whiteColor font:kSystemFont(12)];
        _updateButton.backgroundColor = [UIColor colorWithHex:0x333333];
        [_updateButton corner];
        [_updateButton addTarget:self action:@selector(toUpdate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}
@end
