//
//  SVProfileViewCell.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVProfileViewCell.h"

@implementation SVProfileViewCell {
    UIImageView *_iconView;
    UILabel *_countLabel;
}

// MARK: - setter
- (void)setItem:(SVProfileItem *)item {
    _item = item;
    _iconView.image = [UIImage imageNamed:item.icon];
    _titleLabel.text = item.title;
    
    _countLabel.hidden = item.count <= 0;
    _countLabel.text = [NSString stringWithFormat:@" %ld ", item.count];
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
    /// 控件
    _iconView = [UIImageView imageView];
    _titleLabel = [UILabel labelWithTextColor:[UIColor grayColor7] font:kSystemFont(14)];
    
    _countLabel = [UILabel labelWithTextColor:[UIColor whiteColor] font:kSystemFont(12)];
    _countLabel.backgroundColor = [UIColor redColor];
    [_countLabel corner];

    // 添加控件
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_countLabel];
    
    // 约束
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(24));
        make.centerY.equalTo(self.contentView);
        if (kScreenWidth > kScreenHeight) { // iPad 横屏的情况
            make.size.mas_equalTo(CGSizeMake(kWidth(16), kWidth(16)));
        } else {
            make.size.mas_equalTo(CGSizeMake(kWidth(26), kWidth(26)));
        }
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_iconView.mas_right).offset(kWidth(24));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(kHeight(14));
        make.left.equalTo(_titleLabel.mas_right).offset(kWidth(6));
    }];
}

@end

@implementation SVUpdateViewCell {
    UIImageView *_stateView;
}

// MARK: - setter
- (void)setItem:(SVProfileItem *)item {
    [super setItem:item];
    _stateView.hidden = !item.update;
}

/// 子视图
- (void)prepareSubviews {
    [super prepareSubviews];
    _stateView = [UIImageView imageViewWithImageName:@"profile_has_update"];
    _stateView.hidden = YES;
    
    [self.contentView addSubview:_stateView];
    
    [_stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right).offset(kWidth(12));
    }];
}

@end


@implementation SVSubtextViewCell {
    UILabel *_textLabel;
}

// MARK: - setter
- (void)setItem:(SVProfileItem *)item {
    [super setItem:item];
    _textLabel.text = item.text;
}

/// 子视图
- (void)prepareSubviews {
    [super prepareSubviews];
    _textLabel = [UILabel labelWithTextColor:[UIColor grayColor5] font:kSystemFont(12)];
    
    [self.contentView addSubview:_textLabel];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(kWidth(-24));
    }];
}

@end
