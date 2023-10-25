//
//  SVLoginViewController.m
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVLoginViewController.h"
#import "SVRegisterViewController.h"
#import "SVForgotViewController.h"
#import "SVWebViewController.h"
#import "SVWebAlertViewController.h"
#import "SVWrapperView.h"
#import "SVMoreLoginView.h"
#import "SVUserViewModel.h"
#import "SVLoginManager.h"
#import "AppDelegate+SVRequest.h"
#import "SVCodeViewModel.h"
#import "SVChooseViewController.h"

@interface SVLoginViewController ()
/// 视图模型
@property (nonatomic, strong) SVUserViewModel *viewModel;
/// box view
@property (nonatomic, strong) SVWrapperView *wrapperView;
//CountryCode模型
@property (nonatomic, strong) SVCodeViewModel *codeViewModel;

@end

@implementation SVLoginViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSubviews];
    [self showPrivacyAlert];
    
    [self.codeViewModel getCode:^(BOOL isSuccess, NSString * _Nullable message) {
            NSLog(@"isGetCodeSuccess: %d",isSuccess);
    }];
}

// MARK: - Action
//隐私政策弹框
- (void)showPrivacyAlert {
   BOOL privacyAdmit = [[NSUserDefaults standardUserDefaults] boolForKey:kPrivacyAdmit];
    if(!privacyAdmit){
        SVWebAlertViewController *webAlertVC = [[SVWebAlertViewController alloc] init];
        webAlertVC.actionBlock = ^(NSInteger index) {
            switch (index) {
                case 0:
                    {
                        [[UIApplication sharedApplication] performSelector:@selector(suspend)];
                    }
                    break;
                case 1:
                    {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPrivacyAdmit];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserAdmitPrivacyNotification object:nil];
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [app updateVersion];
                        
                    }
                    break;
                    
                default:
                    break;
            }
        };
        [self presentViewController:webAlertVC animated:YES completion:nil];

    }
}

- (void)handleEvent:(SVButtonEvent)event parameter:(NSDictionary *)parameter {
    if (event == SVButtonEventLogin) {
        [self loginRequest:parameter];
        
    } else if (event == SVButtonEventRegister) {
        SVRegisterViewController *viewController = [[SVRegisterViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (event == SVButtonEventForgot) {
        SVForgotViewController *viewController = [[SVForgotViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (event == SVButtonEventPrivacy || event == SVButtonEventAgreement) {
        SVWebViewController *viewController = [[SVWebViewController alloc] init];
        viewController.event = event;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (event == SVButtonEventCode) {
        if (self.codeViewModel.codeModel.count > 0) {
            SVChooseViewController *chooseViewController = [[SVChooseViewController alloc]init];
            chooseViewController.codeModelArray = self.codeViewModel.codeModel;
            chooseViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            chooseViewController.view.backgroundColor = [UIColor grayColor3];
            
            chooseViewController.codeCallback = ^(SVCodeModel * _Nonnull codeModel) {
                [self.wrapperView updateCodeButton:codeModel];
            };
            [self presentViewController:chooseViewController animated:YES completion:nil];
        }
    }
}

- (void)handleLoginEvent:(SVButtonEvent)event {
    kWself
    [self.wrapperView agree:^{
        [[SVLoginManager sharedManager] login:event completion:^(BOOL isSuccess, BOOL isCancelled, NSDictionary *parameters) {
            if (isCancelled) {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_cancel_login")];
                
            } else if (!isSuccess) { // NO == isSuccess
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_login_failure")];
                
            } else {
                kShowLoading
                if (event == SVButtonEventApple) {
                    [wself appleRequest:parameters];
                    
                } else if (event == SVButtonEventWechat) {
                    [wself wechatRequest:parameters];
                }
            }
        }];
    }];
}

// MARK: - request
/// 手机号/邮箱登录
- (void)loginRequest:(NSDictionary *)parameter {
    kShowLoading
    if ([parameter[@"account"] isEMailNumber]) {
        [self.viewModel login:parameter completion:^(NSString *message) {
            kDismissLoading
            [SVProgressHUD showInfoWithStatus:message];
        }];
    }else {
        NSDictionary *dict = @{@"CountryId" : parameter[@"countryId"], @"PhoneNumber" : parameter[@"account"]};
        [self.codeViewModel getNationalNumber:dict completion:^(BOOL isSuccess, NSString * _Nullable code, NSString * _Nullable number) {
            if (isSuccess) {
                NSDictionary* dict = @{@"account" : number, @"password" : parameter[@"password"]};
                [self.viewModel login:dict completion:^(NSString *message) {
                    kDismissLoading
                    [SVProgressHUD showInfoWithStatus:message];
                }];
            }else {
                [SVProgressHUD showInfoWithStatus:code];
            }
        }];
    }
}

/// 苹果登录
- (void)appleRequest:(NSDictionary *)parameter {
    NSDictionary *dict = @{ @"thirdId" : parameter[@"identityToken"], @"type" : @"1" };
    [self.viewModel verifyThirdParty:dict completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if (isSuccess) {
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameter];
            [param setValue:@"1" forKey:@"type"];
            [self bindAccount:param];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

/// 微信登录
- (void)wechatRequest:(NSDictionary *)parameter {
    NSDictionary *dict = @{ @"thirdId" : parameter[@"wxId"], @"type" : @"0" };
    [self.viewModel verifyThirdParty:dict completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if (isSuccess) {
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameter];
            [param setValue:@"0" forKey:@"type"];
            [self bindAccount:param];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)bindAccount:(NSDictionary *)parameter {
    SVForgotViewController *viewController = [[SVForgotViewController alloc] init];
    viewController.parameter = parameter;
    viewController.bind = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 子控件
- (void)prepareSubviews {
    // 创建控件
    SVWrapperView *wrapperView = [[SVWrapperView alloc] init];
    //SVMoreLoginView *moreView = [[SVMoreLoginView alloc] init];
    
    // 添加视图
    [self.view addSubview:wrapperView];
    //[self.view addSubview:moreView];
    
    // 约束
    [wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kHeight( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 116 : 216));
    }];

//    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(kWidth(36));
//        make.right.equalTo(self.view).offset(kWidth(-36));
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(kHeight(-47));
//    }];
    
    // 事件
    kWself
    wrapperView.eventCallback = ^(SVButtonEvent event, NSDictionary *dict) {
        [wself handleEvent:event parameter:dict];
    };
//    moreView.loginCallback = ^(SVButtonEvent event) {
//        [wself handleLoginEvent:event];
//    };
    
    self.wrapperView = wrapperView;
    // 隐藏导航栏 / 状态栏颜色 / 背景颜色
    self.light = YES;
    self.hidenNav = YES;
    self.view.backgroundColor = [UIColor gradientFromColor:[UIColor textColor] toColor:[UIColor themeColor] gradientType:SVGradientTypeLeftToRight size:self.view.bounds.size];
    
    [self.view layoutIfNeeded];
    [wrapperView corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kHeight(30)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// MARK: - lazy
- (SVUserViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVUserViewModel alloc] init];
    }
    return _viewModel;
}

// MARK: -Lazy
- (SVCodeViewModel *)codeViewModel {
    if(!_codeViewModel){
        _codeViewModel = [[SVCodeViewModel alloc] init];
    }
    
    return _codeViewModel;
}

@end
