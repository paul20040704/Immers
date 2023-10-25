//
//  SVHomeViewController.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "SVHomeViewController.h"
#import "SVControlViewController.h"
#import "SVSettingsViewController.h"
#import "SVAddDeviceViewController.h"
#import "SVNotConnectedController.h"
#import "SVNavigationController.h"
#import "SVAlbumViewController.h"
#import "SVMainViewController.h"
#import "SVSelectFrameViewController.h"
#import "SVUploadingViewController.h"
#import "SVTaskViewController.h"
#import "SVFileManagerController.h"
#import "SVDeviceMemberViewController.h"
#import "SVBackgroundView.h"
#import "SVDeviceView.h"
#import "SVStepView.h"
#import "SVDeviceViewModel.h"
#import "SVEventButton.h"
#import "SVDeviceEventView.h"
@interface SVHomeViewController ()

@property (nonatomic, strong) SVDeviceViewModel *viewModel;
@property (nonatomic, strong) SVFTPInfo *ftpInfo;
@property (nonatomic, strong) SVUploadFilePath *httpInfo;

@end

@implementation SVHomeViewController {
    SVBackgroundView *_backgroundView; // 背景
    SVDeviceView *_deviceView;
    SVDevice *_device; // 选择设备
    SVEmptyView *_emptyView; // 空数据
    UIView *_tableHeadView;//背景
    SVDeviceEventView *_eventView;//控制相框的view
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 加载设备
    [self loadDevices];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareEmptyView];
    [self prepareSubviews];
    [self updateSubviews:YES];
    [self prepareItems:NO];

    // 通知
    [self prepareNotification];
    [SVStepView show];
}

// MARK: - Action
/// 设备状态
- (void)deviceStatus:(void(^)(void))callback {
    if (nil == _device) { // 没有绑定设备
        [self addClick]; // 添加设备
    }
//    else if (NO == _device.onlineStatus) { // 设备不在线
//        [self deviceOnlineStatus:_device];
//    }
    else if (callback) { // 有设备 且 在线
        callback();
    }
}

