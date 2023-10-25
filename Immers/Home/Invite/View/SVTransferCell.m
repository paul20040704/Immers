//
//  SVTransferCell.m
//  Immers
//
//  Created by developer on 2023/3/13.
//

#import "SVTransferCell.h"

@implementation SVTransferCell {
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    UILabel *_accountLabel;
    UIButton *_transferButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
    }
    return self;
}

// MARK: - Setter
- (void)setMember:(SVMember *)member {
    _member = member;
    
    [_avatarView setImageWithURL:member.memberHeadUrl placeholder:nil];
    _nameLabel.text = member.memberName;
    _accountLabel.text = member.memberEmail ? : member.memberPhone;
}

// MARK: - Action
- (void)transferClick {
    if (self.transferAction) {
        self.transferAction(self.member);
    }
}

// MARK: - UI
- (void)prepareSubviews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = self.backgroundColor = UIColor.clearColor;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [bgView corner];
    
    _avatarView = [UIImageView imageView];
    _avatarView.backgroundColor = [UIColor backgroundColor];
    _avatarView.layer.cornerRadius = kHeight(30);
    _avatarView.layer.masksToBounds = YES;
    
    _nameLabel = [UILabel labelWithTextColor:[UIColor grayColor8] font:kSystemFont(14)];
    _accountLabel = [UILabel labelWithTextColor:[UIColor grayColor8] font:kSystemFont(14)];
    _transferButton = [UIButton buttonWithTitle:@"home_member_transfer" titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    _transferButton.backgroundColor = [UIColor grassColor];
    [_transferButton corner];
    
    [self.contentView addSubview:bgView];
    [self.contentView addSubview:_avatarView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_accountLabel];
    [self.contentView addSubview:_transferButton];
    [self.contentView addSubview:_transferButton];
    
    [_transferButton addTarget:self action:@selector(transferClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kHeight(15), kHeight(15), kHeight(15)));
    }];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kHeight(60), kHeight(60)));
        make.left.equalTo(bgView).offset(kHeight(15));
        make.centerY.equalTo(bgView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarView.mas_right).offset(kWidth(15));
        make.top.equalTo(_avatarView);
    }];
    
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_avatarView);
    }];
    
    [_transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kHeight(80), kHeight(30)));
        make.right.equalTo(bgView).offset(kHeight(-15));
        make.centerY.equalTo(bgView);
    }];
}

@end
