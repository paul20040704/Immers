//
//  SVCodeViewController.m
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import "SVCodeViewController.h"
#import "SVAlertViewController.h"
#import "SVReenterViewController.h"
#import "SVPasswordView.h"
#import "SVUserViewModel.h"
#import "SVCodeViewModel.h"

@interface SVCodeViewController ()
/// 视图模型
@property (nonatomic, strong) SVUserViewModel *viewModel;
@property (nonatomic, strong) SVCodeViewModel *codeViewModel;
@end

@implementation SVCodeViewController {
    SVPasscodeView *_passcodeView; // 验证码框
    SVCodeType _type; // 验证码类型
    NSString *_account; // 帐号
    NSString *_msgId; // 验证码消息id
    NSString *_newAccount; //轉換過的標準號碼
    NSString *_countryCode; //手機國碼
}

+ (instancetype)viewControllerWithType:(SVCodeType)type {
    SVCodeViewController *viewController = [[SVCodeViewController alloc] init];
    viewController->_type = type;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareSubviews];
    [self prepareItems];
    [self sendCode];
}

// MARK: - Action
- (void)unReceivedClick {
    kWself
    NSString *message = [NSString stringWithFormat:SVLocalized(@"login_confirm_account"), _account];
    SVAlertViewController *viewController = [SVAlertViewController alertControllerWithTitle:SVLocalized(@"login_prompt") message:message cancelText:SVLocalized(@"login_revise") confirmText:SVLocalized(@"login_yes")];
    viewController.cancelBackgroundColor = [UIColor colorWithHex:0x000000 alpha:0.1];
    [viewController handler:^{
        [wself.navigationController popViewControllerAnimated:YES];
    } confirmAction:^{
        [wself sendCode];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)nextClick {
    NSString *code = _passcodeView.textStore;
    if (code.length < kCodeMaxLength) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"tip_verification_code")]];
        return;
    }
    if (nil == _msgId) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_verification_code_again")];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [parameters setValue:_msgId forKey:@"msgId"];
    [parameters setValue:code forKey:@"code"];
    if(_countryCode.length > 0) {
        [parameters setValue:_countryCode forKey:@"countryCode"];
        [parameters setValue:_newAccount forKey:@"account"];
    }
    
    if (_type == SVCodeTypeRegister) {
        [self registerRequest:parameters];
        
    } else if (_type == SVCodeTypeForgot) {
        [self forgotRequest:parameters];
        
    } else if (_type == SVCodeTypeRemoveAccount) {
        [self removeAccount:parameters];
        
    } else if (_type == SVCodeTypeBindAccount) {
        [self bindAccount:parameters];
    }
}

// MARK: - Request
/// 注册
- (void)registerRequest:(NSMutableDictionary *)parameters {
    kShowLoading
    [self.viewModel register:[parameters copy] completion:^(NSString *message) {
        kDismissLoading
        [SVProgressHUD showInfoWithStatus:message];
    }];
}
    
/// 忘记密码
- (void)forgotRequest:(NSMutableDictionary *)parameters {
    kShowLoading
    [self.viewModel validCode:[parameters copy] completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if (isSuccess) {
            SVReenterViewController *viewController = [[SVReenterViewController alloc] init];
            [parameters setValue:message forKey:@"token"];
            viewController.parameters = parameters;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];

}

/// 注销帐号
- (void)removeAccount:(NSMutableDictionary *)parameters {
    kShowLoading
    [self.viewModel removeAccount:[parameters copy] completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

- (void)bindAccount:(NSMutableDictionary *)parameters {
    NSInteger type = [parameters[@"type"] integerValue];
    if (0 == type) { // 微信登录
        kShowLoading
        [self.viewModel wechatLogin:parameters completion:^(BOOL isSuccess, NSString *message) {
            kDismissLoading
            [SVProgressHUD showInfoWithStatus:message];
        }];
        
    } else if (1 == type) { // 苹果登录
        kShowLoading
        [self.viewModel appleLogin:parameters completion:^(BOOL isSuccess, NSString *message) {
            kDismissLoading
            [SVProgressHUD showInfoWithStatus:message];
        }];
    }
}

/// 发送验证码
- (void)sendCode {
    kShowLoading
    _account = self.parameters[@"account"];
    if ([_account isMobileNumber]) {
        NSDictionary *dict = @{@"CountryId" : self.parameters[@"countryId"], @"PhoneNumber" : self.parameters[@"account"]};
        [self.codeViewModel getNationalNumber:dict completion:^(BOOL isSuccess, NSString * _Nullable code, NSString * _Nullable number) {
            if (isSuccess) {
                NSString *countryCode = [@"+" stringByAppendingFormat:@"%@", code];
                self->_countryCode = countryCode;
                self->_newAccount = number;
                [self.viewModel sendCode:number countryCode:countryCode completion:^(BOOL isSuccess, NSString *message) {
                    kDismissLoading
                    if (isSuccess) {
                        self->_msgId = message;
                        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_verification_code_sent")];
                    } else {
                        [SVProgressHUD showInfoWithStatus:message];
                    }
                }];
            }else {
                [SVProgressHUD showInfoWithStatus:code];
            }
        }];
    }else {
        [self.viewModel sendCode:_account countryCode:@"" completion:^(BOOL isSuccess, NSString * _Nullable message) {
            kDismissLoading
            if (isSuccess) {
                self->_msgId = message;
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_verification_code_sent")];
            } else {
                [SVProgressHUD showInfoWithStatus:message];
            }
        }];
    }
}

/// 子控件
- (void)prepareSubviews {
    _passcodeView = [[SVPasscodeView alloc] init];
    _passcodeView.passcodeCount = 6;
    _passcodeView.space = kWidth(20);
    _passcodeView.font = kSystemFont(46);
    
    UIButton *unReceivedButton = [UIButton buttonWithTitle:SVLocalized(@"login_code_not_received") titleColor:[UIColor grayColor6] font:kSystemFont(12)];
    [unReceivedButton sizeToFit];
    
    [self.view addSubview:_passcodeView];
    [self.view addSubview:unReceivedButton];
    
    [unReceivedButton addTarget:self action:@selector(unReceivedClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_passcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(50));
        make.right.equalTo(self.view).offset(kWidth(-50));
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(90));
        make.height.mas_equalTo(kHeight(90));
    }];
    
    [unReceivedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_passcodeView);
        make.top.equalTo(_passcodeView.mas_bottom).offset(kHeight(15));
    }];
}

- (void)prepareItems {
    UIButton *nextButton = [UIButton buttonWithTitle:SVLocalized(@"login_next") titleColor:[UIColor grayColor8] font:kSystemFont(14)];
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
}

// MARK: - lazy
- (SVUserViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVUserViewModel alloc] init];
    }
    return _viewModel;
}

- (SVCodeViewModel *)codeViewModel {
    if(!_codeViewModel){
        _codeViewModel = [[SVCodeViewModel alloc] init];
    }
    
    return _codeViewModel;
}

@end
