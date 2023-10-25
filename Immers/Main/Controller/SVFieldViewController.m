//
//  SVFieldViewController.m
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVFieldViewController.h"
#import "SVGlobalMacro.h"

@interface SVFieldViewController () <UITextFieldDelegate>

@end

@implementation SVFieldViewController {
    NSString *_title; // 标题
    NSString *_placeholder; // 占位
    NSString *_cancelText; // 取消文本
    NSString *_confirmText; // 确认文本
    
    UILabel *_titleLabel; // 标题视图
    UIButton *_cancelButton; // 取消按钮
    UIButton *_confirmButton; // 确认按钮
    UITextField *_textField; // 输入框
    
    void(^_cancelAction)(void);
    void(^_confirmAction)(NSString *text);
}

// MARK: - 初始化
+ (instancetype)fieldControllerWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancelText:(nullable NSString *)cancelText confirmText:(NSString *)confirmText {
    return [[self alloc] initWithTitle:title placeholder:placeholder cancelText:cancelText confirmText:confirmText];
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder cancelText:(nullable NSString *)cancelText confirmText:(NSString *)confirmText {
    SVFieldViewController *viewController = [SVFieldViewController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    viewController->_title = title;
    viewController->_placeholder = ((placeholder.length == 0) || nil == placeholder) ? SVLocalized(@"login_please_enter") : placeholder;
    viewController->_cancelText = cancelText;
    viewController->_confirmText = ((confirmText.length == 0) || nil == confirmText) ? SVLocalized(@"login_yes") : confirmText;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

// MARK: - 公共方法
- (void)handler:(void (^)(void))cancelAction confirmAction:(void (^)(NSString *text))confirmAction {
    _cancelAction = cancelAction;
    _confirmAction = confirmAction;
}

// MARK: - Action
- (void)cancelClick {
    if (_cancelAction) {
        _cancelAction();
    }
    
    [self closeClick];
}

- (void)confirmClick {
    NSString *text = [_textField.text trimming];
    if (text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_valid_text")];
        return;
    }
    if (_confirmAction) {
        _confirmAction(text);
    }
    [self closeClick];
}

- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

// 子控件
- (void)prepareSubviews {
    UIView *wrapperView = [[UIView alloc] init];
    
    if (_title && _title.length > 0) { // 标题
        UIColor *color = _titleTextColor ? : [UIColor grayColor6];
        _titleLabel = [UILabel labelWithText:_title font:kBoldFont(14) color:color];
        [wrapperView addSubview:_titleLabel];
        
        // 约束
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wrapperView).offset(kWidth(26));
            make.top.equalTo(wrapperView).offset(kHeight(13));
        }];
    }
    
    _textField = [UITextField textFieldWithPlaceholder:_placeholder type:UIKeyboardTypeDefault textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    _textField.textColor = [UIColor grayColor6];
    _textField.tintColor = _textField.textColor;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
//    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth(10), 1)];
    [wrapperView addSubview:_textField];
    
    // 事件
    [_textField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [wrapperView addSubview:lineView];
    
    // 约束
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wrapperView).offset(kWidth(26));
        make.width.mas_equalTo(kWidth(194));
        make.height.mas_equalTo(kHeight(34));
        if (_title && _title.length > 0) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(kHeight(13));
        } else {
            make.top.equalTo(wrapperView).offset(kHeight(13));
        }
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_textField);
        make.top.equalTo(_textField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    if (_confirmText && _confirmText.length > 0) { // 确认按钮
        UIColor *titleColor = self.confirmTextColor ? : [UIColor whiteColor];
        _confirmButton = [UIButton buttonWithTitle:_confirmText titleColor:titleColor font:kSystemFont(12)];
        // 大小/圆角/背景
        [_confirmButton sizeToFit];
        [_confirmButton corner];
        _confirmButton.backgroundColor = self.confirmBackgroundColor ? : [UIColor grayColor8];
        // 添加控件
        [wrapperView addSubview:_confirmButton];

        // 事件
        [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        // 约束
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kHeight(30));
            make.width.mas_equalTo(_confirmButton.bounds.size.width + 30);
            make.right.equalTo(wrapperView).offset(kWidth(-26));
            make.top.equalTo(_textField.mas_bottom).offset(kHeight(20));
        }];
    }
    
    if (_cancelText && _cancelText.length > 0) { // 取消按钮
        UIColor *titleColor = self.cancelTextColor ? : [UIColor grayColor5];
        _cancelButton = [UIButton buttonWithTitle:_cancelText titleColor:titleColor font:kSystemFont(12)];
        // 大小/圆角/背景
        [_cancelButton sizeToFit];
        [_cancelButton corner];
        if (nil == _cancelBorderColor) {
            _cancelButton.backgroundColor = self.cancelBackgroundColor ? : [UIColor whiteColor];
        } else {
            _cancelButton.layer.borderWidth = 1;
            _cancelButton.layer.borderColor = _cancelBorderColor.CGColor;
        }
        
        // 添加控件
        [wrapperView addSubview:_cancelButton];
        
        // 事件
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 约束
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kHeight(30));
            make.width.mas_equalTo(_cancelButton.bounds.size.width + 30);
            make.right.equalTo(_confirmButton.mas_left).offset(kWidth(-26));
            make.centerY.equalTo(_confirmButton);
            
        }];
    }
    
    if (_showClose) { // 关闭按钮
        UIButton *closeButton = [UIButton buttonWithImageName:@"global_close"];
//        UIButton *closeButton = [UIButton buttonWithTitle:@"X" titleColor:[UIColor whiteColor] font:kSystemFont(14)];
        // 添加控件
        [wrapperView addSubview:closeButton];
        // 事件
        [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        // 约束
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(wrapperView);
            make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(30)));
        }];
    }

    // 包装视图 颜色/圆角
    wrapperView.backgroundColor = _backgroundColor ? : [UIColor colorWithHex:0x6f6f6f alpha:0.1];
    [wrapperView corner];
    // 添加控件
    [self.view addSubview:wrapperView];
    
    // 约束
    [wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        // 底部约束
        if (_cancelText && _cancelText.length > 0) { // 有取消按钮
            make.bottom.equalTo(_cancelButton).offset(kHeight(20));
            
        } else if (_confirmText && _confirmText.length > 0) { // 无取消按钮 有确认按钮
            make.bottom.equalTo(_confirmButton).offset(kHeight(20));
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad) {
            make.width.mas_equalTo(kWidth(200));
        } else {
            make.width.equalTo(self.view);
        }
    }];
    
    // 颜色/圆角
    self.view.layer.cornerRadius = kHeight(13);
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = _backgroundColor ? : [UIColor backgroundColor];
    // 约束
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(wrapperView);
    }];
}

@end
