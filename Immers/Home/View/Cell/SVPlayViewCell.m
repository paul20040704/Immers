//
//  SVPlayViewCell.m
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import "SVPlayViewCell.h"

@implementation SVPlayViewCell {
    UIImageView *_iconView; // 图标
    UILabel *_titleLabel; // 标题
    UILabel *_textLabel; // 文本
}

// MARK: - setter
- (void)setItem:(SVPlayItem *)item {
    _item = item;
    
    if (item.icon && item.icon.length > 0) {
        NSString *status = item.selected ? @"selected" : @"normal";
        _iconView.image = [UIImage imageNamed:_item.icon];
        _iconView.hidden = NO;
        _iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_play_%@_%@", item.icon, status]];
    } else {
        _iconView.hidden = YES;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView);
        }];
    }
    
    _titleLabel.textColor = item.selected ? [UIColor grassColor3] : [UIColor grayColor7];
    _titleLabel.text = item.title;
    _textLabel.text = item.text;
}


// MARK: - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareSubviews {
    _iconView = [UIImageView imageView];
    _titleLabel = [UILabel labelWithTextColor:[UIColor grayColor7] font:kSystemFont(14)];
    _textLabel = [UILabel labelWithTextColor:[UIColor grayColor4] font:kSystemFont(12)];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_textLabel];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidthSpace);
        make.centerY.equalTo(self.contentView);
        if (kScreenWidth > kScreenHeight) { // iPad 横屏的情况
            make.size.mas_equalTo(CGSizeMake(kWidth(18), kWidth(18)));
        } else {
            make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(30)));
        }
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_iconView).offset(kWidth(40));
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-kWidthSpace);
    }];
}

@end
