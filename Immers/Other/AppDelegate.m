//
//  AppDelegate.m
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "AppDelegate.h"
#import "AppDelegate+SVRequest.h"
#import "SVMainViewController.h"
#import "SVNavigationController.h"
#import "SVLoginViewController.h"
#import "SVLoginManager.h"
#import <Bugly/Bugly.h>
#import <UMCommon/UMCommon.h>
# import "JPUSHService.h"
# import <UserNotifications/UserNotifications.h>
#import "SVApns.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    // 语言
    [SVLanguage sharedLanguage];
    // 切换控制器
    [self switchRootViewController];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    // 注册通知
    [self addNotification];
    
    // 全局设置
    [self prepareProgressHUD];
    [self prepareNetworkReachability];
    [self prepareApns:launchOptions];
    
    // 第三方登录 注册appid
    [SVLoginManager sharedManager];
    // facebook 登录
    //    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //友盟和bugly 需要在用户同意了隐私协议之后再注册
    BOOL privacyAdmit = [[NSUserDefaults standardUserDefaults] boolForKey:kPrivacyAdmit];
    if(privacyAdmit){
        [self initThirdParty];
    }
    //网络请求
    [self updateVersion];
    //UI要求增加启动页时间
    [NSThread sleepForTimeInterval:1];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    ///  注册 DeviceToken
    DebugLog(@"deviceToken %@", deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)initThirdParty {
    [Bugly startWithAppId:kBuglyAPPID];
    [UMConfigure initWithAppkey:kUmengAPPID channel:nil];
}

// MARK: - Notification
/// 切换根控制器
- (void)switchRootViewController {
    SVUserAccount *account = [SVUserAccount sharedAccount];
    if (account.isLogon) { // 登录了 并且没有过期
        SVMainViewController *vc = [[SVMainViewController alloc] init];
        self.window.rootViewController = vc;
        
        // 设置别名
        NSString *uid = [account.userId stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [JPUSHService setAlias:uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            DebugLog(@"setAlias --> %@", iAlias);
        } seq:0] ;
        
    } else { // 没有登录 或 登录过期了
        self.window.rootViewController = [[SVNavigationController alloc] initWithRootViewController:[[SVLoginViewController alloc] init]];
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            DebugLog(@"deleteAlias --> %@", iAlias);
        } seq:0];
    }
    
}
/// 切换语言
- (void)switchLanguage {
    [self switchRootViewController];
    if ([self.window.rootViewController isKindOfClass:[SVMainViewController class]]) {
        SVMainViewController *viewController = (SVMainViewController *)self.window.rootViewController;
        [viewController reloadMainViewController];
    }
}

/// 跳转添加设备，并且tab回到首页
- (void)toAddDeviceAndBackHome {
    [self switchRootViewController];
    if ([self.window.rootViewController isKindOfClass:[SVMainViewController class]]) {
        SVMainViewController *viewController = (SVMainViewController *)self.window.rootViewController;
        [viewController toAddDeviceAndBackHome];
    }
}

/// 注册通知
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController) name:kSwitchRootViewControllerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchLanguage) name:kSwitchLanguageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toAddDeviceAndBackHome) name:kToAddDeviceAndBackHomeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initThirdParty) name:kUserAdmitPrivacyNotification object:nil];
}

// MARK: - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //    if ([WXApi handleOpenURL:url delegate:[SVLoginManager sharedManager]]) {
    //        return YES;
    //    }
    
    return [WXApi handleOpenURL:url delegate:[SVLoginManager sharedManager]];
    //    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:[SVLoginManager sharedManager]];
}

// MARK: -JPUSHRegisterDelegate
// 前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // 通知内容
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
    
    SVApns *apns = [SVApns yy_modelWithJSON:userInfo];
    if ([apns.type isEqualToString:@"applyInform"]) {
        // 列表
        if ([self.window.rootViewController isKindOfClass:[SVMainViewController class]]) {
            SVMainViewController *viewController = (SVMainViewController *)self.window.rootViewController;
            [viewController handleNotification:SVApnsEventApplyInform info:apns];
        }
        
    } else if ([apns.type isEqualToString:@"inviteInform"]) {
        // 弹窗
        if ([self.window.rootViewController isKindOfClass:[SVMainViewController class]]) {
            SVMainViewController *viewController = (SVMainViewController *)self.window.rootViewController;
            [viewController handleNotification:SVApnsEventInviteInform info:apns];
        }
    } else  {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadBindDevicesNotification object:nil];
    }
}

// 后台 点击处理事件
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    SVApns *apns = [SVApns yy_modelWithJSON:userInfo];
    if ([apns.type isEqualToString:@"applyInform"]) {
        // 列表
        if ([self.window.rootViewController isKindOfClass:[SVMainViewController class]]) {
            SVMainViewController *viewController = (SVMainViewController *)self.window.rootViewController;
            [viewController handleNotification:SVApnsEventApplyInform info:apns];
        }
    }
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    if (status != JPAuthorizationStatusAuthorized) {
        [SVProgressHUD showInfoWithStatus:SVLocalized(@"home_notification_denied")];
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
}

// MARK: - dealloc
/// 注销通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - 全局设置
// APNs
- (void)prepareApns:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setupWithOption:launchOptions appKey:kPushAPPID
                          channel:@"App Store"
                 apsForProduction:kRelease == 0
            advertisingIdentifier:nil];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

/// 设置HUD
- (void)prepareProgressHUD {
    [SVProgressHUD setBackgroundColor:[UIColor grayColor4]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setCornerRadius:kHeight(2)];
    [SVProgressHUD setImageViewSize:CGSizeZero];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wnonnull"
    [SVProgressHUD setInfoImage:nil];
#pragma clang diagnostic pop
}

/// 监听网络状态
- (void)prepareNetworkReachability {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            DebugLog(@"有网络了");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkReachabilityStatusNotification object:nil];
        } else {
            DebugLog(@"断网络了 ^_^");
        }
    }];
    [manager startMonitoring];
}

@end
