//
//  SVNotConnectedController.m
//  Immers
//
//  Created by developer on 2022/5/20.
//

#import "SVNotConnectedController.h"
#import "SVWiFiViewController.h"
#import "SVInterfaces.h"
#if TARGET_IPHONE_SIMULATOR
#else
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#endif

@interface SVNotConnectedController ()

@end

@implementation SVNotConnectedController {
    SVInterfaces *_interfaces;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = SVLocalized(@"home_device_not_connected");
    [self prepareSubviews];
    // 建立 UDP
    [SVUDPSocket sharedSocket];
    _interfaces = [SVInterfaces interfaces];
}

// MARK: - Action
- (void)reconnectClick {
#if TARGET_IPHONE_SIMULATOR
    [SVProgressHUD showInfoWithStatus:@"需要用真机"];
#else
    //3566需要手动配网
    if([self.device.holoVersion containsString:@"3566"]){
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_manually_network")];
        return;
    }
    
    kWself
    [SVProgressHUD showWithStatus:SVLocalized(@"tip_hotpot_connecting")];
    NEHotspotConfiguration *hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:kSSID passphrase:kPassword isWEP:NO];
    // 开始连接 (调用此方法后系统会自动弹窗确认)
    [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error && error.code != 13 && error.code != 7) {
            DebugLog(@"error code %@ %ld", error, error.code);
            [wself reconnectClick];
        } else if(error.code == 7) { //error code = 7 ：用户点击了弹框取消按钮
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:SVLocalized(@"tip_cancellation_hotspot"), kSSID]];
            
        } else { // error code = 13 ：已连接
            DebugLog(@"other code %@ %ld", error, error.code);
            [self prepareSSID];
        }
    }];
#endif
}

/// 准备SSID
- (void)prepareSSID {
    kWself
    [_interfaces ssid:^(NSString *ssid) {
        DebugLog(@"ssid---> %@", ssid);
        if ([ssid isEqualToString:kSSID]) {
            [wself prepareWIFIList];
        }

    } denied:^{
        [wself denied:SVLocalized(@"home_location_not_authorized")];
    }];
}

- (void)prepareWIFIList {
    if (nil == self.device.deviceId) { return; }
    NSDictionary *dict = @{ kDeviceId : self.device.deviceId, @"framePhotoId" : self.device.deviceId };
    SVWiFiViewController *viewController = [SVWiFiViewController viewControllerWithType:SVWiFiTypeReconnect];
    viewController.parameter = dict;
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

// MARK: - Subviews
- (void)prepareSubviews {
    // 占位图片
    SVEmptyView *emptyView = [SVEmptyView viewWithText:nil imageName:@"home_no_device"];

    // 标题label
    UILabel *titleLabel0 = [self prepareTitle:SVLocalized(@"home_please_check")];
    UILabel *titleLabel1 = [self prepareTitle:SVLocalized(@"home_network__relocation")];
    
    // 提示详情label
    UILabel *detailLabel0 = [[UILabel alloc] init];
    UILabel *detailLabel1 = [[UILabel alloc] init];
    // 设置行数
    detailLabel0.numberOfLines = 0;
    detailLabel1.numberOfLines = 0;
    // 设置文本
    detailLabel0.attributedText = [self prepareAttributedText:SVLocalized(@"home_turned_on")];
    NSMutableAttributedString *attributedText = [self prepareAttributedText:SVLocalized(@"home_middle_button")];
    [attributedText appendAttributedString:[self prepareAttributedImage:@"home_android"]];
    [attributedText appendAttributedString:[self prepareAttributedText:SVLocalized(@"home_click_start")]];
    detailLabel1.attributedText = attributedText;
    
    // 重连按钮
    UIButton *connectButton = [UIButton buttonWithTitle:SVLocalized(@"home_network_relocation") titleColor:[UIColor whiteColor] font:kSystemFont(16)];
    connectButton.backgroundColor = [UIColor colorWithHex:0x333333];
    [connectButton corner];
    
    // 添加子控件
    [self.view addSubview:emptyView];
    [self.view addSubview:titleLabel0];
    [self.view addSubview:titleLabel1];
    [self.view addSubview:detailLabel0];
    [self.view addSubview:detailLabel1];
    [self.view addSubview:connectButton];
    
    // 事件
    [connectButton addTarget:self action:@selector(reconnectClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(20));
        make.centerX.equalTo(self.view);
    }];
    
    [titleLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(31));
        make.right.equalTo(self.view).offset(kWidth(-31));
        make.top.equalTo(emptyView.mas_bottom).offset(kHeight(20));
    }];
    
    [detailLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(titleLabel0);
        make.top.equalTo(titleLabel0.mas_bottom).offset(kHeight(10));
    }];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(titleLabel0);
        make.top.equalTo(detailLabel0.mas_bottom).offset(kHeight(30));
    }];
    
    [detailLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(titleLabel0);
        make.top.equalTo(titleLabel1.mas_bottom).offset(kHeight(10));
    }];
    
    [connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel0);
        make.size.mas_equalTo(CGSizeMake(kWidth(300), kHeight(44)));
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(kHeight(-80));
    }];
}

/// 提示标题
- (UILabel *)prepareTitle:(NSString *)title {
    return [UILabel labelWithText:title font:kSystemFont(16) color:[UIColor grayColor6]];
}

/// 富文本
- (NSMutableAttributedString *)prepareAttributedText:(NSString *)text {
    // 设置行间距：
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    style.lineSpacing = kHeight(6);
    NSRange range = NSMakeRange(0, [text length]);
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
    [attriString addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [attriString addAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor6] } range:range];
    [attriString addAttributes:@{ NSFontAttributeName : kSystemFont(16)} range:range];
    
    return attriString;
}

// 图片富文本
- (NSAttributedString *)prepareAttributedImage:(NSString *)imageName {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:imageName];
    attachment.bounds = CGRectMake(0, kHeight(-3), attachment.image.size.width, attachment.image.size.height);
    return [NSAttributedString attributedStringWithAttachment:attachment];
}

@end
