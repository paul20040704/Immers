//
//  SVWrapperView.m
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVWrapperView.h"
#import "SVAgreeView.h"
#import "SVAIDropDownView.h"

@interface SVWrapperView () <UITextFieldDelegate>
@property (nonatomic,strong)SVAIDropDownView *dropMenu;
@end

@implementation SVWrapperView {
    UIButton *_codeButton;
    UITextField *_accountField;
    UITextField *_passwordField;
    BOOL _agree;
    NSString *_countryId;
}

// MARK: - Action
// 登录
- (void)loginClick {
    NSString *account = _accountField.text;
    if (![account isMobileNumber] && ![account isEMailNumber]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_enter_phone_number_email")];
        return;
    }
    
    NSString *password = _passwordField.text;
    if (![password isPassword]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_password_must")];
        return;
    }
    [self endEditing:YES];
    
    if (!_agree) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_tick_agreement")];
        return;
    }
    
    // md5 密码
    password = [password md5String];
    
    if (self.eventCallback) {
        self.eventCallback(SVButtonEventLogin, @{ @"account" : account, @"password" : password, @"countryId" : _countryId});
    }
}

- (void)buttonClick:(UIButton *)button {
    if (self.eventCallback) {
        self.eventCallback(button.tag, nil);
    }
}

- (void)agree:(void(^)(void))callback {
    if (!_agree) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_tick_agreement")];
        return;
    }
    if (callback) {
        callback();
    }
}

// 密码框事件
- (void)passwordFieldChanged {
    [_passwordField textMaxLength:kPasswordMaxLength];
}

- (void)updateCodeButton:(SVCodeModel *)codeModel {
    [_codeButton setTitle:codeModel.countryCode forState:UIControlStateNormal];
    NSString *lowercaseString = [codeModel.countryID lowercaseString];
    UIImage *image = [UIImage imageNamed:lowercaseString];
    [_codeButton setImage:[image resizeImageWithSize:CGSizeMake(28, 21)] forState:UIControlStateNormal];
    _countryId = codeModel.countryID;
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self prepareSubviews];
    }
    return self;
}

