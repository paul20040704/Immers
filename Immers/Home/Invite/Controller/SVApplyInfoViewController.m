//
//  SVApplyInfoViewController.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVApplyInfoViewController.h"
#import "SVMemberApplyCell.h"
#import "SVMemberViewModel.h"

@interface SVApplyInfoViewController ()

@property (nonatomic, strong) SVMemberViewModel *viewModel;

@end

@implementation SVApplyInfoViewController {
    UIButton *_managerButton;
    UIButton *_normalButton;
    /// 角色
    NSInteger _role;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSubView];
}

// MARK: - Action
- (void)handleClick:(UIButton *)button {
    [SVProgressHUD showWithStatus:SVLocalized(@"home_member_handle")];
    NSString *status = [NSString stringWithFormat:@"%ld", button.tag];
    NSString *memberRole = [NSString stringWithFormat:@"%ld", _role];
    NSDictionary *dict = @{ @"status" : status, @"id" : self.apply.aid, @"memberRole" : memberRole };
    [self.viewModel memberApply:dict completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMemberApplyNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

- (void)buttonClick:(UIButton *)button {
    _managerButton.selected = NO;
    _normalButton.selected = NO;
    button.selected = YES;
    _role = button.tag;
}

// MARK: - UI
- (void)prepareSubView {
    self.title = SVLocalized(@"home_member_apply");
    self.view.backgroundColor = UIColor.backgroundColor;
    
    UILabel *messageLabel = [UILabel labelWithText:SVLocalized(@"home_member_apply_info") font:kSystemFont(14) color:UIColor.grayColor];
    [self.view addSubview:messageLabel];
    
    // 申请人信息
    SVMemberApplyCell *cell = [[SVMemberApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SVMemberApplyCell"];
    cell.apply = self.apply;
    cell.showArrow = YES;
    UIView *contentView = cell.contentView;
    [self.view addSubview:contentView];
    
    UILabel *explainKeyLabel = [UILabel labelWithText:SVLocalized(@"home_member_apply_explain") font:kSystemFont(14) color:UIColor.grayColor];
    [self.view addSubview:explainKeyLabel];
    
    UIView *explainBGView = [[UIView alloc] init];
    explainBGView.backgroundColor = UIColor.whiteColor;
    [explainBGView corner];
    [self.view addSubview:explainBGView];
    
    // 说明
    UILabel *explainLabel = [UILabel labelWithText:self.apply.explain font:kSystemFont(12) color:UIColor.textColor];
    [explainBGView addSubview:explainLabel];
    
    UILabel *powerKeyLabel = [UILabel labelWithText:SVLocalized(@"home_member_authority") font:kSystemFont(14) color:UIColor.grayColor];
    [self.view addSubview:powerKeyLabel];
    
    UIView *powerBGView = [[UIView alloc] init];
    powerBGView.backgroundColor = UIColor.whiteColor;
    [powerBGView corner];

    // 角色
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
    
    _managerButton = managerButton;
    _normalButton = normalButton;
    
    // 按钮
    UIButton *refuseButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_refuse") titleColor:UIColor.whiteColor font:kSystemFont(14)];
    refuseButton.backgroundColor = UIColor.redButtonColor;
    [refuseButton corner];
    refuseButton.tag = 2;
    UIButton *agreeButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_apply_agree") titleColor:UIColor.whiteColor font:kSystemFont(14)];
    agreeButton.backgroundColor = UIColor.grassColor;
    [agreeButton corner];
    agreeButton.tag = 1;
    
    // 添加视图
    [self.view addSubview:powerBGView];
    [powerBGView addSubview:managerButton];
    [powerBGView addSubview:normalButton];
    [self.view addSubview:refuseButton];
    [self.view addSubview:agreeButton];
    
    // 事件
    [managerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [normalButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [refuseButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 事件调用
    [self buttonClick:managerButton];
    
    // 约束
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kWidth(12)+kNavBarHeight);
        make.left.equalTo(self.view).offset(kWidth(12));
        
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(messageLabel.mas_bottom).offset(kWidth(12));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kHeight(140));
    }];
    [explainKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messageLabel);
        make.top.equalTo(contentView.mas_bottom).offset(kHeight(24));
    }];
    [explainBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(explainKeyLabel);
        make.top.equalTo(explainKeyLabel.mas_bottom).offset(kHeight(8));
        make.centerX.equalTo(self.view);
    }];
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(explainBGView).offset(kWidth(12));
        make.centerX.equalTo(explainBGView);
        make.top.equalTo(explainBGView).offset(kWidth(12));
        make.centerY.equalTo(explainBGView);
    }];
    [powerKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(explainBGView);
        make.top.equalTo(explainBGView.mas_bottom).offset(kHeight(24));
    }];
    [powerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(powerKeyLabel);
        make.top.equalTo(powerKeyLabel.mas_bottom).offset(kHeight(8));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kHeight(50));
    }];
    [managerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(powerBGView).offset(kWidth(12));
        make.centerY.equalTo(powerBGView);
    }];

    [normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(managerButton.mas_right).offset(kWidth(24));
        make.centerY.equalTo(managerButton);
    }];

    CGFloat width = (kScreenWidth - kWidth(48))/2;
    [refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(12));
        make.size.mas_equalTo(CGSizeMake(width, kHeight(48)));
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottom-kHeight(24));
    }];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kWidth(12));
        make.size.mas_equalTo(CGSizeMake(width, kHeight(48)));
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottom-kHeight(24));
    }];
}

// MARK: - Lazy
- (SVMemberViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVMemberViewModel alloc] init];
    }
    return _viewModel;
}

@end
