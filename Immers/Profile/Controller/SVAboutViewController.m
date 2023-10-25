//
//  SVAboutViewController.m
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVAboutViewController.h"
#import "SVVersionViewController.h"
#import "SVIntroViewController.h"
#import "SVUsViewController.h"
#import "SVWebViewController.h"
#import "SVProfileViewModel.h"
#import "SVProfileViewCell.h"

@interface SVAboutViewController ()

@end

@implementation SVAboutViewController {
    SVProfileViewModel *_viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_about");
    _viewModel = [[SVProfileViewModel alloc] init];
    [self prepareSubviews];
}


// MARK: - Action

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.abouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVProfileItem *item = _viewModel.abouts[indexPath.row];
    Class class = NSClassFromString(item.className);
    SVProfileViewCell *profileCell = [class cellWithTableView:tableView];
    profileCell.item = _viewModel.abouts[indexPath.row];
    return profileCell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    SVBaseViewController *viewController;
    if (0 == row || 1 == row) {
        SVWebViewController *webController = [[SVWebViewController alloc] init];
        webController.event = (0 == row) ? SVButtonEventAgreement : SVButtonEventPrivacy;
        viewController = webController;
        
    } else if (2 == row || 3 == row) {
        viewController = [SVIntroViewController viewControllerWithType:(2 == row) ? SVIntroTypeProduct : SVIntroTypeCompany];
        
    } else if (4 == row) {
        viewController = [[SVUsViewController alloc] init];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 子视图
- (void)prepareSubviews {
    [super prepareTableView];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = kHeight(50);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self prepareHeaderView];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (UIView *)prepareHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(178))];
    
    UIImageView *logoView = [UIImageView imageViewWithImageName:@"profile_immers_logo"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLabel = [UILabel labelWithText:version font:kSystemFont(12) color:[UIColor grayColor5] ];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:logoView];
    [view addSubview:versionLabel];
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(kHeight(-20));
        make.centerX.equalTo(view);
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom).offset(kHeight(12));
        make.centerX.equalTo(view);
    }];
    
    return view;
}

@end
