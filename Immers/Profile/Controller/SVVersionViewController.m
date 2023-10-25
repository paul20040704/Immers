//
//  SVVersionViewController.m
//  Immers
//
//  Created by developer on 2022/5/24.
//

#import "SVVersionViewController.h"
#import "SVAppViewModel.h"

@interface SVVersionViewController ()

@property (nonatomic, strong) SVAppViewModel *appViewModel;

@end

@implementation SVVersionViewController {
    UILabel *_versionLabel;
    UILabel *_textLabel;
    UIButton *_updateButton;
    BOOL _update;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SVLocalized(@"profile_version_update");
    [self prepareSubviews];
    [self loadVersions];
}

// MARK: - Action
- (void)updateClick {
    if (!_update) { return; }
    // 跳转 app store
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1631264709"] options:@{} completionHandler:nil];
}

// MARK: - Request
- (void)loadVersions {
    kWself
    [self.appViewModel versionCompletion:^(BOOL isSuccess, NSString *message) {
        if (isSuccess) {
            kSself
            [sself updateContent:sself.appViewModel.versionInfo.content];
            NSString *currentVersion = sself->_versionLabel.text;
            NSString *newVersion = sself.appViewModel.versionInfo.apkVersion;
            NSInteger cVersion = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            NSInteger nVersion =  [[newVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            if (nVersion > cVersion) {
                sself->_versionLabel.text = [NSString stringWithFormat:@"V%@    --->    V%@", currentVersion, newVersion];
                [sself->_updateButton setTitle:SVLocalized(@"profile_update") forState:UIControlStateNormal];
                [sself->_updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                sself->_updateButton.backgroundColor = [UIColor grayColor8];
                sself->_update = YES;
            }
            
        } else {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"profile_latest_version")];
        }
    }];
}

// MARK: - update text
- (void)updateContent:(NSString *)content {
    if (nil == content || content.length <= 0) {
        return;
    }
    //换行，接口不返回换行符，用;代替换行符
    content = [content stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    
    // 设置行间距：
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    style.lineSpacing = kHeight(10);
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:content
                                                                                    attributes:@{
        NSParagraphStyleAttributeName: style,
        NSForegroundColorAttributeName : [UIColor grayColor6],
        NSFontAttributeName : kSystemFont(12)} ];
    _textLabel.attributedText = attriString;
}

/// @"V1.0.0    --->    V2.0.0"
/// 子视图
- (void)prepareSubviews {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    UIImageView *logoView = [UIImageView imageViewWithImageName:@"profile_immers_logo"];
    UILabel *nameLabel = [UILabel labelWithText:@"NuWo" textColor:[UIColor grayColor7] font:kBoldFont(14)];
    
    _versionLabel = [UILabel labelWithText:version textColor:[UIColor grayColor5] font:kSystemFont(12)];
    _textLabel = [[UILabel alloc] init];
    _textLabel.numberOfLines = 0;
    
    // 提交按钮
    _updateButton = [UIButton buttonWithTitle:SVLocalized(@"profile_latest_version") titleColor:[UIColor grayColor8] font:kSystemFont(14)];
    _updateButton.layer.borderWidth = 1.0;
    _updateButton.layer.borderColor = [UIColor grayColor8].CGColor;
    [_updateButton corner];
    
    // 添加子控件
    [self.view addSubview:logoView];
    [self.view addSubview:nameLabel];
    [self.view addSubview:_versionLabel];
    [self.view addSubview:_textLabel];
    [self.view addSubview:_updateButton];
    
    // 事件
    [_updateButton addTarget:self action:@selector(updateClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(kNavBarHeight+kHeight(68));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(logoView.mas_bottom).offset(kHeight(20));
    }];
    
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8));
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.top.equalTo(_versionLabel.mas_bottom).offset(kHeight(36));
    }];
    
    [_updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(40));
        make.right.equalTo(self.view).offset(kWidth(-40));
        make.height.mas_equalTo(kHeight(48));
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(kHeight(-80));
    }];
}

// MARK: - lazy
- (SVAppViewModel *)appViewModel {
    if (!_appViewModel) {
        _appViewModel = [[SVAppViewModel alloc] init];
    }
    return _appViewModel;
}

@end
