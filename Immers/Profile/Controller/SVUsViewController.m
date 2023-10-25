//
//  SVConnectViewController.m
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "SVUsViewController.h"

@interface SVUsViewController ()

@end

@implementation SVUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SVLocalized(@"profile_contact_us");
    self.view.backgroundColor = [UIColor backgroundColor];
    [self prepareSubviews];
}

// MARK: - Action
- (void)hotClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:400-060-2558"] options:@{} completionHandler:nil];
}

- (void)emailClick {
    // 剪切板
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    // 将文本写入剪切板
    board.string = @"Magiceye@moyansz.com";
    
    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_copy")];
}

/// 子视图
- (void)prepareSubviews {
    // box View
    UIView *serviceView = [[UIView alloc] init];
    UIView *companyView = [[UIView alloc] init];
    // 设置颜色
    serviceView.backgroundColor = [UIColor whiteColor];
    companyView.backgroundColor = [UIColor whiteColor];
    
    // 各个文本
    UILabel *contactLabel = [UILabel labelWithText:SVLocalized(@"profile_contact") font:kSystemFont(14) color:[UIColor grayColor7]];
    UILabel *companyLabel = [UILabel labelWithText:SVLocalized(@"profile_company_info") font:kSystemFont(14) color:[UIColor grayColor7]];
    UILabel *hotLineLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@：%@", SVLocalized(@"profile_service_line"), @"400-060-2558"] font:kSystemFont(12) color:[UIColor grayColor5]];
    UILabel *emailLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@：%@", SVLocalized(@"profile_service_email"), @"Magiceye@moyansz.com"] font:kSystemFont(12) color:[UIColor grayColor5]];
    UILabel *infoLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@：%@", SVLocalized(@"profile_company"), SVLocalized(@"profile_smart")] font:kSystemFont(12) color:[UIColor grayColor5]];
    
    // 添加子控件
    [self.view addSubview:serviceView];
    [self.view addSubview:companyView];
    [serviceView addSubview:contactLabel];
    [serviceView addSubview:hotLineLabel];
    [serviceView addSubview:emailLabel];
    [companyView addSubview:companyLabel];
    [companyView addSubview:infoLabel];
    
    // 事件
    hotLineLabel.userInteractionEnabled = YES;
    emailLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *hotTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotClick)];
    UITapGestureRecognizer *emailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailClick)];
    [hotLineLabel addGestureRecognizer:hotTap];
    [emailLabel addGestureRecognizer:emailTap];
    
    // 约束
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarHeight+kHeight(10));
        make.height.mas_equalTo(kHeight(110));
    }];
    
    [companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(serviceView.mas_bottom).offset(kHeight(10));
        make.height.mas_equalTo(kHeight(80));
    }];

    NSArray <UILabel *> *services = @[ contactLabel, hotLineLabel, emailLabel ];
    NSArray <UILabel *> *infos = @[ companyLabel, infoLabel ];
    
    [services mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:kHeight(8) leadSpacing:kHeight(10) tailSpacing:kHeight(10)];
    [services mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceView).offset(kWidth(12));
    }];
    
    [infos mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:kHeight(8) leadSpacing:kHeight(10) tailSpacing:kHeight(10)];
    [infos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyView).offset(kWidth(12));
    }];
}

@end
