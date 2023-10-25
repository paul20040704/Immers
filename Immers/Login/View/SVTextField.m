//
//  SVTextField.m
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import "SVTextField.h"
#import "SVGlobalMacro.h"

@interface SVTextField () <UITextFieldDelegate>

@end

@implementation SVTextField {
    NSString *_leftText;
    NSString *_placeholder;
    UIKeyboardType _type;
    UITextField *_textField;
    UIColor *_textColor;
    UIColor *_placeholderColor;
    UIButton *_button;
}

// MARK: - getter
- (NSString *)text {
    return _textField.text;
}

// MARK: - setter
- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    _maxLength = maxLength;
}

// MARK: - Action
- (void)textFieldChanged {
    if (_maxLength > 0) {
        [_textField textMaxLength:_maxLength];
    }
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

// MAEK: - 初始化
+ (instancetype)textField:(NSString *)leftText placeholder:(NSString *)placeholder type:(UIKeyboardType)type {
    return [[self alloc] initWithText:leftText countryId:@"" placeholder:placeholder type:type textColor:nil placeholderColor:nil];
}

+ (instancetype)textField:(NSString *)leftText placeholder:(NSString *)placeholder type:(UIKeyboardType)type textColor:(nullable UIColor *)textColor placeholderColor:(nullable UIColor *)placeholderColor {
    return [[self alloc] initWithText:leftText countryId:@"" placeholder:placeholder type:type textColor:textColor placeholderColor:placeholderColor];
}

+ (instancetype)textField:(NSString *)leftText countryId:(NSString *)countryId  placeholder:(NSString *)placeholder type:(UIKeyboardType)type {
    return [[self alloc] initWithText:leftText countryId:countryId placeholder:placeholder type:type textColor:nil placeholderColor:nil];
}

- (instancetype)initWithText:(NSString *)leftText countryId:(NSString *)countryId placeholder:(NSString *)placeholder type:(UIKeyboardType)type textColor:(nullable UIColor *)textColor placeholderColor:(nullable UIColor *)placeholderColor {
    if (self = [super initWithFrame:CGRectZero]) {
        _leftText = leftText;
        _countryId = countryId;
        _placeholder = placeholder;
        _type = type;
        _textColor = textColor;
        _placeholderColor = placeholderColor;
        [self prepareSubviews];
    }
    return self;
}

// 准备视图
- (void)prepareSubviews {
    // 左边视图
    UIView *leftView;
    UIColor *color = _textColor ? :  [UIColor colorWithHex:0xffffff alpha:0.6];
    if (_type == UIKeyboardTypeNumberPad || _type == UIKeyboardTypePhonePad) {
        leftView = [[UIView alloc] init];
        
        // 地区码
        _button = [UIButton buttonWithTitle:_leftText titleColor:color font:kSystemFont(14)];
        UIImage *image = [UIImage imageNamed:_countryId];
        [_button setImage:[image resizeImageWithSize:CGSizeMake(28, 21)] forState:UIControlStateNormal];
        [_button resetButtonStyle:SVButtinStyleDefault space:10];
        //[_button sizeToFit];
        
        [_button addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
        
        // 竖线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHex:0xffffff alpha:0.3];
        
        // 子视图
        [self addSubview:leftView];
        [leftView addSubview:_button];
        [leftView addSubview:lineView];
        
        // 约束
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(76), kHeight(40)));
        }];
        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
            make.left.mas_equalTo(leftView.mas_left);
            make.right.mas_equalTo(lineView.mas_left);
            make.height.mas_equalTo(kHeight(20));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(leftView);
            make.size.mas_equalTo(CGSizeMake(kWidth(0.5), kHeight(30)));
        }];
    
    } else {
        // 普通文本
        leftView = [UILabel labelWithText:_leftText font:kSystemFont(14) color:color];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(76), kHeight(40)));
        }];
    }
    
    // 输入框
    _textField = [self prepareTextField];
    // 横线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = _placeholderColor ? : [UIColor colorWithHex:0xffffff];
    
    // 子视图
    [self addSubview:_textField];
    [self addSubview:lineView];
    
    // 事件
    [_textField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    // 约束
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(kWidth(12));
        make.centerY.height.equalTo(leftView);
        make.right.equalTo(self);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)buttonPress{
    if (self.codeCallback) {
        self.codeCallback();
    }
}

/// 输入框
- (UITextField *)prepareTextField {
    UITextField *textField = [UITextField textFieldWithPlaceholder:_placeholder type:_type textColor: _textColor ? : [UIColor colorWithHex:0xffffff alpha:0.9] backgroundColor:[UIColor clearColor]];
    textField.font = kSystemFont(14);
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.tintColor = [UIColor textColor];
    
    textField.secureTextEntry = _type == UIKeyboardTypeASCIICapable;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    
    // 占位文本样式
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{ NSFontAttributeName: kSystemFont(14), NSForegroundColorAttributeName: _placeholderColor ? : [UIColor colorWithHex:0xffffff alpha:0.3] }];
    
    return textField;
}

/// 修改區碼按鈕圖片文字
-(void)setButtonText:(SVCodeModel *)codeModel {
    [_button setTitle:codeModel.countryCode forState:UIControlStateNormal];
    _countryId = codeModel.countryID;
    NSString *lowercaseString = [codeModel.countryID lowercaseString];
    UIImage *image = [UIImage imageNamed:lowercaseString];
    [_button setImage:[image resizeImageWithSize:CGSizeMake(28, 21)] forState:UIControlStateNormal];
}

@end
