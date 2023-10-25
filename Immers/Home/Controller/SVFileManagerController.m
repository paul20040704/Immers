//
//  SVFileManagerController.m
//  Immers
//
//  Created by ssv on 2022/11/14.
//

#import "SVFileManagerController.h"
#import "SVDeviceViewModel.h"
#import "SVLocalFilesHeadView.h"
#import "SVLocalFileBottomView.h"
#import "SVAlbumViewCell.h"
#import "SVGlobalMacro.h"
@interface SVFileManagerController ()
@property (nonatomic,strong)SVDeviceViewModel *viewModel;
@property (nonatomic,assign)NSInteger storageType;//1本地、2U盘
@property (nonatomic,strong)SVEmptyView *emptyView;
@property (nonatomic,assign)BOOL firstLoading;//是否重新加载
@end

@implementation SVFileManagerController{
    BOOL _couldSelect;//可选状态
    SVLocalFilesHeadView *_headView;
    SVLocalFileBottomView *_bottomView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xd6d6d6]];
    [SVProgressHUD setForegroundColor:[UIColor grayColor5]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storageType = 1;
    if (self.device.deviceId&&self.device.deviceId.length>0) {
        [[SVMQTTManager sharedManager] subscribeDeviceId:self.device.deviceId];
    }
    [self prepareSubView];
    [self getLocalFile:YES];
    [self requestLocalFile];
    [self requestOperationMessage];
    [self updateDeviceARM];
}

// MARK: - Request
- (void)getLocalFile:(BOOL )reload {
    _firstLoading = reload;
    [self.viewModel localFiles:reload storageType:_storageType completion:^(BOOL isSuccess, NSString * _Nullable message) {
        if (isSuccess&&reload) {
            [SVProgressHUD show];
            [SVProgressHUD dismissWithDelay:15];
        }
    }];
}

- (void)requestLocalFile {
    kWself
    [self.viewModel requestLocalFiles:^(BOOL isSuccess, NSString * _Nullable message) {
        if (isSuccess) {
            if (message.integerValue == wself.storageType) {
                wself.firstLoading = NO;
            }
            if ([wself checkNoMoreData]) {
                [wself.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                if ([wself checkIsFirstPage]) {
                    [wself.collectionView.mj_footer resetNoMoreData];
                }
                [wself.collectionView.mj_footer endRefreshing];
            }
            [SVProgressHUD dismiss];
            [wself.collectionView.mj_header endRefreshing];
            [wself.collectionView reloadData];
        }
    }];
}

// MARK: - Action
- (BOOL )checkNoMoreData {
    BOOL noMoreData = _storageType==1?(self.viewModel.localFile.noMoreData):(self.viewModel.usbFile.noMoreData);
    return noMoreData;
}

- (BOOL )checkIsFirstPage {
    BOOL isFirstPage = _storageType==1?(self.viewModel.localFile.page==1):(self.viewModel.usbFile.page==1);
    return isFirstPage;
}

- (NSInteger )storageCount {
    NSInteger count = _storageType==1?self.viewModel.localFile.localFiles.count:self.viewModel.usbFile.localFiles.count;
    return count;
}

- (void)changeAction:(NSInteger )type {
    _storageType = type;
    _bottomView.storageType = type;
    if ((_storageType==1&&self.viewModel.localFile.localFiles.count==0)||(_storageType==2&&self.viewModel.usbFile.localFiles.count==0)) {
        [self getLocalFile:YES];
    }else{
        [self.collectionView reloadData];
        if (![self checkNoMoreData]) {
            [self.collectionView.mj_footer resetNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }
}

- (void)reloadSelectStatus:(BOOL )couldSelect {
    _couldSelect = couldSelect;
    for (SVLocalFile *model in self.viewModel.localFile.localFiles) {
        model.show = couldSelect;
        model.selected = NO;
    }
    for (SVLocalFile *model in self.viewModel.usbFile.localFiles) {
        model.show = couldSelect;
        model.selected = NO;
    }
    if (!couldSelect) {
        [_headView resetSelectStatus];
    }
    [self.viewModel.selectLocalFiles removeAllObjects];
    
    [_bottomView changeSelectStatus:couldSelect];
    [self.collectionView reloadData];
}

- (void)headAction:(NSInteger )index {
    if (0 == index) {
        if ([self storageCount]==0) {
            return;
        }
        [self reloadSelectStatus:!_couldSelect];
    }else if (3 == index) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self changeAction:index];
        [self reloadSelectStatus:NO];
    }
}

- (void)deleteAction {
    if (_viewModel.selectLocalFiles.count==0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_select_delete")];
        return;
    }
    kWself

    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:nil message:SVLocalized(@"tip_delete_confirm") cancelText:SVLocalized(@"login_yes") confirmText:SVLocalized(@"home_cancel")];
    [self alertViewSetting:viewController];
    [viewController handler:^{
        [wself removeFiles];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)removeFiles {
    [self.viewModel deleteLocalFile:^(BOOL isSuccess, NSString * _Nullable message) {
        if (isSuccess) {
            [SVProgressHUD show];
            [SVProgressHUD dismissWithDelay:15];
        }
    }];
}

- (void)addAction {
    if (_viewModel.selectLocalFiles.count==0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_select_add_play")];
        return;
    }
    kWself

    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:nil message:SVLocalized(@"tip_add_play_confirm") cancelText:SVLocalized(@"login_yes") confirmText:SVLocalized(@"home_cancel")];
    [self alertViewSetting:viewController];
    [viewController handler:^{
        [wself addFileToPlay];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)addFileToPlay {
    [self.viewModel addFileToPlay:^(BOOL isSuccess, NSString * _Nullable message) {
        if (isSuccess) {
            [SVProgressHUD show];
            [SVProgressHUD dismissWithDelay:15];
        }
    }];
}

- (void)requestOperationMessage {
    kWself
    [self.viewModel requestFileOtherResult:^(BOOL isSuccess, NSString * _Nullable message, id  _Nonnull result) {
        NSDictionary *dict = result;
        NSNumber *r = result[@"cmd"];
        if (r.integerValue == SVMQTTCmdEventDeleteLocalFilesRes) {
            [SVProgressHUD dismiss];
            if (isSuccess) {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_delete_succeed")];
                [wself reloadSelectStatus:NO];
            }else{
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_delete_failed")];
            }
        }else if (r.integerValue == SVMQTTCmdEventAddFilesToPlayRes) {
            [SVProgressHUD dismiss];
            if (isSuccess) {
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_add_succeed")];
                [wself reloadSelectStatus:NO];
            }else{
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_add_failed")];
            }
        }else if (r.integerValue == SVMQTTCmdEventGetFilesCoverResult){
            NSNumber *isLocal = dict[@"isLocal"];
            NSNumber *index = dict[@"index"];
            if ((isLocal.boolValue&&wself.storageType==1)||(!isLocal.boolValue&&wself.storageType==2)) {
                [wself.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.integerValue inSection:0]]];
            }
        }
    }];
}

- (void)updateDeviceARM {
    NSDictionary *dict = @{ @"framePhotoId" : _device.deviceId };
    kWself
    [self.viewModel deviceRAM:dict completion:^(NSInteger errorCode, NSString * _Nullable message) {
        kSself
        if (sself) {
            [sself->_bottomView updateSize:message];
        }
        
    }];
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_couldSelect) return;
    SVLocalFile *file = _storageType==1?self.viewModel.localFile.localFiles[indexPath.row]:self.viewModel.usbFile.localFiles[indexPath.row];
    file.selected = !file.selected;
    file.selected?[self.viewModel.selectLocalFiles addObject:file]:[self.viewModel.selectLocalFiles removeObject:file];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = _storageType==1?self.viewModel.localFile.localFiles.count:self.viewModel.usbFile.localFiles.count;
    
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVAlbumViewCell *albumCell = [SVAlbumViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    SVLocalFile *file;
    //添加右下白色分割线
    if (_storageType == 1) {
        file = self.viewModel.localFile.localFiles[indexPath.row];
        file.lastRow = ((indexPath.row+1)%3==0)||(indexPath.row==self.viewModel.localFile.localFiles.count-1);
        file.lastLine = indexPath.row>=self.viewModel.localFile.localFiles.count-3;
    }else{
        file = self.viewModel.usbFile.localFiles[indexPath.row];
        file.lastRow = ((indexPath.row+1)%3==0)||(indexPath.row==self.viewModel.usbFile.localFiles.count-1);
        file.lastLine = indexPath.row>=self.viewModel.usbFile.localFiles.count-3;
    }
    file.show = _couldSelect;
    if (indexPath.row==0) {
        file.lastRow = NO;
    }
    //获取文件封面图
    if (file.cover.length==0&&file.getCoverState==0) {
        file.getCoverState = 1;//获取封面图中
        [self.viewModel localFileCover:file.path completion:^(BOOL isSuccess, NSString * _Nullable message) {

        }];
    }
    albumCell.localFile = file;
    return albumCell;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    return _firstLoading?nil:self.emptyView;
}
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    [self.collectionView setContentOffset:CGPointMake(0, -self.collectionView.contentInset.top)];
}

