//
//  SVWiFiViewController.m
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVWiFiViewController.h"
#import "SVConnectViewController.h"
#import "SVWiFiHeaderView.h"
#import "SVSectionHeaderView.h"
#import "SVWiFiViewCell.h"
#import "SVWiFi.h"
#import "SVDeviceViewModel.h"

@interface SVWiFiViewController ()

@property (nonatomic, strong) NSMutableArray<SVWiFi *> *ssids;
@property (nonatomic, strong) NSMutableArray<SVWiFi *> *currents;

@end

@implementation SVWiFiViewController {
    SVWiFiType _type;
    BOOL _open;
}

/// Wi-Fi列表
+ (instancetype)viewControllerWithType:(SVWiFiType)type{
    SVWiFiViewController *viewController = [[SVWiFiViewController alloc] init];
    viewController->_type = type;
    return viewController;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    self.title = @"Wi-FI";
    _open = YES;
    
    [self prepareSubviews];
    NSString *deviceId = self.parameter[kDeviceId] ? : (_deviceId?:@"");
    _deviceId = deviceId;
    kWself
    if (_type != SVWiFiTypeOther) { // 首次配网/设备已经绑定，但断网了 走热点 （UDP）
        [self prepareNotification];
        // 获取Wi-Fi列表
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendWiFiList];
//        });
        
        // 接受Wi-Fi列表
        [[SVUDPSocket sharedSocket] receiveMessage:^(long tag, NSDictionary *message) {
            NSString *value = message[kUDPSocketMsgTypeKey];
            if ([value isEqualToString:kUDPSocketMsgWiFiListValue]) {
                DebugLog(@"UDP WiFi List receive->%@", message);
                [SVProgressHUD dismiss];
                kSself
                NSArray<NSDictionary *> *list = message[kUDPSocketDataTypeKey];
                [sself reloadData:list];
            }
        }];
        
        // MQTT 重连上 重新订阅设备
        [[SVMQTTManager sharedManager] connectionHandler:^(NSError *error) {
            if (nil == error) {
                DebugLog(@"MQTT 重连上 重新订阅设备: %@", deviceId);
                [[SVMQTTManager sharedManager] subscribeDeviceId:deviceId];
            }
        }];
        
    } else { // 在线配网 走热点 （MQTT）
        // 发送获取 设备信息/Wi-Fi列表 指令
        [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventGetDeviceInfo),kFromId : deviceId } handler:nil];
        [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventOpenWiFi) ,kFromId : deviceId} handler:nil];
        [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary *message) {
            kSself
            NSInteger cmd = [message[kCmd] integerValue];
            NSString *fromId = message[kFromId];
            if ([fromId isEqualToString:deviceId]) {
                if (SVMQTTCmdEventWiFiList == cmd) {
                    NSDictionary <NSString *, id> *ext = message[kExt];
                    NSArray<NSDictionary *> *list = ext[kList];
                    [sself reloadData:list];
                } else if (SVMQTTCmdEventDeviceInfo == cmd) { // 设备信息
                    // 当前连接Wi-Fi
                    NSDictionary <NSString *, id> *info = message[kExt][@"currentWifiInfo"];
                    [sself.currents removeAllObjects];
                    // Wi-Fi信息
                    SVWiFi *ssid = [SVWiFi yy_modelWithJSON:info];
                    ssid.current = YES;
                    if(ssid){
                        // 保存 / 刷新表格
                        [sself.currents addObject:ssid];
                        [sself.tableView reloadData];
                    }
                }
            }
        }];
    }
}

- (void)reloadData:(NSArray<NSDictionary *> *)list {
    if(nil == list || list.count == 0){ return; };
    _open = YES;
    [self.ssids removeAllObjects];
    [self.ssids addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVWiFi class] json:list]];
    [self.tableView reloadData];
}

