//
//  SVControlViewController.m
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVControlViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SVTableViewCell.h"

@interface SVControlViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *timeArr;
@end

@implementation SVControlViewController {
    UIView *_playBGView;//播放模式父view
    UILabel *_timeModeLabel;//时间模式文本
    
    UIButton *_playButton;//中间播放按钮
    UIButton *_sortButton;//切换播放模式按钮
    UITableView *_timeTableView;//停留时间选择tableview
    BOOL _hadGetDeviceInfo;//是否获取过设备信息，获取过之后就以播放状态322为准
    NSInteger _status;//播放状态 0:空闲状态 1:顺序播放 2:随机播放 3:单个播放 4:暂停播放 5:资源播放(宠物播放)
    NSInteger _playType;//0 列表 1时钟
    NSInteger _playSort;//播放顺序
    NSInteger _playTime;//停留时长
    NSInteger _oldPlayTime;//修改之前的停留时长
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _playSort = 1;
    self.hidenNav = YES;
    self.view.backgroundColor = [UIColor colorWithHex:0xffffff alpha:0];
    [self prepareSubviews];
    if(_deviceInfo){
        [self updateControlInfo];
    }
    [self prepareMQTT];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[self.view viewWithTag:100] topCorner];
}

// MARK: - Action
- (void)directionClick:(UIButton *)button {
    AudioServicesPlaySystemSound(1520);
    NSInteger cmd;
    if (SVButtonEventVolumeUp == button.tag) {
        cmd = SVMQTTCmdEventVolumeUp;
        
    } else if (SVButtonEventPrevious == button.tag) {
        cmd = SVMQTTCmdEventFilePrevious;
        
    } else if (SVButtonEventVolumeDown == button.tag) {
        cmd = SVMQTTCmdEventVolumeDown;
        
    } else if (SVButtonEventNext == button.tag) {
        cmd = SVMQTTCmdEventFileNext;
        
    } else if (SVButtonEventHome == button.tag) {
        cmd = SVMQTTCmdEventQuit;
        [self dismissClick];
        
    } else { // 播放
        cmd = (_status!=4&&_status!=0) ? SVMQTTCmdEventpause : (_status==4)?SVMQTTCmdEventResume:SVMQTTCmdEventEnter;
        button.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.userInteractionEnabled = YES;
        });
    }
    
    [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(cmd), kFromId : _deviceId?:@"" } handler:nil];
}

- (void)dismissClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareMQTT {
    kWself
    [[SVMQTTManager sharedManager] sendControl:@{ kCmd : @(SVMQTTCmdEventGetDeviceInfo), kFromId : _deviceId?:@"" } handler:nil];
    [[SVMQTTManager sharedManager] receiveMessage:[self hash] handler:^(NSDictionary *message) {
        NSInteger cmd = [message[kCmd] integerValue];
        NSString *fromId = message[kFromId];
        kSself
        if (sself&&[fromId isEqualToString:sself.deviceId]) {
            if (cmd == SVMQTTCmdEventDeviceInfo && wself) {
                if(!sself->_hadGetDeviceInfo){
                    NSInteger status = [message[kExt][kPlayStatus] integerValue];
                    [sself updatePlayStatus:status];
                }
                NSDictionary <NSString *, id> *ext = message[kExt];
                SVDeviceInfo *info = [SVDeviceInfo yy_modelWithDictionary:ext];
                info.deviceId = sself.deviceId;
                sself->_deviceInfo = info;
                [sself updateControlInfo];
                sself->_hadGetDeviceInfo = YES;
            }else if ((cmd == SVMQTTCmdEventStatus && wself)) {
                // 0:未播放 1:已经播放 2:暂停
                NSInteger status = [message[kExt][kPlayStatus] integerValue];
                [sself updatePlayStatus:status];
            }else if ((cmd == SVMQTTCmdEventPalyModeAnyResult && wself)){
                // 停留时长回包
                [SVProgressHUD dismiss];
                BOOL success = [message[kExt] boolValue];
                if(success){
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:SVLocalized(@"home_controller_changeStayTime"),sself->_playTime]];
                }else{
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_failed")];
                    sself->_playTime = sself->_oldPlayTime;
                    [sself changeStayTimeView:sself->_oldPlayTime];
                }
            } else if ((cmd == SVMQTTCmdEventSortAnyRes && wself)){
                //播放模式回包
                [SVProgressHUD dismiss];
                BOOL success = [message[kExt] boolValue];
                if(success){
                    NSArray *arr = @[@"home_controller_changeInOrderMode",@"home_controller_changeShuffleMode",@"home_controller_changeSingleMode"];
                    [SVProgressHUD showInfoWithStatus:SVLocalized(arr[MIN(MAX(sself->_playSort-1, 0), 2)])];
                    [sself changeSortView:sself->_playSort];
                }else{
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_failed")];
                    sself->_playSort --;
                    sself->_playSort = MAX(0, sself->_playSort);
                }
            } else if ((cmd == SVMQTTCmdEventPalyTypeRes && wself)){
                //播放方式回包
                [SVProgressHUD dismiss];
                BOOL success = [message[kExt] boolValue];
                if(success){
                    [SVProgressHUD showInfoWithStatus:sself->_playType==0?SVLocalized(@"home_controller_changeMediaType"):SVLocalized(@"home_controller_changeClockType")];
                    [sself changeDeviceModeView:(sself->_playType==0)];
                }else{
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_operation_failed")];
                    sself->_playType = (sself->_playType==0)?1:0;
                }

            } else if ((cmd == SVMQTTCmdEventFileChangeRes && wself)){
                //切换上一首下一首回包
                BOOL success = [message[kExt] boolValue];
                if(success){
                    if(sself->_status==4){
                        NSInteger status = (sself->_playSort==0)?4:((sself->_playSort==1)?1:2);
                        [sself updatePlayStatus:status];
                    }
                }
            }
        }
    }];
}

