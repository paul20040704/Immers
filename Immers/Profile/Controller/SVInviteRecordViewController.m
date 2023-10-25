//
//  SVInviteRecordViewController.m
//  Immers
//
//  Created by developer on 2023/2/20.
//

#import "SVInviteRecordViewController.h"
#import "SVInviteViewCell.h"
#import "SVMemberViewModel.h"

@interface SVInviteRecordViewController ()

@property (nonatomic, strong) SVMemberViewModel *viewModel;

@end

@implementation SVInviteRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_invite");
    [self prepareSubView];
    [self loadInviteList];
}

// MARK: - UI
- (void)prepareSubView {
    [super prepareTableView];
    self.view.backgroundColor = UIColor.backgroundColor;
    self.tableView.rowHeight = kHeight(160);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
}

// MARK: - Request
- (void)loadInviteList {
    NSDictionary *dict = @{ @"pageSize" : @"10000", @"startPage" : @"1" };
    [self.viewModel inviteList:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (void)handleInvite:(SVInvite *)invite index:(NSInteger)index {
    NSDictionary *dict = @{ @"id" : invite.i_id, @"status" : [NSString stringWithFormat:@"%ld", index] };
    [self.viewModel inviteHandler:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            invite.status = index;
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.invites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVInviteViewCell *inviteCell = [SVInviteViewCell cellWithTableView:tableView];
    SVInvite *invite = self.viewModel.invites[indexPath.row];
    inviteCell.invite = invite;
    kWself
    inviteCell.actionBlock = ^(NSInteger index) {
        [wself handleInvite:invite index:index];
    };
    return inviteCell;
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

@end
