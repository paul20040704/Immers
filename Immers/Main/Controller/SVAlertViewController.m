//
//  SVAlertViewController.m
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import "SVAlertViewController.h"
#import "SVGlobalMacro.h"

@interface SVAlertViewController ()

@end

@implementation SVAlertViewController {
    NSString *_title; // 标题
    NSString *_message; // 内容
    NSString *_cancelText; // 取消文本
    NSString *_confirmText; // 确认文本
    
    UILabel *_titleLabel; // 标题视图
    UILabel *_messageLabel; // 内容视图
    UIButton *_cancelButton; // 取消按钮
    UIButton *_confirmButton; // 确认按钮
    
    void(^_cancelAction)(void);
    void(^_confirmAction)(void);
    void(^_closeAction)(void);
}

// MARK: - 初始化
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelText:(nullable NSString *)cancelText confirmText:(nullable NSString *)confirmText {
    return [[self alloc] initWithTitle:title message:message cancelText:cancelText confirmText:confirmText];
}

/// AlertViewController 默认样式 侧重确认按钮
+ (instancetype)defaultWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelText:(nullable NSString *)cancelText confirmText:(nullable NSString *)confirmText {
    SVAlertViewController *viewController = [self alertControllerWithTitle:title message:message cancelText:cancelText confirmText:confirmText];
    viewController.confirmTextColor = [UIColor whiteColor];
    viewController.confirmBackgroundColor = [UIColor grayColor7];
    viewController.cancelTextColor = [UIColor grayColor7];
    viewController.cancelBackgroundColor = [UIColor whiteColor];
    return viewController;
}

