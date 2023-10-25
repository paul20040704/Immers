//
//  SVFeedbackViewController.m
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVFeedbackViewController.h"
#import "SVAppViewModel.h"

static NSInteger const kFeedbackMaxCount = 300;

@interface SVFeedbackViewController () <UITextViewDelegate>

@property (nonatomic, strong) SVAppViewModel *viewModel;

@end

@implementation SVFeedbackViewController {
    UITextView *_textView;
    UILabel *_countLabel;
    UIButton *_submitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_feedback");
    
    [self prepareSubviews];
}

// MARK: - Action
- (void)submitClick {
    NSString *text = [_textView.text trimming];
    if (text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"profile_feedback_content")];
        return;
    }
    [self.view endEditing:YES];
    
    kShowLoading
    NSDictionary *dict = @{ @"content" : text };
    [self.viewModel feedBack:dict completion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        kDismissLoading
        [SVProgressHUD showInfoWithStatus:message];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// MARK: - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [textView textMaxLength:kFeedbackMaxCount];
    [self updateCount:textView.text.length];
}

- (void)updateCount:(NSInteger)count {
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", count, kFeedbackMaxCount];
    _submitButton.enabled = count>0;
}

/// 子视图
- (void)prepareSubviews {
    // 输入框
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    _textView.textColor = [UIColor colorWithHex:0x333333];
    _textView.delegate = self;
    _textView.text = @" ";
    [_textView deleteBackward];
    [_textView corner];
    _textView.textContainerInset = UIEdgeInsetsMake(kWidth(14), kWidth(14), kWidth(14), kWidth(14));
    [_textView placeholderWith:SVLocalized(@"profile_enter_comments") szie:12 color:[UIColor colorWithHex:0x999999]];
    
    // 提示 字数
    _countLabel = [UILabel labelWithText:[NSString stringWithFormat:@"0/%ld", kFeedbackMaxCount] font:kSystemFont(12) color:[UIColor grayColor5]];
    
    // 提交按钮
    _submitButton = [UIButton buttonWithTitle:SVLocalized(@"profile_submit") titleColor:[UIColor whiteColor] font:kSystemFont(14)];
    _submitButton.backgroundColor = [UIColor grayColor8];
    [_submitButton setBackgroundColor:[UIColor disableColor] forState:UIControlStateDisabled];
    _submitButton.enabled = NO;
    
    [_submitButton corner];
    
    // 添加子控件
    [self.view addSubview:_textView];
    [self.view addSubview:_countLabel];
    [self.view addSubview:_submitButton];
    
    // 事件
    [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(24));
        make.right.equalTo(self.view).offset(kWidth(-24));
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(30));
        make.height.mas_equalTo(kHeight(160));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_textView);
        make.top.equalTo(_textView.mas_bottom).offset(kHeight(6));
    }];
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.height.mas_equalTo(kHeight(48));
        make.top.equalTo(_textView.mas_bottom).offset(kHeight(160));
    }];
}

// MARK: - lazy
- (SVAppViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SVAppViewModel alloc] init];
    }
    return _viewModel;
}

@end
