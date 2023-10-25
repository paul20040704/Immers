//
//  SVDeviceEventView.m
//  Immers
//
//  Created by ssv on 2022/11/10.
//

#import "SVDeviceEventView.h"
#import "SVGlobalMacro.h"
@implementation SVDeviceEventView
{
    SVEventButton *_controlButton; // 控制按钮
    SVEventButton *_settingButton; // 设置按钮
    SVEventButton *_fileButton; // 文件管理按钮
    SVEventButton *_playButton; // 播放列表按钮
    SVEventButton *_taskButton; // 任务中心按钮
    SVEventButton *_manageButton;// 使用管理按钮
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        [self prepareSubviews];
    }
    return self;
}

- (void)prepareSubviews {
    // 控制按钮 /任务中心 / 设置按钮 / 文件管理 / 播放按钮
    NSArray <NSDictionary *> *list = @[
        @{ @"title" : SVLocalized(@"home_control"), @"imageName" : @"home_action_control"},
        @{ @"title" : SVLocalized(@"home_task_center"), @"imageName" : @"home_action_task"},
        @{ @"title" : SVLocalized(@"home_set_up"), @"imageName" : @"home_action_settings"},
        @{ @"title" : SVLocalized(@"home_file_manager"), @"imageName" : @"home_action_file"},
        @{ @"title" : SVLocalized(@"home_play_list"), @"imageName" : @"home_action_list"},
        @{ @"title" : SVLocalized(@"home_use_manager"), @"imageName" : @"home_action_manage"}];
    
    NSMutableArray <UIButton *> *row1s = [NSMutableArray arrayWithCapacity:6];
    for (NSInteger index = 0; index < list.count; index++) {
        NSDictionary *dict = list[index];
        NSInteger type = index==0?1:0;
        SVEventButton *button = [SVEventButton buttonWithTitle:dict[@"title"] imageName:dict[@"imageName"] sizeType:type];
        button.tag = 100+index;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:button];
        if (index >= 2 && index<5) {
            [row1s addObject:button];
        }
        if (0 == index) {
            _controlButton = button;
        } else if (1 == index) {
            _taskButton = button;
        } else if (2 == index) {
            _settingButton = button;
        } else if (3 == index) {
            _fileButton = button;
        } else if (4 == index) {
            _playButton = button;
        } else if (5 == index) {
            _manageButton = button;
        }
    }
    [_controlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(170), kHeight(68)));
        make.left.top.equalTo(self).offset(kWidth(24));
        
    }];
    [_taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(170), kHeight(68)));
        make.left.equalTo(_controlButton);
        make.top.equalTo(_controlButton.mas_bottom).offset(kHeight(8));
    }];
    [_manageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(170), kHeight(68)));
        make.left.equalTo(_taskButton);
        make.top.equalTo(_taskButton.mas_bottom).offset(kHeight(8));
    }];
    [row1s mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:kHeight(8) leadSpacing:kWidth(24) tailSpacing:kWidth(88)];
    [row1s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(170), kHeight(68)));
        make.left.equalTo(_controlButton.mas_right).offset(kWidth(12));
    }];
}

- (void)buttonClick:(UIControl *)sender{
    if (self.clickAction){
        self.clickAction(sender.tag-100);
    }
}

- (void)setTaskCount:(NSInteger)taskCount {
    _taskCount = taskCount;
    _taskButton.count = taskCount;
}
@end