// MARK: - Action
/// 绑定提示
- (void)showAlert {
    if (_type == SVWiFiTypeReconnect) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_relocation_succeed")];
        NSString *deviceId = self.parameter[kDeviceId] ? : (_deviceId?:@"");
        [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventReconnect) ,kFromId : deviceId} handler:nil];

        NSDictionary *dict = @{ kDeviceId : deviceId ? : @"", @"status" : @(YES) };
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceStatusNotification object:dict];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    kWself
    SVAlertViewController *viewController = [SVAlertViewController alertControllerWithTitle:SVLocalized(@"login_prompt") message:SVLocalized(@"home_device_bound") cancelText:SVLocalized(@"home_cancel") confirmText:SVLocalized(@"home_confirm")];
    viewController.messageAlignment = NSTextAlignmentCenter;
    viewController.cancelBorderColor = [UIColor whiteColor];
    viewController.cancelTextColor = [UIColor grayColor5];
    viewController.confirmBackgroundColor = [UIColor grassColor3];
    viewController.confirmTextColor = [UIColor grayColor7];
    viewController.showClose = YES;
    [viewController handler:nil confirmAction:^{
        [wself bindDevice];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)boundDevice {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_device_has_bound") message:SVLocalized(@"home_back") cancelText:nil confirmText:SVLocalized(@"home_confirm")];
    [viewController handler:nil confirmAction:^{
        [wself.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)sendWiFiList {
    if (0 != self.ssids.count) { return; }
    kWself
    [SVProgressHUD showWithStatus:SVLocalized(@"tip_loading")];
    NSDictionary *dict = @{ kUDPSocketMsgTypeKey : kUDPSocketMsgGetWiFiListValue };
    [[SVUDPSocket sharedSocket] sendMessage:dict completion:^(long tag, NSError *error) {
        DebugLog(@"UDP WiFi List send->%@", error);
        if ((nil == error) && (0 == wself.ssids.count)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself sendWiFiList];
            });
        }
    }];
}

/// 打开Wi-Fi列表
- (void)openClick:(BOOL)open {
    if (_type != SVWiFiTypeOther && 0 == self.ssids.count && open) { // 首次配网并且没有获取到Wi-Fi列表
        [self sendWiFiList];
        return;
    }

    _open = open;
    if (open) { // 动画刷新列表
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    } else { // 默认刷新
        [self.tableView reloadData];
    }
}

// MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) { return self.currents.count; }
    return _open ? self.ssids.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVWiFiViewCell *wifiCell = [SVWiFiViewCell cellWithTableView:tableView];
    if (0 == indexPath.section) {
        wifiCell.ssid = self.currents[indexPath.row];
    } else {
        wifiCell.ssid = self.ssids[indexPath.row];
    }
    
    return wifiCell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) { return; }
    kWself
    SVConnectViewController *viewController = [[SVConnectViewController alloc] init];
    viewController.ssid = self.ssids[indexPath.row];
    viewController.type = (_type != SVWiFiTypeOther) ? SVConnectTypeUDP : SVConnectTypeMQTT;
    viewController.deviceId = self.deviceId;
    viewController.connectedCallback = ^{
        [wself showAlert];
    };
    viewController.connectErrorCallback = ^{
        [wself.navigationController popViewControllerAnimated:YES];
    };
    [self presentViewController:viewController animated:YES completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            viewController.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
        }];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (0 == section) { return nil; }
    SVSectionHeaderView *headerView = [SVSectionHeaderView viewWithTableView:tableView];
    headerView.title = SVLocalized(@"home_network");
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) { return 0.01; }
    return kHeight(38);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

// MARK: - Notification
- (void)prepareNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendWiFiList) name:kNetworkReachabilityStatusNotification object:nil];
}

// MARK: - Request
- (void)bindDevice {
    SVDeviceViewModel *viewModel = [[SVDeviceViewModel alloc] init];
    kWself
    [viewModel bindDevice:self.parameter completion:^(NSInteger errorCode, NSString *message) {
        kSself
        NSInteger isSuccess = 0 == errorCode;
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadBindDevicesNotification object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD showInfoWithStatus:message];
        } else if (-17 == errorCode) {
            [self boundDevice];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
        NSString *deviceId = sself.parameter[kDeviceId] ? : (sself->_deviceId?:@"");
        NSInteger cmd = isSuccess ? SVMQTTCmdEventBind : SVMQTTCmdEventCancelSend;
        [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(cmd),kFromId : deviceId } handler:nil];
    }];
}

// MARK: - Subviews
/// 子视图
- (void)prepareSubviews {
    self.style = UITableViewStyleGrouped;
    [super prepareTableView];
    self.tableView.rowHeight = kHeight(44);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kSafeAreaBottom, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 子控件
    kWself
    SVWiFiHeaderView *headerView = [[SVWiFiHeaderView alloc] init];
    headerView.valueChangedCallback = ^(BOOL open) {
        [wself openClick:open];
    };
    // 添加视图
    [self.view addSubview:headerView];
    
    // 约束
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarHeight);
        make.height.mas_equalTo(kHeight(44));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(kHeight(1));
        make.left.right.bottom.equalTo(self.view);
    }];
}

// MARK: - lazy
- (NSMutableArray<SVWiFi *> *)ssids {
    if (!_ssids) {
        _ssids = [[NSMutableArray alloc] init];
    }
    return _ssids;
}

- (NSMutableArray<SVWiFi *> *)currents {
    if (!_currents) {
        _currents = [[NSMutableArray alloc] init];
    }
    return _currents;
}

// MARK: - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}

@end