/// 控制事件
- (void)controlClick {
    if (![self deviceOnlineStatus:_device]) { return; }
    SVControlViewController *viewController = [[SVControlViewController alloc] init];
    viewController.deviceId = _device.deviceId;
    viewController.deviceInfo = [SVUserAccount sharedAccount].deviceInfo;
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 设置事件
- (void)settingClick {
//    if (![self deviceOnlineStatus:_device]) { return; }
    kWself
    SVSettingsViewController *viewController = [[SVSettingsViewController alloc] init];
    viewController.device = _device;
    viewController.updateDeviceNameCallback = ^(NSString *name) {
        [wself updateDeviceName:name];
    };
    SVNavigationController *nav = [[SVNavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
}

/// 播放列表
- (void)playClick {
    if (![self deviceOnlineStatus:_device]) { return; }
    SVAlbumViewController *viewController = [[SVAlbumViewController alloc] init];
    viewController.deviceId = _device.deviceId;
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 使用管理
- (void)manageClick {
    SVDeviceMemberViewController *viewController = [[SVDeviceMemberViewController alloc] init];
    viewController.device = _device;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)taskClick {
    SVTaskViewController *viewController = [[SVTaskViewController alloc] init];
    viewController.deviceId = _device.deviceId;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)fileClick {
    if (![self deviceOnlineStatus:_device]) { return; }
    SVFileManagerController *viewController = [[SVFileManagerController alloc] init];
    viewController.device = _device;
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 设备是否在线
- (BOOL)deviceOnlineStatus:(SVDevice *)device {
    [self deviceOnline];
    if (!_device.onlineStatus) {
        SVNotConnectedController *viewController = [[SVNotConnectedController alloc] init];
        viewController.device = device;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    return _device.onlineStatus;
}

/// 添加设备
- (void)addClick {
    SVAddDeviceViewController *viewController = [[SVAddDeviceViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 更新选中及订阅设备
- (void)updateSubscribeDevice:(SVDevice *)device {
    _device = device;
    [SVUserAccount sharedAccount].device = device;
    // 订阅设备
    [[SVMQTTManager sharedManager] subscribeDeviceId:device.deviceId];
    // 获取设备信息
    [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventGetDeviceInfo), kFromId : device.deviceId?:@"" } handler:nil];
    [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventTaskCount) , kFromId : device.deviceId?:@""} handler:nil];
    // 设置封面
    _backgroundView.cover = device.imageUrl;
    
    [self prepareItems:YES];
}

/// 更新设备状态
- (void)updateDevice:(NSString *)deviceId status:(BOOL)status {
    NSMutableArray<SVDevice *> *devices = self.viewModel.devices;
    for (SVDevice *device in devices) {
        if ([device.deviceId isEqualToString:deviceId]) {
            device.onlineStatus = status;
            break;
        }
    }
    if (status&&[_device.deviceId isEqualToString:deviceId]) {
        [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventGetDeviceInfo), kFromId : deviceId?:@"" } handler:nil];
    }
    [_deviceView updateDeviceStatus];
}

/// 更新设备名称
- (void)updateDeviceName:(NSString *)name {
    NSMutableArray<SVDevice *> *devices = self.viewModel.devices;
    for (SVDevice *device in devices) {
        if ([device.deviceId isEqualToString:_device.deviceId]) {
            device.name = name;
            break;
        }
    }
    [_deviceView reloadData];
}

/// 更新设备界面
- (void)updateDeviceSubviews {
    [self updateSubviews:NO];
    kWself
    [[SVMQTTManager sharedManager] connectionHandler:^(NSError *error) {
        if (nil == error) {
            kSself  // 连接成功 开始订阅
            if (sself) { // 当前控制器没有销毁
                [[SVMQTTManager sharedManager] subscribeDeviceId:sself->_device.deviceId];
                [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventGetDeviceInfo) , kFromId : sself->_device.deviceId?:@""} handler:nil];
                [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventTaskCount) , kFromId : sself->_device.deviceId?:@""} handler:nil];
            }
        }
    }];
    [[SVMQTTManager sharedManager] connect];
    
    // 接受消息
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary *message) {
        kSself
        NSInteger cmd = [message[kCmd] integerValue];
        NSString *fromId = message[kFromId];
        if (cmd == SVMQTTCmdEventOnline) { // 在线
            [wself updateDevice:message[kFromId] status:YES];
            
        } else if (cmd == SVMQTTCmdEventOffline) { // 离线
            [wself updateDevice:message[kFromId] status:NO];
            
        } else if (cmd == SVMQTTCmdEventNotStorage || cmd == SVMQTTCmdEventNotMoreStorage) { // 相框存储空间不足
            if ([fromId isEqualToString:sself->_device.deviceId]) {
                [wself notEnoughStorage];
            }
            
        } else if (cmd == SVMQTTCmdEventDeviceInfo) {
            NSDictionary <NSString *, id> *ext = message[kExt];
            if ([fromId isEqualToString:sself->_device.deviceId]) {
                SVDeviceInfo *deviceInfo = [SVDeviceInfo yy_modelWithDictionary:ext];
                deviceInfo.deviceId = fromId;
                [SVUserAccount sharedAccount].deviceInfo = deviceInfo;
                sself->_device.surplusCapacity = deviceInfo.surplusCapacity;
                sself->_device.versionNum = [NSString stringWithFormat:@"%ld",deviceInfo.versionNum.integerValue];

                wself.ftpInfo = deviceInfo.ftpServiceInfo;
                wself.httpInfo = deviceInfo.updateFilePath;

                NSString *ssid = deviceInfo.currentWifiInfo.SSID;
                if (nil != ssid) {
                    [[NSUserDefaults standardUserDefaults] setValue:ssid forKey:kDeviceSSIDKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }

            
        } else if (cmd == SVMQTTCmdEventTaskList) {
            NSDictionary <NSString *, id> *ext = message[kExt];
            [self updateTaskCount:[ext[@"total"] integerValue]];
        }
    }];
    
    _deviceView.devices = self.viewModel.devices;
    if (self.viewModel.devices.count>0&&self.viewModel.devices[0].onlineStatus==NO) {
        [self taskNum];
    }
}

- (void)updateTaskCount:(NSInteger)count {
    _eventView.taskCount = count;
}

/// 更新数据界面
- (void)updateSubviews:(BOOL)hidden {
    _backgroundView.hidden = hidden;
    _deviceView.hidden = hidden;
    _eventView.hidden = hidden;
    _emptyView.hidden = !hidden;
    self.light = !hidden;
    [self prepareItems:!hidden];
}

