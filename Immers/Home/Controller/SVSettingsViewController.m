//
//  SVSettingViewController.m
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVSettingsViewController.h"
#import "SVAlertViewController.h"
#import "SVFieldViewController.h"
#import "SVWiFiViewController.h"
#import "SVSettingsViewCell.h"
#import "SVDeviceViewModel.h"
#import "SVFileManagerController.h"
#import "SVMemberViewModel.h"

@interface SVSettingsViewController ()

@end

@implementation SVSettingsViewController {
    UITableView *_tableView;
    SVDeviceViewModel *_viewModel;
    BOOL _online;
    BOOL _hotSpot;//是否可以热点配网
    NSArray *_settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[SVDeviceViewModel alloc] init];
    [self prepareSubviews];
    [self loadDeviceInfo];
    _settings = [_device.holoVersion containsString:@"3566"]?_viewModel.noNetSettings:_viewModel.settings;

    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[self.view viewWithTag:100] topCorner];
}

// MARK: - Action
- (void)setDeviceName:(NSString *)name {
    SVFieldViewController *viewController = [SVFieldViewController fieldControllerWithTitle:SVLocalized(@"home_device_name") placeholder:name cancelText:SVLocalized(@"home_cancel") confirmText:SVLocalized(@"home_confirm")];
    viewController.maxLength = kNameMaxLength;
    viewController.backgroundColor = [UIColor grayColor3];
    viewController.cancelTextColor = [UIColor grayColor7];
    viewController.confirmBackgroundColor = [UIColor grassColor3];
    viewController.backgroundColor = [UIColor colorWithHex:0xbbbbbb];
    kWself
    [viewController handler:nil confirmAction:^(NSString *text) {
        [wself updateDeviceName:text];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)setNetwork {
    SVWiFiViewController *viewController = [SVWiFiViewController viewControllerWithType:SVWiFiTypeOther];
    viewController.deviceId = _device.deviceId;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)unbindDevice {
    if (self.device.isShare) { // 分享设备
        kWself
        SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:nil message:SVLocalized(@"home_exit_tip_title") cancelText:SVLocalized(@"home_confirm") confirmText:SVLocalized(@"home_cancel")];
        viewController.showClose = YES;
        [viewController handler:^{
            NSDictionary *dict = @{ @"framePhotoId" : wself.device.deviceId };
            SVMemberViewModel *viewModel = [[SVMemberViewModel alloc] init];
            [viewModel exitDevice:dict completion:^(BOOL isSuccess, NSString *message) {
                if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadBindDevicesNotification object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                [SVProgressHUD showInfoWithStatus:message];
            }];
            
        } confirmAction:nil];
        [self presentViewController:viewController animated:YES completion:nil];
        
    } else { // 自己的设备
        if (_online) { // 设备在线
            [self unbindDeviceWithClear];
        } else { // 不在线  提示不在线
            kWself
            SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_offline_device") message:SVLocalized(@"home_offline_unbind") cancelText:SVLocalized(@"home_cancel") confirmText:SVLocalized(@"home_continue_unbind")];
            viewController.showClose = YES;
            viewController.backgroundColor = [UIColor grayColor3];
            viewController.cancelBackgroundColor = [UIColor colorWithHex:0xDEDEDE];
            [viewController handler:nil confirmAction:^{
                [wself unbindDeviceWithClear];
            }];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    } 
}

- (void)unbindDeviceWithClear {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_device_unbind") message:SVLocalized(@"home_unbind_clear_text") cancelText:SVLocalized(@"home_unbind_clear") confirmText:SVLocalized(@"home_unbind_keep")];
    viewController.showClose = YES;
    viewController.backgroundColor = [UIColor grayColor3];
    viewController.cancelBorderColor = [UIColor grassColor3];
    viewController.cancelBackgroundColor = [UIColor colorWithHex:0xDEDEDE];
    [viewController handler:^{
        [wself unbindRequest:YES];
    } confirmAction:^{
        [wself unbindRequest:NO];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)shutdown {
    SVSettings *settings = _settings.firstObject;
    NSString *title = settings.text ? : SVLocalized(@"home_power_off");
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:title message:SVLocalized(@"home_device_turned_off") cancelText:SVLocalized(@"home_power_off") confirmText:SVLocalized(@"home_cancel")];
    viewController.showClose = YES;
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{
        [wself updateDeviceStatus];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)toFileManager {
    SVFileManagerController *vc = [[SVFileManagerController alloc] init];
    vc.device = _device;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateDeviceStatus {
    [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventShutdown) ,kFromId : _device.deviceId?:@""} handler:nil];
    NSDictionary *dict = @{ kDeviceId : _device.deviceId ? : @"", @"status" : @(NO) };
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceStatusNotification object:dict];
    [self dismissClick];
}

- (void)dismissClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVSettingsViewCell *settingCell = [SVSettingsViewCell cellWithTableView:tableView];
    settingCell.settings = _settings[indexPath.row];
    settingCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, (indexPath.row == _settings.count - 1) ? 2*kScreenWidth : 0);
    return settingCell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SVSettings *settings = _settings[indexPath.row];
    if (nil == settings.sel || settings.sel.length <= 0) { return; }
    SEL selector = NSSelectorFromString(settings.sel);
    IMP imp = [self methodForSelector:selector];
    void (*msgSendPointer)(id, SEL, NSString *) = (void *)imp;
    msgSendPointer(self, selector, settings.text);
}

