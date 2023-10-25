//
//  SVTaskViewController.m
//  Immers
//
//  Created by developer on 2022/10/14.
//

#import "SVTaskViewController.h"
#import "SVTaskViewCell.h"
#import "SVDeviceViewModel.h"

@interface SVTaskViewController ()

@property (nonatomic, strong) SVDeviceViewModel *viewModel;

@end

@implementation SVTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SVLocalized(@"home_task_center");
    [self prepareTableView];
    [self loadTasks];
    [self receiveTasks];
}

/// MQTT 接受下载任务
- (void)receiveTasks {
    kWself
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary *message) {
        NSInteger cmd = [message[kCmd] integerValue];
        NSString *fromId = message[kFromId];
        if (![fromId isEqualToString:wself.deviceId]) {
            return;
        }
        if (cmd == SVMQTTCmdEventTaskDown) { // 下载任务
            [wself updateData:message[kExt]];
        }
    }];
}

/// 更新状态
- (void)updateData:(NSDictionary *)dict {
    [self.viewModel.downs enumerateObjectsUsingBlock:^(SVDown * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.imageId isEqualToString:dict[@"serviceId"]]) {
            obj.state = [dict[@"state"] integerValue];
            obj.percent = [dict[@"percent"] doubleValue];
            if (obj.state == 1 || obj.state == 7) {
                [self.viewModel.downs removeObject:obj];
            }
        }
    }];
    [self.tableView reloadData];

}

// MARK: - Requset
- (void)loadTasks {
    if (nil == self.deviceId) { return; }
    [self.viewModel tasks:@{ @"framePhotoId" : _deviceId?:@"" } completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.downs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVTaskViewCell *taskCell = [SVTaskViewCell cellWithTableView:tableView];
    taskCell.down = self.viewModel.downs[indexPath.row];
    return taskCell;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [SVEmptyView viewWithText:SVLocalized(@"home_no_download_task") imageName:@"home_no_data"];
}

// MARK: - prepare
- (void)prepareTableView {
    [super prepareTableView];
    
    self.tableView.rowHeight = kHeight(60);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

// MARK: - lazy
- (SVDeviceViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVDeviceViewModel alloc] init];
    }
    return _viewModel;
}

- (void)dealloc {
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}

@end