/// 相框本地存储空间不足
- (void)notEnoughStorage {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_local_storage_clean") message:nil cancelText:SVLocalized(@"login_yes") confirmText:SVLocalized(@"home_cancel")];
    viewController.showClose = YES;
    viewController.messageAlignment = NSTextAlignmentCenter;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{
        [wself fileClick];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

// MARK: - Request
- (void)loadDevices {
    kWself
    [self.viewModel devicesCompletion:^(BOOL isSuccess, NSString *message) {
        kSself
        if (isSuccess) {
            NSMutableArray <SVDevice *> *devices = sself.viewModel.devices;
            if (devices.count > 0) {
                [sself updateDeviceSubviews];
            } else {
                [[SVMQTTManager sharedManager] unsubscribeAllDevice];
                sself->_device = nil;
                [SVUserAccount sharedAccount].device = nil;
                [sself updateSubviews:YES];
            }
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
        [sself.tableView.mj_header endRefreshing];
    }];
}

/// 有网络 重新加载设备
- (void)reloadDevices {
    if (0 != _deviceView.devices.count) { return; }
    [self loadDevices];
}

- (void)deviceOnline {
    kWself
    [self.viewModel deviceOnline:@{@"framePhotoId":_device.deviceId} completion:^(BOOL isSuccess, NSString * _Nullable message, id  _Nullable result) {
        kSself
        if (isSuccess) {
           [sself updateDevice:sself->_device.deviceId status:result];
        }

    }];
}

- (void)taskNum {
    kWself
    [self.viewModel taskNum:@{@"framePhotoId":_device.deviceId} completion:^(BOOL isSuccess, NSString * _Nullable message, id  _Nullable result) {
        kSself
        if (isSuccess) {
            NSNumber *downNums = result[@"downNums"];
            [sself updateTaskCount:downNums.intValue];
        }
    }];
}

// MARK: - Notification

/// 选中文件上传
- (void)selectedFile:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[UIImage class]]) {
        SVSelectFrameViewController *viewController = [[SVSelectFrameViewController alloc] init];
        viewController.image = notification.object;
        viewController.eventType = SVButtonEventUpload;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        if (self.httpInfo&&!self.httpInfo.isOpen) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_not_the_same_LAN")];
            return;
        }
        NSDictionary *dict = notification.object;;
        NSString *path = dict[@"url"];
        NSNumber *type = dict[@"type"];
        long long size = [NSData fileSizeAtPath:[path stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        if (size>_device.surplusCapacity) {
            [self showDeviceMemoryWaring];
            return;
        }
        SVUploadingViewController *viewController = [SVUploadingViewController uploadingViewController];
        viewController.filePath = path;
        viewController.info = self.ftpInfo;
        viewController.httpInfo = _httpInfo;
        viewController.fileType = type.integerValue;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}
- (void)showDeviceMemoryWaring {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_local_storage_clean") message:nil cancelText:SVLocalized(@"home_to_file_manager") confirmText:SVLocalized(@"home_cancel")];
    viewController.showClose = YES;
    viewController.messageAlignment = NSTextAlignmentCenter;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{
        [wself fileClick];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];

}
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
    return CGRectMake(0, 100, kScreenWidth, 700);
}

- (void)updateDevicesStatus:(NSNotification *)notification {
    NSDictionary *dict = notification.object;
    [self updateDevice:dict[kDeviceId] status:[dict[@"status"] boolValue]];
}
/// 通知
- (void)prepareNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedFile:) name:kSelectedFileToUploadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDevices) name:kReloadBindDevicesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDevicesStatus:) name:kUpdateDeviceStatusNotification object:nil];
}

// MARK: - Subviews
/// 子视图
- (void)prepareSubviews {
    self.style = UITableViewStylePlain;
    [self prepareTableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -kTabBarHeight, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableHeadView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    //下拉刷新
    kWself
    MJRefreshNormalHeader *header = [MJRefreshHeader getNormalRefreshHeaderWithRefreshingBlock:^{
        [wself loadDevices];
    }];

    self.tableView.mj_header = header;
    self.tableView.tableHeaderView = _tableHeadView;
    
    // 背景
    _backgroundView = [[SVBackgroundView alloc] init];
    // 设备列表
    _deviceView = [[SVDeviceView alloc] init];
    _deviceView.updateSelectedDeviceCallback = ^(SVDevice *device) {
        [wself updateSubscribeDevice:device];
    };
    
    // 添加子控件
    [_tableHeadView insertSubview:_backgroundView atIndex:0];
    [_tableHeadView addSubview:_deviceView];
    
    _eventView = [[SVDeviceEventView alloc] initWithFrame:CGRectZero];
    _eventView.clickAction = ^(NSInteger index) {
        switch (index) {
            case 0:
                [wself controlClick];
                break;
            case 1:
                [wself taskClick];
                break;
            case 2:
                [wself settingClick];
                break;
            case 3:
                [wself fileClick];
                break;
            case 4:
                [wself playClick];
                break;
            case 5:
                [wself manageClick];
                break;
                
            default:
                break;
        }
    } ;
    [_tableHeadView addSubview:_eventView];
    
    // 约束
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_tableHeadView);
        make.height.mas_equalTo(kHeight(344));
    }];
    
    [_deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableHeadView);
        make.bottom.equalTo(_backgroundView);
        make.height.mas_equalTo(kHeight(255));
    }];
    
    [_eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deviceView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    self.translucent = YES;
}

/// items
- (void)prepareItems:(BOOL)status {
    NSString *title = _device.isShare ? SVLocalized(@"home_share_device") : SVLocalized(@"home_device"); 
    UIButton *deviceButton = [UIButton buttonWithTitle:title titleColor:status ? [UIColor whiteColor] : [UIColor grayColor6] font:kBoldFont(18)];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deviceButton];
    
    NSString *name = status ? @"nav_add_white" : @"nav_add";
    UIButton *addButton = [UIButton buttonWithImageName:name];
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(24), kHeight(24)));
    }];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

/// 空数据界面
- (void)prepareEmptyView {
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _emptyView = [SVEmptyView viewWithText:SVLocalized(@"home_device_connected") imageName:@"home_no_device"];

    [self.view addSubview:_emptyView];
    [_emptyView addSubview:reloadButton];

    [reloadButton addTarget:self action:@selector(reloadDevices) forControlEvents:UIControlEventTouchUpInside];
    
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(_emptyView.bounds.size);
    }];
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_emptyView);
    }];
}

// MARK: - lazy
- (SVDeviceViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVDeviceViewModel alloc] init];
    }
    return _viewModel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}

@end
