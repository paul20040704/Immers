//
//  SVWebViewController.m
//  Immers
//
//  Created by developer on 2022/6/28.
//

#import "SVWebViewController.h"
#import "WebKit/WebKit.h"

@interface SVWebViewController ()

/// 用户协议
@property (nonatomic, strong) NSDictionary *agreementDict;

/// 隐私政策
@property (nonatomic, strong) NSDictionary *privacyDict;

@end

@implementation SVWebViewController {
    WKWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareWebView];
}

- (void)prepareWebView {
    // 创建WKWebView
    _webView = [[WKWebView alloc] init];
    // 设置访问的URL
    NSString *key = [SVLanguage remote];
    NSString *string = @"";
    if (self.event == SVButtonEventAgreement) {
        string = self.agreementDict[key];
    } else if (self.event == SVButtonEventPrivacy) {
        string = self.privacyDict[key];
    }

    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    // WKWebView加载请求
    [_webView loadRequest:request];
    // 将WKWebView添加到视图
    [self addSubview:_webView];
    
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
}

// 根据监听 实时修改title
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (object == _webView) {
            self.title = _webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"title" context:nil];
}


- (NSDictionary *)agreementDict {
    if (!_agreementDict) {
        _agreementDict = @{ @"CN" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_user_agreement_v1.html",
                            @"TC" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_user_agreement_v1.html",
                            @"JA" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_user_agreement_v1.html",
                            @"KR" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_user_agreement_v1.html",
                            @"EN" : @"https://jpeaststorage.blob.core.windows.net/nuwo/nuwo_user_agreement_v1.html"
        };
    }
    return _agreementDict;
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
