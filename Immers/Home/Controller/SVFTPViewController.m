//
//  SVFTPViewController.m
//  Immers
//
//  Created by developer on 2022/9/6.
//

#import "SVFTPViewController.h"
#import "SVProgressView.h"
#import "GRRequestsManager.h"

@interface SVFTPViewController () <GRRequestsManagerDelegate>

@property (nonatomic, strong) GRRequestsManager *requestsManager;

@end

static NSString *const kFilePath = @"holoos/ftp/";

@implementation SVFTPViewController {
    SVFTPInfo *_info; // ftp info
    NSString *_filePath; // file path
    SVProgressView *_progressView;
    UILabel *_tipLabel;
}

+ (instancetype)viewControllerWithPath:(NSString *)filePath serviceInfo:(SVFTPInfo *)serviceInfo {
    SVFTPViewController *viewController = [SVFTPViewController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    viewController->_filePath = filePath;
    viewController->_info = serviceInfo;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self prepareSubview];
    
    if (_filePath.length <= 7) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_connection_failed")];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self setupManager];
    NSString *path = _filePath;
    if ([_filePath hasPrefix:@"file:"]) {
        path = [_filePath substringFromIndex:7];
    }
    
    NSArray<NSString *> *list = [path componentsSeparatedByString:@"/"];
    [self.requestsManager addRequestForUploadFileAtLocalPath:path toRemotePath:[NSString stringWithFormat:@"%@%@", kFilePath, list.lastObject]];
    [self.requestsManager startProcessingRequests];

    DebugLog(@"\n account: %@ \n password: %@ \n addrees: %@ \n path: %@ \n\n", _info.account, _info.password, _info.addrees, path);
}

/// 准备视图
- (void)prepareSubview {
    UIView *wrapperView = [[UIView alloc] init];
    _progressView = [[SVProgressView alloc] init];
    _progressView.progress = 0.001;
    _tipLabel = [UILabel labelWithText:SVLocalized(@"tip_connecting") font:kSystemFont(14) color:[UIColor grayColor6]];
    
    // 添加控件
    [wrapperView addSubview:_progressView];
    [wrapperView addSubview:_tipLabel];
    [self.view addSubview:wrapperView];
    
    // 约束
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(wrapperView);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wrapperView);
        make.top.equalTo(_progressView.mas_bottom).offset(kHeight(10));
    }];
    
    [wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self.view);
        make.height.mas_equalTo(kWidth(250));
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

// MARK: - GRRequestsManagerDelegate
/// 上传进度
- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompletePercent:(float)percent forRequest:(id<GRRequestProtocol>)request {
    _progressView.progress = percent;
    _tipLabel.text = SVLocalized(@"tip_uploading");
}

/// 上传完成
- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteUploadRequest:(id<GRDataExchangeRequestProtocol>)request {
    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_uploading_succeed")];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 上传失败
- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailRequest:(id<GRRequestProtocol>)request withError:(NSError *)error {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@，%@", SVLocalized(@"tip_uploading_failed"), SVLocalized(@"tip_poor_network")]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    DebugLog(@"error: %@", error);
}

/// 创建Manager
- (void)setupManager {
    self.requestsManager = [[GRRequestsManager alloc] initWithHostname:_info.addrees
                                                                  user:_info.account
                                                              password:_info.password];
    self.requestsManager.delegate = self;
}

// MARK: - dealloc
- (void)dealloc {
    DebugLog(@"SVFTPViewController dealloc");
}

@end