//切换模式
- (void)changeDeviceMode:(UIButton *)sender {
    [self delayUserInterface:[self.view viewWithTag:200]];
    [self delayUserInterface:[self.view viewWithTag:201]];
    BOOL isPlay = (sender.tag == 200);
    _playType = isPlay?0:1;
    [self sendMessage:SVMQTTCmdEventPalyType ext:@{@"playType":isPlay?@(1):@(2)}];
    [self showProgress];
    
}

//切换播放模式
- (void)changePlayMode {
    [self delayUserInterface:_sortButton];
    _playSort ++;
    if(_playSort>3) _playSort = 1;
    [self showProgress];
    [self sendMessage:SVMQTTCmdEventSortAny ext:@{@"playModel":@(_playSort)}];
    
}

//切换停留时长
- (void)changePlayTime:(NSInteger )index {
    NSNumber *time = self.timeArr[MIN(index, 5)];
    if(_playTime == time.integerValue){
        return;
    }
    _playTime = time.integerValue;
    [self showProgress];
    [self sendMessage:SVMQTTCmdEventPalyModeAny ext:@{@"stayTime":@(time.intValue * 1000)}];
    
}
/// 发送指令
- (void)sendMessage:(NSInteger)cmd ext:(NSDictionary *)ext {
    NSDictionary *dict = ext?@{ kCmd : @(cmd) ,kFromId : _deviceId?:@"",kExt:ext}:@{ kCmd : @(cmd) ,kFromId : _deviceId?:@""};
    [[SVMQTTManager sharedManager] sendControl:dict handler:^(NSError *error) {
    }];
}

/// 延迟500ms
- (void)delayUserInterface:(UIView *)view {
    view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.userInteractionEnabled = YES;
    });
}

/// 设备信息初始化界面
- (void)updateControlInfo {
    NSInteger playType = _deviceInfo.playType.integerValue;
    [self changeDeviceModeView:(playType==1)];
    
    NSInteger playSort = _deviceInfo.playModel.integerValue;
    _playSort = playSort;
    [self changeSortView:playSort];
    
    NSInteger time = _deviceInfo.imageStayTime / 1000;
    _playTime = time;
    _oldPlayTime = time;
    [self changeStayTimeView:time];
    
}

/// 更新按钮状态 0:未播放
- (void)updatePlayStatus:(NSInteger)status {
    _status = status;
    [_playButton setImage:(0 != status && 4 != status)?[UIImage imageNamed:@"home_control_pause"]:[UIImage imageNamed:@"home_control_play"] forState:0];
}

