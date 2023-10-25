//
//  SVPetViewController.m
//  Immers
//
//  Created by ssv on 2022/11/9.
//

#import "SVPetViewController.h"

#import "SVGlobalMacro.h"
#import "SVPetInfoViewController.h"
#import "SVAddDeviceViewController.h"

#import "SVPetViewModel.h"
#import "SVDeviceViewModel.h"

#import "SVPetCell.h"
#import "SVDropDownMenu.h"
@interface SVPetViewController ()
@property (nonatomic,strong)SVPetViewModel *viewModel;
@property (nonatomic,strong)SVDeviceViewModel *deviceViewModel;
@property (nonatomic,strong)SVDevice *selectDevice;
@property (nonatomic,strong)SVDropDownMenu *dropMenu;
@property (nonatomic,strong)UIView *menuBGView;
@end

@implementation SVPetViewController
{
    SVEmptyView *_emptyView; // 空数据
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_dropMenu closeMenu];
    [self loadDevices];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSubviews];
    [self prepareEmptyView];
    [self prepareNotification];
    [self requestMessage];
    
}

// MARK: -Action
- (void)selectDevice:(NSInteger )index {
    SVDevice *device = self.deviceViewModel.devices[index];
    [self deviceOnline:device.deviceId];
    if (!device.onlineStatus) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_offline_device")];
        return;
    }
    self.selectDevice = self.deviceViewModel.devices[index];
    self.viewModel.deviceId = self.selectDevice.deviceId;
    [self loadDeviceAndPets];
}

- (void)sortDeviceArr:(BOOL )resetSelectDevice {
    NSMutableArray <SVDevice *> *devices = self.deviceViewModel.devices;
    NSMutableArray *online = @[].mutableCopy;
    NSMutableArray *offline = @[].mutableCopy;
    BOOL deviceExit = NO;
    for (SVDevice *device in devices) {
        if (device.onlineStatus) {
            if (!self.selectDevice) {
                deviceExit = YES;
                self.selectDevice = device;
            }else if ([self.selectDevice.deviceId isEqualToString:device.deviceId]){
                deviceExit = YES;
                device.versionNum = self.selectDevice.versionNum;
                self.selectDevice = device;
            }
            [online addObject:device];
        }else{
            [offline addObject:device];
        }
    }
    self.deviceViewModel.devices = devices = [online arrayByAddingObjectsFromArray:offline].mutableCopy;
    if (!deviceExit&&resetSelectDevice) {
        self.selectDevice = devices.count>0?devices[0]:nil;
    }
}

- (void)closeMenu {
    _menuBGView.hidden = YES;
    [_dropMenu closeMenu];
}

