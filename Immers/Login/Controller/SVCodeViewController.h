//
//  SVCodeViewController.h
//  Immers
//
//  Created by developer on 2022/5/14.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 事件类型
typedef NS_ENUM(NSInteger, SVCodeType) {
    SVCodeTypeRegister = 100, // 注册
    SVCodeTypeForgot, // 忘记密码
    SVCodeTypeRemoveAccount, // 注销帐号
    SVCodeTypeBindAccount, // 绑定帐号
};

@interface SVCodeViewController : SVBaseViewController

/// 验证码 Controller
/// @param type 验证码类型
+ (instancetype)viewControllerWithType:(SVCodeType)type;

/// 参数
@property (nonatomic, strong) NSDictionary *parameters;


@end

NS_ASSUME_NONNULL_END