// MARK: - Request
/// 加载设备信息
- (void)loadDeviceInfo {
    if (nil == _device.deviceId) { return; }
    NSDictionary *dict = @{ @"framePhotoId" : _device.deviceId?:@"" };
    kWself
    [_viewModel deviceInfo:dict completion:^(BOOL isSuccess, NSString *message) {
        kSself
        if (isSuccess&&sself) {
            sself->_online = [message boolValue];
            [sself->_tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

/// 更新设备名称
- (void)updateDeviceName:(NSString *)name {
    if (nil == _device.deviceId) { return; }
    NSDictionary *dict = @{ @"framePhotoId" : _device.deviceId, @"framePhotoName" : name };
    [_viewModel deviceName:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self->_tableView reloadData];
            if (self.updateDeviceNameCallback) {
                self.updateDeviceNameCallback(name);
            }
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)unbindRequest:(BOOL)clear {
    if (nil == _device.deviceId) { return; }
    NSDictionary *dict = @{ @"framePhotoId" : _device.deviceId ,@"type":clear?@(1):@(0)};
    kWself
    [_viewModel unbindDevice:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            kSself
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadBindDevicesNotification object:sself->_device.deviceId];
            if (clear) { // 301 解绑 清除数据
                [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventUnbindAndClear) } handler:nil];
            } else { // 解绑 不清除数据
                [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventUnbind) } handler:nil];
            }

            [[SVMQTTManager sharedManager] unsubscribeDeviceId:sself->_device.deviceId];
            [self dismissClick];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - Subviews
// 子视图
- (void)prepareSubviews {
    // 设置样式
    self.hidenNav = YES;
    self.view.backgroundColor = [UIColor colorWithHex:0xffffff alpha:0];
    // 销毁按钮
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 控制视图
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *controlView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    controlView.tag = 100;
    
    // 标题/关闭
    UILabel *titleLabel = [UILabel labelWithText:SVLocalized(@"home_set_up") textColor:[UIColor whiteColor] font:kBoldFont(16)];
    UIButton *closeButton = [UIButton buttonWithImageName:@"global_close"];

    // 表格
    _tableView = [self prepareSettingView];
    
    // 添加视图
    [self.view addSubview:dismissButton];
    [self.view addSubview:controlView];
    [self.view addSubview:titleLabel];
    [self.view addSubview:closeButton];
    [self.view addSubview:_tableView];
    
    // 事件
    [dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [closeButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight((330)));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(controlView).offset(kWidth(24));
        make.top.equalTo(controlView).offset(kHeight(12));
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(controlView);
        make.size.mas_equalTo(CGSizeMake(kWidth(44), kWidth(44)));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(controlView).offset(kWidth(40));
        make.right.equalTo(controlView).offset(kWidth(-40));
        make.bottom.equalTo(controlView);
        make.top.equalTo(controlView).offset(kHeight(66));
    }];
}

/// 设置列表
- (UITableView *)prepareSettingView {
    // 表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];
    
    // 设置数据源/代理
    tableView.dataSource = self;
    tableView.delegate = self;
    // 行高
    tableView.rowHeight = kHeight(44);
    // 分隔线颜色 / 背景颜色
    tableView.separatorColor = [UIColor colorWithHex:0xffffff alpha:0.6];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.backgroundColor = [UIColor clearColor];

    // 禁止滚动 / 隐藏滚动条
    tableView.scrollEnabled = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    
    return tableView;
}

- (void)dealloc {
    
}
@end
