//
//  SVQRCodeAlertViewController.m
//  Immers
//
//  Created by developer on 2023/2/22.
//

#import "SVQRCodeAlertViewController.h"
#import "SVScanner.h"

@interface SVQRCodeAlertViewController ()

@end

@implementation SVQRCodeAlertViewController{
    UIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSubView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissAction];
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAction {
    [UIImage resetUpImageSize:_image];
    _image = [_image fixOrientation:_image];
    NSData *imageData = UIImagePNGRepresentation(_image);
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_save_image_erroe")];
    } else {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"tip_save_image_succeed")];
        [self dismissAction];
    }
}

- (void)prepareSubView {
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    self.hidenNav = YES;
    
    UIView *alertBGView = [UIView new];
    alertBGView.backgroundColor = UIColor.backgroundColor;
    [alertBGView corner];
    [self.view addSubview:alertBGView];
    
    UILabel *titleLabel = [UILabel labelWithText:SVLocalized(@"home_member_share_qr") font:kSystemFont(16) color:UIColor.grayColor8];
    [alertBGView addSubview:titleLabel];
    
    // 时间
    NSTimeInterval interval = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000;
    
    UIImageView *qrImageView = [[UIImageView alloc] init];
    __weak typeof(qrImageView) weakQrImage = qrImageView;
    kWself
    [SVScanner qrImageWithString:[NSString stringWithFormat:@"https://immers.download.smartsuperv.com?deviceId=%@&type=1&wc=%.0f", self.deviceId, interval] avatar:[UIImage imageNamed:@"immersIcon"] scale:0.3 completion:^(UIImage *image) {
        kSself
        sself->_image = image;
        weakQrImage.image = image;
    }];
    [alertBGView addSubview:qrImageView];
    
    UIButton *cancelButton = [UIButton buttonWithTitle:SVLocalized(@"home_cancel") titleColor:UIColor.textColor font:kSystemFont(14)];
    cancelButton.backgroundColor = UIColor.whiteColor;
    [cancelButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton corner];
    
    UIButton *saveButton = [UIButton buttonWithTitle:SVLocalized(@"home_member_save") titleColor:UIColor.whiteColor font:kSystemFont(14)];
    saveButton.backgroundColor = UIColor.grassColor;
    [saveButton corner];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    [alertBGView addSubview:cancelButton];
    [alertBGView addSubview:saveButton];
    [alertBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(kWidth(38));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertBGView);
        make.top.equalTo(alertBGView).offset(kHeight(8));
    }];
    [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(kHeight(12));
        make.centerX.equalTo(alertBGView);
        make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(200)));
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrImageView.mas_bottom).offset(kHeight(16));
        make.left.equalTo(alertBGView).offset(kWidth(12));
        make.size.mas_equalTo(CGSizeMake(kWidth(120), kHeight(40)));
        make.bottom.equalTo(alertBGView).offset(-kHeight(24));
    }];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancelButton);
        make.right.equalTo(alertBGView).offset(-kWidth(12));
        make.size.mas_equalTo(CGSizeMake(kWidth(120), kHeight(40)));
    }];
}

@end
