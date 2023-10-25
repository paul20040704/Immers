//
//  SVNetworkManager.h
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SVRequestCompletion)(NSInteger errorCode, NSDictionary *info);

@interface SVNetworkManager : AFHTTPSessionManager

/// 网络单例
+ (instancetype)sharedManager;

// MARK: - POST 方法
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

// MARK: - GET 方法
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

// MARK: - PUT 方法
- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

// MARK: - DELETE 方法
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

// MARK: - upload
/// 上传图片
- (void)uploadURL:(NSString *)URLString images:(NSArray<NSData *> *)images progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion;

/// 上传视频
- (void)uploadURL:(NSString *)URLString video:(NSData *)video progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion;

/// 上传文件
- (void)upload:(NSString *)URLString type:(NSInteger)type suffix:(NSString *)suffix name:(NSString *)name files:(NSArray<NSData *> *)files progress:(nullable void(^)(double uploadProgress))progress finished:(SVRequestCompletion)finished;
// MARK: - wechat登录

/// 获取accessToken
/// @param parameters 参数 appid secret code grant_type=authorization_code
/// @param completion 回调
- (void)accessToken:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 获取用户信息
/// @param parameters 参数 openid access_token
/// @param completion 回调
- (void)userInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END

