//
//  SVPhotoFrameCell.m
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import "SVPhotoFrameCell.h"

@implementation SVPhotoFrameCell {
    UIImageView *_coverView;
    UILabel *_nameLabel;
    UIButton *_stateButton;
    UIButton *_selectButton;
}

// MARK: - setter
- (void)setDevice:(SVDevice *)device {
    _device = device;
    _nameLabel.text = device.name;
    _stateButton.selected = device.onlineStatus;
    _selectButton.selected = device.selected;
    [_coverView setImageWithURL:device.imageUrl placeholder:[UIImage imageNamed:@"home_device_empty"]];
    self.contentView.layer.borderColor = (device.selected && device.onlineStatus) ? [UIColor grassColor].CGColor : [UIColor clearColor].CGColor;
}

// MARK: - Action
- (void)selectClick {
    self.device.selected = !self.device.selected;
    if (self.selectedCallback) {
        self.selectedCallback(self.device);
    }
}

// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    [self.contentView corner];
    self.contentView.layer.borderWidth = kWidth(2);
    self.contentView.backgroundColor = [UIColor backgroundColor];
 
    // 创建子控件
    _coverView = [UIImageView imageView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.alpha = 0.8;
    
    _nameLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(12)];
    _stateButton = [UIButton buttonWithNormalName:@"home_device_disconnect" selectedName:@"home_device_connected"];
    _selectButton = [UIButton buttonWithNormalName:@"home_frame_normal" selectedName:@"home_frame_selected"];
    
    // 添加子控件
    [self.contentView addSubview:_coverView];
    [self.contentView addSubview:visualView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_stateButton];
    [self.contentView addSubview:_selectButton];
    
    // 事件
    [_selectButton addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight(34));
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(visualView);
        make.left.mas_equalTo(kWidth(12));
        make.width.mas_equalTo(self.contentView.bounds.size.width * 0.7);
    }];
    
    [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(visualView);
        make.right.mas_equalTo(kWidth(-12));
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kWidth(34), kWidth(34)));
    }];
}

@end
