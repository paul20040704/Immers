//
//  SVMemberApplyCell.m
//  Immers
//
//  Created by developer on 2023/2/22.
//

#import "SVMemberApplyCell.h"

@implementation SVMemberApplyCell{
    UILabel *_nameLabel;
    UILabel *_accountLabel;
    UIImageView *_arrow;
//    UILabel *_applyTime;
    UIImageView *_headImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style
                   reuseIdentifier:reuseIdentifier]){
        [self prepareSubView];
    }
    return self;
}

// MARK: - Setter
- (void)setApply:(SVApply *)apply {
    _apply = apply;
    
    _nameLabel.text = apply.applyName;
    _accountLabel.text = (apply.applyEmail && apply.applyEmail.length > 0) ? apply.applyEmail : apply.applyPhone;
    [_headImageView setImageWithURL:apply.applyHeadUrl placeholder:[UIImage imageNamed:@"profile_avarat_normal"]];
}

- (void)setShowArrow:(BOOL)showArrow {
    _showArrow = showArrow;
    _arrow.hidden = showArrow;
}

// MARK: - UI
- (void)prepareSubView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = self.backgroundColor = UIColor.clearColor;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [bgView corner];
    
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_avarat_normal"]];
    _nameLabel = [UILabel labelWithText:@"" font:kSystemFont(14) color:UIColor.textColor];
    _accountLabel = [UILabel labelWithText:@"" font:kSystemFont(14) color:UIColor.textColor];

    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_more"]];
    [self.contentView addSubview:bgView];
    [bgView addSubview:_headImageView];
    [bgView addSubview:_nameLabel];
    [bgView addSubview:_accountLabel];
    [bgView addSubview:_arrow];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(kWidth(12));
        make.right.bottom.equalTo(self.contentView).offset(-kHeight(12));
    }];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(kWidth(12));
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(60)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(kWidth(12));
        make.top.equalTo(_headImageView).offset(kHeight(8));
    }];
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_headImageView.mas_bottom).offset(-kHeight(8));
    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).offset(-kWidth(12));
    }];
}

@end
