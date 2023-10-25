//
//  SVInviteViewController.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVInviteViewController.h"
#import "SVMemberViewModel.h"

@interface SVInviteViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) SVMemberViewModel *viewModel;

@end

@implementation SVInviteViewController{
    UITextField *_accountTextField;
    UIButton *_managerButton;
    UIButton *_normalButton;
    /// 角色
    NSInteger _role;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSubView];
}

// MARK: - Action
- (void)inviteClick:(UIButton *)button {
    if (self.deviceId == nil) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_device_error")];
        return;
    }
    NSString *accountText = [_accountTextField.text trimming];
    if (accountText.length <= 0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_enter_account_error")];
        return;
    }
    
    NSString *memberRole = [NSString stringWithFormat:@"%ld", _role];
    NSDictionary *dict = @{ @"account" : accountText, @"memberRole" : memberRole, @"framePhotoId" : self.deviceId };
    [self.viewModel invite:dict completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD showInfoWithStatus:message];
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)buttonClick:(UIButton *)button {
    _managerButton.selected = NO;
    _normalButton.selected = NO;
    button.selected = YES;
    _role = button.tag;
}

// MARK: - SubViews
- (void)prepareSubView {
    self.title = SVLocalized(@"home_member_invite");
    self.view.backgroundColor = UIColor.backgroundColor;
    _accountTextField = [UITextField textFieldWithPlaceholder:SVLocalized(@"home_member_account") type:UIKeyboardTypeDefault textColor:UIColor.textColor backgroundColor:UIColor.whiteColor];
    _accountTextField.returnKeyType = UIReturnKeyDone;
    _accountTextField.delegate = self;
    [_accountTextField corner];
    [self.view addSubview:_accountTextField];
    
    UIView *selectBGView = [[UIView alloc] init];
    selectBGView.backgroundColor = UIColor.whiteColor;
    [selectBGView corner];
    
    UILabel *selectKey = [UILabel labelWithText:SVLocalized(@"home_member_authority") font:kSystemFont(16) color:UIColor.grayColor8];
    UIButton *managerButton = [UIButton buttonWithNormalName:@"login_agree_normal_g" selectedName:@"login_agree_selected"];
    [managerButton setTitle:SVLocalized(@"home_member_manager") forState:UIControlStateNormal];
    [managerButton setTitleColor:UIColor.grayColor8 forState:UIControlStateNormal];
    managerButton.tag = 2;
    managerButton.titleLabel.font = kSystemFont(16);
    
    UIButton *normalButton = [UIButton buttonWithNormalName:@"login_agree_normal_g" selectedName:@"login_agree_selected"];
    normalButton.tag = 3;
    normalButton.titleLabel.font = kSystemFont(16);
    [normalButton setTitleColor:UIColor.grayColor8 forState:UIControlStateNormal];
    [normalButton setTitle:SVLocalized(@"home_member_normal") forState:UIControlStateNormal];
    
    UIButton *inviteButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_invite") titleColor:UIColor.whiteColor font:kSystemFont(16)];
    inviteButton.backgroundColor = UIColor.grassColor;
    [inviteButton corner];
    
    _managerButton = managerButton;
    _normalButton = normalButton;
    
    // 事件
    [managerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [normalButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton addTarget:self action:@selector(inviteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self buttonClick: managerButton];
    
    // 添加视图
    [self.view addSubview:selectBGView];
    [selectBGView addSubview:selectKey];
    [selectBGView addSubview:managerButton];
    [selectBGView addSubview:normalButton];
    [selectBGView addSubview:inviteButton];
    [self.view addSubview:inviteButton];
    
    // 约束
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(24));
        make.left.equalTo(self.view).offset(kWidth(12));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kHeight(50));
    }];
    [selectBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountTextField.mas_bottom).offset(kHeight(24));
        make.left.equalTo(self.view).offset(kWidth(12));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kHeight(50));
    }];
    
    [selectKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBGView).offset(kWidth(12));
        make.centerY.equalTo(selectBGView);
    }];
    [managerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectKey.mas_right).offset(kWidth(36));
        make.centerY.equalTo(selectKey);
    }];

    [normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(managerButton.mas_right).offset(kWidth(24));
        make.centerY.equalTo(managerButton);
    }];

    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottom-kHeight(36));
        make.height.mas_equalTo(kHeight(48));
    }];
}

// MARK: -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    [textField endEditing:YES];
    return YES;
}

// MARK: - lazy
- (SVMemberViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVMemberViewModel alloc] init];
    }
    return _viewModel;
}


@end