// MARK: -Request
- (void)loadDevices {
    kWself
    [SVProgressHUD show];
    [self.deviceViewModel devicesCompletion:^(BOOL isSuccess, NSString * _Nullable message) {
        kSself
        if (isSuccess) {
            [sself sortDeviceArr:YES];
            sself.viewModel.deviceId = sself.selectDevice.deviceId;
            [sself loadDeviceAndPets];
            sself.dropMenu.hidden = NO;
            sself.dropMenu.datas = sself.deviceViewModel.devices;

        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)loadDeviceAndPets {
    [[SVMQTTManager sharedManager] subscribeDeviceId:_selectDevice.deviceId];
    [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventGetDeviceInfo) , kFromId : _selectDevice.deviceId?:@""} handler:nil];
    [self loadAllPets];

}

//从相框拿资源组任务列表以及后台拿宠物数据
- (void)loadAllPets {
    [self.viewModel petsTaskList:^(BOOL isSuccess, NSString * _Nullable message) {
        
    }];
    kWself
    [self.viewModel allPets:^(BOOL isSuccess, NSString * _Nullable message) {
        [SVProgressHUD dismiss];
        if(isSuccess){
            [wself.collectionView reloadData];
        }else{
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)deviceOnline:(NSString *)deviceId {
    kWself
    [_deviceViewModel deviceOnline:@{@"framePhotoId":deviceId?:@""} completion:^(BOOL isSuccess, NSString * _Nullable message, id  _Nullable result) {
        kSself
        if (isSuccess) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId LIKE %@",deviceId];
           NSArray *arr =  [sself.deviceViewModel.devices filteredArrayUsingPredicate:predicate];
            SVDevice *device = arr.count>0?arr[0]:nil;
            if (device) {
                device.onlineStatus = ((NSNumber *)result).intValue;
                [sself sortDeviceArr:NO];
                sself.dropMenu.datas = sself.deviceViewModel.devices;
            }
        }
    }];
}

- (void)requestMessage {
    kWself;
    [self.viewModel requestMessage:^(BOOL isSuccess, NSString * _Nullable message, id  _Nonnull result) {
        NSNumber *cmd = result[kCmd];
        if (cmd.intValue == SVMQTTCmdEventGetResourceGroupTaskList) {
            [wself.collectionView reloadData];
        }else if (cmd.intValue == SVMQTTCmdEventResourceGroupProgress){
            NSNumber *index = result[@"index"];
            [wself.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.integerValue inSection:0]]];
        }else if (cmd.intValue == SVMQTTCmdEventDeviceInfo){
            NSString *deviceId = result[kFromId];
            if ([deviceId isEqualToString:wself.selectDevice.deviceId]) {
                NSString *versionNum = result[@"versionNum"];
                wself.selectDevice.versionNum = versionNum;
            }
        }
    }];
}

// 领养宠物
- (void)downloadPet:(NSString *)petId {
    kWself
    [SVProgressHUD show];
    [self.viewModel downloadPet:@{@"framePhotoId":_selectDevice.deviceId?:@"",@"petId":petId?:@""} completion:^(BOOL isSuccess, NSString * _Nullable message) {
        if(isSuccess){
            [wself loadDeviceAndPets];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// 取消宠物领养(弃养)
- (void)abandonPet:(SVPetModel *)petModel {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:[NSString stringWithFormat:SVLocalized(@"pet_cancel_adopt"),petModel.petName?:@""] message:nil cancelText:SVLocalized(@"login_yes") confirmText:SVLocalized(@"pet_think_again")];
    [self alertViewSetting:viewController];
    viewController.showClose = YES;
    viewController.messageAlignment = NSTextAlignmentCenter;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{
        [wself abandonPetAction:petModel.petId];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)abandonPetAction:(NSString *)petId {
    [SVProgressHUD show];
    kWself
    [self.viewModel abandonPet:@{@"framePhotoId":_selectDevice.deviceId?:@"",@"petId":petId?:@""} completion:^(BOOL isSuccess, NSString * _Nullable message) {
        if(isSuccess){
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_succeed")];
            [wself loadAllPets];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// 重新领养宠物
- (void)reloadPet:(SVPetModel *)petModel {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:[NSString stringWithFormat:SVLocalized(@"pet_reAdopt"),petModel.petName?:@""] message:nil cancelText:SVLocalized(@"pet_think_again") confirmText:SVLocalized(@"login_yes")];
    [self alertViewSetting:viewController];
    viewController.showClose = YES;
    viewController.messageAlignment = NSTextAlignmentCenter;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:nil confirmAction:^{
        [wself reloadPetAction:petModel.petId];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)reloadPetAction:(NSString *)petId {
    [SVProgressHUD show];
    kWself
    [self.viewModel reDownloadPet:@{@"framePhotoId":_selectDevice.deviceId?:@"",@"petId":petId?:@""} completion:^(BOOL isSuccess, NSString * _Nullable message) {
        if(isSuccess){
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_succeed")];
            [wself loadAllPets];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)toAddDevice {
    SVAddDeviceViewController *vc = [[SVAddDeviceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//弹框设置
- (void)alertViewSetting:(SVAlertViewController *)viewController {
    viewController.showClose = YES;
    viewController.messageAlignment = NSTextAlignmentLeft;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.buttonSize = CGSizeMake(kWidth(80), kHeight(30));
    viewController.textMinTopMargin = kHeight(40);
    viewController.messageTextColor = [UIColor grayColor7];
    viewController.messageTextFont = kSystemFont(16);
    viewController.buttonMinTopMargin = kHeight(52);
    
}
// MARK: Notification
- (void)prepareNotification {
    //设备变动，绑定或者解绑
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDevices) name:kReloadBindDevicesNotification object:nil];
}


// MARK: -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    _emptyView.hidden = self.viewModel.pets.count>0;
    return self.viewModel.pets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVPetModel *model = self.viewModel.pets[indexPath.row];
    SVPetCell *petCell = [SVPetCell cellWithCollectionView:collectionView indexPath:indexPath];
    //相框资源组任务列表该宠物有任务进度
    if ([self.viewModel.petProgress objectForKey:[_selectDevice.deviceId stringByAppendingString:model.petId]]) {
        petCell.percent = ((NSNumber *)[self.viewModel.petProgress objectForKey:[_selectDevice.deviceId stringByAppendingString:model.petId]]).integerValue;
    }else if(self.viewModel.hadLoadProgress){
        //资源组任务列表获取没有该宠物下载任务
        petCell.percent = -1;
    }else {
        //相框资源组任务列表还未获取到数据
        petCell.percent = 0;
    }
    if (petCell.percent>=100&&model.isAdopt.intValue == 2) {
        //相框下载进度为100%，服务端更新没那么快。手动更换成已领养
        model.isAdopt = @"1";
    }
    petCell.petModel = model;
    kWself
    petCell.clickAction = ^(NSInteger type) {
        kSself
        if(![SVUserAccount sharedAccount].device){
            [sself toAddDevice];
            return;
        }
        [sself deviceOnline:sself->_selectDevice.deviceId];
        if (!sself->_selectDevice.onlineStatus) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_offline_device")];
            return;
        }
        switch (type) {
            case 0:
            {
                [wself downloadPet:model.petId];
            }
                break;
            case 1:
            {
                [wself abandonPet:model];
            }
                break;
            case 2:
            {
                [wself reloadPet:model];
            }
                break;
            default:
                break;
        }
    };

    return petCell;
}

// MARK: -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(![SVUserAccount sharedAccount].device){
        return;
    }
    SVPetModel *model = self.viewModel.pets[indexPath.row];
    NSInteger percent = ((NSNumber *)[self.viewModel.petProgress objectForKey:[_selectDevice.deviceId stringByAppendingString:model.petId]]).integerValue;
    if (model.isAdopt.integerValue==1||percent>=100){
        if (!_selectDevice.onlineStatus) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_offline_device")];
            return;
        }
        SVPetInfoViewController *vc = [[SVPetInfoViewController alloc] init];
        vc.petModel = model;
        vc.deviceId = _selectDevice.deviceId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: -UIView
- (void)prepareSubviews {
    [self prepareCollectionViewForRegisterClass:SVPetCell.class layout:[[SVPetFrameLayout alloc] init]];
    kWself;
    _dropMenu = [[SVDropDownMenu alloc] initWithFrame:CGRectMake(kWidth(24), kHeight(54), kWidth(140), kWidth(36))];
    _dropMenu.rowHeight = kWidth(36);
    _dropMenu.autoCloseWhenSelected = YES;
    _dropMenu.textColor = UIColor.grassColor;
    _dropMenu.indicatorColor = UIColor.grayColor3;
    _dropMenu.cellClickedBlock = ^(NSString * _Nonnull title, NSInteger index) {
        [wself selectDevice:index];
    };
    _dropMenu.openMenuBlock = ^(BOOL isOpen) {
        wself.menuBGView.hidden = !isOpen;
    };
    _dropMenu.noDeviceBlock = ^{
        [wself toAddDevice];
    };
    [self.view addSubview:self.menuBGView];
    [self.view addSubview:_dropMenu];
}

/// 空数据界面
- (void)prepareEmptyView {
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _emptyView = [SVEmptyView viewWithText:SVLocalized(@"home_device_connected") imageName:@"home_no_device"];
    [self.view addSubview:_emptyView];
    [_emptyView addSubview:reloadButton];

    [reloadButton addTarget:self action:@selector(loadDevices) forControlEvents:UIControlEventTouchUpInside];
    
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(_emptyView.bounds.size);
    }];
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_emptyView);
    }];
}

// MARK: -Lazy
- (SVPetViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[SVPetViewModel alloc] init];
    }
    return _viewModel;
}

- (SVDeviceViewModel *)deviceViewModel {
    if (!_deviceViewModel) {
        _deviceViewModel = [[SVDeviceViewModel alloc] init];
    }
    return _deviceViewModel;
}

- (UIView *)menuBGView {
    if (!_menuBGView) {
        _menuBGView = [[UIView alloc] initWithFrame:self.view.bounds];
        _menuBGView.backgroundColor = UIColor.clearColor;
        _menuBGView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
        [_menuBGView addGestureRecognizer:tap];
    }
    return _menuBGView;
}
@end
