//
//  SVApplyListViewController.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVApplyListViewController.h"
#import "SVApplyInfoViewController.h"
#import "SVMemberApplyCell.h"
#import "SVMemberViewModel.h"

@interface SVApplyListViewController ()

@property (nonatomic, strong) SVMemberViewModel *viewModel;

@end

@implementation SVApplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSubView];
    [self loadApplyLsit];
    [self addNotification];
}

// MARK: - UI
- (void)prepareSubView {
    self.view.backgroundColor = UIColor.backgroundColor;
    self.title = SVLocalized(@"home_apply_count");
    [self prepareTableView];
    self.tableView.rowHeight = kHeight(140);
    self.tableView.backgroundColor = UIColor.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

// MARK: - Request
- (void)loadApplyLsit {
    if ([self.deviceId trimming].length < 0 || self.deviceId == nil) {
        return;
    }
    NSDictionary *dict = @{ @"framePhotoId" : self.deviceId, @"status" : @"0", @"startPage" : @"1", @"pageSize" : @"10000" };
    [self.viewModel applyList:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.applys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVMemberApplyCell *cell = [SVMemberApplyCell cellWithTableView:tableView];
    cell.apply = self.viewModel.applys[indexPath.row];
    return cell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SVApplyInfoViewController *viewController = [[SVApplyInfoViewController alloc] init];
    viewController.apply = self.viewModel.applys[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

// MARK: - DZNEmptyDataSetDelegate
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"tip_empty") imageName:@"home_no_data"];
}

// MARK: - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadApplyLsit) name:kMemberApplyNotification object:nil];
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
