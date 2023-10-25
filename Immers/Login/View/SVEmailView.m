//
//  SVEmailView.m
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import "SVEmailView.h"
#import "SVTextField.h"
#import "SVGlobalMacro.h"

@implementation SVEmailView {
    SVTextField *_nameField;
    SVTextField *_emailField;
    SVTextField *_passwordField;
}

// MARK: - 公共方法
- (void)submitForm:(void (^)(NSDictionary *))completion {
    NSString *nameText = _nameField.text;
    if (nameText.length <= 0) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"login_user_name")]];
        return;
    }
    NSString *emailText = _emailField.text;
    if (![emailText isEMailNumber]) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:SVLocalized(@"login_account_format_wrong"), SVLocalized(@"login_enter_email")]];
        return;
    }
    
    NSString *passwordText = _passwordField.text;
    if (![passwordText isPassword]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_password_must")];
        return;
    }
    
    NSDictionary *dict = @{ @"userName" : nameText, @"account" : emailText, @"password" : [passwordText md5String] };
    if (completion) {
        completion(dict);
    }
}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

// 准备视图
- (void)prepareSubviews {
    _nameField = [SVTextField textField:SVLocalized(@"login_user_name") placeholder:[NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"login_user_name")] type:UIKeyboardTypeDefault];
    _emailField = [SVTextField textField:SVLocalized(@"login_enter_email") placeholder:[NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"login_enter_email")] type:UIKeyboardTypeEmailAddress];
    _passwordField = [SVTextField textField:SVLocalized(@"login_password") placeholder:[NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"login_password")] type:UIKeyboardTypeASCIICapable];
    _nameField.maxLength = 50;
    
    [self addSubview:_nameField];
    [self addSubview:_emailField];
    [self addSubview:_passwordField];
    
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(kWidth(40));
        make.right.equalTo(self).offset(kWidth(-40));
        make.height.mas_equalTo(kHeight(41));
    }];
    
    [_emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).offset(kHeight(30));
        make.size.centerX.equalTo(_nameField);
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailField.mas_bottom).offset(kHeight(30));
        make.size.centerX.equalTo(_nameField);
    }];
}

@end