// MARK: - View
- (void)prepareSubView {
    self.navigationController.navigationBar.hidden = YES;
    self.light = YES;
    kWself
    self.view.backgroundColor = [UIColor colorWithHex:0x333333];
    
    self.translucent = YES;
    
    _headView = [[SVLocalFilesHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    _headView.clickAction = ^(NSInteger index) {
        [wself headAction:index];

    };
    [self.view addSubview:_headView];
    
    _bottomView = [[SVLocalFileBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight, kScreenWidth, kTabBarHeight)];
    [_bottomView updateSize:[NSString stringWithFormat:@"%@%@/%@%@",SVLocalized(@"home_used"),[NSString byte2gb:_device.totalCapacity-_device.surplusCapacity],SVLocalized(@"home_remaining"),[NSString byte2gb:_device.surplusCapacity]]];
    _bottomView.deleteAction = ^{
        [wself deleteAction];
    };
    _bottomView.addAction = ^{
        [wself addAction];
    };
    _bottomView.storageType = 1;
    [self.view addSubview:_bottomView];
    
    [self prepareCollectionView];
    
}

- (void)prepareCollectionView {
    kWself
    [self prepareCollectionViewForRegisterClass:SVAlbumViewCell.class layout:[[SVAlbumLayout alloc] init]];
    self.collectionView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, kTabBarHeight, 0);
    
    MJRefreshNormalHeader *header = [MJRefreshHeader getNormalRefreshHeaderWithRefreshingBlock:^{
        [wself getLocalFile:YES];
    }];
    MJRefreshBackStateFooter *footer = [MJRefreshFooter getNormalRefreshFooterWithRefreshingBlock:^{
        [wself getLocalFile:NO];
    }];
    self.collectionView.backgroundColor = [UIColor colorWithHex:0x333333];
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;

    
}

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

// MARK: - Lazy
- (SVDeviceViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVDeviceViewModel alloc] init];
        _viewModel.deviceId = _device.deviceId;
    }
    return _viewModel;;
}

- (SVEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [SVEmptyView viewWithText:SVLocalized(@"tip_empty") imageName:@"home_no_data" textColor:UIColor.whiteColor];
    }
    return _emptyView;;
}

-(void)dealloc {
    
}
@end
