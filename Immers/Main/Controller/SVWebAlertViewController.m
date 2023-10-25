//
//  SVWebAlertViewController.m
//  Immers
//
//  Created by developer on 2022/12/20.
//

#import "SVWebAlertViewController.h"
#import "WebKit/WebKit.h"
@interface SVWebAlertViewController ()<WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;
/// 隐私政策
@property (nonatomic, strong) NSDictionary *privacyDict;
@end

@implementation SVWebAlertViewController{
    BOOL _isURLLoaded;
    UIButton *_agreeBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareWebView];
}

// MARK: Action
- (void)agreeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.actionBlock){
        self.actionBlock(1);
    }
}

- (void)disAgreeAction {
    if(self.actionBlock){
        self.actionBlock(0);
    }
}

// MARK: - wkNavDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    _isURLLoaded = YES;
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(_isURLLoaded){
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            _agreeBtn.enabled = YES;
        }
    }
}


// MARK: View
- (void)prepareWebView {
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    self.hidenNav = YES;
    
    UIView *alertBGView = [UIView new];
    alertBGView.backgroundColor = UIColor.whiteColor;
    [alertBGView corner];
    [self.view addSubview:alertBGView];
    
    UIButton *agreeBtn = [UIButton buttonWithTitle:SVLocalized(@"profile_agree") normalColor:UIColor.whiteColor font:[UIFont systemFontOfSize:12]];
    agreeBtn.enabled = NO;
    [agreeBtn setBackgroundColor:UIColor.grassColor forState:0];
    [agreeBtn setBackgroundColor:UIColor.grayColor3 forState:UIControlStateDisabled];
    [agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn corner];
    [alertBGView addSubview:agreeBtn];
    _agreeBtn = agreeBtn;
    
    UIButton *disAgreeBtn = [UIButton buttonWithTitle:SVLocalized(@"profile_disagree") normalColor:UIColor.grayColor5 font:[UIFont systemFontOfSize:12]];
    [disAgreeBtn addTarget:self action:@selector(disAgreeAction) forControlEvents:UIControlEventTouchUpInside];
    [disAgreeBtn corner];
    [alertBGView addSubview:disAgreeBtn];
    
    // 创建WKWebView
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    // 设置访问的URL
    NSString *key = [SVLanguage remote];
    NSString *string = self.privacyDict[key];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    // WKWebView加载请求
    [_webView loadRequest:request];
    // 将WKWebView添加到视图
    [alertBGView addSubview:_webView];

    [alertBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kHeight(154));
        make.left.equalTo(self.view).offset(kWidth(38));
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertBGView).offset(kWidth(12));
        make.right.equalTo(alertBGView).offset(-kWidth(12));
        make.top.equalTo(alertBGView).offset(kHeight(24));
        make.height.mas_equalTo(kHeight(322));
    }];
    
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertBGView);
        make.top.equalTo(_webView.mas_bottom).offset(kHeight(30));
        make.size.mas_equalTo(CGSizeMake(kWidth(206), kWidth(32)));
    }];
    
    [disAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertBGView);
        make.top.equalTo(agreeBtn.mas_bottom).offset(kHeight(12));
        make.size.mas_equalTo(CGSizeMake(kWidth(206), kWidth(32)));
        make.bottom.equalTo(alertBGView).offset(-kHeight(24));
    }];
    
    
}

- (NSDictionary *)privacyDict {
    if (!_privacyDict) {
        _privacyDict = @{ @"CN" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_privacy_policy_v1.html",
                          @"TC" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_privacy_policy_v1.html",
                          @"JA" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_privacy_policy_v1.html",
                          @"KR" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_privacy_policy_v1.html",
                          @"EN" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_privacy_policy_v1.html"
        };
    }
    return _privacyDict;
}
@end
