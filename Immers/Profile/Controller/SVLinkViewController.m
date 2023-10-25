//
//  SVLinkViewController.m
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVLinkViewController.h"
#import "SVAlertViewController.h"
#import "SVUserViewModel.h"
#import "SVLoginManager.h"

@interface SVLinkViewController ()

@property (nonatomic, strong) SVUserViewModel *viewModel;

@end

@implementation SVLinkViewController {
//    SVLinkType _type;
    BOOL _isBind;
}

+ (instancetype)viewControllerWithType:(SVLinkType)type {
    SVLinkViewController *viewController = [[SVLinkViewController alloc] init];
    viewController->_isBind = (type == SVLinkTypeBind);
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadSubviews];
}

// MARK: - Action
- (void)actionClick {
    if (_isBind) {
        kWself
        SVAlertViewController *viewController = [SVAlertViewController weakWithTitle:SVLocalized(@"profile_unbound") message:SVLocalized(@"profile_wechat_unbinding") cancelText:SVLocalized(@"home_confirm") confirmText:SVLocalized(@"home_cancel")];
        [viewController handler:^{
            [wself unbindRequest]; // 解绑
        } confirmAction:nil];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        [self bindThirdParty];
    }
}

// MARK: - Request
/// 获取第三方平台信息
- (void)bindThirdParty {
    kWself
    [[SVLoginManager sharedManager] login:SVButtonEventWechat completion:^(BOOL isSuccess, BOOL isCancelled, NSDictionary *parameters) {
        if (isCancelled) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_cancel_binding")];
            
        } else if (!isSuccess) { // NO == isSuccess
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_binding_failed")];
            
        } else {
            kShowLoading
            [wself bindRequest:parameters[@"wxId"]];
        }
    }];
}

/// 绑定
- (void)bindRequest:(NSString *)tid {
    NSDictionary *dict = @{ @"thirdPartyId" : tid, @"type" : @"0" };
    [self.viewModel bindThirdParty:dict completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if (isSuccess) {
            [self reloadData:YES];
        }
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

/// 解绑
- (void)unbindRequest {
    kShowLoading
    [self.viewModel unbindThirdParty:@{ @"type" : @"0" } completion:^(BOOL isSuccess, NSString *message) {
            kDismissLoading
        if (isSuccess) {
            [self reloadData:NO];
        }
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

- (void)reloadData:(BOOL)bind  {
     _isBind = bind;
    [self reloadSubviews];
    if (self.bindCallback) {
        self.bindCallback();
    }
}

// MARK: - Subviews
- (void)reloadSubviews {
    self.title = _isBind ? SVLocalized(@"profile_unbound") : SVLocalized(@"profile_account_binding");
    [self prepareSubviews];
}
/// 准备控件
- (void)prepareSubviews {
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[SVNavigationBar class]]) {
            continue;
        }
        [subview removeFromSuperview];
    }
    
    // logo图标/提示文本
    NSString *text = _isBind ? SVLocalized(@"profile_wechat_unbinding") : SVLocalized(@"profile_wechat_binding");
    
    UIImageView *logoView = [UIImageView imageViewWithImageName:@"profile_wechat_logo"];
    UILabel *textLabel = [UILabel labelWithText:text textColor:[UIColor grayColor7] font:kSystemFont(14) lines:0 alignment:NSTextAlignmentCenter];
    
    // 提交按钮
    NSString *title = _isBind ? SVLocalized(@"profile_confirm_unbinding") : SVLocalized(@"profile_bind");
    UIColor *color = _isBind ? [UIColor grayColor8] : [UIColor whiteColor];
    UIButton *actionButton = [UIButton buttonWithTitle:title titleColor:color font:kSystemFont(14)];
    actionButton.backgroundColor = _isBind ? [UIColor whiteColor] : [UIColor grayColor8];
    actionButton.layer.borderColor = [UIColor grayColor8].CGColor;
    actionButton.layer.borderWidth = 1;
    [actionButton corner];
    
    // 添加子控件
    [self.view addSubview:logoView];
    [self.view addSubview:textLabel];
    [self.view addSubview:actionButton];
    
    // 事件
    [actionButton addTarget:self action:@selector(actionClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(kNavBarHeight+kHeight(68));
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWidth(280));
        make.top.equalTo(logoView.mas_bottom).offset(kHeight(20));
    }];
    
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.height.mas_equalTo(kHeight(48));
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(kHeight(-80));
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
