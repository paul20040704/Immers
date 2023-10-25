//
//  SVIntroViewController.m
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "SVIntroViewController.h"

@interface SVIntroViewController ()

@end

@implementation SVIntroViewController {
    BOOL _isProduct;
}

+ (instancetype)viewControllerWithType:(SVIntroType)type {
    SVIntroViewController *viewController = [[SVIntroViewController alloc] init];
    viewController->_isProduct = type == SVIntroTypeProduct;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _isProduct ? SVLocalized(@"profile_product") : SVLocalized(@"profile_company_intro");
    [self prepareSubviews];
}

- (void)prepareSubviews {
    // logo图标/提示文本
    NSString *name = _isProduct ? @"profile_immers_logo" : @"profile_company";
    NSString *text = [self prepareText];
    UIImageView *logoView = [UIImageView imageViewWithImageName:name];
    UILabel *textLabel = [UILabel labelWithTextColor:[UIColor grayColor7] font:kSystemFont(12) lines:0];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft; // 对齐
    style.headIndent = 0.0; // 行首缩进
    style.firstLineHeadIndent = textLabel.font.pointSize * 2;// 首行缩进 （字体大小号字乘以2，即首行空出两个字符）
    style.tailIndent = 0.0; // 行尾缩进
    style.lineSpacing = kHeight(5); // 行间距
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSParagraphStyleAttributeName: style, NSFontAttributeName : textLabel.font }];
    textLabel.attributedText = attrText;
    
    // 添加子控件
    [self.view addSubview:logoView];
    [self.view addSubview:textLabel];
    if (_isProduct) {
        UILabel *productLabel = [UILabel labelWithText:@"Immers" font:kBoldFont(14) color:[UIColor grayColor7]];
        [self.view addSubview:productLabel];
        [productLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(logoView);
            make.top.equalTo(logoView.mas_bottom).offset(kHeight(20));
        }];
    }
    
    // 约束
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(kNavBarHeight+kHeight(68));
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(24));
        make.right.equalTo(self.view).offset(kWidth(-24));
        make.top.equalTo(logoView.mas_bottom).offset(kHeight(42) + (_isProduct ? kHeight(26) : 0));
    }];
}

- (NSString *)prepareText {
    return _isProduct ?
        SVLocalized(@"profile_immers")
        :
        SVLocalized(@"profile_shenzhen");
}

@end
