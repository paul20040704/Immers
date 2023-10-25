//
//  SVAlbumViewController.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVAlbumViewController.h"
#import "SVAlertViewController.h"
#import "SVSheetViewController.h"
#import "SVPickerViewController.h"
#import "SVSelectFrameViewController.h"
#import "SVUploadingViewController.h"
#import "SVFileManagerController.h"
#import "SVAlbumViewCell.h"
#import "SVDeviceViewModel.h"
#import "SVInterfaces.h"
@interface SVAlbumViewController ()
@property (nonatomic, strong) SVDeviceViewModel *viewModel; // 视图模型
@property (nonatomic, strong) NSMutableArray <SVPhoto *> *selectedFiles; // 选中文件
@end

@implementation SVAlbumViewController {
    UIButton *_deleteButton; // 删除按钮
    BOOL _show; // 是否可选中
    SVTimer *_timer;
    NSInteger _current;
    NSInteger _page;
    SVInterfaces *_interfaces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _interfaces = [SVInterfaces interfaces];
    [self prepareSubviews];
    [self prepareTitle:0];
    [self prepareItems:nil];
    [self receiveMessage];
    [self.collectionView.mj_header beginRefreshing];
    
    if (self.image) { // 有图片数据
        [self uploadFile:self.image];
    }
}

// MARK: - Action
/// 加添 / 删除
- (void)buttonClick {
    if (_show) { // 可以选中及删除事件
        if (self.selectedFiles.count <= 0) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_artworks_deleted")];
            return;
        }
        kWself
        SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:nil message:SVLocalized(@"home_selected_artworks") cancelText:SVLocalized(@"login_yes") confirmText:SVLocalized(@"home_cancel")];
        viewController.showClose = YES;
        viewController.messageAlignment = NSTextAlignmentLeft;
        viewController.titleTextColor = [UIColor whiteColor];
        viewController.buttonSize = CGSizeMake(kWidth(80), kHeight(30));
        viewController.textMinTopMargin = kHeight(40);
        viewController.messageTextColor = [UIColor grayColor7];
        viewController.messageTextFont = kSystemFont(16);
        viewController.buttonMinTopMargin = kHeight(52);
        [viewController handler:^{
            [wself removeFiles];
        } confirmAction:nil];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        [self showSheet];
    }
}

