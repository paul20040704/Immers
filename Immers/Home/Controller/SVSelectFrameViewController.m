//
//  SVSelectFrameViewController.m
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import "SVSelectFrameViewController.h"
#import "SVUploadingViewController.h"
#import "SVPhotoFrameView.h"
#import "SVPhotoFrameCell.h"
#import "SVDeviceViewModel.h"
#import "SVResourceViewModel.h"
#import "LGScrollCardView.h"
#import "SVFileManagerController.h"
@interface SVSelectFrameViewController ()<LGScrollCardDataSource,LGScrollCardDelegate>
@property (nonatomic, strong) SVDeviceViewModel *viewModel;
@property (nonatomic, strong) SVResourceViewModel *resourceViewModel;

@property (nonatomic, strong) NSMutableSet<NSString *> *ids;

@property (nonatomic, strong) SVUploadingViewController *uploadController;

@end

@implementation SVSelectFrameViewController {
    UIImageView *_previewView; // 预览视图
    LGScrollCardView *_preCardView;//多图卡片重叠视图
    SVPhotoFrameView *_frameView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDevices];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = SVLocalized(@"home_choose_device");
    self.light = YES;
    self.barTintColor = [UIColor blackColor];
    self.titleColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self prepareSubviews];
    [self prepareItem];
    
}

// MARK: - Action
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedDevice:(SVDevice *)device {
    device.selected ? [self.ids addObject:device.deviceId] : [self.ids removeObject:device.deviceId];
    _frameView.selectAll = self.ids.count == self.viewModel.devices.count;
    _frameView.submitAble = self.ids.count>0;
    [self.collectionView reloadData];
}

