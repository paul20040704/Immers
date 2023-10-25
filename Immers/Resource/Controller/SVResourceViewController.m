//
//  SVResourceViewController.m
//  Immers
//
//  Created by ssv on 2022/11/8.
//

#import "SVResourceViewController.h"
#import "SVResourceViewModel.h"
#import "SVResourceCell.h"
#import "SVResourceHeadView.h"
#import "SVResourceBottomView.h"
#import "SVSelectFrameViewController.h"
#import "SVAddDeviceViewController.h"
@interface SVResourceViewController ()
@property (nonatomic,strong)SVResourceViewModel *viewModel;
@end

@implementation SVResourceViewController
{
    BOOL _couldSelect;//可选状态
    SVResourceBottomView *_bootomView;//底部选择栏
    NSInteger _resourceType;//0 图片 ，1 视频
    SVResourceHeadView * _headView;//头部选择栏
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self reloadSelectStatus:NO];
    [_headView resetSelectStatus];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSubviews];
    [self loadResource:YES];
    [self.collectionView.mj_header beginRefreshing];

}

// MARK: -Action
- (void)showBottomView:(BOOL )show {
    self.tabBarController.tabBar.hidden = show;
    _bootomView.hidden = !show;
    [self reloadBottomView];
}

- (void)showNoDeviceAlert {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"login_prompt") message:SVLocalized(@"tip_unBind_device_long") cancelText:SVLocalized(@"home_cancel") confirmText:SVLocalized(@"tip_toBind")];
    viewController.showClose = YES;
    viewController.actionFirst = YES;
    viewController.backgroundColor = [UIColor colorWithHex:0xffffff alpha:0.9];
    viewController.cancelBackgroundColor = [UIColor colorWithHex:0xDEDEDE];
    
    [viewController handler:nil confirmAction:^{
        [wself toAddDevice];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)toAddDevice {
    SVAddDeviceViewController *vc = [[SVAddDeviceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)reloadSelectStatus:(BOOL )couldSelect {
    for (SVResourceModel *model in self.viewModel.resources) {
        model.show = couldSelect;
        model.selected = NO;
    }
    [self.viewModel.selectResources removeAllObjects];
    _couldSelect = couldSelect;
    [self showBottomView:_couldSelect];
    [self.collectionView reloadData];
}

- (void)headAction:(NSInteger )index {
    if (2 == index) {
        if (![SVUserAccount sharedAccount].device) {
            [_headView resetSelectStatus];
            [self showNoDeviceAlert];
        }else{
            [self reloadSelectStatus:!_couldSelect];
        }
    }else{
        self.viewModel.resourceType = index;
        [self reloadSelectStatus:NO];
        [self loadResource:YES];
    }
}

- (void)downAction {
    SVSelectFrameViewController *selectVC = [[SVSelectFrameViewController alloc] init];
    selectVC.selectResources = self.viewModel.selectResources;
    selectVC.eventType = SVButtonEventDownloadResource;
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)reloadBottomView {
    _bootomView.selectCounnt  = self.viewModel.selectResources.count;
}

// MARK: -Request
- (void)loadResource:(BOOL)reLoad {
    kWself
    if (reLoad) {
        [SVProgressHUD show];
        [self reloadSelectStatus:NO];
        [_headView resetSelectStatus];
    }
    [self.viewModel resources:reLoad completion:^(BOOL isSuccess, NSString * _Nullable message) {
        [wself.collectionView.mj_header endRefreshing];
        
        if(wself.viewModel.noMoreData){
            [wself.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [wself.collectionView.mj_footer endRefreshing];
            [wself.collectionView.mj_footer resetNoMoreData];
        }
        [wself.collectionView reloadData];
        [SVProgressHUD dismiss];
        
    }];
}

// MARK: -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVResourceCell *resourceCell = [SVResourceCell cellWithCollectionView:collectionView indexPath:indexPath];
    SVResourceModel *model = self.viewModel.resources[indexPath.item];
    kWself
    resourceCell.longPressBlock = ^{
        kSself
        if (sself->_couldSelect) return;
        if (![SVUserAccount sharedAccount].device){
            [sself showNoDeviceAlert];
            return;
        }
        [sself.viewModel.selectResources addObject:model];
        [sself downAction];
    };
    model.show = _couldSelect;
    resourceCell.resource = model;
    return resourceCell;
}

// MARK: -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![SVUserAccount sharedAccount].device){
        [self showNoDeviceAlert];
        return;
    }
    if (!_couldSelect) return;
    
    SVResourceModel *model = self.viewModel.resources[indexPath.item];
    if (self.viewModel.selectResources.count>=5 && model.selected==NO) return;
    model.selected = !model.selected;
    model.selected?[self.viewModel.selectResources addObject:model]:[self.viewModel.selectResources removeObject:model];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self reloadBottomView];
    
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"tip_empty") imageName:@"home_no_data"];
}
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    [self.collectionView setContentOffset:CGPointMake(0, -self.collectionView.contentInset.top)];
}

// MARK: -UIView
- (void)prepareSubviews {

    [self prepareCollectionViewForRegisterClass:[SVResourceCell class] layout:[[SVResourceFrameLayout alloc] init]];
    kWself
    MJRefreshNormalHeader *header = [MJRefreshHeader getNormalRefreshHeaderWithRefreshingBlock:^{
        [wself loadResource:YES];
    }];
    MJRefreshBackStateFooter *footer = [MJRefreshFooter getNormalRefreshFooterWithRefreshingBlock:^{
        [wself loadResource:NO];
    }];
    
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;
    self.translucent = YES;
    _headView = [[SVResourceHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    _headView.clickAction = ^(NSInteger index) {
        [wself headAction:index];

    };
    [self.view addSubview:_headView];
    
    _bootomView = [[SVResourceBottomView alloc] initWithFrame:CGRectZero];
    _bootomView.hidden = YES;
    _bootomView.downAction = ^{
        [wself downAction];
    };
    [self.view addSubview:_bootomView];
    
    CGSize tabSize = self.tabBarController.tabBar.frame.size;
    [_bootomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(tabSize.width, tabSize.height));
        make.left.equalTo(self.view).offset(kWidth(24));
        make.top.equalTo(self.view).offset(kScreenHeight-kSafeAreaBottom-tabSize.height);
    }];
}



// MARK: -Lazy
- (SVResourceViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[SVResourceViewModel alloc] init];
    }
    
    return _viewModel;
}

@end
