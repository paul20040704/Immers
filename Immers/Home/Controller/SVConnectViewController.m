//
//  SVConnectViewController.m
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVConnectViewController.h"

@interface SVConnectViewController () <UITextFieldDelegate>

@end

@implementation SVConnectViewController {
    UITextField *_textField;
    SVTimer *_timer;
    NSInteger _current;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.hidenNav = YES;
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.0];
    [self prepareSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

// MARK: - Action
- (void)connectClick {
    NSString *text = [_textField.text trimming];
    if (text.length < 8) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_length_more")];
        return;
    }
    
    if (nil == self.ssid) { return; }
    // Wi-Fi 信息
    NSDictionary *ext = @{ @"ssid" : self.ssid.SSID, @"bssid" : self.ssid.BSSID, @"capabilities" : self.ssid.capabilities, @"password" : text };
    DebugLog(@"WiFi info: %@", ext);
    if (SVConnectTypeMQTT == self.type) { // MQTT 配网
        [self connectToMQTT:ext];
        
    } else if (SVConnectTypeUDP == self.type) { // UDP 配网
        [self connectToUDP:ext];
    }

    // 取消响应
    [_textField endEditing:YES];
    _current = 0;
    [_timer invalidate];
    kWself
    _timer = [SVTimer syncTimerWithTimeInterval:1.0 repeats:YES block:^{
        kSself
        if (sself->_current > kTimeOutSecond) {
            [SVProgressHUD dismiss];
            if (wself.connectErrorCallback) { // 回调
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_connection_failed")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    wself.connectErrorCallback();
                    [wself dismissClick]; // 销毁控制器
                });
            }
            [sself->_timer invalidate]; // 销毁定时器
        }
        sself->_current += 1;
    }];
}

/// MQTT 连接
- (void)connectToUDP:(NSDictionary *)data {
    // 指令
    NSDictionary *dict = @{ kUDPSocketMsgTypeKey : kUDPSocketMsgSetWiFiValue,
                            kUDPSocketDataTypeKey : data };
    // UDP 发送Wi-Fi信息
    [[SVUDPSocket sharedSocket] sendMessage:dict completion:^(long tag, NSError *error) {
        DebugLog(@"UDP send SetWiFi error: %@", error);
        if (nil == error) { [SVProgressHUD showWithStatus:SVLocalized(@"tip_networking")]; }
    }];
    
    kWself
    // UDP 接受信息 Wi-Fi状态
    [[SVUDPSocket sharedSocket] receiveMessage:^(long tag, NSDictionary *message) {
        NSString *value = message[kUDPSocketMsgTypeKey];
        if ([value isEqualToString:kUDPSocketMsgConnectValue]) {
            DebugLog(@"UDP Connect receive->%@", message);
            NSInteger status = [message[kUDPSocketDataTypeKey] integerValue];
            if (0 == status) {
                kSself
                [sself->_timer invalidate];
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_password_error")];
            }
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SVMQTTManager sharedManager] connect];
    });

    // MQTT接收消息 相框连接上Wi-Fi会发指令【401】
    [self requestMessage];

}

/// MQTT 连接
- (void)connectToMQTT:(NSDictionary *)ext {
    // 指令
    NSString *deviceId = self.deviceId ? : @"";
    NSDictionary *dict = @{ kCmd : @(SVMQTTCmdEventSetWiFi),
                            kExt : ext ,kFromId : deviceId};

    // 发送指令
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {
        if (nil == error) { [SVProgressHUD showWithStatus:SVLocalized(@"tip_connecting")]; }
    }];
    [self requestMessage];
}

- (void)requestMessage {
    kWself
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary *message) {
        kSself
        NSInteger cmd = [message[kCmd] integerValue];
        if (SVMQTTCmdEventWiFiConnected == cmd && nil != wself) {
            [sself->_timer invalidate];
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_connection_succeed")];
            [wself dismissWithCall:YES];
        }else if (SVMQTTCmdEventWiFiStatus == cmd) {
            NSDictionary <NSString *, id> *ext = message[kExt];
            NSInteger status = [ext[@"status"] integerValue];
            NSString *text;
            if (0 == status) {
                text = SVLocalized(@"home_password_error");
                
            } else if (1 == status) {
                text = SVLocalized(@"tip_connection_succeed");
                [wself dismissWithCall:NO];
                
            } else if (3 == status) {
                text = SVLocalized(@"tip_connected");
                [wself dismissWithCall:NO];
            }
            if (text) {
                [sself->_timer invalidate];
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:text];
            }

            DebugLog(@"Wi-Fi status: %ld", status);
        }

        

    }];
}