- (void)photoFrameEvent:(SVButtonEvent)event {
    if (event == SVButtonEventUpload) { // 上传
        if (self.ids.count <= 0) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_choose_one_device")];
            return;
        }
        
        if (nil == self.uploadController) { // 创建进度控制器
            [self prepareUploadController];
        }
        
        NSMutableArray<NSString *> *idArray = [NSMutableArray arrayWithCapacity:self.ids.count];
        for (NSString *did in self.ids) {
            [idArray addObject:did];
        }
        
        NSString *ids = [idArray componentsJoinedByString:@","];
        
        NSString *aid = [SVUserAccount sharedAccount].userId;
        
        NSData *data = [[NSData alloc]init];
        if ([self.fileType isEqual: @"1"]) {
            data = UIImagePNGRepresentation(self.image);
        }else {
            data = [NSData dataWithContentsOfFile:self.videoUrl];
        }
        NSDictionary *dict = @{ @"galleryId" : aid, @"framePhotoId" : ids, @"framePhotoIdList" : ids, @"fileType" : self.fileType };
        [self.viewModel uploadImage:data parameters:dict progress:^(double uploadProgress) {
            self.uploadController.progress = uploadProgress;
            DebugLog(@"上传 progress--> %.2f", uploadProgress);
            
        } completion:^(BOOL isSuccess, NSString *message) {
            if (isSuccess) {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_upload_completes")];
                [self.uploadController dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
                //1.2.0去除转制进度
                //[self converted:message];
                
            } else {
                [self.uploadController dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showInfoWithStatus:message];
            }
        }];
        // 保存到系统相册
        [self saveImage2Album];
        
    } else if (event == SVButtonEventUnselected || event == SVButtonEventSelectAll) { // 反选 / 全选
        
        BOOL selectAll = event == SVButtonEventSelectAll;
        
        for (SVDevice *device in self.viewModel.devices) {
            device.selected = selectAll;
            selectAll ? [self.ids addObject:device.deviceId] : [self.ids removeAllObjects];
        }
        _frameView.selectAll = selectAll;
        _frameView.submitAble = self.ids.count>0;
        [self.collectionView reloadData];
    } else if (event == SVButtonEventDownloadResource) {
        NSMutableArray<NSString *> *idArray = [NSMutableArray arrayWithCapacity:self.ids.count];
        for (NSString *did in self.ids) {
            [idArray addObject:did];
        }
        NSString *ids = [idArray componentsJoinedByString:@","];
        [self.resourceViewModel downloadResource:@{@"framePhotoId":ids} completion:^(BOOL isSuccess, NSString * _Nullable message) {
            if (isSuccess) {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_downloading_resource")];
                [self.uploadController dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [SVProgressHUD showInfoWithStatus:message];
            }
        }];
        
    }
}

/// 保存图片到相册
- (void)saveImage2Album {
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveImageKey];
    if (nil == imageData) {
        return;
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    DebugLog(@"%@, error = %@, contextInfo = %@", nil == error ? @"保存成功" : @"保存失败" , error, contextInfo);
    // 清空数据
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveImageKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
}

//只有一个相框时，默认选中
- (void)defaultSelectDevice {
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    if([self.collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]){
        [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    _frameView.submitAble = self.ids.count>0;
    _frameView.selectAble = self.viewModel.devices.count>0;
    return self.viewModel.devices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVPhotoFrameCell *cell = [SVPhotoFrameCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.device = self.viewModel.devices[indexPath.item];
    kWself
    cell.selectedCallback = ^(SVDevice *device) {
        [wself selectedDevice:device];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SVDevice *device = self.viewModel.devices[indexPath.item];
    long long uploadSize = 0;
    if (_eventType==SVButtonEventDownloadResource&&_selectResources.count>0) {
        for (SVResourceModel *resource in _selectResources) {
            uploadSize +=resource.uploadSize.longLongValue;
        }
    }else if (_eventType==SVButtonEventUpload&&_image){
        uploadSize = kCover3DImageSize;
    }
    
    if(device.surplusCapacity<uploadSize){
        kWself
        SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_local_storage_clean") message:nil cancelText:SVLocalized(@"login_yes") confirmText:SVLocalized(@"home_cancel")];
        viewController.showClose = YES;
        viewController.messageAlignment = NSTextAlignmentCenter;
        viewController.titleTextColor = [UIColor whiteColor];
        viewController.backgroundColor = [UIColor grayColor3];
        [viewController handler:^{
            [wself toFileManager:device];
        } confirmAction:nil];
        [self presentViewController:viewController animated:YES completion:nil];
        return;
    }
    device.selected = !device.selected;
    [self selectedDevice:device];
}

- (void)toFileManager:(SVDevice *)device {
    SVFileManagerController *vc = [[SVFileManagerController alloc] init];
    vc.device = device;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - Request
- (void)converted:(NSString *)token {
    self.uploadController.converting = YES;
    [self.viewModel converted:token completion:^(NSInteger code, NSString *message) {
        if (1 == code) { // 正在转换
            double progress = [message doubleValue];
            if (progress >= 100) { // 转换完成
                self.uploadController.progress = progress / 100.0;
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_convert_completes")];

            } else { // 更新进度
                self.uploadController.progress = progress / 100.0;
                DebugLog(@"转换 progress--> %.2f", self.uploadController.progress);
                [self converted:token];
            }
        } else if (0 == code) { // 在等待转换
             // 延时 请求转换进度
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self converted:token];
            });

        } else { // 销毁进度控制器
            [self.uploadController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)loadDevices {
    MJWeakSelf;
    [self.viewModel devicesCompletion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [weakSelf.collectionView reloadData];
            //只有一个相框时默认选中
            if(weakSelf.viewModel.devices.count==1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新完成
                    // reloadDate会在主队列执行
                    [weakSelf defaultSelectDevice];
                });
            }
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - LGScrollCard
- (NSInteger)overlapCountOfEasyScrollCard:(LGScrollCardView *)card {
    if (self.resourceViewModel.selectResources.count<=2){
        return 1;
    }
    return 2;
}

- (NSArray<NSString *> *)cardListOfEasyScrollCard:(LGScrollCardView *)card {
    NSMutableArray *arr = @[].mutableCopy;
    for (SVResourceModel *model in self.resourceViewModel.selectResources) {
        NSString *imgUrl;
        if (model.coverPicture.length>0) {
            imgUrl = model.coverPicture;
        }else{
            if([model.uploadUrl containsString:@"?"]){
                imgUrl = [NSString stringWithFormat:@"%@&type=%@",model.uploadUrl,model.type];
            }else{
                imgUrl = [NSString stringWithFormat:@"%@?type=%@",model.uploadUrl,model.type];
            }
        }

        [arr addObject:imgUrl];
    }
    return arr;
}

// MARK: - prepare
- (void)prepareUploadController {
    self.uploadController = [SVUploadingViewController uploadingViewController];
    [self presentViewController:self.uploadController animated:NO completion:nil];
}

- (void)prepareSubviews {
    [self prepareCollectionViewForRegisterClass:[SVPhotoFrameCell class] layout:[[SVPhotoFrameLayout alloc] init]];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.backgroundColor = [UIColor clearColor];
    BOOL isUpload = _eventType == SVButtonEventUpload;
    if(_eventType == SVButtonEventUpload){
        _previewView = [UIImageView imageView];
        _previewView.backgroundColor = [UIColor backgroundColor];
        [_previewView corner];
        [self.view addSubview:_previewView];
        [_previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kNavBarHeight + kHeight(10));
            make.size.mas_equalTo(CGSizeMake(kWidth(140), kHeight(187)));
        }];
        _previewView.image = self.image;
    }else if (_eventType == SVButtonEventDownloadResource){
        _preCardView = [[LGScrollCardView alloc]initWithFrame:CGRectMake((self.view.mj_w - kWidth(140))/2, kNavBarHeight + kHeight(10), kWidth(140), kHeight(187))];
        _preCardView.backgroundColor = UIColor.clearColor;
        _preCardView.dataSource = self;
        _preCardView.delegate = self;
        [self.view addSubview:_preCardView];
        [_preCardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kNavBarHeight + kHeight(10));
            make.size.mas_equalTo(CGSizeMake(kWidth(140), kHeight(187)));
        }];
    }

    
    kWself
    _frameView = [[SVPhotoFrameView alloc] init];
    _frameView.eventType = _eventType;
    _frameView.submitAble = NO;
    _frameView.selectAble = NO;
    _frameView.frameEventCallback = ^(SVButtonEvent event) {
        [wself photoFrameEvent:event];
    };
    
    [self.view addSubview:_frameView];
    [self.view insertSubview:self.collectionView aboveSubview:_frameView];
    
    [_frameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(isUpload?_previewView.mas_bottom:_preCardView.mas_bottom).offset(kHeight(10));
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_frameView).offset(kHeight(60));
        make.left.equalTo(self.view).offset(kWidth(24));
        make.right.equalTo(self.view).offset(kWidth(-24));
        make.height.mas_equalTo(kHeight(300));
    }];
    
    [self.view layoutIfNeeded];
    [_frameView corners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kHeight(30)];
}

- (void)prepareItem {
    UIButton *button = [UIButton buttonWithImageName:@"nav_back_white"];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

// MARK: - lazy
- (SVDeviceViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVDeviceViewModel alloc] init];
    }
    return _viewModel;
}

- (SVResourceViewModel *)resourceViewModel {
    if(!_resourceViewModel){
        _resourceViewModel = [[SVResourceViewModel alloc] init];
        _resourceViewModel.selectResources = _selectResources;
    }
    return _resourceViewModel;
}

- (NSMutableSet<NSString *> *)ids {
    if (!_ids) {
        _ids = [[NSMutableSet alloc] init];
    }
    return _ids;
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kSaveImageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
