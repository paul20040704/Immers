//
//  SVTransferViewController.m
//  Immers
//
//  Created by developer on 2023/3/13.
//

#import "SVTransferViewController.h"
#import "SVTransferCell.h"
#import "SVMemberViewModel.h"


@interface SVTransferViewController ()

@property (nonatomic, strong) SVMemberViewModel *viewModel;

@end

@implementation SVTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SVLocalized(@"home_transfer_device");

    [self prepareTableView];
    [self loadTransferList];
}

// MARK: - Action
- (void)transferDevice:(SVMember *)member {
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:nil message:[NSString stringWithFormat:SVLocalized(@"home_confirm_transfer_device"), member.memberName] cancelText:SVLocalized(@"home_confirm") confirmText:SVLocalized(@"home_cancel")];
    kWself
    [viewController handler:^{
        [wself transfer:[NSString stringWithFormat:@"%ld", member.memberId]];
    } confirmAction:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

// MARK: - Request
- (void)transfer:(NSString *)memberId {
    NSDictionary *dict = @{ @"memberId" : memberId, @"framePhotoId" : self.deviceId};
    [self.viewModel transferDevice:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess && self.updateRole) {
            self.updateRole();
        }
        [SVProgressHUD showInfoWithStatus:message];
    }];
    
    
}

- (void)loadTransferList {
    NSDictionary *dict = @{ @"framePhotoId" : self.deviceId };
    [self.viewModel transferMember:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVTransferCell *cell = [SVTransferCell cellWithTableView:tableView];
    cell.member = self.viewModel.members[indexPath.row];
    kWself
    cell.transferAction = ^(SVMember *member) {
        [wself transferDevice:member];
    };
    return cell;
}

// MARK: - DZNEmptyDataSetDelegate
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"tip_empty") imageName:@"home_no_data"];
}

// MARK: - UI
- (void)prepareTableView {
    [super prepareTableView];

    self.tableView.backgroundColor = [UIColor backgroundColor];
    UIView *headerView = [[UIView alloc] init];
    UILabel *textLabel = [UILabel labelWithText:SVLocalized(@"home_transfer_device") font:kSystemFont(14) color:[UIColor grayColor7]];
    
    UIView *tipView = [[UIView alloc] init];
    [tipView corner];
    tipView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [UILabel labelWithText:SVLocalized(@"home_transfer_to") font:kBoldFont(16) color:[UIColor redColor]];
    tipLabel.numberOfLines = 0;
    
    [headerView addSubview:textLabel];
    [headerView addSubview:tipView];
    [tipView addSubview:tipLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(headerView).offset(kHeight(15));
    }];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(kHeight(15));
        make.right.equalTo(headerView).offset(kHeight(-15));
        make.top.equalTo(textLabel.mas_bottom).offset(kHeight(10));
        make.height.mas_equalTo(kHeight(70));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, kHeight(130)));
    }];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = kHeight(100);
}

// MARK: - lazy
- (SVMemberViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVMemberViewModel alloc] init];
    }
    return _viewModel;
}

@end
