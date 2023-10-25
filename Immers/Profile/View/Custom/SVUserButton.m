//
//  SVUserButton.m
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVUserButton.h"
#import "SVGlobalMacro.h"

@implementation SVUserButton {
    UIImageView *_avaratView;
    UIImageView *_genderView;
    UILabel *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

- (void)prepareSubviews {
    _avaratView = [UIImageView imageView];
    _genderView = [UIImageView imageView];
    _nameLabel = [UILabel labelWithTextColor:[UIColor grayColor8] font:kSystemFont(14) alignment:NSTextAlignmentCenter];
    
    [_avaratView corner];
    _avaratView.backgroundColor = [UIColor whiteColor];
    _avaratView.layer.borderWidth = 2;
    _avaratView.layer.borderColor = [UIColor grassColor].CGColor;
    
    [self addSubview:_avaratView];
    [self addSubview:_genderView];
    [self addSubview:_nameLabel];
    
    [_avaratView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kHeight(100), kHeight(100)));
    }];
    
    [_genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(_avaratView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kWidth(20), kWidth(20)));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avaratView.mas_bottom).offset(kHeight(15));
        make.centerX.width.equalTo(self);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kHeight(100), kHeight(135)));
    }];
    
    [self updateInfo];
    [self prepareNotification];
}

/// 更新用户信息
- (void)updateInfo {
    SVUserAccount *account = [SVUserAccount sharedAccount];
    [_avaratView setImageWithURL:account.userImage placeholder:[UIImage imageNamed:@"profile_avarat_normal"]];
    _genderView.image = [UIImage imageNamed:account.userSex != 0 ? @"profile_gender_male" : @"profile_gender_female"];
    _nameLabel.text = account.userName;
}

/// 注册通知
- (void)prepareNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:kEditedToUpdateUserProfileNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
