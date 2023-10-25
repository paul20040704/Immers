//
//  SVPetInfoViewController.m
//  Immers
//
//  Created by ssv on 2022/11/10.
//

#import "SVPetInfoViewController.h"
#import "SVPetViewModel.h"
#import "SVDeviceViewModel.h"
#import "SVPetActionCell.h"
@interface SVPetInfoViewController ()
@property (nonatomic,strong)SVPetViewModel *viewModel;
@property (nonatomic,strong)SVDeviceViewModel *deviceViewModel;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,assign)BOOL actionEnable;
@property (nonatomic,assign)BOOL online;
@end

@implementation SVPetInfoViewController

- (void)viewWillDisappear:(BOOL)animated {
    [self stopPlayAction];
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _actionEnable = YES;
    _online = YES;
    [self prepareSubviews];
    [self prepareItems];
    [self prepareNotification];
    [self getPetInfo];
    [self receiveMessage];
}

// MARK: -Action


// MARK: -Request
//进入宠物详情，播放默认动作并传输文件大小给相框做校验
- (void)startPlayPetAction {

    NSDictionary *dict = @{kCmd:@(SVMQTTCmdEventStartPlayResource),kFromId:_deviceId?:@"",kExt:@{@"resGroupId":self.viewModel.petInfo.petId?:@"",@"resId":self.viewModel.petInfo.awaitId?:@"",@"playMode":@(4),@"playCompletionResId":self.viewModel.petInfo.awaitId?:@"",@"sizeInfo":self.viewModel.actionSizes}};
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError * _Nonnull error) {
            
    }];
}

//播放宠物动作
- (void)playPetAction:(SVPetActionModel *)action {
    if (action.petActionId.length==0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_failed")];
        return;
    }
    NSDictionary *dict = @{kCmd : @(SVMQTTCmdEventPlayResource), kFromId:_deviceId?:@"", kExt:@{@"resGroupId":self.viewModel.petInfo.petId?:@"",@"resId":action.petActionId?:@"",@"fileSize":action.petActionSize?:@(0)}};
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {
        if (error) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_failed")];
        }
    }];
}

- (void)stopPlayAction {
    NSDictionary *dict = @{kCmd : @(SVMQTTCmdEventStopPlayResource), kFromId:_deviceId?:@"", kExt:@{@"quitType":@(2)}};
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {

    }];
}

- (void)getPetInfo {
    if (!_deviceId||_deviceId.length==0||!_petModel.petId||_petModel.petId.length==0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_request_failed")];
        return;
    }
    kWself
    [SVProgressHUD show];
    [self.viewModel petInfo:@{@"framePhotoId":_deviceId?:@"",@"petId":_petModel.petId?:@""} completion:^(BOOL isSuccess, NSString * _Nullable message) {
        [SVProgressHUD dismiss];
        if (isSuccess){
            [wself startPlayPetAction];
            [wself.bgImageView setImageWithURL:wself.viewModel.petInfo.backgroundImage placeholder:[UIImage imageNamed:@"pet_info_backGround"]];
            [wself.collectionView reloadData];
        }else{
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)abandonPet {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"pet_abandon_confirm") message:nil cancelText:SVLocalized(@"login_yes") confirmText:SVLocalized(@"home_cancel")];
    viewController.showClose = YES;
    viewController.messageAlignment = NSTextAlignmentCenter;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{
        [wself abandonPetAction];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)abandonPetAction {
    [SVProgressHUD show];
    kWself
    [self.viewModel abandonPet:@{@"framePhotoId":_deviceId?:@"",@"petId":_petModel.petId?:@""} completion:^(BOOL isSuccess, NSString * _Nullable message) {
        [SVProgressHUD dismiss];
        if(isSuccess){
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_succeed")];
            [wself.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)deviceOnline {
    
    kWself
    [self.deviceViewModel deviceOnline:@{@"framePhotoId":_deviceId?:@""} completion:^(BOOL isSuccess, NSString * _Nullable message, id  _Nullable result) {
        kSself
        if (isSuccess) {
        sself.online = ((NSNumber *)result).intValue;
            if (!sself.online) {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_offline_device")];
            }
        }
    }];
}

- (void)receiveMessage {
    kWself
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary *message) {
        NSInteger cmd = [message[kCmd] integerValue];
        NSString *fromId = message[kFromId];
        if (![fromId isEqualToString:wself.deviceId]) {
            return;
        }
        if (cmd == SVMQTTCmdEventPlayResourceResult||cmd == SVMQTTCmdEventStartPlayResourceResult) {
            NSNumber *ext = message[kExt];
            NSString *text;
            switch (ext.intValue) {
                case 1:
                    break;
                case 2:{
                    //资源已损坏，自动弃养
                    text = SVLocalized(@"tip_resource_corrupted");
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showInfoWithStatus:text];
                    [wself abandonPetAction];
                    break;
                }
                case 6:{
                    text = SVLocalized(@"tip_operate_frequently");
                }
                default:
                    text = SVLocalized(@"tip_operation_failed");
                    break;
            }
            if (text&&cmd == SVMQTTCmdEventPlayResourceResult) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:text];
            }
        }
    }];
}
// MARK: Notification
- (void)prepareNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unbindeDevice:) name:kReloadBindDevicesNotification object:nil];
}

