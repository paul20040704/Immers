//
//  SVSectionHeaderView.m
//  Immers
//
//  Created by developer on 2022/5/19.
//

#import "SVSectionHeaderView.h"

@implementation SVSectionHeaderView {
    UILabel *_titleLabel;
}

// MARK: - setter
- (void)setTitle:(NSString *)title {
    _title = [title copy];
    _titleLabel.text = title;
}

// MARK: - 初始化
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
//        self.tintColor = [UIColor redColor];
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = [UIColor colorWithHex:0x000000 alpha:0.1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 10;
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    _titleLabel = [UILabel labelWithTextColor:[UIColor grayColor4] font:kSystemFont(14)];
    
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidthSpace);
        make.centerY.equalTo(self);
    }];
}

@end
