//
//  SVReenterViewController.m
//  Immers
//
//  Created by developer on 2022/5/15.
//

#import "SVReenterViewController.h"
#import "SVTextField.h"
#import "SVUserViewModel.h"

@interface SVReenterViewController ()
/// 视图模型
@property (nonatomic, strong) SVUserViewModel *viewModel;
@end

@implementation SVReenterViewController {
    SVTextField *_newField;
    SVTextField *_confirmField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSubviews];
}

// MARK: - Action
- (void)confirmClick {
    NSString *newText = _newField.text;
    if (![newText isPassword]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_password_must")];
        return;
    }
    
    NSString *confirmText = _confirmField.text;
    if (![confirmText isPassword]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_password_must")];
        return;
    }
    
    if (![newText isEqualToString:confirmText]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"profile_passwords_not_match")];
        return;
    }
    
    [self forgetRequest:newText];
}

// MARK: - Request
- (void)forgetRequest:(NSString *)password {
    if (nil == password) { return; }
    [SVProgressHUD showWithStatus:SVLocalized(@"loading")];
    [self.parameters setValue:[password md5String] forKey:@"password"];
    [self.viewModel forget:[self.parameters copy] completion:^(BOOL isSuccess, NSString *message) {
//        if (isSuccess) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

/// 子视图
- (void)prepareSubviews {
    // 密码输入框 / 确认按钮
    NSString *text = [NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"login_password")];
    _newField = [SVTextField textField:SVLocalized(@"login_password") placeholder:text type:UIKeyboardTypeASCIICapable textColor:[UIColor grayColor7] placeholderColor:[UIColor grayColor3]];
    _confirmField = [SVTextField textField:SVLocalized(@"login_confirm_password") placeholder:text type:UIKeyboardTypeASCIICapable textColor:[UIColor grayColor7] placeholderColor:[UIColor grayColor3]];
    
    _newField.maxLength = kPasswordMaxLength;
    _confirmField.maxLength = kPasswordMaxLength;
    
    UIButton *confirmButton = [UIButton buttonWithTitle:SVLocalized(@"login_yes") titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    [confirmButton corner];
    confirmButton.backgroundColor = [UIColor grayColor8];
    
    // 添加控件
    [self.view addSubview:_newField];
    [self.view addSubview:_confirmField];
    [self.view addSubview:confirmButton];
    
    // 事件
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [_newField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(60));
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.height.mas_equalTo(kHeight(41));
    }];
    
    [_confirmField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_newField.mas_bottom).offset(kHeight(30));
        make.size.centerX.equalTo(_newField);
    }];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmField.mas_bottom).offset(kHeight(160));
        make.centerX.width.equalTo(_confirmField);
        make.height.mas_equalTo(kHeight(48));
    }];
}

// MARK: - lazy
- (SVUserViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVUserViewModel alloc] init];
    }
    return _viewModel;
}


@end
