//
//  SVMemberInfoViewController.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVMemberInfoViewController.h"
#import "SVMemberViewModel.h"

@interface SVMemberInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) SVMemberViewModel *viewModel;

@end

@implementation SVMemberInfoViewController{
    UITextField *_nameTextField;
    UIButton *_managerButton;
    UIButton *_normalButton;
    /// 角色
    NSInteger _role;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSubview];
}

// MARK: - Action
/// 删除成员
- (void)deleteClick:(UIButton *)button {
    button.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"删除"];
    NSString *memberId = [NSString stringWithFormat:@"%ld", self.member.memberId];
    [self.viewModel deleteMember:memberId completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD dismiss];
        button.userInteractionEnabled = YES;
        if (isSuccess) {
            if (self.updateMemberList) {
                self.updateMemberList(YES);
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

/// 更新信息
- (void)saveClick:(UIButton *)button {
    button.userInteractionEnabled = NO;
    NSString *memberId = [NSString stringWithFormat:@"%ld", self.member.memberId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{ @"memberId" : memberId }];
    if (_role > 0) {
        [dict setValue:[NSString stringWithFormat:@"%ld", _role] forKey:@"memberRole"];
    }
    
    NSString *nameText = [_nameTextField.text trimming];
    if (nameText.length > 0) {
        [dict setValue:_nameTextField.text forKey:@"memberName"];
    }
    
    [SVProgressHUD showWithStatus:SVLocalized(@"home_member_update")];
    [self.viewModel updateMember:[dict copy] completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD dismiss];
        button.userInteractionEnabled = YES;
        if (isSuccess) {
            self.member.memberRole = self->_role;
            self.member.memberName = nameText;
            if (self.updateMemberList) {
                self.updateMemberList(NO);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

/// 切换角色
- (void)buttonClick:(UIButton *)button {
    _managerButton.selected = NO;
    _normalButton.selected = NO;
    button.selected = YES;
    _role = button.tag;
}

// MARK: - UI
- (void)prepareSubview {
    self.title = SVLocalized(@"home_member_info");
    self.view.backgroundColor = UIColor.backgroundColor;
    
    _nameTextField = [UITextField textFieldWithPlaceholder:SVLocalized(@"home_member_remarks") type:UIKeyboardTypeDefault textColor:UIColor.textColor backgroundColor:UIColor.whiteColor];
    [_nameTextField corner];
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.delegate = self;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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

    UIButton *delButton = [UIButton buttonWithTitle:SVLocalized(@"home_delete") titleColor:UIColor.whiteColor font:kSystemFont(16)];
    delButton.backgroundColor = UIColor.redButtonColor;
    [delButton corner];
    
    UIButton *saveButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_save") titleColor:UIColor.whiteColor font:kSystemFont(16)];
    saveButton.backgroundColor = UIColor.grassColor;
    [saveButton corner];
    
    _managerButton = managerButton;
    _normalButton = normalButton;
    _nameTextField.text = self.member.memberName;
    
    if ([self.member.userId isEqualToString:[SVUserAccount sharedAccount].userId]) {
        selectBGView.hidden = YES;
        delButton.hidden = YES;
    } else {
        selectBGView.hidden = self.member.memberRole <= self.currentRole || 1 == self.member.memberRole;
        delButton.hidden = self.member.memberRole <= self.currentRole || 1 == self.member.memberRole;
    }
    
    // 添加视图
    [self.view addSubview:_nameTextField];
    [self.view addSubview:selectBGView];
    [selectBGView addSubview:selectKey];
    [selectBGView addSubview:managerButton];
    [selectBGView addSubview:normalButton];
    [self.view addSubview:delButton];
    [self.view addSubview:saveButton];
    
    // 事件
    [managerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [normalButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [delButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (1 != self.member.memberRole) {
        [self buttonClick:self.member.memberRole == 2 ? managerButton : normalButton];
    }
    
    // 约束
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(24));
        make.left.equalTo(self.view).offset(kWidth(12));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kHeight(50));
    }];
    
    [selectBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTextField.mas_bottom).offset(kHeight(24));
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
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottom-kHeight(36));
        make.height.mas_equalTo(kHeight(48));
    }];
    
    [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(saveButton.mas_top).offset(-kHeight(24));
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
