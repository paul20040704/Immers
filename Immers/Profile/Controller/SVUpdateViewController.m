//
//  SVUpdateViewController.m
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVUpdateViewController.h"
#import "SVPasswordField.h"
#import "SVUserViewModel.h"

@interface SVUpdateViewController ()

@end

@implementation SVUpdateViewController {
    SVPasswordField *_newField;
    SVPasswordField *_renewField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_set_password");
    
    [self prepareSubviews];
    [self prepareItems];
}

// MARK: - Action
- (void)confirmClick {
    if (nil == self.token) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_old_password_first")];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *newText = _newField.text;
    if (newText.length <= 0 || ![newText isPassword] ) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_password_must")];
        return;
    }
    
    NSString *renewText = _renewField.text;
    if (renewText.length <= 0 || ![renewText isPassword] ) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_password_must")];
        return;
    }
    
    if (![newText isEqualToString:renewText]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"profile_passwords_not_match")];
        return;
    }
    
    NSDictionary *dict = @{ @"newPassword" : [newText md5String], @"checkToken" : self.token };
    SVUserViewModel *viewModel = [[SVUserViewModel alloc] init];
    [viewModel updatePassword:dict completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

/// 子视图
- (void)prepareSubviews {
    // 密码框/忘记密码
    NSString *text = SVLocalized(@"profile_new_password");
    NSString *new = [NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), text];
    _newField = [SVPasswordField fieldWithTitle:text placeholder:new secureTextEntry:YES];
    UILabel *tipLabel = [UILabel labelWithText:SVLocalized(@"login_password_must") font:kSystemFont(12) color:[UIColor grayColor5]];
    _renewField = [SVPasswordField fieldWithTitle:SVLocalized(@"login_confirm_password") placeholder:new secureTextEntry:YES];
    
    // 添加子视图
    [self.view addSubview:_newField];
    [self.view addSubview:tipLabel];
    [self.view addSubview:_renewField];
    
    // 约束
    [_newField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(40));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_newField);
        make.top.equalTo(_newField.mas_bottom).offset(kHeight(8));
    }];
    
    [_renewField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(_newField);
        make.top.equalTo(tipLabel.mas_bottom).offset(kHeight(20));
    }];
}

/// items
- (void)prepareItems {
    UIButton *confirmButton = [UIButton buttonWithTitle:SVLocalized(@"home_confirm") titleColor:[UIColor grayColor8] font:kSystemFont(14)];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
}


@end
