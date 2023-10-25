//
//  SVUserService.m
//  Immers
//
//  Created by developer on 2022/5/28.
//

#import "SVUserService.h"

@implementation SVUserService

/// 登录
+ (void)login:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/login" parameters:parameters completion:completion];
}

/// 注册
+ (void)register:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/register" parameters:parameters completion:completion];
}

/// 帐号检查
+ (void)account:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/checkAccount" parameters:parameters completion:completion];
}

/// 用户名字帐号密码全检查
+ (void)verifyUser:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/checkUser" parameters:parameters completion:completion];
}

/// 忘记密码
+ (void)forget:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/forgetPassword" parameters:parameters completion:completion];
}

/// 修改密码
+ (void)updatePassword:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/updatePassword" parameters:parameters completion:completion];
}

/// 用户登出
+ (void)logoutCompletion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/logout" parameters:@{} completion:completion];
}

/// 发送验证码
+ (void)sendCode:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/sendCode" parameters:parameters completion:completion];
}

/// 校验验证码
+ (void)validCode:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/validCode" parameters:parameters completion:completion];
}

/// 获取阿里云STS服务
+ (void)aliCompletion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] GET:@"user/aliyun/sts/token" parameters:@{} completion:completion];
}

/// 用户信息
/// @param completion 完成回调
+ (void)userCompletion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/getUserInfo" parameters:@{} completion:completion];
}

/// 修改用户信息
/// @param parameters 参数
/// @param completion 完成回调
+ (void)update:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"user/updateUserInfo" parameters:parameters completion:completion];
}

/// 校验原密码
/// @param parameters 参数
/// @param completion 完成回调
+ (void)validPassword:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/pwd/validPassword" parameters:parameters completion:completion];
}

/// 注销帐号
+ (void)removeAccount:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/closeAccount" parameters:parameters completion:completion];
}

/// 微信登录 获取用户信息
/// @param parameters 参数
/// @param completion 完成回调
+ (void)userInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    // 获取accessToken
    [[SVNetworkManager sharedManager] accessToken:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) { // 获取accessToken 成功
            NSDictionary *dict = @{ @"openid" : info[@"openid"], @"access_token" : info[@"access_token"] };
            [[SVNetworkManager sharedManager] userInfo:dict completion:^(NSInteger errorCode, NSDictionary *info) {
                if (0 == errorCode) {  // 获取用户信息 成功
                    completion(errorCode, info);
                } else { // 获取用户信息 失败
                    completion(errorCode, info);
                }
            }];
        } else { // 获取accessToken 失败
            completion(errorCode, info);
        }
    }];
}

/// 苹果登录
+ (void)appleLogin:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/appleLogin" parameters:parameters completion:completion];
}

/// 微信登录
+ (void)wechatLogin:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/wechatLogin" parameters:parameters completion:completion];
}

/// 判断第三方登录是否已经注册
+ (void)verifyThirdParty:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/thirdPartyLogin" parameters:parameters completion:completion];
}

/// 绑定手机号、邮箱
/// @param parameters 参数
/// @param completion 完成回调
+ (void)bindAccount:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/bindAccount" parameters:parameters completion:completion];
}

///  手机号、邮箱登录 第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
+ (void)bindThirdParty:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/bindThirdParty" parameters:parameters completion:completion];
}

///  手机号、邮箱登录 解绑第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
+ (void)unbindThirdParty:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"account/unpinless" parameters:parameters completion:completion];
}

@end
