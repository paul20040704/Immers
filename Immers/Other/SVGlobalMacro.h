//
//  SVGlobalMacro.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#ifndef SVGlobalMacro_h
#define SVGlobalMacro_h

//// MARK: - 第三方头文件
#import "Masonry.h"
#import "YYModel.h"
#import "YYText.h"
#import "SVProgressHUD.h"
#import "UIScrollView+EmptyDataSet.h"
#import "YYWebImage.h"
#import "MJRefresh.h"
#import "RSKImageCropper.h"

#import "WXApi.h"
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

// MARK: - 头文件
#import "UILabel+Extension.h"
#import "UIButton+Extension.h"
#import "UITextField+Extension.h"
#import "UITextView+Extension.h"
#import "UIImageView+Extension.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"
#import "NSString+Extension.h"
#import "NSData+Extension.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"
#import "MJRefreshHeader+Extension.h"
#import "MJRefreshFooter+Extension.h"
#import "UIAlertController+Extension.h"

#import "SVAlertViewController.h"

#import "SVEmptyView.h"
#import "SVAuthorization.h"


#import "SVUserAccount.h"
#import "SVLanguage.h"

// 服务
#import "SVUserService.h"

// 布局
#import "SVFlowLayout.h"

// MQTT / UDP
#import "SVMQTTManager.h"
#import "SVUDPSocket.h"
#import "SVTimer.h"


#define kRelease  0   // 0->正式版  1->预发布环境  2->测试服  3->本地服务器

#if kRelease == 0
#define kBaseURL          @"https://api.nuwo.ai/v1/"  // 正式服务器
#define kMQTTHost         @"mqtt.nuwo.ai"  // MQTT服务IP
#define kMQTTPort         1883
#define kEvn              @"prd" // 当前环境 服务器需要的公共参数
#define kPath             @"release"  // 阿里云存储路径

#elif kRelease == 1
#define kBaseURL          @""    // 预发布服务器
#define kEvn              @"pre"
#define kPath             @"test"

#elif kRelease == 2
#define kBaseURL          @"http://api.nuwo.ai:6061/v1/"    // 测试服务器
#define kMQTTHost         @"mqtt.nuwo.ai"
#define kMQTTPort         1882
#define kEvn              @"test"
#define kPath             @"test"

#elif kRelease == 3
#define kBaseURL          @""       // 本地服务器
#define kMQTTHost         @""
#define kEvn              @"dev"
#define kPath             @"test"

#elif kRelease == 10
#define kBaseURL          @""    // 测试服务器
#define kMQTTHost         @""
#define kEvn              @"test"
#define kPath             @"test"

#endif

/// 第三方key
#define kBuglyAPPID      @""
#define kUmengAPPID      @""
#define kPushAPPID       @""

/// 事件类型
typedef NS_ENUM(NSInteger, SVButtonEvent) {
    SVButtonEventLogin = 100, // 登录
    SVButtonEventRegister, // 注册
    SVButtonEventForgot, // 忘记密码
    SVButtonEventApple, // 苹果登录
    SVButtonEventWechat, // 微信登录
    SVButtonEventFacebook, // Facebook登录
    SVButtonEventVolumeUp, // 音量+
    SVButtonEventVolumeDown, // 音量-
    SVButtonEventPrevious, // 上一张
    SVButtonEventNext, // 下一张
    SVButtonEventHome, // 返回首页
    SVButtonEventPrivacy, // 隐私政策
    SVButtonEventAgreement, // 用户协议
    SVButtonEventIntroduce, // 产品介绍
    SVButtonEventSelectAll, // 全选相框
    SVButtonEventUnselected, // 取消全选相框
    SVButtonEventUpload, // 上传图片
    SVButtonEventDownloadResource,//下载资源
    SVButtonEventCode//選擇國碼
};

/// 事件类型
typedef NS_ENUM(NSInteger, SVApnsEvent) {
    SVApnsEventApplyInform = 100, // 申请加入相框 通知
    SVApnsEventInviteInform, // 收到邀请 通知
};

// MARK: - 常量
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

