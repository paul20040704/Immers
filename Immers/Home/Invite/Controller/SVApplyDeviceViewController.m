//
//  SVApplyDeviceViewController.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVApplyDeviceViewController.h"
#import "SVMemberViewModel.h"
#import "SVDeviceViewModel.h"

@interface SVApplyDeviceViewController ()<UITextViewDelegate>

@property (nonatomic, strong) SVMemberViewModel *viewModel;
@property (nonatomic, strong) SVDeviceViewModel *deviceViewModel;

@end

@implementation SVApplyDeviceViewController{
    UILabel *_deviceIdLabel;
    UILabel *_deviceNameLabel;
    UILabel *_ownerNameLabel;
    UILabel *_phoneLabel;
    UITextView *_applyTextView;
    UIButton *_applyBtn;
    
    UIView *_statusView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSubView];
    [self loadDeviceInfo];
}

- (void)submitAction {
    [self.view endEditing:YES];
    NSString *text = [_applyTextView.text trimming];
    if (text.length < 0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_say_something")];
        return;
    }
    NSDictionary *dict = @{ @"explain" : text, @"framePhotoId" : self.deviceId ? : @"" };
    [self.viewModel apply:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_apply_succeed")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// MARK: - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [textView textMaxLength:300];
    _applyBtn.enabled = textView.text.length>0;
}

// MARK: - Request
- (void)loadDeviceInfo {
    NSDictionary *dict = @{ @"framePhotoId" : self.deviceId ? : @"" };
    [self.deviceViewModel deviceInfo:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self updateInfo];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}


- (void)updateInfo {
    _deviceIdLabel.text = [NSString stringWithFormat:@"%@%@", SVLocalized(@"home_device_id"), self.deviceViewModel.deviceData.deviceId];
    _deviceNameLabel.text = [NSString stringWithFormat:@"%@%@", SVLocalized(@"home_device_rename"), self.deviceViewModel.deviceData.name];
    _ownerNameLabel.text = [NSString stringWithFormat:@"%@%@", SVLocalized(@"home_binder"), self.deviceViewModel.deviceData.user.userName];
    _phoneLabel.text = [NSString stringWithFormat:@"%@%@", SVLocalized(@"home_binder_account"), self.deviceViewModel.deviceData.user.userEmail ? : self.deviceViewModel.deviceData.user.userPhone];
    
    _statusView.hidden = !self.deviceViewModel.deviceData.isBinding;
}

// MARK: - UI
- (void)prepareSubView {
    self.title = SVLocalized(@"home_apply_join");
    self.view.backgroundColor = UIColor.backgroundColor;
    
    UILabel *statusLabel = [UILabel labelWithText:SVLocalized(@"home_device_status") font:kSystemFont(16) color:UIColor.textColor];
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectZero];
    statusView.backgroundColor = UIColor.whiteColor;
    [statusView corner];
    statusView.hidden = YES;
    _statusView = statusView;
    UILabel *tipsLabel = [UILabel labelWithText:SVLocalized(@"home_device_bind_desc") font:kSystemFont(14) color:UIColor.grayColor7];
    [self.view addSubview:statusLabel];
    [self.view addSubview:statusView];
    [statusView addSubview:tipsLabel];
    
    UILabel *messageLabel = [UILabel labelWithText:SVLocalized(@"home_device_info") font:kSystemFont(16) color:UIColor.textColor];
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectZero];
    messageView.backgroundColor = UIColor.whiteColor;
    [messageView corner];
    
    _deviceIdLabel = [UILabel labelWithText:SVLocalized(@"home_device_id") font:kSystemFont(14) color:UIColor.grayColor7];
    _deviceNameLabel = [UILabel labelWithText:SVLocalized(@"home_device_rename") font:kSystemFont(14) color:UIColor.grayColor7];
    _ownerNameLabel = [UILabel labelWithText:SVLocalized(@"home_binder") font:kSystemFont(14) color:UIColor.grayColor7];
    _phoneLabel = [UILabel labelWithText:SVLocalized(@"home_binder_account") font:kSystemFont(14) color:UIColor.grayColor7];
    [self.view addSubview:messageLabel];
    [self.view addSubview:messageView];
    [messageView addSubview:_deviceIdLabel];
    [messageView addSubview:_deviceNameLabel];
    [messageView addSubview:_ownerNameLabel];
    [messageView addSubview:_phoneLabel];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeight(12)+kNavBarHeight);
        make.left.equalTo(self.view).offset(kWidth(12));
    }];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusLabel.mas_bottom).offset(kHeight(8));
        make.left.equalTo(self.view).offset(kWidth(12));
        make.right.equalTo(self.view).offset(-kWidth(12));
    }];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(statusView).offset(kWidth(12));
        make.right.bottom.equalTo(statusView).offset(-kWidth(12));
    }];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusView.mas_bottom).offset(kHeight(12));
        make.left.equalTo(self.view).offset(kWidth(12));
    }];
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLabel.mas_bottom).offset(kHeight(8));
        make.left.equalTo(self.view).offset(kWidth(12));
        make.right.equalTo(self.view).offset(-kWidth(12));
    }];
    
    [_deviceIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(messageView).offset(kWidth(12));
        make.right.equalTo(messageView).offset(kWidth(-12));
    }];
    
    [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deviceIdLabel.mas_bottom).offset(kHeight(8));
        make.left.right.equalTo(_deviceIdLabel);
    }];
    [_ownerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deviceNameLabel.mas_bottom).offset(kHeight(8));
        make.left.right.equalTo(_deviceNameLabel);
    }];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ownerNameLabel.mas_bottom).offset(kHeight(8));
        make.left.right.equalTo(_ownerNameLabel);
        make.bottom.equalTo(messageView).offset(-kHeight(12));
    }];
    
    UILabel *explainLabel = [UILabel labelWithText:SVLocalized(@"home_apply_explain") font:kBoldFont(16) color:UIColor.grayColor];
    
    _applyTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _applyTextView.font = kSystemFont(14);
    _applyTextView.textColor = UIColor.textColor;
    _applyTextView.delegate = self;
    _applyTextView.textContainerInset = UIEdgeInsetsMake(kWidth(14), kWidth(14), kWidth(14), kWidth(14));
    [_applyTextView placeholderWith:SVLocalized(@"home_enter_explain") szie:14 color:[UIColor colorWithHex:0x999999]];
    _applyTextView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    
    _applyBtn = [UIButton buttonWithTitle:SVLocalized(@"申请加入") titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    [_applyBtn setBackgroundColor:[UIColor disableColor] forState:UIControlStateDisabled];
    _applyBtn.enabled = NO;
    _applyBtn.backgroundColor = [UIColor grassColor];
    [_applyBtn corner];
    [_applyBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:explainLabel];
    [self.view addSubview:_applyTextView];
    [self.view addSubview:_applyBtn];
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageView.mas_bottom).offset(kHeight(36));
        make.left.equalTo(messageView);
    }];
    [_applyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(explainLabel.mas_bottom).offset(kHeight(12));
        make.left.equalTo(explainLabel);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-kWidth(48), kHeight(160)));
    }];
    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.height.mas_equalTo(kHeight(48));
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottom-kHeight(20));
    }];
}

// MARK: - lazy
- (SVMemberViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVMemberViewModel alloc] init];
    }
    return _viewModel;
}

- (SVDeviceViewModel *)deviceViewModel {
    if (!_deviceViewModel) {
        _deviceViewModel = [[SVDeviceViewModel alloc] init];
    }
    return _deviceViewModel;
}

@end
