//
//  SVMainViewController.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "SVMainViewController.h"
#import "SVNavigationController.h"
#import "SVBaseViewController.h"
#import "SVHomeViewController.h"
#import "SVSheetViewController.h"
#import "SVPickerViewController.h"
#import "SVAccountViewController.h"
#import "SVLanguageViewController.h"
#import "SVForgotViewController.h"
#import "SVSelectFrameViewController.h"
#import "SVUploadingViewController.h"
#import "SVFileManagerController.h"
#import "SVAddDeviceViewController.h"
#import "SVApplyListViewController.h"
#import "SVTabBar.h"
#import "SVUserViewModel.h"
#import "SVMemberViewModel.h"
#import "SVInterfaces.h"

@interface SVMainViewController () <UITabBarControllerDelegate>

@end

@implementation SVMainViewController {
    SVInterfaces *_interfaces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareTabBar];
    [self prepareChildViewControllers];
    [self updateUser];
    _interfaces = [SVInterfaces interfaces];
}


- (void)deviceStatus {
    kWself
    if (![SVUserAccount sharedAccount].device) {
        SVNavigationController *nav = self.viewControllers[self.selectedIndex];
        SVAddDeviceViewController *vc = [[SVAddDeviceViewController alloc] init];
        [nav pushViewController:vc animated:YES];
        
    }else{
        [wself showSheet];
    }
}

- (void)showSheet {
    kWself
    SVSheetItem *item0 = [SVSheetItem item:@"home_local" text:SVLocalized(@"home_local_files") callback:^{
        [SVAuthorization cameraAuthorization:^{
            [wself prepareImage:UIImagePickerControllerSourceTypePhotoLibrary];
        } denied:^{
            [wself denied:SVLocalized(@"home_album_not_authorized")];
        }];
    }];
    SVSheetItem *item1 = [SVSheetItem item:@"home_take" text:SVLocalized(@"home_camera") callback:^{
        [SVAuthorization cameraAuthorization:^{
            [wself prepareImage:UIImagePickerControllerSourceTypeCamera];
        } denied:^{
            [wself denied:SVLocalized(@"home_camera_not_authorized")];
        }];
    }];
    SVSheetItem *item2 = [SVSheetItem item:@"home_file_transfer" text:SVLocalized(@"home_video") callback:^{
        __strong typeof(self) sself= wself;
        NSString *ssid = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceSSIDKey];
//        if (![[sself->_interfaces ssid] isEqualToString:ssid]) {
//            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_not_the_same_LAN")];
//            return;
//        }
        
        [SVAuthorization cameraAuthorization:^{
//            [wself prepareImage:UIImagePickerControllerSourceTypePhotoLibrary];
            [wself transferFile];
        } denied:^{
            [wself denied:SVLocalized(@"home_camera_not_authorized")];
        }];
    }];
    SVSheetViewController *viewController = [SVSheetViewController sheetController:@[item0, item1, item2]];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    SVNavigationController *nav = self.childViewControllers.firstObject;
    [nav.viewControllers.firstObject presentViewController:viewController animated:YES completion:nil];
}

