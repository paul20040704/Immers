//
//  SVScannerViewController.m
//  Immers
//
//  Created by developer on 2022/6/6.
//

#import "SVScannerViewController.h"
#import "SVScannerBorder.h"
#import "SVScannerMaskView.h"
#import "SVScanner.h"
#import "SVGlobalMacro.h"

/// 控件间距
#define kControlMargin  32.0
/// 相册图片最大尺寸
#define kImageMaxSize   CGSizeMake(1000, 1000)
#define kIsiPhoneX ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0)

static NSString *const kTorchOffText = @"轻触关闭";
static NSString *const kTorchOnText = @"轻触打开";

@interface SVScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/// 完成回调
@property (nonatomic, copy) void (^completionCallBack)(NSString *);

@end

@implementation SVScannerViewController {
    /// 扫描框
    SVScannerBorder *scannerBorder;
    /// 扫描器
    SVScanner *scanner;
    /// 提示标签
    UILabel *tipLabel;
}


- (instancetype)initWithCompletion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        self.completionCallBack = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    // 实例化扫描器
    __weak typeof(self) weakSelf = self;
    scanner = [SVScanner scanerWithView:self.view scanFrame:self.view.frame completion:^(NSString *stringValue) {
        // 完成回调
        weakSelf.completionCallBack(stringValue);
        
        // 关闭
        [weakSelf clickCloseButton];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [scannerBorder startScannerAnimating];
    [scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [scannerBorder stopScannerAnimating];
    [scanner stopScan];
}

#pragma mark - 监听方法
/// 点击关闭按钮
- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 点击相册按钮
- (void)clickAlbumButton {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        tipLabel.text = SVLocalized(@"home_album_not_authorized");
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.view.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self showDetailViewController:picker sender:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [self resizeImage:info[UIImagePickerControllerOriginalImage]];
    
    // 扫描图像
    [SVScanner scaneImage:image completion:^(NSArray *values) {
        
        if (values.count > 0) {
            self.completionCallBack(values.firstObject);
            [self dismissViewControllerAnimated:NO completion:^{
                [self clickCloseButton];
            }];
        } else {
            self->tipLabel.text = @"没有识别到二维码，请选择其他照片";
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image {
    
    if (image.size.width < kImageMaxSize.width && image.size.height < kImageMaxSize.height) {
        return image;
    }
    
    CGFloat xScale = kImageMaxSize.width / image.size.width;
    CGFloat yScale = kImageMaxSize.height / image.size.height;
    CGFloat scale = MIN(xScale, yScale);
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)torchButtonAction:(UIButton *)torchButton {
    torchButton.selected = !torchButton.selected;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device hasTorch]) { // 判断是否有闪光灯
        // 请求独占访问硬件设备
        [device lockForConfiguration:nil];
        if(torchButton.selected) {
            [device setTorchMode:AVCaptureTorchModeOn];//手电筒开
        }else{
            [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
        }
        // 请求解除独占访问硬件设备
        [device unlockForConfiguration];
    }
}

#pragma mark - 设置界面
- (void)prepareUI {
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self prepareNavigationBar];
    [self prepareScanerBorder];
    [self prepareOtherControls];
}

/// 准备提示标签和名片按钮
- (void)prepareOtherControls {
    
    // 1> 提示标签
    tipLabel = [[UILabel alloc] init];
    
    tipLabel.text = SVLocalized(@"home_scan_rq_code");
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 2;
    tipLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    tipLabel.frame = CGRectMake(0, 0, 200, 30);
//    tipLabel.layer.cornerRadius = 5;
//    tipLabel.layer.masksToBounds = YES;

    tipLabel.center = CGPointMake(scannerBorder.center.x, CGRectGetMaxY(scannerBorder.frame) + 30);
    // 图像文件包
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"SVScanner" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    
    UIButton *torchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    torchButton.center = CGPointMake(CGRectGetMidX(self.view.frame), self.view.bounds.size.height - (kIsiPhoneX ? 120 : 80));
    [torchButton setImage:[self imageWithName:@"Torch_off" bundle:imageBundle] forState:UIControlStateNormal];
    [torchButton setImage:[self imageWithName:@"Torch_on" bundle:imageBundle] forState:UIControlStateSelected];
    [torchButton addTarget:self action:@selector(torchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *albumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    albumButton.center = CGPointMake(CGRectGetMaxX(tipLabel.frame) + albumButton.bounds.size.height, CGRectGetMidY(torchButton.frame));
//    [albumButton setImage:[self imageWithName:@"Album" bundle:imageBundle] forState:UIControlStateNormal];
//    [albumButton addTarget:self action:@selector(clickAlbumButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tipLabel];
    [self.view addSubview:torchButton];
//    [self.view addSubview:albumButton];
}

- (UIImage *)imageWithName:(NSString *)imageName bundle:(NSBundle *)imageBundle {
    NSString *fileName = [NSString stringWithFormat:@"%@@2x", imageName];
    NSString *path = [imageBundle pathForResource:fileName ofType:@"png"];
    return [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/// 准备扫描框
- (void)prepareScanerBorder {
    
    CGFloat width = 230;
    scannerBorder = [[SVScannerBorder alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    
    scannerBorder.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    scannerBorder.tintColor = [UIColor colorWithRed:38/255.0 green:238/255.0 blue:159/255.0 alpha:0.7]; //[UIColor whiteColor];
    [self.view addSubview:scannerBorder];
    
    SVScannerMaskView *maskView = [SVScannerMaskView maskViewWithFrame:self.view.bounds cropRect:scannerBorder.frame];
    [self.view insertSubview:maskView atIndex:0];
}

/// 准备导航栏
- (void)prepareNavigationBar {
    // 1> 背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.1 alpha:1.0]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    // 2> 标题
//    self.title = @"添加设备";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"SVScanner" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    
    // 3> 左右按钮 back
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[self imageWithName:@"back" bundle:imageBundle] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
