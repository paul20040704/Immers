//
//  SVPhotoFrameView.m
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import "SVPhotoFrameView.h"

@implementation SVPhotoFrameView {
    UIButton *_allButton;
    UIButton *_submitButton;
}

/// MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareSubviews];
    }
    return self;
}

// MARK: - setting
- (void)setSelectAll:(BOOL)selectAll {
    _selectAll = selectAll;
    _allButton.selected = selectAll;
}

- (void)setSubmitAble:(BOOL)submitAble {
    _submitAble = submitAble;
    _submitButton.enabled = submitAble;
    
}

- (void)setSelectAble:(BOOL)selectAble {
    _selectAble = selectAble;
    _allButton.enabled = selectAble;
}

// MARK: - Action
- (void)submitClick {
    if (self.frameEventCallback) {
        self.frameEventCallback(_eventType);
    }
}

- (void)allClick:(UIButton *)button {
    if (self.frameEventCallback) {
        self.frameEventCallback(button.selected ? SVButtonEventUnselected : SVButtonEventSelectAll);
    }
}

/// 准备视图
- (void)prepareSubviews {
    self.backgroundColor = [UIColor colorWithHex:0x5C5C5C];
    
    // 子视图
    UILabel *titleLabel = [UILabel labelWithText:SVLocalized(@"home_upload_to") font:kBoldFont(16) color:[UIColor whiteColor]];
    _allButton = [UIButton buttonWithTitle:SVLocalized(@"home_select_all") selectedTitle:SVLocalized(@"home_cancel_select") normalColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] font:kSystemFont(14)];
    
    [_allButton sizeToFit];
    _allButton.backgroundColor = [UIColor disableColor];
    [_allButton corner];
    _submitButton = [UIButton buttonWithTitle:@"" titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    _submitButton.backgroundColor = [UIColor blackColor];
    [_submitButton setBackgroundColor:[UIColor disableColor] forState:UIControlStateDisabled];
    [_submitButton corner];
    
    // 添加视图
    [self addSubview:titleLabel];
    [self addSubview:_allButton];
    [self addSubview:_submitButton];
    
    // 事件
    [_allButton addTarget:self action:@selector(allClick:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kWidth(24));
    }];
    
    [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(self).offset(kWidth(-24));
        make.width.mas_equalTo(_allButton.bounds.size.width+kWidth(36));
    }];
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(40));
        make.right.equalTo(self).offset(kWidth(-40));
        make.bottom.equalTo(self).offset(-kSafeAreaBottom-kHeight(28));
        make.height.mas_equalTo(kHeight(48));
    }];
}

- (void)setEventType:(SVButtonEvent)eventType {
    _eventType = eventType;
    NSString *buttonTitle = (_eventType == SVButtonEventUpload)?SVLocalized(@"home_upload_text"):SVLocalized(@"home_download");
    [_submitButton setTitle:buttonTitle forState:0];
    
}
@end
