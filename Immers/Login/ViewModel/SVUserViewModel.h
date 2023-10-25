//
//  SVUserViewModel.h
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import "SVBaseViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SVUserViewModel : SVBaseViewModel

/// 登录
/// @param parameters 参数
/// @param completion 完成回调
- (void)login:(NSDictionary *)parameters completion:(SVMessageCompletion)completion;

/// 注册
/// @param parameters 参数
/// @param completion 完成回调
- (void)register:(NSDictionary *)parameters completion:(SVMessageCompletion)completion;

/// 帐号检查
/// @param account 帐号
/// @param completion 完成回调
- (void)account:(NSString *)account completion:(SVSuccessCompletion)completion;

/// 用户名字帐号密码全检查
/// @param parameters 参数
/// @param completion 完成回调
- (void)verifyUser:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 忘记密码
/// @param parameters 参数
/// @param completion 完成回调
- (void)forget:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 修改密码
/// @param parameters 参数
/// @param completion 完成回调
- (void)updatePassword:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 用户登出
/// @param completion 完成回调
- (void)logoutCompletion:(SVSuccessCompletion)completion;

/// 发送验证码
/// @param account 帐号
/// @param completion 完成回调
- (void)sendCode:(NSString *)account countryCode:(NSString *)code completion:(SVSuccessCompletion)completion;

/// 校验验证码
/// @param parameters 参数
/// @param completion 完成回调
- (void)validCode:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 用户信息
/// @param completion 完成回调
- (void)userCompletion:(SVRequestCompletion)completion;

/// 修改用户信息
/// @param parameters 参数
/// @param completion 完成回调
- (void)update:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 修改用户头像
/// @param avarat 头像
/// @param completion 完成回调
- (void)updateAvarat:(UIImage *)avarat completion:(SVSuccessCompletion)completion;

/// 校验原密码
/// @param parameters 参数
/// @param completion 完成回调
- (void)validPassword:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 注销帐号
/// @param parameters 参数
/// @param completion 完成回调
- (void)removeAccount:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 苹果登录
/// @param parameters 参数
/// @param completion 完成回调
- (void)appleLogin:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 微信登录
/// @param parameters 参数
/// @param completion 完成回调
- (void)wechatLogin:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 判断第三方登录是否已经注册
/// @param parameters 参数
/// @param completion 完成回调
- (void)verifyThirdParty:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 第三方登录 绑定手机号、邮箱
/// @param parameters 参数
/// @param completion 完成回调
- (void)bindAccount:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

///  手机号、邮箱登录 第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
- (void)bindThirdParty:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

///  手机号、邮箱登录 解绑第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
- (void)unbindThirdParty:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

@end

NS_ASSUME_NONNULL_END