/// 取消事件
- (void)dismissClick {
    [self dismissWithCall:NO];
}

/// 销毁控制器及回调
- (void)dismissWithCall:(BOOL)call {
    [SVProgressHUD dismiss];
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.0];
    [self dismissViewControllerAnimated:YES completion:^{
        if (call && self.connectedCallback) {
            self.connectedCallback();
        }
    }];
}

/// 输入框 明文/密文事件
- (void)secureClick:(UIButton *)button {
    button.selected = !button.selected;
    _textField.secureTextEntry = button.selected;
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

// MARK: - Subviews
/// 子视图
- (void)prepareSubviews {
    // 销毁按钮
    UIButton *dismissButton = [[UIButton alloc] init];
    
    // 容器
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.backgroundColor = [UIColor whiteColor];
    
    // 标题/取消按钮/连接按钮
    UILabel *titleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@%@", SVLocalized(@"login_please_enter"), SVLocalized(@"login_password")] font:kSystemFont(16) color:[UIColor grayColor6]];
    UIButton *cancelButton = [UIButton buttonWithTitle:SVLocalized(@"home_cancel") titleColor:[UIColor grayColor5] font:kSystemFont(14)];
    UIButton *connectButton = [UIButton buttonWithTitle:SVLocalized(@"home_connect") titleColor:[UIColor colorWithHex:0x409F7A] font:kSystemFont(14)];
    [cancelButton sizeToFit];
    [connectButton sizeToFit];
    
    UIView *networkView = [self prepare:SVLocalized(@"home_network") text:self.ssid.SSID];
    UIView *passwordkView = [self prepare:SVLocalized(@"login_password") text:nil];
    
    UIButton *secureButton = [UIButton buttonWithNormalName:@"home_password_open" selectedName:@"home_password_close"];
    
    // 添加控件
    [self.view addSubview:dismissButton];
    [self.view addSubview:wrapperView];
    [self.view addSubview:titleLabel];
    [self.view addSubview:cancelButton];
    [self.view addSubview:connectButton];
    [self.view addSubview:networkView];
    [self.view addSubview:passwordkView];
    [self.view addSubview:secureButton];
    
    // 事件
    [dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [connectButton addTarget:self action:@selector(connectClick) forControlEvents:UIControlEventTouchUpInside];
    [secureButton addTarget:self action:@selector(secureClick:) forControlEvents:UIControlEventTouchUpInside];
    [self secureClick:secureButton];
    // 约束
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight(557));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wrapperView);
        make.top.equalTo(wrapperView).offset(kHeight(23));
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(wrapperView).offset(kWidth(12));
        make.width.mas_equalTo(cancelButton.bounds.size.width + kWidth(24));
    }];
    
    [connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(wrapperView).offset(kWidth(-12));
        make.width.mas_equalTo(connectButton.bounds.size.width + kWidth(24));
    }];
    
    [networkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wrapperView);
        make.top.equalTo(titleLabel.mas_bottom).offset(kHeight(22));
        make.height.mas_equalTo(kHeight(44));
    }];
    
    [passwordkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(networkView);
        make.top.equalTo(networkView.mas_bottom);
    }];
    
    [secureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordkView);
        make.centerX.equalTo(connectButton);
        make.size.mas_equalTo(CGSizeMake(kWidth(44), kWidth(44)));
    }];
    
    [self.view layoutIfNeeded];
    [wrapperView topCorner];
}

- (UIView *)prepare:(NSString *)title text:(nullable NSString *)text {
    UIColor *color = text ? [UIColor grayColor3] : [UIColor grayColor6];
    UIView *wrapperView = [[UIView alloc] init];
    
    UILabel *titleLabel = [UILabel labelWithText:title font:kSystemFont(14) color:color];
    UITextField *textField = [UITextField textFieldWithPlaceholder:SVLocalized(@"login_please_enter") type:UIKeyboardTypeASCIICapable textColor:color backgroundColor:[UIColor clearColor]];
    textField.text = text;
    textField.userInteractionEnabled = nil == text;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (textField.userInteractionEnabled) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        _textField = textField;
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.1];
    
    [wrapperView addSubview:titleLabel];
    [wrapperView addSubview:textField];
    [wrapperView addSubview:lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wrapperView).offset(kWidth(24));
        make.centerY.equalTo(wrapperView);
        make.width.mas_equalTo(kWidth(80));
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(kWidth(12));
        make.height.centerY.equalTo(wrapperView);
        make.width.mas_equalTo(kWidth(200));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wrapperView);
        make.height.mas_equalTo(kHeight(1));
    }];
    
    return wrapperView;;
}

// MARK: - dealloc
- (void)dealloc {
    [_timer invalidate];
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}

@end
