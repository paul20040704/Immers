//
//  SVAIHeadView.m
//  Immers
//
//  Created by Paul on 2023/7/21.
//

#import "SVAIHeadView.h"
#import "SVGlobalMacro.h"
@interface SVAIHeadView() <UITextFieldDelegate>

@end

@implementation SVAIHeadView {
    UILabel *_titleLabel;
    UIButton *_selectButton;
    UIButton *_searchButton;
}

- (instancetype )initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self prepareSubViews];
    }
    return self;
}

// MARK: - Action
- (void)resetSelectStatus {
    _selectButton.selected = NO;
}

- (void)buttonClick:(UIButton *)sender {
    NSInteger tag = sender.tag - 100;
    if (self.clickAction) {
        if(tag==0){
            _selectButton.selected = !_selectButton.selected;
            self.clickAction(tag, @"");
        }else {
            if (_searchTextFeild.text.length > 0) {
                self.clickAction(tag, _searchTextFeild.text);
            }
        }
    }
}

// MARK: - View
- (void)prepareSubViews {
    self.backgroundColor = UIColor.whiteColor;
    _titleLabel = [UILabel labelWithText:SVLocalized(@"ai_image") font: kSystemFont(24) color: [UIColor colorWithHexString:@"707070"]];
    _selectButton = [UIButton buttonWithTitle:SVLocalized(@"resource_select") titleColor:[UIColor colorWithHexString:@"454545"] font:kSystemFont(18)];
    [_selectButton setTitle:SVLocalized(@"home_cancel") forState:UIControlStateSelected];
    _selectButton.tag = 100;
    [_selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextFeild = [self prepareTextField:SVLocalized(@"keywords_placeholder")];
    _searchButton = [UIButton buttonWithTitle:SVLocalized(@"search") titleColor:[UIColor colorWithHexString:@"#454545"] font:kSystemFont(16)];
    _searchButton.tag = 101;
    [_searchButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_titleLabel];
    [self addSubview:_selectButton];
    [self addSubview:_searchTextFeild];
    [self addSubview:_searchButton];

    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kWidth(30));
        make.top.equalTo(self.mas_top);
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kWidth(-24));
        make.centerY.equalTo(_titleLabel.mas_centerY);
    }];
    
    [_searchTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kWidth(20));
        make.size.mas_equalTo(CGSizeMake(kWidth(280), kHeight(40)));
        make.top.equalTo(_titleLabel.mas_bottom).offset(kHeight(15));
    }];
    
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(kWidth(-24));
        make.centerY.equalTo(_searchTextFeild.mas_centerY);
    }];
}

/// 创建 输入框
- (UITextField *)prepareTextField:(NSString *)placeholder {
    UITextField *textField = [UITextField textFieldWithPlaceholder:placeholder type:UIKeyboardTypeDefault textColor:[UIColor textColor] backgroundColor:[UIColor colorWithHexString:@"#E3E1F0"]];
    textField.font = kSystemFont(16);
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    if (@available(iOS 13.0, *)) {
        searchImageView.image = [UIImage systemImageNamed:@"magnifyingglass"];
    }
    textField.leftView = searchImageView;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.tintColor = [UIColor textColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    
    [textField corner:23];

    // 占位文本样式
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{ NSFontAttributeName: kSystemFont(16), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#928CB2"] }];
    
    return textField;
}

@end
