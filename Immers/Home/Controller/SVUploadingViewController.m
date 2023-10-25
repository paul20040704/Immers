//
//  SVUploadingViewController.m
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import "SVUploadingViewController.h"
#import "SVGlobalMacro.h"
#import "GRRequestsManager.h"

#import "SVFileService.h"

#import <MobileCoreServices/MobileCoreServices.h>
@interface SVUploadingViewController ()<GRRequestsManagerDelegate>

@property (nonatomic, strong) GRRequestsManager *requestsManager;

@end

static NSString *const kFilePath = @"holoos/ftp/";

@implementation SVUploadingViewController {
    UIImageView *_loadingView;
    UILabel *_progressLabel;
}

+ (instancetype)uploadingViewController {
    SVUploadingViewController *viewController = [SVUploadingViewController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSubviews];
    
    if (nil != self.filePath) {
        [self prepareFTP];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 设置背景颜色
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    for (UIView *subview in window.subviews.reverseObjectEnumerator ) {
        if ([subview isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            subview.backgroundColor = [UIColor grayColor8];
            break;
        }
    }
}

// MARK: - Setter
- (void)setProgress:(float)progress {
    NSString *text;
    if (self.converting) { // 是否 2转3
        // 正在转化  /  等待转换
        text = progress > 0.0 ? SVLocalized(@"tip_converting") : SVLocalized(@"home_waiting_convert");
    } else { // 正在上传
        text = SVLocalized(@"tip_uploading");
    }
    _progressLabel.text = [NSString stringWithFormat:@"%@(%.0f%@)", text, progress * 100, @"%"];
    
    if (self.converting && progress >= 1.0) {
        [_loadingView stopAnimating];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// MARK: - GRRequestsManagerDelegate
/// 上传进度
- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompletePercent:(float)percent forRequest:(id<GRRequestProtocol>)request {
    self.progress = percent;
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

/// prepare Subviews
- (void)prepareFTP {
    if (_filePath.length <= 7) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_uploading_failed")];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self setupManager];
    NSString *path = _filePath;
    if ([_filePath hasPrefix:@"file:"]) { // 模拟器 带有file:// 协议头
        path = [_filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];//[_filePath substringFromIndex:7];
    }
    
    //http
    if (_httpInfo) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:path];
            kWself
            NSArray *arr = [path componentsSeparatedByString:@"."];
            NSString *suffix;
            if (arr.count>0) {
                suffix = [NSString stringWithFormat:@".%@",arr.lastObject];
            }
            [[SVNetworkManager sharedManager] upload:_httpInfo.url type:_fileType suffix:suffix name:@"file" files:@[fileData] progress:^(double uploadProgress) {
                wself.progress = uploadProgress;
            } finished:^(NSInteger errorCode, NSDictionary * _Nonnull info) {
                kSself
                if (sself->_fileType==1) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                }

                if (errorCode==0) {
                    [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_uploading_succeed")];
                }else{
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@，%@", SVLocalized(@"tip_uploading_failed"), SVLocalized(@"tip_poor_network")]];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_uploading_failed")];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    }else{
        //ftp
        // 拼接路径
        NSArray<NSString *> *list = [path componentsSeparatedByString:@"/"];
         //添加请求
        [self.requestsManager addRequestForUploadFileAtLocalPath:path toRemotePath:[NSString stringWithFormat:@"%@%@", kFilePath, list.lastObject]];
        // 开始传送
        [self.requestsManager startProcessingRequests];
            DebugLog(@"\n account: %@ \n password: %@ \n addrees: %@ \n path: %@ \n\n", _info.account, _info.password, _info.addrees, path);
    }
    
    // 设置进度
    self.progress = 0.0;
    

}

// MARK: - Subviews
/// prepare Subviews
- (void)prepareSubviews {
    // 创建视图
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.backgroundColor = [UIColor colorWithHex:0x434343];
    
    _loadingView = [UIImageView imageView];
    NSArray<NSString *> *names = @[ @"home_loading_1", @"home_loading_2", @"home_loading_3" ];
    NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:names.count];
    for (NSString *name in names) {
        [images addObject:[UIImage imageNamed:name]];
    }
    _loadingView.animationImages = [images copy];
    _loadingView.animationDuration = 1.5;
    [_loadingView startAnimating];
    
    _progressLabel = [UILabel labelWithText:SVLocalized(@"tip_uploading") font:kSystemFont(16) color:[UIColor whiteColor]];
    
    // 添加视图
    [wrapperView addSubview:_loadingView];
    [wrapperView addSubview:_progressLabel];
    [self.view addSubview:wrapperView];
    
    // 约束
    [wrapperView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(kWidth(152));
    }];
    
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wrapperView);
        make.centerY.equalTo(wrapperView).offset(kHeight(-10));
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wrapperView);
        make.top.equalTo(_loadingView.mas_bottom);
    }];
    
    // 颜色/圆角
    self.view.layer.cornerRadius = kHeight(13);
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.8];
    
    // 约束
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(wrapperView);
    }];
}


@end