- (void)unbindeDevice:(NSNotification *)sender {
    NSString *deviceId =  sender.object;
    if ([deviceId isEqualToString:_deviceId]) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_device_unbind")];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// MARK: -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _viewModel.petInfo.petInfoVos.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVPetActionCell *cell = [SVPetActionCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.action = _viewModel.petInfo.petInfoVos[indexPath.row];
    return cell;
}
// MARK: -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 设备是否已离线
    if (!_online) {
        [self deviceOnline];
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_offline_device")];
        return;
    }
    // 降低点击频率 需求3s点一次
    if (_actionEnable) {
        [self deviceOnline];
        _actionEnable = NO;
        [self performSelector:@selector(setActionEnable)
          withObject:nil afterDelay:3.0f];
        SVPetActionModel *action = self.viewModel.petInfo.petInfoVos[indexPath.row];
        [self playPetAction:action];
    }else{
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, kHeight(-200))];
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operate_frequently")];
        //提示位置复原
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD resetOffsetFromCenter];
        });
        
    }
}

- (void)setActionEnable{
    _actionEnable = YES;

}

// MARK: -UIView
- (void)prepareSubviews {

    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageView.image = [UIImage imageNamed:@"pet_info_backGround"];
    [self addSubview:_bgImageView];
    [self prepareCollectionViewForRegisterClass:SVPetActionCell.class layout:[[SVPetActionFrameLayout alloc] init]];
    self.collectionView.contentInset = UIEdgeInsetsMake(kNavBarHeight+kHeight(326), 0, kTabBarHeight, 0);
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.bounces = NO;
    
}

- (void)prepareItems {
    self.title = _petModel.petName;
    self.translucent = YES;
    UIButton *abdonButton = [UIButton buttonWithTitle:SVLocalized(@"pet_abandon") titleColor:UIColor.grayColor8 font:kSystemFont(16)];
    [abdonButton addTarget:self action:@selector(abandonPet) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:abdonButton];

}
// MARK: -Lazy
-(SVPetViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[SVPetViewModel alloc] init];
        _viewModel.deviceId = _deviceId;
    }
    return _viewModel;
}
- (SVDeviceViewModel *)deviceViewModel {
    if (!_deviceViewModel) {
        _deviceViewModel = [[SVDeviceViewModel alloc] init];
        _deviceViewModel.deviceId = _deviceId;
    }
    return _deviceViewModel;;
}
- (void)dealloc {
    [SVProgressHUD resetOffsetFromCenter];
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}
@end
