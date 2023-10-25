//
//  SVWiFiViewCell.m
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVWiFiViewCell.h"

@implementation SVWiFiViewCell {
    UILabel *_nameLabel;
    UIImageView *_strengthView;
}

// MARK: - setter
- (void)setSsid:(SVWiFi *)ssid {
    _ssid = ssid;
    _nameLabel.text = ssid.SSID;
    if (ssid.current) {
        _strengthView.image = [UIImage imageNamed:@"home_current_wifi"];
        [_strengthView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWidth(14), kWidth(10)));
        }];
        
    } else {
        _strengthView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_wifi_level_%@", ssid.level]];
        [_strengthView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWidth(18), kWidth(18)));
        }];
    }
}

// MARK: - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    _nameLabel = [UILabel labelWithTextColor:[UIColor grayColor7] font:kSystemFont(14)];
    _strengthView = [UIImageView imageView];
    
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_strengthView];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(45));
        make.centerY.equalTo(self.contentView);
    }];
    
    [_strengthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(kWidth(-45));
        make.centerY.equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(kWidth(18), kWidth(18)));
    }];
}

@end
