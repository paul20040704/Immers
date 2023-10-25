//
//  SVSheetViewCell.m
//  Immers
//
//  Created by developer on 2022/5/21.
//

#import "SVSheetViewCell.h"

@implementation SVSheetViewCell {
    UIImageView *_iconView;
    UILabel *_textLabel;
}

// MARK: - setting
- (void)setItem:(SVSheetItem *)item {
    _item = item;
    
    if (item.icon && item.icon.length > 0) {
        _iconView.image = [UIImage imageNamed:item.icon];
        _iconView.hidden = NO;
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).offset(kWidth(12));
        }];
    } else {
        _iconView.hidden = YES;
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
    }
    
    _textLabel.text = item.text;
    _textLabel.textColor = item.textColor ? : [UIColor whiteColor];
    
    if (item.selected) {
        _textLabel.textColor = item.selectedColor ? : [UIColor whiteColor];
    }
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

// 子视图
- (void)prepareSubviews {
    _iconView = [UIImageView imageView];
    _textLabel = [UILabel labelWithTextColor:[UIColor textColor] font:kSystemFont(16)];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_textLabel];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_textLabel.mas_left).offset(kWidth(-5));
//        make.centerX.equalTo(self.contentView).offset(kWidth(-24));
        make.size.mas_equalTo(CGSizeMake(kWidth(24), kWidth(24)));
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(kWidth(24));
    }];
}

@end
