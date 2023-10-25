//
//  SVDeviceMemberViewController.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVDeviceMemberViewController.h"
#import "SVMemberInfoViewController.h"
#import "SVApplyListViewController.h"
#import "SVInviteViewController.h"
#import "SVQRCodeAlertViewController.h"
#import "SVTransferViewController.h"
#import "SVMemberTopView.h"
#import "SVMemberListCell.h"

#import "SVMemberViewModel.h"

@interface SVDeviceMemberViewController ()

@property (nonatomic, strong) SVMemberViewModel *viewModel;

@end

@implementation SVDeviceMemberViewController{
    SVMemberTopView *_topView;
    UIButton *_commitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSubView];
    [self loadMembers];
    [self addNotification];
}

- (void)prepareSubView {
    self.title = SVLocalized(@"home_use_manager");
    _topView = [[SVMemberTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(260))];
    _topView.device = self.device;
    kWself
    _topView.actionBlock = ^(NSInteger type) {
        if (type == 0) {
            SVApplyListViewController *viewController = [[SVApplyListViewController alloc] init];
            viewController.deviceId = wself.device.deviceId;
            [wself.navigationController pushViewController:viewController animated:YES];
            
        } else if (type == 1){
            SVQRCodeAlertViewController *viewController = [[SVQRCodeAlertViewController alloc] init];
            viewController.deviceId = wself.device.deviceId;
            [wself presentViewController:viewController animated:YES completion:nil];
            
        } else {
            SVInviteViewController *viewController = [[SVInviteViewController alloc] init];
            viewController.deviceId = wself.device.deviceId;
            [wself.navigationController pushViewController:viewController animated:YES];
        }
    };
   
    [self prepareTableView];
    self.tableView.rowHeight = kHeight(90);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = _topView;
    self.tableView.backgroundColor = UIColor.backgroundColor;
    
    UIButton *commitBtn = [UIButton buttonWithTitle:SVLocalized(@"home_member_transfer") titleColor:UIColor.whiteColor font:kSystemFont(12)];
    commitBtn.backgroundColor = [UIColor redButtonColor];
    _commitBtn = commitBtn;
    [commitBtn corner];
    
    //commitBtn.frame = CGRectMake(kWidth(40), 0, kScreenWidth-kWidth(80), kHeight(48));
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottom-kHeight(12));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(kWidth(40));
        make.height.mas_equalTo(kHeight(48));
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottom-kHeight(48));
    }];
}

- (void)updateInfo {
    _topView.auditNum = self.viewModel.userInfo.auditNum;
    _topView.currentRole = self.viewModel.userInfo.currentRole;
    
    if (1 == self.viewModel.userInfo.currentRole) {
        [_commitBtn setTitle:SVLocalized(@"home_member_transfer") forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(transferClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_commitBtn setTitle:SVLocalized(@"home_member_exit") forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

// MARK: - Request
- (void)transferClick {
    SVTransferViewController *viewController = [[SVTransferViewController alloc] init];
    viewController.deviceId = self.device.deviceId;
    [self.navigationController pushViewController:viewController animated:YES];
    kWself
    viewController.updateRole = ^{
        wself.viewModel.userInfo.currentRole = 2;
        [wself updateInfo];
    };
}

/// 退出相框
- (void)exitClick {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:nil message:SVLocalized(@"home_exit_tip_title") cancelText:SVLocalized(@"home_confirm") confirmText:SVLocalized(@"home_cancel")];
    viewController.showClose = YES;
    [viewController handler:^{
        
        NSDictionary *dict = @{ @"framePhotoId" : wself.device.deviceId };
        [wself.viewModel exitDevice:dict completion:^(BOOL isSuccess, NSString *message) {
            if (isSuccess) {
                [wself.navigationController popViewControllerAnimated:YES];
            }
            [SVProgressHUD showInfoWithStatus:message];
        }];
        
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 成员列表
- (void)loadMembers {
    [SVProgressHUD showWithStatus:SVLocalized(@"tip_loading")];
    [self.viewModel loadMembers:self.device.deviceId completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [self.tableView reloadData];
            [self updateInfo];
            
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - Notification
- (void)updateApplyNumber {
    NSDictionary *dict = @{ @"framePhotoId" : self.device.deviceId, @"status" : @"0" };
    [self.viewModel applyNum:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            self->_topView.auditNum = self.viewModel.userInfo.auditNum;
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateApplyNumber) name:kMemberApplyNotification object:nil];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.userInfo.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVMemberListCell *cell = [SVMemberListCell cellWithTableView:tableView];
    cell.member = self.viewModel.userInfo.members[indexPath.row];
    return cell;
}


// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (3 == self.viewModel.userInfo.currentRole) { return; }
    
    SVMember *member = self.viewModel.userInfo.members[indexPath.row];
    SVMemberInfoViewController *viewController = [[SVMemberInfoViewController alloc] init];
    viewController.member = member;
    viewController.currentRole = self.viewModel.userInfo.currentRole;
    [self.navigationController pushViewController:viewController animated:YES];
    
    // 删除 / 修改 回调
    kWself
    viewController.updateMemberList = ^(BOOL remove) {
        if (remove) {
            [wself.viewModel.userInfo.members removeObject:member];
        }
        [wself.tableView reloadData];
    };
}

// MARK: - DZNEmptyDataSetDelegate
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"tip_empty") imageName:@"home_no_data"];
}

// MARK: - lazy
- (SVMemberViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVMemberViewModel alloc] init];
    }
    return _viewModel;
}

// MARK: - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
