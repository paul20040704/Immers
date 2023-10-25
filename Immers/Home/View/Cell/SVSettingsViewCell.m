//
//  SVSettingViewCell.m
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVSettingsViewCell.h"

@implementation SVSettingsViewCell {
    UILabel *_titleLabel;
    UILabel *_textLabel;
}


// MARK: - Setting
- (void)setSettings:(SVSettings *)settings {
    _settings = settings;
    _titleLabel.text = settings.title;
    _textLabel.text = settings.text;
}

// MARK: - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    _titleLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(16)];
    _textLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(16) alignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_textLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.contentView);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(kWidth(240));
    }];
}

@end
