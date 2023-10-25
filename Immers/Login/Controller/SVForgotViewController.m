//
//  SVForgotViewController.m
//  Immers
//
//  Created by developer on 2022/5/13.
//

#import "SVForgotViewController.h"
#import "SVCodeViewController.h"
#import "SVUserViewModel.h"
#import "SVCodeViewModel.h"
#import "SVChooseViewController.h"

@interface SVForgotViewController ()
/// 视图模型
@property (nonatomic, strong) SVUserViewModel *viewModel;
//CountryCode模型
@property (nonatomic, strong) SVCodeViewModel *codeViewModel;

@end

@implementation SVForgotViewController {
    UIButton *_codeButton;
    UITextField *_textField;
    NSString *_countryId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSubviews];
    [self prepareItems];
    
    [self.codeViewModel getCode:^(BOOL isSuccess, NSString * _Nullable message) {
            NSLog(@"isGetCodeSuccess: %d",isSuccess);
    }];
}

// MARK: - Action
- (void)nextClick {    
    NSString *text = _textField.text;
    if (![text isMobileNumber] && ![text isEMailNumber]) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"login_account")]];
        return;
    }
    [self checkAccount:text];
}

-(void)codeButtonClick {
    if(self.codeViewModel.codeModel.count > 0) {
        SVChooseViewController *chooseViewController = [[SVChooseViewController alloc]init];
        chooseViewController.codeModelArray = self.codeViewModel.codeModel;
        chooseViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        chooseViewController.view.backgroundColor = [UIColor grayColor3];
        
        chooseViewController.codeCallback = ^(SVCodeModel * _Nonnull codeModel) {
            [self updateCodeButton:codeModel];
        };
        [self presentViewController:chooseViewController animated:YES completion:nil];
    }
}

- (void)updateCodeButton:(SVCodeModel *)codeModel {
    [_codeButton setTitle:codeModel.countryCode forState:UIControlStateNormal];
    NSString *lowercaseString = [codeModel.countryID lowercaseString];
    UIImage *image = [UIImage imageNamed:lowercaseString];
    [_codeButton setImage:[image resizeImageWithSize:CGSizeMake(28, 21)] forState:UIControlStateNormal];
    _countryId = codeModel.countryID;
}


// MARK: - Request
- (void)checkAccount:(NSString *)account {
    kShowLoading
    [self.viewModel account:account completion:^(BOOL isSuccess, NSString *message) {
        kDismissLoading
        if(isSuccess) {
            /**
             1、忘记密码
                 1.1 手机号或邮箱 未注册(不存在)  提示用户未注册
                 1.2 手机号或邮箱 已注册（存在）  进入 验证码
             2、绑定微信/苹果
                 2.1 手机号或邮箱 未注册(不存在)  进入 验证码
                 2.2 手机号或邮箱 已注册（存在）  提示用户已绑定
             */
            BOOL exist = [message boolValue];  // 0 不存在  1 存在
            if (exist && self.bind) { // 存在 / 绑定帐号进来
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_phone_email_bound")];
                
            } else if (!exist && !self.bind) { // 不存在 / 忘记密码进来
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"login_phone_email_registered")];
                
            } else {
                SVCodeType type = self.bind ? SVCodeTypeBindAccount : SVCodeTypeForgot;
                SVCodeViewController *viewController = [SVCodeViewController viewControllerWithType:type];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{ @"account" : account, @"countryId" : self->_countryId }];
                if (self.bind) {
                    [dict addEntriesFromDictionary:self.parameter];
                }
                viewController.parameters = [dict copy];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - subviews
/// 子控件
- (void)prepareSubviews {
    UILabel *textLabel = [UILabel labelWithText:SVLocalized(@"login_account") font:kSystemFont(14) color:[UIColor grayColor7]];
    
    //選擇國碼按鈕
    _codeButton = [UIButton buttonWithTitle:@"+886" titleColor:[UIColor grayColor6] font:kSystemFont(12)];
    [_codeButton setImage:[[UIImage imageNamed:@"tw"] resizeImageWithSize:CGSizeMake(28, 21)] forState:UIControlStateNormal];
    [_codeButton resetButtonStyle:SVButtinStyleDefault space:10];
    [_codeButton setBackgroundColor: [UIColor colorWithHex:0x000000 alpha:0.03]];
    [_codeButton corner];
    [_codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _countryId = @"tw";
    
    // 输入框
    _textField = [self prepareTextField];
    // 横线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor3];
    
    // 子视图
    [self addSubview:textLabel];
    [self addSubview:_codeButton];
    [self addSubview:_textField];
    [self addSubview:lineView];
    
    // 约束
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(100));
    }];
    
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.width.mas_equalTo(kWidth(100));
        make.height.mas_equalTo(kHeight(38));
        make.bottom.equalTo(textLabel.mas_top).offset(kHeight(-20));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.top.equalTo(textLabel.mas_bottom).offset(kHeight(10));
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_textField);
        make.height.mas_equalTo(kHeight(1));
    }];
}

/// 输入框
- (UITextField *)prepareTextField {
    UITextField *textField = [UITextField textFieldWithPlaceholder:SVLocalized(@"login_account") type:UIKeyboardTypeASCIICapable textColor:[UIColor grayColor8] backgroundColor:[UIColor clearColor]];
    textField.font = kSystemFont(14);
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.tintColor = [UIColor textColor];
    
    // 占位文本样式
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{ NSFontAttributeName: kSystemFont(14), NSForegroundColorAttributeName: [UIColor grayColor3] }];
    
    return textField;
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