/// 本地/拍照
- (void)showSheet {
    kWself
    SVSheetItem *item0 = [SVSheetItem item:@"home_local" text:SVLocalized(@"home_local_files") callback:^{
        [SVAuthorization cameraAuthorization:^{
            [wself prepareImage:UIImagePickerControllerSourceTypePhotoLibrary];
        } denied:^{
            [wself denied:SVLocalized(@"home_album_not_authorized")];
        }];
    }];
    SVSheetItem *item1 = [SVSheetItem item:@"home_take" text:SVLocalized(@"home_camera") callback:^{
        [SVAuthorization cameraAuthorization:^{
            [wself prepareImage:UIImagePickerControllerSourceTypeCamera];
        } denied:^{
            [wself denied:SVLocalized(@"home_camera_not_authorized")];
        }];
    }];
    SVSheetItem *item2 = [SVSheetItem item:@"home_file_transfer" text:SVLocalized(@"home_video") callback:^{
        __strong typeof(self) sself= wself;
        NSString *ssid = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceSSIDKey];
        if (![[sself->_interfaces ssid] isEqualToString:ssid]) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_not_the_same_LAN")];
            return;
        }
        
        [SVAuthorization cameraAuthorization:^{
//            [wself prepareImage:UIImagePickerControllerSourceTypePhotoLibrary];
            [wself transferFile];
        } denied:^{
            [wself denied:SVLocalized(@"home_camera_not_authorized")];
        }];
    }];
    SVSheetViewController *viewController = [SVSheetViewController sheetController:@[item0, item1,item2]];
    [self presentViewController:viewController animated:YES completion:nil];
}
/// 文件传输
- (void)transferFile {
    kWself
    SVPickerViewController *viewController = [SVPickerViewController pickerViewControllerWithTransferCompletion:^(NSInteger type,NSString *url) {
        [wself selectFileToUpload:@{@"type":@(type),@"url":url}];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)selectFileToUpload:(id )object {
    if ([object isKindOfClass:[UIImage class]]) {
        SVSelectFrameViewController *viewController = [[SVSelectFrameViewController alloc] init];
        viewController.image = object;
        viewController.eventType = SVButtonEventUpload;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        SVDeviceInfo *deviceInfo = [SVUserAccount sharedAccount].deviceInfo;
        if (deviceInfo.updateFilePath&&!deviceInfo.updateFilePath.isOpen) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_not_the_same_LAN")];
            return;
        }
        NSDictionary *dict = object;;
        NSString *path = dict[@"url"];
        NSNumber *type = dict[@"type"];
        long long size = [NSData fileSizeAtPath:[path stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        if (size>deviceInfo.surplusCapacity) {
            [self showDeviceMemoryWaring];
            return;
        }
        SVUploadingViewController *viewController = [SVUploadingViewController uploadingViewController];
        viewController.filePath = path;
        viewController.info = deviceInfo.ftpServiceInfo;
        viewController.httpInfo = deviceInfo.updateFilePath;
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

- (void)fileClick{
    SVDeviceInfo *deviceInfo = [SVUserAccount sharedAccount].deviceInfo;
    SVFileManagerController *viewController = [[SVFileManagerController alloc] init];
    SVDevice *device = [SVUserAccount sharedAccount].device;
    device.surplusCapacity = deviceInfo.surplusCapacity;
    device.totalCapacity = deviceInfo.totalCapacity;
    device.versionNum = deviceInfo.versionNum;
    
    viewController.device = device;
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 选择 图片/拍照
- (void)prepareImage:(UIImagePickerControllerSourceType)sourceType {
    kWself
    SVPickerViewController *viewController = [SVPickerViewController pickerViewControllerWithSourceType:sourceType completion:^(UIImage *image) {
        [wself uploadFile:image];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
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

/// 删除
- (void)deleteClick {
    _deleteButton.selected = !_deleteButton.selected;
    if (_deleteButton.selected) {
        [self prepareItems:SVLocalized(@"home_delete")];
        [self reloadFiles:YES];

    } else {
        [self resetFiles];
    }
}

- (void)resetFiles {
    [self prepareItems:nil];
    [self reloadFiles:NO];
    [self.selectedFiles removeAllObjects];
    [self prepareTitle:0];
    _deleteButton.selected = NO;
}

/// 刷新文件
- (void)reloadFiles:(BOOL)show {
    for (SVPhoto *photo in self.viewModel.photos) {
        photo.show = show;
        photo.selected = NO;
    }
    [self.collectionView reloadData];
    _show = show;
}

/// 删除文件
- (void)removeAllFiles {
    NSMutableArray <SVPhoto *> *photos = [NSMutableArray arrayWithCapacity:1];
    for (SVPhoto *photo in self.viewModel.photos) {
        if (nil == photo.pid) { continue; }
        [photos addObject:photo];
    }
    [self.viewModel.photos removeObjectsInArray:photos];
}

/// 手势事件
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer {
    // 判断手势状态
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            // 判断手势落点位置是否在路径上(长按cell时,显示对应cell的位置,如path = 1 - 0,即表示长按的是第1组第0个cell). 点击除了cell的其他地方皆显示为null
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
            // 如果点击的位置不是cell,break
            if (nil == indexPath) { break; }
            // 在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            // 移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[gestureRecognizer locationInView:self.collectionView]];
            break;
            
        case UIGestureRecognizerStateEnded:
            // 移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            [self updateSotr];
            break;
            
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

// MARK: - Request
/// 加载图集
- (void)loadAlbum {
    [self resetFiles];
    if (nil == self.deviceId) { return; }
    NSDictionary *dict = @{ @"framePhotoId" : self.deviceId, @"pageSize" : @"18", @"startPage" : @(_page) };
    kWself
    [self.viewModel framePhoto:dict completion:^(BOOL isSuccess, NSString *message) {
        kSself
        if(!sself) return;
        [sself.collectionView.mj_header endRefreshing];
        [sself.collectionView.mj_footer endRefreshing];
        if (isSuccess) {
            [sself.collectionView reloadData];
            
            if ([message integerValue] <= sself->_page) {
                [wself.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
            sself->_deleteButton.hidden = 0 == sself.viewModel.photos.count;
            
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)receiveMessage {
    kWself
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary *message) {
        kSself
        NSInteger cmd = [message[kCmd] integerValue];
        NSString *fromId = message[kFromId];
        if (![fromId isEqualToString:sself.deviceId]) {
            return;
        }
        if (cmd == SVMQTTCmdEventSyncFile) {
            [sself.collectionView.mj_header beginRefreshing];
            
        } else if (cmd == SVMQTTCmdEventRemoveSuccess) {
            sself->_page = 1;
            [sself.viewModel.photos removeObjectsInArray:sself.selectedFiles];
            [sself deleteClick];
            [sself.collectionView reloadData];
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_delete_succeed")];
            
        } else if (cmd == SVMQTTCmdEventSortSuccess) {
            sself->_page = 1;
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_sorting_succeed")];
        }else if (cmd == SVMQTTCmdEventEnterRes) {
            NSInteger res = ((NSNumber *)message[kExt]).integerValue;
            switch (res) {
                case 1:
                {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_playing")];
                }
                    break;
                case 3:
                {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_play_mode_failed")];
                }
                    break;
                case 6:
                {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operate_frequently")];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }];
}


/// 上传文件
- (void)uploadFile:(UIImage *)image {
    SVPhoto *file = [[SVPhoto alloc] init];
    file.image = image;
    [self.viewModel.photos addObject:file];
    [self.collectionView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.viewModel.photos indexOfObject:file] inSection:0];
    NSString *aid = [SVUserAccount sharedAccount].userId;
    NSDictionary *dict = @{ @"galleryId" : aid, @"framePhotoId" : _deviceId, @"framePhotoIdList" : _deviceId, @"fileType" : @"1" };
    [self.viewModel uploadImage:UIImagePNGRepresentation(image) parameters:dict progress:^(double uploadProgress) {
        file.progress = uploadProgress;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL isSuccess, NSString *message) {
        if (!isSuccess) {
            [self.viewModel.photos removeObject:file];
            [self.collectionView reloadData];
            [SVProgressHUD showInfoWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_uploading_succeed")];
        }
    }];
}

/// 删除文件
- (void)removeFiles {
    NSMutableArray <SVPhoto *> *files = self.selectedFiles;
    NSMutableArray <NSDictionary *> *ids = [NSMutableArray arrayWithCapacity:files.count];
    for (SVPhoto *photo in files) {
        if (nil == photo.localId) { continue; }
        NSDictionary *dict = @{ @"id" : photo.localId };
        [ids addObject:dict];
    }
    
    NSDictionary *dict = @{ kCmd : @(SVMQTTCmdEventRemoveFiles),
                            kExt : @{ kList : ids } ,kFromId : _deviceId};
    
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {
        if (nil == error) {
            [SVProgressHUD showWithStatus:SVLocalized(@"tip_deleting")];
        }
    }];
}

/// 排序
- (void)updateSotr {
    NSMutableArray <SVPhoto *> *files = self.viewModel.photos;
    NSMutableArray <NSDictionary *> *ids = [NSMutableArray arrayWithCapacity:files.count];
    NSInteger index = 0;
    for (SVPhoto *photo in files) {
        if (nil == photo.localId) { continue; }
        NSDictionary *dict = @{ @"id" : photo.localId, @"sort" : @(index) };
        [ids addObject:dict];
        index += 1;
    }
    NSDictionary *dict = @{ kCmd : @(SVMQTTCmdEventFilesSort),
                            kExt : @{ kList : ids } ,kFromId : _deviceId};
    
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {
        if (nil == error) {
            [SVProgressHUD showWithStatus:SVLocalized(@"tip_sorting")];
        }
    }];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVAlbumViewCell *albumCell = [SVAlbumViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    albumCell.photo = self.viewModel.photos[indexPath.item];
    return albumCell;
}

/// 重新处理数据源
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    SVPhoto *file = self.viewModel.photos[sourceIndexPath.item];
    [self.viewModel.photos removeObject:file];
    [self.viewModel.photos insertObject:file atIndex:destinationIndexPath.item];
}

/// 可移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return !_show;
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SVPhoto *file = self.viewModel.photos[indexPath.item];
    if (nil == file.localId || file.localId.length <= 0) { return; }
    if (!_show) {
        NSDictionary *dict = @{ kCmd : @(SVMQTTCmdEventEnter),
                                kExt : @{ @"id" : file.localId } ,kFromId : _deviceId};
        [[SVMQTTManager sharedManager] sendControl:dict handler:nil];
        return;
    }
    
    file.selected = !file.selected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    file.selected ? [self.selectedFiles addObject:file] : [self.selectedFiles removeObject:file];
    [self prepareTitle:self.selectedFiles.count];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"home_no_photo_added") imageName:@"home_no_data"];
}

// MARK: - 控件
/// 子视图
- (void)prepareSubviews {
    [self prepareCollectionViewForRegisterClass:[SVAlbumViewCell class] layout:[[SVAlbumLayout alloc] init]];
    kWself
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kSself
        sself->_page = 1;
        [wself loadAlbum];
    }];
    
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        kSself
        sself->_page += 1;
        [wself loadAlbum];
    }];

    [header setTitle:SVLocalized(@"home_pull_more") forState:MJRefreshStateIdle];
    [header setTitle:SVLocalized(@"home_pelease_more") forState:MJRefreshStatePulling];
    [header setTitle:SVLocalized(@"home_refreshing") forState:MJRefreshStateRefreshing];
    [header modifyLastUpdatedTimeText:^NSString *(NSDate *lastUpdatedTime) {
        return [NSString stringWithFormat:SVLocalized(@"home_last_update"), nil == lastUpdatedTime ? @"" : lastUpdatedTime.timeDescription ];
    }];

    [footer setTitle:SVLocalized(@"home_no_more_data") forState:MJRefreshStateNoMoreData];
    [footer setTitle:SVLocalized(@"home_pull_up") forState:MJRefreshStateIdle];
    [footer setTitle:SVLocalized(@"home_pull_release_more") forState:MJRefreshStatePulling];
    [footer setTitle:SVLocalized(@"home_pull_up_loading") forState:MJRefreshStateRefreshing];
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
    
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

/// 标题
- (void)prepareTitle:(NSUInteger)count {
    self.title = count <= 0 ? SVLocalized(@"home_play_list") : [NSString stringWithFormat:SVLocalized(@"home_selected"), count];
//    self.title = count <= 0 ? self.asset.name : [NSString stringWithFormat:@"已选择%ld个", count];
}

/// 右边 ➕ / 删除
- (void)prepareItems:(NSString *)delete {
    UIButton *button = (delete.length <= 0 || nil == delete) ? [UIButton buttonWithImageName:@"nav_add"] : [UIButton buttonWithTitle:delete titleColor:[UIColor grayColor7] font:kSystemFont(16)];
    [button sizeToFit];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kWidth(24));
    }];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

// MARK: - lazy
- (SVDeviceViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVDeviceViewModel alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray<SVPhoto *> *)selectedFiles {
    if (!_selectedFiles) {
        _selectedFiles = [[NSMutableArray alloc] init];
    }
    return _selectedFiles;
}

// MARK: - dealloc
- (void)dealloc {
    [_timer invalidate];
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}

@end