/// 准备子控件
- (void)prepareSubviews {
    // 标题
    UILabel *loginLabel = [UILabel labelWithText:SVLocalized(@"login") font:kBoldFont(24) color:[UIColor grayColor7]];
    
    //選擇登入類型
    kWself;
    _dropMenu = [[SVAIDropDownView alloc] initWithFrame:CGRectMake(30, kHeight(76), kWidth(100), kWidth(30))];
    _dropMenu.rowHeight = kHeight(30);
    _dropMenu.autoCloseWhenSelected = YES;
    _dropMenu.textColor = UIColor.grayColor3;
    _dropMenu.indicatorColor = UIColor.grayColor3;
    _dropMenu.cellClickedBlock = ^(NSString * _Nonnull title, NSInteger index) {
        kSself
        if (index == 0){
            sself->_codeButton.hidden = YES;
        }else {
            sself->_codeButton.hidden = NO;
        }
    };
    _dropMenu.datas = @[SVLocalized(@"login_enter_email"), SVLocalized(@"login_enter_phone")];
    
    //選擇國碼按鈕
    _codeButton = [UIButton buttonWithTitle:@"+886" titleColor:[UIColor grayColor6] font:kSystemFont(12)];
    [_codeButton setImage:[[UIImage imageNamed:@"tw"] resizeImageWithSize:CGSizeMake(28, 21)] forState:UIControlStateNormal];
    [_codeButton resetButtonStyle:SVButtinStyleDefault space:10];
    [_codeButton setBackgroundColor: [UIColor colorWithHex:0x000000 alpha:0.03]];
    [_codeButton corner];
    _codeButton.hidden = YES;
    _countryId = @"tw";
    
    // 帐号/密码 输入框
    _accountField = [self prepareTextField:SVLocalized(@"login_account")];
    _passwordField = [self prepareTextField:SVLocalized(@"login_password")];
    
    // 注册/忘记密码/登录按钮
    UIButton *registerButton = [UIButton buttonWithTitle:SVLocalized(@"register") titleColor:[UIColor grayColor6] font:kSystemFont(12)];
    UIButton *forgotButton = [UIButton buttonWithTitle:SVLocalized(@"forgot") titleColor:[UIColor grayColor3] font:kSystemFont(12)];
    UIButton *loginButton = [UIButton buttonWithTitle:SVLocalized(@"login") titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    loginButton.backgroundColor = [UIColor grayColor8];
    [loginButton corner];
    
    SVAgreeView *agreeView = [[SVAgreeView alloc] init];
    agreeView.agreeCallback = ^(BOOL agree) {
        kSself
        sself->_agree = agree;
    };
    agreeView.webCallback = ^(SVButtonEvent event) {
        if (wself.eventCallback) {
            wself.eventCallback(event, nil);
        }
    };
    
    // 计算大小
    _passwordField.secureTextEntry = YES;
    [registerButton sizeToFit];
    [forgotButton sizeToFit];
    registerButton.tag = SVButtonEventRegister;
    forgotButton.tag = SVButtonEventForgot;
    _codeButton.tag = SVButtonEventCode;
    
    // 事件
    [_codeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgotButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_passwordField addTarget:self action:@selector(passwordFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    // 添加控件
    [self addSubview:loginLabel];
    [self addSubview:_codeButton];
    [self addSubview:_accountField];
    [self addSubview:_passwordField];
    [self addSubview:registerButton];
    [self addSubview:forgotButton];
    [self addSubview:loginButton];
    [self addSubview:agreeView];
    [self addSubview:_dropMenu];
    
    // 约束
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(38));
        make.top.equalTo(self).offset(kHeight(28));
    }];
    
    
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginLabel).offset(kWidth(110));
        make.top.equalTo(loginLabel.mas_bottom).offset(kHeight(20));
        make.width.mas_equalTo(kWidth(100));
        make.height.mas_equalTo(kHeight(30));
    }];
    
    [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginLabel);
        make.right.equalTo(self).offset(kWidth(-38));
        make.top.equalTo(_codeButton.mas_bottom).offset(kHeight(20));
        make.height.mas_equalTo(kHeight(38));
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(_accountField);
        make.top.equalTo(_accountField.mas_bottom).offset(kHeight(20));
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passwordField).offset(kWidth(5));
        make.top.equalTo(_passwordField.mas_bottom).offset(kHeight(8));
        make.height.mas_equalTo(kHeight(22));
    }];
    
    [forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_passwordField).offset(kWidth(-5));
        make.centerY.height.equalTo(registerButton);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_accountField);
        make.top.equalTo(registerButton.mas_bottom).offset(kHeight(60));
        make.height.mas_equalTo(kHeight(48));
    }];
    
    [agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(loginButton);
        make.top.equalTo(loginButton.mas_bottom).offset(kHeight(10));
    }];
    
    if (10 == kRelease) {
        _accountField.text = kDevAccount;
        _passwordField.text = kDevPassword;
    }
}

/// 创建 输入框
- (UITextField *)prepareTextField:(NSString *)placeholder {
    UITextField *textField = [UITextField textFieldWithPlaceholder:placeholder type:UIKeyboardTypeASCIICapable textColor:[UIColor textColor] backgroundColor:[UIColor colorWithHex:0x000000 alpha:0.03]];
    textField.font = kSystemFont(14);
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth(10), 1)];
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.tintColor = [UIColor textColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    
    [textField corner];

    // 占位文本样式
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{ NSFontAttributeName: kSystemFont(14), NSForegroundColorAttributeName: [UIColor grayColor5] }];
    
    return textField;
}

// MARK: - Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([newText isEMailNumber]) {
        _codeButton.hidden = YES;
        [_dropMenu changeHeaderBtn: SVLocalized(@"login_enter_email")];
    } else if ([newText isMobileNumber]) {
        _codeButton.hidden = NO;
        [_dropMenu changeHeaderBtn: SVLocalized(@"login_enter_phone")];
    }
    
    return YES;
}


@end
