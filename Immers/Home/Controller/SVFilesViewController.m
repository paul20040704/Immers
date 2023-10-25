//
//  SVFilesViewController.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVFilesViewController.h"
#import "SVFieldViewController.h"
#import "SVAlertViewController.h"
#import "SVAlbumViewController.h"
#import "SVFilesViewCell.h"
#import "SVDeviceViewModel.h"

@interface SVFilesViewController ()

@property (nonatomic, strong) SVDeviceViewModel *viewModel;

@end

@implementation SVFilesViewController {
    SVFilesType _type; // 上传类型
    NSString *_deviceId; // 设备id
    NSData *_fileData; // 上传数据
    UIButton *_deleteButton; // 删除按钮
    NSString *_galleryId; // 选中图集id
    BOOL _upload; // 是否是
}

/// 文件管理
+ (instancetype)viewControllerWithType:(SVFilesType)type deviceId:(NSString *)deviceId data:(NSData *)data {
    SVFilesViewController *viewController = [[SVFilesViewController alloc] init];
    viewController->_type = type;
    viewController->_deviceId = deviceId;
    viewController->_fileData = data;
    viewController->_upload = (nil != data && [data isKindOfClass:[NSData class]]);
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSubviews];
    [self prepareItems];
    [self deviceGalleries];
}

