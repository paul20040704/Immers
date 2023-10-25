//
//  SVNavigationController.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "SVNavigationController.h"
#import "SVBaseViewController.h"
#import "SVGlobalMacro.h"

@interface SVNavigationController ()

@end

@implementation SVNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.hidden = YES;
}

- (void)pushViewController:(SVBaseViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        if ([viewController isKindOfClass:[SVBaseViewController class]]) {
            viewController.navItem.leftBarButtonItem = [self prepareBackButton];
        } else {
            DebugLog(@"psuh Controller 要是使用 SVBaseViewController 的子类");
        }
    }
    self.tabBarController.tabBar.hidden = self.childViewControllers.count > 0;
    [super pushViewController:viewController animated:YES];
}

- (UIBarButtonItem *)prepareBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)toBack {
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if ([NSStringFromClass([self.visibleViewController class]) isEqualToString:@"SVWiFiViewController"]) {
        return self.visibleViewController;
    }
    return self.topViewController;
}

// 设备 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
