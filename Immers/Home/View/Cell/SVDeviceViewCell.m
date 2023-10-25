//
//  SVDeviceViewCell.m
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVDeviceViewCell.h"

@implementation SVDeviceViewCell {
    UIImageView *_coverView;
    UILabel *_nameLabel;
    UIButton *_stateButton;
}

// MARK: - setter
- (void)setDevice:(SVDevice *)device {
    _device = device;
    _nameLabel.text = device.name;
    _stateButton.selected = device.onlineStatus;
    [_coverView setImageWithURL:device.imageUrl placeholder:[UIImage imageNamed:@"home_device_empty"]];
    self.contentView.layer.borderColor = (device.selected && device.onlineStatus) ? [UIColor grassColor].CGColor : [UIColor clearColor].CGColor;
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
 
    _coverView = [UIImageView imageView];
    _coverView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.alpha = 0.8;
    
    _nameLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(14/kDeviceScale)];
    _stateButton = [UIButton buttonWithNormalName:@"home_device_disconnect" selectedName:@"home_device_connected"];
    
    [self.contentView addSubview:_coverView];
    [self.contentView addSubview:visualView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_stateButton];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight(44/kDeviceScale));
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(visualView);
        make.left.mas_equalTo(kWidth(12));
        make.centerX.equalTo(visualView);
    }];
    
    [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(visualView);
        make.right.mas_equalTo(kWidth(-12));
    }];
}

@end
