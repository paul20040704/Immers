//
//  SVRegisterViewController.m
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVRegisterViewController.h"
#import "SVCodeViewController.h"
#import "SVWebViewController.h"
#import "SVPhoneView.h"
#import "SVEmailView.h"
#import "SVAgreeView.h"
#import "SVUserViewModel.h"
#import "SVChooseViewController.h"
#import "SVCodeViewModel.h"

@interface SVRegisterViewController()
/// 视图模型
@property (nonatomic, strong) SVUserViewModel *viewModel;
@property (nonatomic, strong) SVCodeViewModel *codeViewModel;
@property (nonatomic, strong) SVChooseViewController *chooseViewController;

@end

@implementation SVRegisterViewController {
    UIButton *_typeButton;
    UIScrollView *_scrollView;
    SVPhoneView *_phoneView;
    SVEmailView *_emailView;
    BOOL _agree;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.light = YES;
    self.hidenNav = YES;
    self.view.backgroundColor = [UIColor colorWithHex:0x6f6f6f];
    [self.codeViewModel getCode:^(BOOL isSuccess, NSString * _Nullable message) {
            NSLog(@"isGetCodeSuccess: %d",isSuccess);
    }];
    [self prepareSubViews];
}

// MARK: - Action
/// 注册按钮事件
- (void)registerClick {
    kWself
    UIView *inputView = (0 == _typeButton.tag) ? _phoneView : _emailView;
    [((SVPhoneView *)inputView) submitForm:^(NSDictionary *parameter) {
        [wself loginWithParameter:parameter];
    }];
}

- (void)loginWithParameter:(NSDictionary *)parameter {
    if (!_agree) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_tick_agreement")];
        return;
    }
    
    [self.viewModel verifyUser:parameter completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            SVCodeViewController *viewController = [SVCodeViewController viewControllerWithType:SVCodeTypeRegister];
            viewController.parameters = parameter;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

/// 用户协议/隐私政策
- (void)handleEvent:(SVButtonEvent)event {
    SVWebViewController *viewController = [[SVWebViewController alloc] init];
    viewController.event = event;
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 切换登录方式
- (void)switchClick:(UIButton *)button {
    _typeButton.selected = NO;
    _typeButton.titleLabel.font = kSystemFont(18);
    
    button.selected = YES;
    button.titleLabel.font = kBoldFont(18);
    _typeButton = button;
    
    [_scrollView setContentOffset:CGPointMake(button.tag * kScreenWidth, 0) animated:YES];
    
    [self.view endEditing:YES];
}

/// 已有帐号 返回事件
- (void)hasClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// MARK： - subviews
/// 准备子视图
- (void)prepareSubViews {
    // 切换登录方式
    UIButton *phoneButton = [UIButton buttonWithTitle:SVLocalized(@"login_phone_number") selectedTitle:nil normalColor:[UIColor colorWithHex:0xffffff alpha:0.7] selectedColor:[UIColor grassColor3] font:kSystemFont(18)];
    UIButton *emailButton = [UIButton buttonWithTitle:SVLocalized(@"login_email") selectedTitle:nil normalColor:[UIColor colorWithHex:0xffffff alpha:0.7] selectedColor:[UIColor grassColor3] font:kSystemFont(18)];
    emailButton.tag = 1;
    
    // 滚动视图 / 参照约束
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    _scrollView.pagingEnabled = YES;
    UIView *referView = [[UIView alloc] init];
    // 手机 / 邮箱登录方式输入框
    _phoneView = [[SVPhoneView alloc] init];
    _emailView = [[SVEmailView alloc] init];
    
    UIButton *hasButton = [UIButton buttonWithTitle:SVLocalized(@"login_have_account") titleColor:[UIColor whiteColor] font:kSystemFont(12)];
    [hasButton sizeToFit];
    
    UIButton *registerButton = [UIButton buttonWithTitle:SVLocalized(@"register") titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    registerButton.backgroundColor = [UIColor grayColor8];
    [registerButton corner];
    
    SVAgreeView *agreeView = [[SVAgreeView alloc] init];
    agreeView.normalName = @"login_agree_normal_w";
    kWself
    agreeView.agreeCallback = ^(BOOL agree) {
        kSself
        sself->_agree = agree;
    };
    agreeView.webCallback = ^(SVButtonEvent event) {
        [wself handleEvent:event];
    };
    
    _phoneView.codeCallback = ^{
        if (self.codeViewModel.codeModel.count > 0) {
            wself.chooseViewController = [[SVChooseViewController alloc]init];
            wself.chooseViewController.codeModelArray = wself.codeViewModel.codeModel;
            wself.chooseViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            wself.chooseViewController.view.backgroundColor = [UIColor grayColor3];
            
            wself.chooseViewController.codeCallback = ^(SVCodeModel * _Nonnull codeModel) {
                kSself
                [sself->_phoneView updateTextField:codeModel];
            };
            
            [wself presentViewController:wself.chooseViewController animated:YES completion:nil];
        }
    };
    
    // 添加子控件
    [self.view addSubview:phoneButton];
    [self.view addSubview:emailButton];
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:referView];
    [referView addSubview:_phoneView];
    [referView addSubview:_emailView];
    [self.view addSubview:hasButton];
    [self.view addSubview:registerButton];
    [self.view addSubview:agreeView];
    
    // 添加事件
    [registerButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [emailButton addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneButton addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    [hasButton addTarget:self action:@selector(hasClick) forControlEvents:UIControlEventTouchUpInside];
    [self switchClick:phoneButton];
    
    // 约束
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.top.equalTo(self.view).offset(kWidth( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 84 : 104));
    }];
    
    [emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.centerY.equalTo(phoneButton);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(phoneButton.mas_bottom).offset(kHeight(30));
        make.height.mas_equalTo(kHeight(184));
    }];
    
    [referView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.height.equalTo(_scrollView);
        make.width.mas_equalTo(2*kScreenWidth);
    }];
    
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(referView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [_emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(referView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [hasButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(emailButton);
        make.top.equalTo(_scrollView.mas_bottom);
        make.height.mas_equalTo(kHeight(33));
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneButton);
        make.right.equalTo(emailButton);
        make.top.equalTo(referView.mas_bottom).offset(kHeight(60));
        make.height.mas_equalTo(kHeight(48));
    }];
    
    [agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(registerButton);
        make.top.equalTo(registerButton.mas_bottom).offset(kHeight(10));
    }];
    
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