/// 选择 图片/拍照
- (void)prepareImage:(UIImagePickerControllerSourceType)sourceType {
    kWself
    SVPickerViewController *viewController = [SVPickerViewController pickerViewControllerWithSourceType:sourceType completion:^(UIImage *image) {
        [wself selectFileToUpload:image];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

/// 文件传输
- (void)transferFile {
    kWself
    SVPickerViewController *viewController = [SVPickerViewController pickerViewControllerWithTransferCompletion:^(NSInteger type,NSString *url) {
        //[wself selectFileToUpload:@{@"type":@(type),@"url":url}];
        //改成上傳影片
        [wself selectVideoToUpload:@{@"type":@(type),@"url":url}];
    }];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)selectFileToUpload:(id )object {
    SVNavigationController *nav = self.selectedViewController;
    SVBaseViewController *vc = nav.viewControllers.firstObject;
    if ([object isKindOfClass:[UIImage class]]) {
        SVSelectFrameViewController *viewController = [[SVSelectFrameViewController alloc] init];
        viewController.image = object;
        viewController.fileType = @"1";
        viewController.eventType = SVButtonEventUpload;
        [nav pushViewController:viewController animated:YES];
        
    } else {
        SVDeviceInfo *deviceInfo = [SVUserAccount sharedAccount].deviceInfo;
        if (deviceInfo.updateFilePath&&!deviceInfo.updateFilePath.isOpen) {
            [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_not_the_same_LAN")];
            return;
        }
        NSDictionary *dict = object;;
        NSString *path = dict[@"url"];
        NSNumber *type = dict[@"type"];
        long long size = [NSData fileSizeAtPath:[path stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        if (size>deviceInfo.surplusCapacity) {
            [self showDeviceMemoryWaring:vc];
            return;
        }
        SVUploadingViewController *viewController = [SVUploadingViewController uploadingViewController];
        viewController.filePath = path;
        viewController.info = deviceInfo.ftpServiceInfo;
        viewController.httpInfo = deviceInfo.updateFilePath;
        viewController.fileType = type.integerValue;
        [vc presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)selectVideoToUpload:(id )object {
    SVNavigationController *nav = self.selectedViewController;
    SVBaseViewController *vc = nav.viewControllers.firstObject;
    NSDictionary *dict = object;;
    NSString *path = dict[@"url"];
    //NSNumber *type = dict[@"type"];
    SVSelectFrameViewController *viewController = [[SVSelectFrameViewController alloc] init];
    viewController.videoUrl = path;
    viewController.fileType = @"2";
    viewController.eventType = SVButtonEventUpload;
    [nav pushViewController:viewController animated:YES];
    
}

- (void)showDeviceMemoryWaring:(SVBaseViewController *)vc {
    kWself
    SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:SVLocalized(@"home_local_storage_clean") message:nil cancelText:SVLocalized(@"home_to_file_manager") confirmText:SVLocalized(@"home_cancel")];
    viewController.showClose = YES;
    viewController.messageAlignment = NSTextAlignmentCenter;
    viewController.titleTextColor = [UIColor whiteColor];
    viewController.backgroundColor = [UIColor grayColor3];
    [viewController handler:^{
        [wself fileClick:vc];
    } confirmAction:nil];
    [vc presentViewController:viewController animated:YES completion:nil];
}

- (void)fileClick:(SVBaseViewController *)vc {
    SVDeviceInfo *deviceInfo = [SVUserAccount sharedAccount].deviceInfo;
    SVFileManagerController *viewController = [[SVFileManagerController alloc] init];
    SVDevice *device = [SVUserAccount sharedAccount].device;
    device.surplusCapacity = deviceInfo.surplusCapacity;
    device.totalCapacity = deviceInfo.totalCapacity;
    device.versionNum = deviceInfo.versionNum;
    
    viewController.device = device;
    [vc.navigationController pushViewController:viewController animated:YES];
}

/// 相机/相册未授权 提示
- (void)denied:(NSString *)message {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:SVLocalized(@"login_prompt") message:message cancelText:SVLocalized(@"home_cancel") doneText:SVLocalized(@"home_allow_access") cancelAction:nil doneAction:^(UIAlertAction *action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        });
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: - Request
- (void)updateUser {
    SVUserViewModel *viewModel = [[SVUserViewModel alloc] init];
    [viewModel userCompletion:^(NSInteger errorCode, NSDictionary *info) {}];
}

- (void)handleInviteInform:(NSInteger)index invite_id:(NSString *)invite_id {
    NSDictionary *dict = @{ @"id" : invite_id, @"status" : [NSString stringWithFormat:@"%ld", index] };
    SVMemberViewModel *viewModel = [[SVMemberViewModel alloc] init];
    [viewModel inviteHandler:dict completion:^(BOOL isSuccess, NSString *message) {
        [SVProgressHUD showInfoWithStatus:message];
    }];
}


// MARK: - Notification
- (void)handleNotification:(SVApnsEvent)event info:(SVApns *)info {
    if (event == SVApnsEventApplyInform) { // 申请加入相框 通知
        SVApplyListViewController *viewController = [[SVApplyListViewController alloc] init];
        viewController.deviceId = info.framePhotoId;
        SVNavigationController *nav = self.viewControllers[self.selectedIndex];
        [nav pushViewController:viewController animated:nil];
        
    } else if (event == SVApnsEventInviteInform) { // 收到邀请 通知
        kWself
        SVAlertViewController *viewController = [SVAlertViewController defaultWithTitle:nil message:info.aps.alert cancelText:SVLocalized(@"home_member_refuse") confirmText:SVLocalized(@"home_member_apply_agree")];
        viewController.showClose = YES;
        [viewController handler:^{
            [wself handleInviteInform:2 invite_id:info.msgId];
        } confirmAction:^{
            [wself handleInviteInform:1 invite_id:info.msgId];
        }];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}




// MARK: - ViewControllers
/// TabBar
- (void)prepareTabBar {
    // 设置tabbar
    SVTabBar *tabBar = [[SVTabBar alloc] init];
    kWself
    tabBar.uploadCallback = ^{
        [wself deviceStatus];
    };
    [self setValue:tabBar forKey:@"tabBar"];

    // 设置delegate
    self.delegate = self;
}

- (void)reloadMainViewController {
    self.selectedIndex = 3;
    SVNavigationController *nav = self.viewControllers[self.selectedIndex];
    [self tabBarController:self shouldSelectViewController:nav];
    
    [nav pushViewController:[[SVAccountViewController alloc] init] animated:NO];
    [nav pushViewController:[[SVLanguageViewController alloc] init] animated:NO];
}

- (void)toAddDeviceAndBackHome {
    self.selectedIndex = 0;
    SVNavigationController *nav = self.viewControllers[self.selectedIndex];
    [self tabBarController:self shouldSelectViewController:nav];
//    SVNavigationController *nav = self.viewControllers[self.selectedIndex];
    SVAddDeviceViewController *vc = [[SVAddDeviceViewController alloc] init];
    [nav pushViewController:vc animated:YES];
}

// MARK: - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(SVNavigationController *)viewController {
    return YES;
}

/// 准备子控制器
- (void)prepareChildViewControllers {
    NSArray <NSDictionary *> *vcs = @[
        @{ @"className" : @"SVHomeViewController", @"title" : SVLocalized(@"home"), @"imageName" : @"home" },
        @{ @"className" : @"SVResourceViewController", @"title" : SVLocalized(@"resource"), @"imageName" : @"resource" },
        //@{ @"className" : @"SVPetViewController", @"title" : SVLocalized(@"pet"), @"imageName" : @"pet" },
        @{ @"className" : @"SVAIHomeViewController", @"title" : SVLocalized(@"pet"), @"imageName" : @"pet" },
        @{ @"className" : @"SVProfileViewController", @"title" : SVLocalized(@"profile_my"), @"imageName" : @"profile" }
    ];
    
    NSMutableArray <SVNavigationController *> *navs = [NSMutableArray arrayWithCapacity:vcs.count];
    for (NSDictionary *dict in vcs) {
        
        // 获取类名 创建控制器
        Class class = NSClassFromString(dict[@"className"]);
        SVBaseViewController *viewController = [[class alloc] init];
        
        // 设置标题
        //viewController.tabBarItem.title = dict[@"title"];
        
        // 设置 默认/选中图片
        NSString *normalImageName = [NSString stringWithFormat:@"tabbar_%@_normal", dict[@"imageName"]];
        NSString *selectImageName = [NSString stringWithFormat:@"tabbar_%@_selected", dict[@"imageName"]];
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        
        
        viewController.tabBarItem.image = normalImage;
        viewController.tabBarItem.selectedImage = selectImage;
        
        // 创建导航控制器
        SVNavigationController *nav = [[SVNavigationController alloc] initWithRootViewController:viewController];
        [navs addObject:nav];
    }
    
    // 设置子控制器
    self.viewControllers = [navs mutableCopy];
}

// MARK: - 设备 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