// MARK: - Action
/// 删除图集
- (void)removeAsset:(NSString *)aid {
    kWself
    NSString *message = _type == SVFilesTypeImage ? SVLocalized(@"home_delete_album") : SVLocalized(@"home_delete_video");
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:message message:nil cancelText:SVLocalized(@"home_cancel") confirmText:SVLocalized(@"home_confirm")];
    viewController.showClose = YES;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:nil confirmAction:^{
        [wself removeGallery:aid];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 删除事件
- (void)deleteClick {
    _deleteButton.selected = !_deleteButton.selected;
    for (SVAsset *asset in self.viewModel.assets) {
        asset.show = _deleteButton.selected;
    }
    
    [self.collectionView reloadData];
}

/// 选择文件
- (void)addClick {
    if (_deleteButton.selected) {
        [self deleteClick];
    }
    kWself
    SVFieldViewController *viewController = [SVFieldViewController fieldControllerWithTitle:SVLocalized(@"home_input_name_album") placeholder:SVLocalized(@"login_please_enter") cancelText:nil confirmText:SVLocalized(@"home_confirm")];
    viewController.showClose = YES;
    viewController.confirmBackgroundColor = [UIColor grassColor3];
    [viewController handler:nil confirmAction:^(NSString *text) {
        [wself addGallery:text];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 操作图集提示
- (void)actionAlert:(SVAsset *)asset {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_select_album_proceed") message:nil cancelText:SVLocalized(@"home_playback") confirmText:SVLocalized(@"home_management")];
    viewController.showClose = YES;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{  // 播放事件
        [wself playGallery:asset];
        [wself cancelSelected];
    } confirmAction:^{  // 管理事件
        [wself managerGallery:asset];
        [wself cancelSelected];
    } closeAction:^{  // 关闭弹窗事件
        [wself cancelSelected];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 上传提示
- (void)uploadAlert {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController weakWithTitle:SVLocalized(@"home_upload_album") message:nil cancelText:SVLocalized(@"home_cancel") confirmText:SVLocalized(@"home_confirm")];
    viewController.showClose = YES;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{  // 取消事件
        [wself cancelSelected];
    } confirmAction:^{   // 确认事件
        [wself uploadFile]; // 上传文件请求
        [wself cancelSelected];
    } closeAction:^{  // 关闭弹窗事件
        [wself cancelSelected];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 播放该图集
- (void)playGallery:(SVAsset *)asset {
    if (self.playGalleryCallback) {
        self.playGalleryCallback(asset.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/// 管理该图集
- (void)managerGallery:(SVAsset *)asset {
    SVAlbumViewController *viewController = [[SVAlbumViewController alloc] init];
    viewController.asset = asset;
    viewController.deviceId = _deviceId;
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 取消图集 选择状态
- (void)cancelSelected {
    NSMutableArray<SVAsset *> *assets = self.viewModel.assets;
    for (SVAsset *a in assets) {
        a.selected = NO;
    }
    [self.collectionView reloadData];
}

// MARK: - Request
- (void)deviceGalleries {
    if (nil == _deviceId) { return; }
    NSDictionary *dict = @{ @"framePhotoId" : _deviceId, @"type" : @"0", @"pageSize" : @"10000", @"startPage" : @"1" };
    [self.viewModel galleries:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self.collectionView reloadData];
            self->_deleteButton.hidden = 0 == self.viewModel.assets.count;
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)addGallery:(NSString *)name {
    if (nil == _deviceId) { return; }
    kWself
    NSDictionary *dict = @{ @"framePhotoId" : _deviceId, @"type" : @"0", @"name" : name };
    [self.viewModel addGallery:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [wself.collectionView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)removeGallery:(NSString *)aid {
    NSDictionary *dict = @{ @"id" : aid };
    [self.viewModel removeGallery:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            NSMutableArray<SVAsset *> *assets = self.viewModel.assets;
            for (SVAsset *a in assets) {
                if ([a.aid isEqualToString:aid]) {
                    [assets removeObject:a];
                    break;
                }
            }
            
            [self.collectionView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)uploadFile {
    if (nil == _galleryId) { return; }
    NSDictionary *dict = @{ @"galleryId" : _galleryId, @"framePhotoId" : _deviceId, @"fileType" : @"1" };
    [self.viewModel uploadImage:_fileData parameters:dict progress:^(double uploadProgress) {
        [SVProgressHUD showProgress:uploadProgress status:SVLocalized(@"tip_uploading")];
    } completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD showInfoWithStatus:message];
    }];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVFilesViewCell *filesCell = [SVFilesViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    filesCell.asset = self.viewModel.assets[indexPath.item];
    kWself
    filesCell.removeCallback = ^(NSString *aid) {
        [wself removeAsset:aid];
    };
    return filesCell;
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (nil == _deviceId || _deleteButton.selected) { return; }
    SVAsset *asset = self.viewModel.assets[indexPath.item];
    if (_upload) { // 上传文件
        _galleryId = asset.aid; // 记录图集id
        [self uploadAlert]; // 提示
        
    } else { // 管理文件
        [self actionAlert:asset];
    }
    
    asset.selected = YES; // 设置状态
    [collectionView reloadItemsAtIndexPaths:@[indexPath]]; // 刷新
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"home_no_photo_added") imageName:@"home_no_data"];
}

/// 子视图
- (void)prepareSubviews {
    self.title = _type == SVFilesTypeImage ? SVLocalized(@"home_album_management") : SVLocalized(@"home_video_management");
    [self prepareCollectionViewForRegisterClass:[SVFilesViewCell class] layout:[[SVFilesLayout alloc] init]];
    
    if (!_upload) {
        // 删除按钮
        _deleteButton = [UIButton buttonWithNormalName:@"home_file_delete" selectedName:@"home_file_close"];
        _deleteButton.layer.shadowColor = [UIColor colorWithHex:0x000000 alpha:0.36].CGColor;
        _deleteButton.layer.shadowOffset = CGSizeMake(0, 4);
        _deleteButton.layer.shadowOpacity = 1;
        _deleteButton.layer.shadowRadius = kHeight(10);
        _deleteButton.hidden = YES;
        
        // 添加子控件
        [self.view addSubview:_deleteButton];
        
        // 事件
        [_deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 约束
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(24));
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(kHeight(-62));
            make.size.mas_equalTo(CGSizeMake(kWidth(55), kWidth(55)));
        }];
    }
}

- (void)prepareItems {
    UIButton *addButton = [UIButton buttonWithImageName:@"nav_add"];
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

// MARK: - lazy
- (SVDeviceViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVDeviceViewModel alloc] init];
    }
    return _viewModel;
}

@end