// iPhoneX 系列
#define kIsiPhoneX ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0)
// 底部安全间距
#define kSafeAreaBottom (kIsiPhoneX ? 34.0 : 0.0)
// 导航栏高度
#define kNavBarHeight   (kIsiPhoneX ? 88.0 : 64.0)
// 选项卡高度
#define kTabBarHeight   (kIsiPhoneX ? 83.0 : 49.0)
// 状态栏高度
#define kStatusBarHeight   (kIsiPhoneX ? 44.0 : 20.0)

// 宽度缩放系数
#define kWidthScale [[NSString stringWithFormat:@"%.1f", (kScreenWidth / 375.0)] floatValue]
// 高度缩放系数
#define kHeightScale [[NSString stringWithFormat:@"%.1f", (kScreenHeight / 812.0)] floatValue]

// 弱引用
#define kWself __weak typeof(self) wself = self;
#define kSself __strong typeof(self) sself= wself;
// 宽
#define kWidth(width) (roundf((width * kWidthScale)))
// 高
#define kHeight(height) (roundf((height * kHeightScale)))
// 全局的间距
#define kWidthSpace  kWidth(15)
#define kHeightSpace kHeight(15)

// 转出来3d图片的大小(5-8m,取8m)
#define kCover3DImageSize 8*1024*1024

#define SVLocalized(text) [SVLanguage localizedForKey:text]

/// 手机号
static NSInteger const kPhoneNumberMaxLength = 11;
/// 密码
static NSInteger const kPasswordMaxLength = 30;
/// 名称最大长度
static NSInteger const kNameMaxLength = 50;
/// 验证码
static NSInteger const kCodeMaxLength = 6;
/// 超时
static NSInteger const kTimeOutSecond = 30;
/// 相框存储小于50M
static NSUInteger const kNotStorage = 52428800;

static NSString *const KErrorMsg = @"errorMsg";
static NSString *const KTotalPage = @"totalPage";
static NSString *const kSSID = @"HOLO .O.S";
static NSString *const kPassword = @"88888888";
static NSString *const kDeviceId = @"deviceId";
static NSString *const kSaveImageKey = @"saveImageKey";
static NSString *const kDeviceSSIDKey = @"SSID";
static NSString *const kPrivacyAdmit = @"privacyAdmit";

/// token 过期
static NSInteger const kTokenExpiredErrorCode = -1;

// MARK: - 通知 NSNotificationCenter
// 切换控制器
static NSString *const kSwitchRootViewControllerNotification = @"SVSwitchRootViewControllerNotification";
// 上传文件
static NSString *const kSelectedFileToUploadNotification = @"SVSelectedFileToUploadNotification";
// 编辑及更新个人信息
static NSString *const kEditedToUpdateUserProfileNotification = @"SVEditedToUpdateUserProfileNotification";
// 切换语言
static NSString *const kSwitchLanguageNotification = @"SVSwitchLanguageNotification";
/// 跳转添加设备，并且tab回到首页
static NSString *const kToAddDeviceAndBackHomeNotification = @"SVToAddDeviceAndBackHomeNotification";
// 重新加载绑定设备
static NSString *const kReloadBindDevicesNotification = @"SVReloadBindDevicesNotification";
/// 更新设备信息
static NSString *const kUpdateDeviceStatusNotification = @"SVUpdateDeviceStatusNotification";
/// 重新连接上网络或热点
static NSString *const kNetworkReachabilityStatusNotification = @"SVNetworkReachabilityStatusNotification";
/// 用户同意了隐私协议
static NSString *const kUserAdmitPrivacyNotification = @"SVUserAdmitPrivacyNotification";
/// 接受申请
static NSString *const kMemberApplyNotification = @"SVMemberApplyNotification";

// MARK: - 字体
#define kBoldFont(fontSize) [UIFont boldSystemFontOfSize:(fontSize) * kWidthScale]
#define kSystemFont(fontSize) [UIFont systemFontOfSize:(fontSize) * kWidthScale]

// MARK: - 调试Log
#ifdef DEBUG
#define DebugLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
#define DebugLog(format, ...)
#endif


#define kShowLoading [SVProgressHUD showWithStatus:SVLocalized(@"tip_loading")];
#define kDismissLoading [SVProgressHUD dismiss];

#define kDevAccount @""
#define kDevPassword @""


#endif /* SVGlobalMacro_h */
