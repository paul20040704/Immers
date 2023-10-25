//
//  SVInviteViewCell.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVInviteViewCell.h"

@implementation SVInviteViewCell {
    UIView *_bgView;
    UILabel *_contentLabel;
    UIButton *_refuseBtn;
    UIButton *_agreeBtn;
    UILabel *_operatorLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// MARK: - Setter
- (void)setInvite:(SVInvite *)invite {
    _invite = invite;
    _contentLabel.text = [NSString stringWithFormat:SVLocalized(@"home_member_invite_title"), invite.inviterName, invite.framePhotoName];
    
    // 0: 待答复 1:同意 2:拒绝
    if (0 == invite.status) {
        _refuseBtn.hidden = NO;
        _agreeBtn.hidden = NO;
        _operatorLabel.hidden = YES;
    } else {
        if (1 == invite.status) {
            _operatorLabel.text = SVLocalized(@"home_member_apply_agreed");
            _operatorLabel.textColor = [UIColor grassColor];
        } else {
            _operatorLabel.text = SVLocalized(@"home_member_refused");
            _operatorLabel.textColor = [UIColor redColor];
        }
        _operatorLabel.hidden = NO;
        _refuseBtn.hidden = YES;
        _agreeBtn.hidden = YES;
    }
}

// MARK: - UI
- (void)prepareSubviews {
    self.backgroundColor = self.contentView.backgroundColor = UIColor.clearColor;
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [_bgView corner];
    _bgView.backgroundColor = UIColor.whiteColor;
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.textColor = UIColor.grayColor8;
    _contentLabel.font = kSystemFont(16);
    _contentLabel.numberOfLines = 2;
//    _contentLabel.text = @"xxx相框邀请你进入他的相框 Holos12 中，请同意或者拒绝";
    
    _refuseBtn = [UIButton buttonWithTitle:SVLocalized(@"home_member_refuse") titleColor:UIColor.grayColor8 font:kSystemFont(14)];
    _refuseBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    _refuseBtn.backgroundColor = UIColor.backgroundColor;
    [_refuseBtn corner];
    [_refuseBtn addTarget:self action:@selector(refuseAction) forControlEvents:UIControlEventTouchUpInside];
    _refuseBtn.hidden = YES;
    
    _agreeBtn = [UIButton buttonWithTitle:SVLocalized(@"home_member_apply_agree") titleColor:UIColor.whiteColor font:kSystemFont(14)];
    _agreeBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    _agreeBtn.backgroundColor = UIColor.grassColor;
    [_agreeBtn corner];
    [_agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    _agreeBtn.hidden = YES;
    
    _operatorLabel = [UILabel labelWithText:@"" font:kSystemFont(12) color:UIColor.grayColor7];
    _operatorLabel.hidden = YES;
    
    [self.contentView addSubview:_bgView];
    [_bgView addSubview:_contentLabel];
    [_bgView addSubview:_agreeBtn];
    [_bgView addSubview:_refuseBtn];
    [_bgView addSubview:_operatorLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(kWidth(12));
        make.right.bottom.equalTo(self.contentView).offset(-kWidth(12));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_bgView).offset(kWidth(12));
        make.right.equalTo(_bgView).offset(-kWidth(12));
    }];
    
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(_bgView).offset(kWidth(-12));
    }];
    
    [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_agreeBtn);
        make.right.equalTo(_agreeBtn.mas_left).offset(kWidth(-36));
    }];
    
    [_operatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgView).offset(kWidth(-12));
        make.right.equalTo(_bgView).offset(kWidth(-24));
    }];
}

- (void)refuseAction {
    if(self.actionBlock){
        self.actionBlock(2);
    }
}

- (void)agreeAction {
    if(self.actionBlock){
        self.actionBlock(1);
    }
}

// MARK: - setter

@end
