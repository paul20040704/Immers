//
//  SVPasswordField.m
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVPasswordField.h"
#import "SVGlobalMacro.h"

@implementation SVPasswordField {
    UILabel *_titleLabel;
    UITextField *_textField;
    
    NSString *_title;
    NSString *_placeholder;
    BOOL _secureTextEntry;
    
}

// MARK: - getter
- (NSString *)text {
    return [_textField.text trimming];
}

// MARK: - Action
- (void)secureClick:(UIButton *)button {
    button.selected = !button.selected;
    _textField.secureTextEntry = button.selected;
}

- (void)textDidChange {
    [_textField textMaxLength:kPasswordMaxLength];
}

// MARK: - 初始化
+ (instancetype)fieldWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    return [[self alloc] initWithTitle:title placeholder:placeholder secureTextEntry:NO];
}

+ (instancetype)fieldWithTitle:(NSString *)title placeholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry {
    return [[self alloc] initWithTitle:title placeholder:placeholder secureTextEntry:secureTextEntry];
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry {
    if (self = [super init]) {
        _title = title;
        _placeholder = placeholder;
        _secureTextEntry = secureTextEntry;
        [self prepareSubviews];
    }
    return self;
}

/// 子视图
- (void)prepareSubviews {
    _titleLabel = [UILabel labelWithText:_title font:kSystemFont(14) color:[UIColor grayColor6]];
    
    UIView *wrapperView = [[UIView alloc] init];
    [wrapperView corner];
    wrapperView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    
    _textField = [UITextField textFieldWithPlaceholder:_placeholder type:UIKeyboardTypeASCIICapable textColor:[UIColor grayColor4] backgroundColor:[UIColor clearColor]];
    _textField.font = kSystemFont(12);
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIButton *secureButton = [UIButton buttonWithNormalName:@"home_password_open" selectedName:@"home_password_close"];
    
    // 添加控件
    [self addSubview:_titleLabel];
    [self addSubview:wrapperView];
    [self addSubview:_textField];
    [self addSubview:secureButton];
    
    // 事件
    [secureButton addTarget:self action:@selector(secureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self secureClick:secureButton];
    
    if (_secureTextEntry) {
        [self secureClick:secureButton];
    }
    
    // 约束
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    [wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(kHeight(12));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kHeight(40));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wrapperView).insets(UIEdgeInsetsMake(0, kWidth(10), 0, kWidth(50)));
    }];
    
    [secureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(wrapperView);
        make.width.mas_equalTo(kWidth(40));
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight(72));
    }];
}

@end