/// 切换播放方式UI
- (void)changeDeviceModeView:(BOOL )isPlay {
    UIButton *playModeButton = [self.view viewWithTag:200];
    UIButton *clockModeButton = [self.view viewWithTag:201];
    playModeButton.selected = isPlay;
    clockModeButton.selected = !isPlay;
    _timeModeLabel.hidden = isPlay;
    _playBGView.hidden = !isPlay;
}
/// 切换播放模式UI
- (void)changeSortView:(NSInteger )sort {
    NSArray *imgArr = @[@"home_play_list_cycle",@"home_play_random",@"home_play_cycle"];
    [_sortButton setImage:[UIImage imageNamed:imgArr[MIN(MAX(sort-1, 0), 2)]] forState:0];
}
/// 切换时间UI
- (void)changeStayTimeView:(NSInteger )time {
    kWself
    [self.timeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kSself
        if([obj  isEqual: @(time)]){
            [sself->_timeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            *stop = YES;
        }
    }];
}
/// 显示loading
- (void)showProgress {
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

// MARK: - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeArr.count*1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    NSInteger index = indexPath.row%self.timeArr.count;
    SVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SVTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = UIColor.whiteColor;
        cell.textLabel.font = kBoldFont(15);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.contentView.backgroundColor = cell.backgroundColor =  UIColor.clearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@s",self.timeArr[index]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = (indexPath.row+1)%self.timeArr.count;
    [_timeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row+1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self changePlayTime:index];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat rowHeight = _timeTableView.rowHeight;
    int verticalOffset = ((int)targetContentOffset->y % (int)rowHeight);

    if (velocity.y < 0) {
        targetContentOffset->y -= verticalOffset;
    } else if (velocity.y > 0) {
        targetContentOffset->y += (rowHeight - verticalOffset);
    } else {
        if (verticalOffset < rowHeight / 2) {
            targetContentOffset->y -= verticalOffset;
        } else {
            targetContentOffset->y += (rowHeight - verticalOffset);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *visibleArr = _timeTableView.indexPathsForVisibleRows;
    if(visibleArr.count>0){
        if (visibleArr.count==1) {
            NSIndexPath *indexPath = visibleArr[0];
            NSInteger index = indexPath.row%self.timeArr.count;
            [self changePlayTime:index];
        }else{
            NSIndexPath *indexPath = visibleArr.lastObject;
            NSInteger index = indexPath.row%self.timeArr.count;
            [_timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            [self changePlayTime:index];
        }
        
        
    }
}

// MARK: - Subviews
// 子视图
- (void)prepareSubviews {
    // 销毁按钮
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 切换模式背景
    UIImageView *changeBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_change_mode_bg"]];
    
    // 切换按钮
    UIButton *playModeButton = [UIButton buttonWithNormalName:@"home_play_mode" selectedName:@"home_change_play_mode"];
    playModeButton.tag = 200;
    [playModeButton addTarget:self action:@selector(changeDeviceMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *clockModeButton = [UIButton buttonWithNormalName:@"home_clock_mode" selectedName:@"home_clock_change_mode"];
    clockModeButton.tag = 201;
    [clockModeButton addTarget:self action:@selector(changeDeviceMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 控制视图
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *controlView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    controlView.tag = 100;
    
    //播放模式
    _playBGView = [UIView new];
    _playBGView.backgroundColor = UIColor.clearColor;
    _playBGView.hidden = YES;
    
    // 控制背景
    UIImageView *backgroundView = [UIImageView imageViewWithImageName:@"home_control_r_bg"];
    
    // 控制相框返回首页/关闭
    UIButton *homeButton = [UIButton buttonWithImageName:@"home_back"];
    homeButton.tag = SVButtonEventHome;
    
    // 播放模式按钮
    _sortButton = [UIButton buttonWithType:0];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"home_control_button_bg"] forState:0];
    [_sortButton setImage:[UIImage imageNamed:@"home_play_cycle"] forState:0];
    [_sortButton addTarget:self action:@selector(changePlayMode) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *timeBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_control_button_bg"]];
    
    
    // 停留时长
    _timeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];
    // 设置数据源/代理
    _timeTableView.dataSource = self;
    _timeTableView.delegate = self;
    // 行高
    _timeTableView.rowHeight = kHeight(40);
    //隐藏滚动条
    _timeTableView.showsVerticalScrollIndicator = NO;
    _timeTableView.tableFooterView = [[UIView alloc] init];
    _timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _timeTableView.backgroundColor = UIColor.clearColor;
    _timeTableView.pagingEnabled = YES;
    _timeTableView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    
    
    UIButton *upButton = [self prepareButton:SVButtonEventVolumeUp imageName:@"home_control_volume_up"];
    UIButton *leftButton = [self prepareButton:SVButtonEventPrevious imageName:@"home_control_previous"];
    UIButton *bottomButton = [self prepareButton:SVButtonEventVolumeDown imageName:@"home_control_volume_down"];
    UIButton *rightButton = [self prepareButton:SVButtonEventNext imageName:@"home_control_next"];
    _playButton = [UIButton buttonWithImageName:@"home_control_play"];
    
    
    //时钟模式
    _timeModeLabel = [UILabel labelWithText:SVLocalized(@"home_controller_changeClockType_long") font:kSystemFont(14) color:UIColor.whiteColor];
    _timeModeLabel.textAlignment = NSTextAlignmentCenter;
    _timeModeLabel.hidden = YES;
    
    // 添加视图
    [self.view addSubview:dismissButton];
    [self.view addSubview:controlView];
    [self.view addSubview:changeBG];
    [self.view addSubview:playModeButton];
    [self.view addSubview:clockModeButton];
    [self.view addSubview:_playBGView];
    [_playBGView addSubview:backgroundView];
    [_playBGView addSubview:homeButton];
    [_playBGView addSubview:_sortButton];
    [_playBGView addSubview:timeBGView];
    [_playBGView addSubview:_timeTableView];
    [_playBGView addSubview:upButton];
    [_playBGView addSubview:leftButton];
    [_playBGView addSubview:bottomButton];
    [_playBGView addSubview:rightButton];
    [_playBGView addSubview:_playButton];
    [self.view addSubview:_timeModeLabel];
    // 事件
    [dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [homeButton addTarget:self action:@selector(directionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton addTarget:self action:@selector(directionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight((382)));
    }];
    
    [changeBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controlView).offset(kHeight(10));
        make.centerX.equalTo(controlView);
        make.size.mas_equalTo(CGSizeMake(kWidth(126), kWidth(44)));
    }];
    
    [playModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(changeBG).offset(kWidth(4));
        make.centerY.equalTo(changeBG);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(36)));
    }];
    
    [clockModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeBG).offset(kWidth(-4));
        make.centerY.equalTo(changeBG);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(36)));
    }];
    
    [_playBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(changeBG.mas_bottom);
    }];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(controlView).offset(kHeight(70));
    }];
    
    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(controlView);
        make.top.equalTo(backgroundView.mas_bottom).offset(kHeight(20));
    }];
    
    [_sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(40)));
        make.centerY.equalTo(homeButton);
        make.right.equalTo(homeButton.mas_left).offset(-kWidth(40));
    }];
    
    [_timeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(40)));
        make.centerY.equalTo(homeButton);
        make.left.equalTo(homeButton.mas_right).offset(kWidth(40));
    }];
    
    [timeBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_timeTableView);
    }];
    
    [upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(backgroundView);
        make.size.mas_equalTo(CGSizeMake(kHeight(50), kHeight(50)));
    }];
    
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(backgroundView);
        make.size.equalTo(upButton);
    }];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(backgroundView);
        make.size.equalTo(upButton);
    }];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(backgroundView);
        make.size.equalTo(upButton);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backgroundView);
        make.size.equalTo(upButton);
    }];
    
    [_timeModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(changeBG.mas_bottom).offset(kHeight(112));
        make.left.equalTo(self.view).offset(kHeight(12));
    }];
}

/// 创建按钮
- (UIButton *)prepareButton:(NSInteger)tag imageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithImageName:imageName];
    [button setBackgroundImage:[UIImage imageNamed:@"home_control_highlighted"] forState:UIControlStateHighlighted];
    button.tag = tag;
    
    [button addTarget:self action:@selector(directionClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// MARK: - getter/setter
- (NSArray *)timeArr {
    if(!_timeArr){
        _timeArr = @[@(3),@(5),@(10),@(15),@(30),@(60)];
    }
    return _timeArr;
}

// MARK: - dealloc
- (void)dealloc {
    [[SVMQTTManager sharedManager] removeHandler:[self hash]];
}

@end
