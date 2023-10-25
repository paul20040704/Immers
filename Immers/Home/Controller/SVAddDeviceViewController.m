//
//  SVAddDeviceViewController.m
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVAddDeviceViewController.h"
#import "SVWiFiViewController.h"
#import "SVScannerController.h"
#import "SVApplyDeviceViewController.h"
#import "SVInterfaces.h"
#import "SVDeviceViewModel.h"
#if TARGET_IPHONE_SIMULATOR
#else
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#endif

@interface SVAddDeviceViewController ()
@end

@implementation SVAddDeviceViewController {
    UILabel *_textLabel;
    UITextField *_textField;
    SVInterfaces *_interfaces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SVLocalized(@"home_add_device");
    [self prepareSubviews];
    [self prepareItems];
    
    // 建立 UDP
    [SVUDPSocket sharedSocket];
    _interfaces = [SVInterfaces interfaces];
}

// MARK: - Action
- (void)nextClick {
//#warning 测试
//    SVApplyDeviceViewController *vc = [[SVApplyDeviceViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
#if TARGET_IPHONE_SIMULATOR
    [SVProgressHUD showInfoWithStatus:@"需要用真机"];
#else
    if ([[_interfaces ssid] isEqualToString:kSSID]) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:SVLocalized(@"home_connected_hotspot"), kSSID]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"] options:@{} completionHandler:nil];
        });
        return;
    }
    
    kWself
    [SVAuthorization cameraAuthorization:^{
        [wself prepareScanner];
        
    } denied:^{
        [wself denied:SVLocalized(@"home_camera_not_authorized")];
    }];
#endif
}

/// 连接热点
- (void)connectHotspot:(NSDictionary *)parameter {
    //3566需要手动配网
    if ([parameter[@"deviceName"] containsString:@"3566"]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_manually_network")];
        return;
    }
#if TARGET_IPHONE_SIMULATOR
#else
    kWself
    [SVProgressHUD showWithStatus:SVLocalized(@"tip_hotpot_connecting")];
    NEHotspotConfiguration *hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:kSSID passphrase:kPassword isWEP:NO];
    // 开始连接 (调用此方法后系统会自动弹窗确认)
    [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error && error.code != 13 && error.code != 7) {
            DebugLog(@"error code %@ %ld", error, error.code);
            [wself connectHotspot:parameter];
            
        } else if(error.code == 7) { //error code = 7 ：用户点击了弹框取消按钮
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:SVLocalized(@"tip_cancellation_hotspot"), kSSID]];
            
        } else { // error code = 13 ：已连接
            DebugLog(@"other code %@ %ld", error, error.code);
            [wself prepareSSID:parameter];
        }
    }];
#endif
}

/// 准备SSID
- (void)prepareSSID:(NSDictionary *)parameter {
    kWself
    [_interfaces ssid:^(NSString *ssid) {
        DebugLog(@"ssid---> %@", ssid);
        if ([ssid isEqualToString:kSSID]) {
            [wself prepareWIFIList:parameter];
        }
    } denied:^{
        [wself denied:SVLocalized(@"home_location_not_authorized")];
    }];
}