/// AlertViewController 默认样式 侧重取消按钮
+ (instancetype)weakWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelText:(nullable NSString *)cancelText confirmText:(nullable NSString *)confirmText {
    SVAlertViewController *viewController = [self alertControllerWithTitle:title message:message cancelText:cancelText confirmText:confirmText];
    viewController.confirmTextColor = [UIColor grayColor7];
    viewController.confirmBackgroundColor = [UIColor whiteColor];
    viewController.cancelTextColor = [UIColor whiteColor];
    viewController.cancelBackgroundColor = [UIColor grayColor7];
    return viewController;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelText:(nullable NSString *)cancelText confirmText:(nullable NSString *)confirmText {
    SVAlertViewController *viewController = [SVAlertViewController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    viewController->_title = title;
    viewController->_message = message;
    viewController->_cancelText = cancelText;
    viewController->_confirmText = confirmText;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(nil != _title || nil != _message, @"title或message不为空");
    
    [self prepareSubviews];
}

// MARK: - 公共方法
- (void)handler:(void (^)(void))cancelAction confirmAction:(void (^)(void))confirmAction {
    [self handler:cancelAction confirmAction:confirmAction closeAction:nil];
}

- (void)handler:(void (^)(void))cancelAction confirmAction:(void (^)(void))confirmAction closeAction:(void (^)(void))closeAction {
    _cancelAction = cancelAction;
    _confirmAction = confirmAction;
    _closeAction = closeAction;
}

// MARK: - Action
- (void)cancelClick {
    if(_actionFirst){
        if (_cancelAction) {
            _cancelAction();
        }
        [self dismiss];
    }else{
        [self dismiss];
        if (_cancelAction) {
            _cancelAction();
        }
    }
}

- (void)confirmClick {
    
    if(_actionFirst){
        if (_confirmAction) {
            _confirmAction();
        }
        [self dismiss];
    }else{
        [self dismiss];
        if (_confirmAction) {
            _confirmAction();
        }
    }

}

- (void)closeClick {
    [self dismiss];
    if (_closeAction) {
        _closeAction();
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
//            make.right.equalTo(wrapperView).offset(kWidth(-26));
            make.width.mas_equalTo(kWidth(215));
            make.top.equalTo(wrapperView).offset(kHeight(14));
        }];
    }
    
    if (_message && _message.length > 0) { // 内容
        if ([_message containsString:@"  "]) { // 有空格 需要 富文本
            
           __block NSRange range;
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"  .*?  "options:0 error:NULL];
            [regular enumerateMatchesInString:_message options:NSMatchingReportCompletion
            range:NSMakeRange(0, _message.length)
            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                if (0 == flags) {
                    range = result.range;
                }
            }];
            
            // 设置文本
            NSMutableAttributedString *attributedTextM = [[NSMutableAttributedString alloc] initWithString:_message attributes:@{ NSFontAttributeName : kSystemFont(12), NSForegroundColorAttributeName : [UIColor grayColor6] }];
            [attributedTextM setAttributes:@{ NSFontAttributeName : kSystemFont(12),  NSForegroundColorAttributeName : [UIColor grayColor8] } range:range];
            
            _messageLabel = [[UILabel alloc] init];
            _messageLabel.attributedText = [attributedTextM copy];
            _messageLabel.numberOfLines = 0;
        } else { // 普通文本
            _messageLabel = [UILabel labelWithText:_message font:_messageTextFont?:kSystemFont(12) color:_messageTextColor?:[UIColor grayColor6]];
        }
        _messageLabel.textAlignment = _messageAlignment;
        // 添加控件
        [wrapperView addSubview:_messageLabel];
        
        // 约束
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wrapperView).offset(kWidth(26));
            make.width.mas_equalTo(kWidth(215));
            // 有/无标题 约束
            (_title && _title.length > 0) ? make.top.equalTo(_titleLabel.mas_bottom).offset(kHeight(14)) : make.top.equalTo(wrapperView).offset(_textMinTopMargin>0?_textMinTopMargin:kHeight(22));
        }];
    }
    
    
    if (_cancelText && _cancelText.length > 0) { // 取消按钮
        UIColor *titleColor = self.cancelTextColor ? : [UIColor grayColor5];
        _cancelButton = [UIButton buttonWithTitle:_cancelText titleColor:titleColor font:kSystemFont(12)];
        _cancelButton.titleLabel.lineBreakMode = 0;
//        _cancelButton.titleEdgeInsets = UIEdgeInsetsMake(kWidth(5), kWidth(15), kWidth(5), kWidth(15));
        _cancelButton.titleLabel.numberOfLines = 2;
        // 大小/圆角/背景
        [_cancelButton sizeToFit];
        [_cancelButton corner];
        if (nil == _cancelBorderColor) {
            _cancelButton.backgroundColor = self.cancelBackgroundColor ? : [UIColor whiteColor];
        } else {
            _cancelButton.backgroundColor = self.cancelBackgroundColor ? : [UIColor whiteColor];
            _cancelButton.layer.borderWidth = 1;
            _cancelButton.layer.borderColor = _cancelBorderColor.CGColor;
        }
        
        // 添加控件
        [wrapperView addSubview:_cancelButton];
        
        // 事件
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 约束
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_buttonSize.width>0&&_buttonSize.height>0) {
                make.size.mas_equalTo(_buttonSize);
            }else{
                //make.width.lessThanOrEqualTo(wrapperView).multipliedBy(0.45);
                make.height.mas_equalTo(kHeight(30));
                make.width.mas_equalTo(_cancelButton.bounds.size.width + 30);
            }
            // 有/无确认按钮  约束在左边/中间
            (_confirmText && _confirmText.length > 0) ? make.left.equalTo(wrapperView).offset(kWidth(26)) : make.centerX.equalTo(wrapperView);
            
            if (_message && _message.length > 0) { // 有内容
                make.top.equalTo(_messageLabel.mas_bottom).offset(_buttonMinTopMargin?:kHeight(30));
                
            } else if (_title && _title.length > 0) { // 无内容 有标题
                make.top.equalTo(_titleLabel.mas_bottom).offset(_buttonMinTopMargin?:kHeight(30));
            }
        }];
    }
    
    if (_confirmText && _confirmText.length > 0) { // 确认按钮
        UIColor *titleColor = self.confirmTextColor ? : [UIColor whiteColor];
        _confirmButton = [UIButton buttonWithTitle:_confirmText titleColor:titleColor font:kSystemFont(12)];
        _confirmButton.titleLabel.lineBreakMode = 0;
        _confirmButton.titleLabel.numberOfLines = 2;
//        _confirmButton.titleEdgeInsets = UIEdgeInsetsMake(kWidth(5), kWidth(10), kWidth(5), kWidth(10));
        // 大小/圆角/背景
        [_confirmButton sizeToFit];
        [_confirmButton corner];
        _confirmButton.backgroundColor = self.confirmBackgroundColor ? : [UIColor grayColor7];
        // 添加控件
        [wrapperView addSubview:_confirmButton];

        // 事件
        [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        // 约束
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_buttonSize.width>0&&_buttonSize.height>0) {
                make.size.mas_equalTo(_buttonSize);
            }else{
                make.height.mas_equalTo(kHeight(30));
                make.width.mas_equalTo(_confirmButton.bounds.size.width + 30);
            }
            
            // 有/无取消按钮  约束在左边/中间
            (_cancelText && _cancelText.length > 0) ? make.right.equalTo(wrapperView).offset(kWidth(-26)) :  make.centerX.equalTo(wrapperView);
            if (_cancelText && _cancelText.length>0) {
                make.left.greaterThanOrEqualTo(_cancelButton.mas_right).offset(kWidth(26));
            }
            
            if (_message && _message.length > 0) {  // 有内容
                make.top.equalTo(_messageLabel.mas_bottom).offset(_buttonMinTopMargin?:kHeight(30));
                
            } else if (_title && _title.length > 0) {  // 无内容 有标题
                make.top.equalTo(_titleLabel.mas_bottom).offset(_buttonMinTopMargin?:kHeight(30));
            }
        }];
    }
    
    if (_showClose) { // 关闭按钮
        UIButton *closeButton = [UIButton buttonWithImageName:@"global_close"];
        // 添加控件
        [wrapperView addSubview:closeButton];
        // 事件
        [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        // 约束
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(wrapperView);
            make.size.mas_equalTo(CGSizeMake(kWidth(44), kWidth(30)));
        }];
    }

    // 包装视图 颜色/圆角
    wrapperView.backgroundColor = _backgroundColor ? : [UIColor colorWithHex:0x6f6f6f alpha:0.1];
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
            
        } else {  // 无取消按钮 无确认按钮
            make.bottom.equalTo(_messageLabel).offset(kHeight(20));
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad) {
            make.width.mas_equalTo(kWidth(267));
        } else {
            make.width.equalTo(self.view);
        }
    }];
    
    // 颜色/圆角
    self.view.layer.cornerRadius = kHeight(13);
    
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor backgroundColor];
    // 约束
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(wrapperView);
    }];
}

@end
