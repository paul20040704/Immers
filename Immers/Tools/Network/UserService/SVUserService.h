//
//  SVUserService.h
//  Immers
//
//  Created by developer on 2022/5/28.
//

#import "SVNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVUserService : NSObject

/// 登录
/// @param parameters 参数
/// @param completion 完成回调
+ (void)login:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 注册
/// @param parameters 参数
/// @param completion 完成回调
+ (void)register:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 帐号检查
/// @param parameters 参数
/// @param completion 完成回调
+ (void)account:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 用户名字帐号密码全检查
/// @param parameters 参数
/// @param completion 完成回调
+ (void)verifyUser:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 忘记密码
/// @param parameters 参数
/// @param completion 完成回调
+ (void)forget:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 修改密码
/// @param parameters 参数
/// @param completion 完成回调
+ (void)updatePassword:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 用户登出
/// @param completion 完成回调
+ (void)logoutCompletion:(SVRequestCompletion)completion;

/// 发送验证码
/// @param parameters 参数
/// @param completion 完成回调
+ (void)sendCode:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 校验验证码
/// @param parameters 参数
/// @param completion 完成回调
+ (void)validCode:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 获取阿里云STS服务
/// @param completion 完成回调
+ (void)aliCompletion:(SVRequestCompletion)completion;

/// 用户信息
/// @param completion 完成回调
+ (void)userCompletion:(SVRequestCompletion)completion;

/// 修改用户信息
/// @param parameters 参数
/// @param completion 完成回调
+ (void)update:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 校验原密码
/// @param parameters 参数
/// @param completion 完成回调
+ (void)validPassword:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 注销帐号
/// @param parameters 参数
/// @param completion 完成回调
+ (void)removeAccount:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;


/// 微信登录 获取用户信息
/// @param parameters 参数 appid secret code grant_type=authorization_code
/// @param completion 完成回调
+ (void)userInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 苹果登录
/// @param parameters 参数
/// @param completion 完成回调
+ (void)appleLogin:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 微信登录
/// @param parameters 参数
/// @param completion 完成回调
+ (void)wechatLogin:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 判断第三方登录是否已经注册
/// @param parameters 参数
/// @param completion 完成回调
+ (void)verifyThirdParty:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 绑定手机号、邮箱
/// @param parameters 参数
/// @param completion 完成回调
+ (void)bindAccount:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

///  手机号、邮箱登录 第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
+ (void)bindThirdParty:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

///  手机号、邮箱登录 解绑第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
+ (void)unbindThirdParty:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END
