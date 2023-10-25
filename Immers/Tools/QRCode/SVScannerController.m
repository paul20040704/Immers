//
//  SVScannerController.m
//  Immers
//
//  Created by developer on 2022/6/6.
//

#import "SVScannerController.h"
#import "SVScannerViewController.h"
#import "SVScanner.h"

@interface SVScannerController ()

@end

@implementation SVScannerController

+ (void)cardImageWithCardName:(NSString *)cardName avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *))completion {
    [SVScanner qrImageWithString:cardName avatar:avatar scale:scale completion:completion];
}

+ (instancetype)scannerCompletion:(void (^)(NSString *stringValue))completion {
    NSAssert(completion != nil, @"必须传入完成回调");
    return [[self alloc] initWithCompletion:completion];
}

- (instancetype)initWithCompletion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        SVScannerViewController *scanner = [[SVScannerViewController alloc] initWithCompletion:completion];
         
        [self setTitleColor:[UIColor whiteColor] tintColor:[UIColor whiteColor]];
        
        [self pushViewController:scanner animated:NO];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor}];
    self.navigationBar.tintColor = tintColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
