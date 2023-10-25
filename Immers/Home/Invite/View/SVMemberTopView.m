//
//  SVMemberTopView.m
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVMemberTopView.h"
#import "SVGlobalMacro.h"
@implementation SVMemberTopView{
    UILabel *_nameLabel;
    UILabel *_applyCountLabel;
    UIButton *_shareButton;
    UIButton *_inviteButton;
    UILabel *_applyListLabel;
    UIView *_applyCountBGView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self prepareSubView];
    }
    return self;
}

// MARK: - action
- (void)applyListAction {
    if(self.actionBlock){
        self.actionBlock(0);
    }
}

- (void)shareAction {
    if(self.actionBlock){
        self.actionBlock(1);
    }
}

- (void)inviteAction {
    if(self.actionBlock){
        self.actionBlock(2);
    }
}

// MARK: - Setter
- (void)setDevice:(SVDevice *)device {
    _device = device;
    _nameLabel.text = device.name;
}

- (void)setAuditNum:(NSString *)auditNum {
    _auditNum = [auditNum copy];
    _applyCountLabel.text = auditNum;
}

- (void)setCurrentRole:(NSInteger)currentRole {
    _currentRole = currentRole;
    
    _shareButton.hidden = currentRole == 3;
    _inviteButton.hidden = currentRole == 3;
    _applyListLabel.hidden = currentRole == 3;
    _applyCountBGView.hidden = currentRole == 3;
    
    if(3 == currentRole) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kHeight(160)));
        }];
        self.frame = CGRectMake(0, 0, kScreenWidth, kHeight(160));
    }
}

// MARK: - UI
- (void)prepareSubView {
    self.backgroundColor = UIColor.backgroundColor;
    
    UILabel *messageLabel = [UILabel labelWithText:SVLocalized(@"home_device_info") font:kSystemFont(14) color:UIColor.grayColor];
    [self addSubview:messageLabel];
    
    UIView *nameBGView = [[UIView alloc] init];
    [nameBGView corner];
    nameBGView.backgroundColor = UIColor.whiteColor;
    [self addSubview:nameBGView];
    
    UILabel *nameKeyLabel = [UILabel labelWithText:SVLocalized(@"home_device_name") font:kSystemFont(14) color:UIColor.textColor];
    [nameBGView addSubview:nameKeyLabel];
    
    _nameLabel = [UILabel labelWithText:@"" font:kSystemFont(14) color:UIColor.textColor];
    [nameBGView addSubview:_nameLabel];
    
    UILabel *applyListLabel = [UILabel labelWithText:SVLocalized(@"home_apply_list") font:kSystemFont(14) color:UIColor.grayColor];
    [self addSubview:applyListLabel];
    
    UIView *applyCountBGView = [[UIView alloc] init];
    [applyCountBGView corner];
    applyCountBGView.backgroundColor = UIColor.whiteColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyListAction)];
    [applyCountBGView addGestureRecognizer:tap];
    [self addSubview:applyCountBGView];
    UILabel *applyLabel = [UILabel labelWithText:SVLocalized(@"home_apply_count") font:kSystemFont(14) color:UIColor.textColor];
    _applyCountLabel = [UILabel labelWithTextColor:UIColor.redButtonColor font:kSystemFont(14)];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_more"]];
    
    [applyCountBGView addSubview:applyLabel];
    [applyCountBGView addSubview:_applyCountLabel];
    [applyCountBGView addSubview:arrow];
    
    UILabel *memberLabel = [UILabel labelWithText:SVLocalized(@"home_member_list") font:kSystemFont(14) color:UIColor.textColor];
    [self addSubview:memberLabel];
    
    UIButton *shareButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_share") titleColor:UIColor.textColor font:kSystemFont(14)];
    shareButton.backgroundColor = UIColor.whiteColor;
    shareButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [shareButton corner];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    
    UIButton *inviteButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_invite") titleColor:UIColor.whiteColor font:kSystemFont(14)];
    inviteButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [inviteButton layoutIfNeeded];
    inviteButton.backgroundColor = UIColor.grassColor;
    [inviteButton corner];
    [inviteButton addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inviteButton];
    
    _shareButton = shareButton;
    _inviteButton = inviteButton;
    _applyListLabel = applyListLabel;
    _applyCountBGView = applyCountBGView;
    
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kWidth(12));
    }];
    
    [nameBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLabel.mas_bottom).offset(kWidth(12));
        make.left.equalTo(messageLabel);
        make.right.equalTo(self).offset(-kWidth(12));
        make.height.mas_equalTo(kHeight(50));
        
    }];
    
    [nameKeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameBGView).offset(kWidth(12));
        make.centerY.equalTo(nameBGView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameBGView).offset(-kWidth(12));
        make.centerY.equalTo(nameBGView);
    }];
    
    [applyListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameBGView);
        make.top.equalTo(nameBGView.mas_bottom).offset(kHeight(12));
    }];
    
    [applyCountBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyListLabel.mas_bottom).offset(kHeight(8));
        make.left.right.equalTo(nameBGView);
        make.height.mas_equalTo(kHeight(50));
    }];
    
    [applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyCountBGView).offset(kWidth(12));
        make.centerY.equalTo(applyCountBGView);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyCountBGView);
        make.right.equalTo(applyCountBGView).offset(-kWidth(12));
    }];
    
    [_applyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow).offset(-kWidth(12));
        make.centerY.equalTo(applyCountBGView);
    }];

    [memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyCountBGView);
        make.bottom.equalTo(self).offset(-kHeight(24));
    }];
    
    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(applyCountBGView);
        make.centerY.equalTo(memberLabel);
    }];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inviteButton.mas_left).offset(-kWidth(12));
        make.centerY.equalTo(inviteButton);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.bounds.size);
    }];
}

@end
