//
//  SVAccountViewCell.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVAccountViewCell.h"

// MARK: - 帐号Cell
@implementation SVAccountViewCell {
    UILabel *_titleLabel;
}

// MARK: - setter
- (void)setItem:(SVAccountItem *)item {
    _item = item;
    _titleLabel.text = item.title;
    _titleLabel.textColor = item.enabled ? [UIColor grayColor7] : [UIColor grayColor4];
}

// MARK: - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    // 标题
    _titleLabel = [UILabel labelWithTextColor:[UIColor grayColor7] font:kSystemFont(14)];
    
    // 添加子控件
    [self.contentView addSubview:_titleLabel];
    
    // 约束
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(24));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(kWidth(200));
    }];
}

@end

// MARK: - 文本Cell
@implementation SVTextViewCell {
    UILabel *_textLabel;
}

// MARK: - setter
- (void)setItem:(SVAccountItem *)item {
    [super setItem:item];
    _textLabel.text = item.text;
    _textLabel.textColor = item.enabled ? [UIColor grayColor7] : [UIColor grayColor4];
    
    self.selectionStyle = item.enabled ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
}

/// 子视图
- (void)prepareSubviews {
    [super prepareSubviews];
    
    // 文本
    _textLabel = [UILabel labelWithTextColor:[UIColor grayColor7] font:kSystemFont(14) alignment:NSTextAlignmentRight];
    
    // 添加文本
    [self.contentView addSubview:_textLabel];
    
    // 约束
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(kWidth(-24));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(kWidth(200));
    }];
}

@end

// MARK: - 图标Cell
@implementation SVIconViewCell {
    UIImageView *_iconView;
}

// MARK: - setter
- (void)setItem:(SVAccountItem *)item {
    [super setItem:item];
    if ([item.icon hasPrefix:@"http"] || [item.title isEqualToString:SVLocalized(@"profile_avarat")] ) {
        [_iconView setImageWithURL:item.icon placeholder:[UIImage imageNamed:@"profile_avarat_normal"]];
        [_iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kHeight(26), kHeight(26)));
        }];
        
    } else {
        if (nil == item.icon || item.icon.length <= 0) {
            return;
        }
        _iconView.image = [UIImage imageNamed:item.icon];
        [_iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kHeight(20), kHeight(20)));
        }];
    }
}

/// 子视图
- (void)prepareSubviews {
    [super prepareSubviews];
    
    // 图标
    _iconView = [UIImageView imageView];
    [_iconView corner];
    
    // 添加图标
    [self.contentView addSubview:_iconView];
    
    // 约束
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(kWidth(-24));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kHeight(26), kHeight(26)));
    }];
}

@end


@implementation SVLanguageViewCell {
    UIImageView *_stateView;
}

// MARK: - setter
- (void)setItem:(SVAccountItem *)item {
    [super setItem:item];
    _stateView.hidden = nil == item.text;
}

/// 子视图
- (void)prepareSubviews {
    [super prepareSubviews];
    _stateView = [UIImageView imageViewWithImageName:@"profile_selected_language"];
    _stateView.hidden = YES;
    
    [self.contentView addSubview:_stateView];
    
    [_stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(kWidth(-24));
    }];
}

@end
