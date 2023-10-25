//
//  SVPasswordViewController.m
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVPasswordViewController.h"
#import "SVUpdateViewController.h"
#import "SVCodeViewController.h"
#import "SVPasswordField.h"
#import "SVUserViewModel.h"

@interface SVPasswordViewController ()

@end

@implementation SVPasswordViewController {
    SVPasswordField *_passwordField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_set_password");
    
    [self prepareSubviews];
    [self prepareItems];
}

// MARK: - Action
- (void)nextClick {
    NSString *text = _passwordField.text;
    if (text.length <= 0 || ![text isPassword] ) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_password_must")];
        return;
    }
    
    SVUserViewModel *viewModel = [[SVUserViewModel alloc] init];
    [viewModel validPassword:@{ @"oldPassword" : [text md5String] } completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            SVUpdateViewController *viewController = [[SVUpdateViewController alloc] init];
            viewController.token = message;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)forgotClick {
    SVUserAccount *currentAccount = [SVUserAccount sharedAccount];
    SVCodeViewController *viewController = [SVCodeViewController viewControllerWithType:SVCodeTypeForgot];
    viewController.parameters = @{ @"account" : currentAccount.account };
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 子视图
- (void)prepareSubviews {
    // 密码框/忘记密码
    NSString *text = SVLocalized(@"profile_enter_old_password");
    _passwordField = [SVPasswordField fieldWithTitle:text placeholder:text];
    UIButton *forgotButton = [UIButton buttonWithTitle:SVLocalized(@"forgot") titleColor:[UIColor grayColor3] font:kSystemFont(10)];
    
    // 添加子视图
    [self.view addSubview:_passwordField];
    [self.view addSubview:forgotButton];
    
    // 事件
    [forgotButton addTarget:self action:@selector(forgotClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(40));
    }];
    
    [forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_passwordField);
        make.top.equalTo(_passwordField.mas_bottom).offset(kHeight(8));
        make.height.mas_equalTo(kHeight(22));
    }];
}

/// items
- (void)prepareItems {
    UIButton *nextButton = [UIButton buttonWithTitle:SVLocalized(@"login_next") titleColor:[UIColor grayColor8] font:kSystemFont(14)];
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
}

@end
