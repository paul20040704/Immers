//
//  SVProfileViewController.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "SVProfileViewController.h"
#import "SVAccountViewController.h"
#import "SVFeedbackViewController.h"
#import "SVAboutViewController.h"
#import "SVInviteRecordViewController.h"
#import "SVVersionViewController.h"
#import "SVProfileViewCell.h"
#import "SVProfileHeaderView.h"
#import "SVUserButton.h"
#import "SVProfileViewModel.h"
#import "SVAppViewModel.h"
#import "SVMemberViewModel.h"

@interface SVProfileViewController ()

@property (nonatomic, strong) SVAppViewModel *appViewModel;
@property (nonatomic, strong) SVMemberViewModel *memberViewModel;

@end

@implementation SVProfileViewController {
    SVProfileViewModel *_viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _viewModel = [[SVProfileViewModel alloc] init];
    [self prepareSubviews];
    [self prepareItems];
    [self checkVersion];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.frame;
    frame.size.height -= (kSafeAreaBottom + kHeight(10));
    self.view.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestInviteNumber];
}

// MARK: - Action
- (void)settingsClick {
    SVAccountViewController *viewController = [[SVAccountViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.profileItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVProfileItem *item = _viewModel.profileItems[indexPath.row];
    Class class = NSClassFromString(item.className);
    SVProfileViewCell *profileCell = [class cellWithTableView:tableView];
    profileCell.item = _viewModel.profileItems[indexPath.row];
    return profileCell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    SVBaseViewController *viewController;
    if (0 == row) {
        viewController = [[SVInviteRecordViewController alloc] init];
        
    } else if (1 == row) {
        viewController = [[SVFeedbackViewController alloc] init];
        
    } else if (2 == row) {
        viewController = [[SVVersionViewController alloc] init];

    } else if (3 == row) {
        
        viewController = [[SVAboutViewController alloc] init];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

// MARK: - Request
- (void)checkVersion {
    kWself
    [self.appViewModel versionCompletion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            kSself
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *newVersion = sself.appViewModel.versionInfo.apkVersion;
            NSInteger cVersion = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            NSInteger nVersion =  [[newVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            
            if (nVersion > cVersion) {
                sself->_viewModel.profileItems[2].update = YES;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}

/// 请求邀请数量
- (void)requestInviteNumber {
    [self.memberViewModel invitesNumCompletion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            self->_viewModel.profileItems[0].count = [message integerValue];
            [self.tableView reloadData];
        }
    }];
}

/// 子视图
- (void)prepareSubviews {
    [super prepareTableView];

    SVProfileHeaderView *headerView = [[SVProfileHeaderView alloc] init];
    kWself
    headerView.didSelectedCallback = ^{
        [wself settingsClick];
    };
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = kHeight(55);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight);
    }];

    self.light = YES;
    self.translucent = YES;
    self.view.backgroundColor = [UIColor gradientFromColor:[UIColor textColor] toColor:[UIColor themeColor] gradientType:SVGradientTypeLeftToRight size:self.view.bounds.size];
}

- (void)prepareItems {
    UIButton *settingsButton = [UIButton buttonWithImageName:@"profile_settings"];
    [settingsButton addTarget:self action:@selector(settingsClick) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(44), kWidth(30)));
    }];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
}

// MARK: - lazy
- (SVAppViewModel *)appViewModel {
    if (!_appViewModel) {
        _appViewModel = [[SVAppViewModel alloc] init];
    }
    return _appViewModel;
}

- (SVMemberViewModel *)memberViewModel {
    if (!_memberViewModel) {
        _memberViewModel = [[SVMemberViewModel alloc] init];
    }
    return _memberViewModel;
}

@end