/// 扫码获取设备
- (void)prepareScanner {
    // 连接MQTT
    [[SVMQTTManager sharedManager] connect];
    
    kWself
    SVScannerController *viewController = [SVScannerController scannerCompletion:^(NSString *stringValue) {
        if (nil == stringValue || stringValue.length <= 0) { return; }
        
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        // 识别二维码的时候，二维码会出现中文字符
        NSString *info = [stringValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        // 传入url创建url组件类
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:info];
        // 回调遍历所有参数，添加入字典
        [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *obj, NSUInteger idx, BOOL *stop) {
            [parameter setObject:obj.value forKey:obj.name];
        }];
        [wself deviceInfo:parameter];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 准备Wi-Fi列表
- (void)prepareWIFIList:(NSDictionary *)parameter {
    SVWiFiViewController *viewController = [SVWiFiViewController viewControllerWithType:SVWiFiTypeFirst];
    viewController.parameter = parameter;
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 相机/相册未授权 提示
- (void)denied:(NSString *)message {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:SVLocalized(@"login_prompt") message:message cancelText:SVLocalized(@"home_cancel") doneText:SVLocalized(@"home_allow_access") cancelAction:nil doneAction:^(UIAlertAction *action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        });
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: - Request
/// 获取设备信息
- (void)deviceInfo:(NSDictionary *)parameter {
    NSString *deviceId = parameter[kDeviceId];
    NSString *wc = parameter[@"wc"];
    NSString *holoVersion = parameter[@"deviceName"];
    if (deviceId.length > 0 && [parameter[@"type"] isEqualToString:@"1"]) { // 邀请分享 二维码
        SVApplyDeviceViewController *viewController = [[SVApplyDeviceViewController alloc] init];
        viewController.deviceId = deviceId;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 添加设备
    else if (deviceId.length > 0 && [parameter[@"type"] isEqualToString:@"0"] && deviceId && wc.length > 0 && wc) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameter];
        [dict setValue:deviceId forKey:@"framePhotoId"];
        [dict setValue:holoVersion?:@"" forKey:@"holoVersion"];
        kShowLoading
        SVDeviceViewModel *viewModel = [[SVDeviceViewModel alloc] init];
        [viewModel deviceStatus:[dict copy] completion:^(NSInteger errorCode, NSString *message) {
            kDismissLoading
            if (0 == errorCode) {
                if ([message boolValue]) { // 设备在线 直接绑定
                    [self bindDevice:[dict copy]];
                } else { // 设备不在线  需要配网
                    [self connectHotspot:[dict copy]];
                }
            } else if(-18 == errorCode) { // 设备不存在 需要设备
                [self connectHotspot:[dict copy]];
                
            } else if(-19 == errorCode) { // 申请绑定设备
                SVApplyDeviceViewController *viewController = [[SVApplyDeviceViewController alloc] init];
                viewController.deviceId = deviceId;
                [self.navigationController pushViewController:viewController animated:YES];
                
            } else {
                [SVProgressHUD showInfoWithStatus:message];
            }
        }];
        
        /**
         1、设备不在线（无网）
            1.1、连接热点进行配网
            1.2、配网成功绑定

         2、设备在线（有网）
            2.1、直接绑定
         */
    } else {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_qrcode_error")];
    }
}

/// 绑定设备
- (void)bindDevice:(NSDictionary *)parameter {
    SVDeviceViewModel *viewModel = [[SVDeviceViewModel alloc] init];
    NSString *deviceId = parameter[@"deviceId"]?:@"";
    [viewModel bindDevice:parameter completion:^(NSInteger errorCode, NSString *message) {
        if (0 == errorCode) {
            [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventBind) ,kFromId : deviceId} handler:^(NSError *error) {
                DebugLog(@"SVMQTTCmdEventBind send %@", error);
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadBindDevicesNotification object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

// MARK: - Subviews
/// 子视图
- (void)prepareSubviews {
    // 子控件
    SVEmptyView *emptyView = [SVEmptyView viewWithText:SVLocalized(@"home_phone_connect_hotspot") imageName:@"home_open_wifi"];
    NSString *text = [NSString stringWithFormat:@"%@：%@\n\n%@：%@", SVLocalized(@"home_wifi_name"), kSSID, SVLocalized(@"home_wlan_assword"), kPassword];
    UILabel *textLabel = [UILabel labelWithText:text textColor:[UIColor grayColor4] font:kSystemFont(14) lines:0 alignment:NSTextAlignmentLeft];
    
    // 添加视图
    [self.view addSubview:emptyView];
    [self.view addSubview:textLabel];
    
    // 约束
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(kHeight(-60));
        make.centerX.equalTo(self.view);
    }];
    
    CGFloat maxWidth = kWidth(260);
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset((kScreenWidth - maxWidth) / 2.0);
        make.width.mas_equalTo(maxWidth);
        make.top.equalTo(emptyView.mas_bottom).offset(kHeight(20));
    }];
}

/// items
- (void)prepareItems {
    UIButton *nextButton = [UIButton buttonWithTitle:SVLocalized(@"login_next") titleColor:[UIColor grayColor7] font:kSystemFont(14)];
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
}

@end

