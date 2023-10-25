//
//  SVAIViewController.m
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import "SVAIViewController.h"
#import "SVAIViewModel.h"
#import "SVAICell.h"
#import "SVAIHeadView.h"
#import "SVAIBottomView.h"
#import "SVSelectFrameViewController.h"
#import <Photos/Photos.h>
#import "SVAIZoomViewController.h"

@interface SVAIViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)SVAIViewModel *viewModel;
@end

@implementation SVAIViewController{
    BOOL _couldSelect;//可选状态
    SVAIBottomView *_bootomView;//底部选择栏
    SVAIHeadView *_headView;//头部选择栏
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
    [self setDefaultResources];
}

// MARK: -UIView
- (void)prepareSubviews {
    
    self.tabBarController.tabBar.hidden = YES;
    [self prepareCollectionViewForRegisterClass:[SVAICell class] layout:[[SVResourceFrameLayout alloc] init]];
//    self.collectionView.mj_header = header;
//    self.collectionView.mj_footer = footer;
//    self.translucent = YES;
    kWself
    _headView = [[SVAIHeadView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kHeight(90))];
    
    _headView.clickAction = ^(NSInteger index, NSString *keyword) {
        [wself headAction:index andKeyword:keyword];
    };
    
    _headView.searchTextFeild.delegate = self;
    [self.view addSubview:_headView];
    
    _bootomView = [[SVAIBottomView alloc] initWithFrame:CGRectZero];
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

-(void)setDefaultResources {
    for (int i = 1; i < 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ai_default_0%d",i]];
        SVAIModel *model = [[SVAIModel alloc] init];
        model.image = image;
        model.show = NO;
        model.selected = NO;
        [self.viewModel.resources addObject: model];
    }
    [self.collectionView reloadData];
}

// MARK: -Action
- (void)showBottomView:(BOOL )show {
    _bootomView.hidden = !show;
    [self reloadBottomView];
}

- (void)reloadSelectStatus:(BOOL )couldSelect {
    for (SVAIModel *model in self.viewModel.resources) {
        model.show = couldSelect;
        model.selected = NO;
    }
    [self.viewModel.selectResources removeAllObjects];
    _couldSelect = couldSelect;
    [self showBottomView:_couldSelect];
    [self.collectionView reloadData];
}

- (void)headAction:(NSInteger )index andKeyword:(NSString *)keyword {
    kWself
    if (0 == index) {
        [self reloadSelectStatus:!_couldSelect];
    }else{
        if (_couldSelect) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"select_Image_text")];
        }else {
            [SVProgressHUD show];
            //搜尋AI圖片
            [self.viewModel getAIResources:keyword completion:^(BOOL isSuccess, NSString * _Nullable message) {
                NSLog(@"isSuccess: %d", isSuccess);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself.collectionView reloadData];
                });
                [SVProgressHUD dismiss];
            }];
        }
    }
}

- (void)downAction {
    //下載圖片
    [self saveImagesToAlbum];
//    kWself
//    SVAlertViewController *viewController = [SVAlertViewController weakWithTitle:SVLocalized(@"in_progress") message:SVLocalized(@"in_progress_content_02") cancelText:SVLocalized(@"yes") confirmText:SVLocalized(@"just_download")];
//    viewController.showClose = YES;
//    viewController.backgroundColor = [UIColor grayColor3];
//    viewController.titleTextColor = [UIColor blackColor];
//    [viewController handler:^{
//    } confirmAction:^{
//        [wself saveImagesToAlbum];
//    }];
//    [wself presentViewController:viewController animated:YES completion:nil];
}

- (void)reloadBottomView {
    _bootomView.selectCounnt  = self.viewModel.selectResources.count;
}

-(void)saveImagesToAlbum {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSMutableArray *assetRequests = [NSMutableArray array];
        for (SVAIModel *model in self.viewModel.selectResources) {
            PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:model.image];
            [assetRequests addObject:assetRequest.placeholderForCreatedAsset];
        }
        PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"My Album"];
        [collectionRequest addAssets:assetRequests];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_save_image_succeed")];
                [self reloadSelectStatus:YES];
            });
        }else {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_save_image_erroe")];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

// MARK: -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVAICell *resourceCell = [SVAICell cellWithCollectionView:collectionView indexPath:indexPath];
    SVAIModel *model = self.viewModel.resources[indexPath.item];
    model.show = _couldSelect;
    resourceCell.resource = model;
    return resourceCell;
}

// MARK: -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SVAIModel *model = self.viewModel.resources[indexPath.item];
    
    if (!_couldSelect) {
        SVAIZoomViewController *viewController = [[SVAIZoomViewController alloc] init];
        viewController.image = model.image;
        [self.navigationController pushViewController:viewController animated:YES];
    }else {
        if (self.viewModel.selectResources.count>=5 && model.selected==NO) return;
        model.selected = !model.selected;
        model.selected?[self.viewModel.selectResources addObject:model]:[self.viewModel.selectResources removeObject:model];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self reloadBottomView];
    }
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"tip_empty") imageName:@"home_no_data"];
}
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    [self.collectionView setContentOffset:CGPointMake(0, -self.collectionView.contentInset.top)];
}


// MARK: -Lazy
- (SVAIViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[SVAIViewModel alloc] init];
    }
    
    return _viewModel;
}

@end
