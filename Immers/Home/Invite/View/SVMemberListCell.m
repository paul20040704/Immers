//
//  SVMemberListCell.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVMemberListCell.h"

@implementation SVMemberListCell{
    UILabel *_nameLabel;
    UILabel *_accountLabel;
    UIButton *_identifyButton;
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
- (void)setMember:(SVMember *)member {
    _member = member;
    
    [_headImageView setImageWithURL:member.memberHeadUrl placeholder:[UIImage imageNamed:@"profile_avarat_normal"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", member.memberName, [member.userId isEqualToString: [SVUserAccount sharedAccount].userId] ? SVLocalized(@"home_self") : @""];
    _accountLabel.text = (member.memberEmail && member.memberEmail.length > 0) ? member.memberEmail : member.memberPhone;
    [_identifyButton setTitle:member.role forState:UIControlStateNormal];
    _identifyButton.backgroundColor = [UIColor colorWithHexString:member.roleColor];
}

// MARK: - UI
- (void)prepareSubView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = self.backgroundColor = UIColor.clearColor;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [bgView corner];
    
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_avarat_normal"]];
    _headImageView.layer.cornerRadius = kWidth(30);
    _headImageView.layer.masksToBounds = YES;
    
    _nameLabel = [UILabel labelWithText:@"" font:kSystemFont(14) color:UIColor.textColor];
    _accountLabel = [UILabel labelWithText:@"" font:kSystemFont(12) color:UIColor.textColor];
    _identifyButton = [UIButton buttonWithTitle:@"" titleColor:UIColor.whiteColor font:kSystemFont(12)];
    _identifyButton.backgroundColor = UIColor.grassColor;
    [_identifyButton corner];
    _identifyButton.enabled = NO;
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_more"]];
    [self.contentView addSubview:bgView];
    [bgView addSubview:_headImageView];
    [bgView addSubview:_nameLabel];
    [bgView addSubview:_accountLabel];
    [bgView addSubview:_identifyButton];
    [bgView addSubview:arrow];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kWidth(12));
        make.right.bottom.equalTo(self.contentView).offset(-kHeight(12));
    }];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(kWidth(12));
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(60)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(kWidth(12));
        make.top.equalTo(_headImageView).offset(kHeight(4));
    }];
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_headImageView.mas_bottom).offset(-kHeight(4));
    }];
    [_identifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(_headImageView);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kHeight(20)));
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).offset(-kWidth(12));
    }];
    
}

@end
