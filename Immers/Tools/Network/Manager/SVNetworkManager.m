//
//  SVNetworkManager.m
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import "SVNetworkManager.h"
#import "SVGlobalMacro.h"

@protocol SVNetworkManagerProxy <NSObject>
@optional
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

@interface SVNetworkManager () <SVNetworkManagerProxy>

@end

@implementation SVNetworkManager

+ (instancetype)sharedManager {
    static SVNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        // 响应
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", nil];
        // 请求
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        // 超时
        instance.requestSerializer.timeoutInterval = 30.0;
    });
    return instance;
}

// MARK: - POST 方法
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    return [self requestWithMethod:@"POST" URLString:URLString parameters:parameters finished:completion];
}

// MARK: - GET 方法
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    return [self requestWithMethod:@"GET" URLString:URLString parameters:parameters finished:completion];
}

// MARK: - PUT 方法
- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    return [self requestWithMethod:@"PUT" URLString:URLString parameters:parameters finished:completion];
}

// MARK: - DELETE 方法
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    return [self requestWithMethod:@"DELETE" URLString:URLString parameters:parameters finished:completion];
}

// MARK: - upload
/// 上传图片
- (void)uploadURL:(NSString *)URLString images:(NSArray<NSData *> *)images progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion {
    [self upload:URLString type:0 files:images progress:progress finished:completion];
}

- (void)uploadURL:(NSString *)URLString video:(NSData *)video progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion {
    if (nil == video) { return; }
    [self upload:URLString type:1 files:@[video] progress:progress finished:completion];
}

// MARK: - 封装 AFN 网络访问方法
/// 发起网络请求
///
/// @param method     GET / POST
/// @param URLString  URLString
/// @param parameters 请求参数字典
/// @param finished   完成回调
- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters finished:(SVRequestCompletion)finished {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    SVUserAccount *account = [SVUserAccount sharedAccount];
    if (account.isLogon) {
        [dict setValue:account.loginKey forKey:@"loginKey"];
        [dict setValue:account.userId forKey:@"uid"];
    }
    DebugLog(@"\n方法：%@ \n接口：%@ \n请求参数：%@ \n语言：%@", method, URLString, dict, [SVLanguage remote]);
    
    // 设置额外参数 app版本号 手机系统版本 时间戳 环境
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *date = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
    [dict setValue:@"iOS" forKey:@"os"];
    [dict setValue:kEvn forKey:@"evn"];
    [dict setValue:appVersion forKey:@"appVer"];
    [dict setValue:sysVersion forKey:@"osVer"];
    [dict setValue:date forKey:@"date"];
    
    // 设置语言
    [self.requestSerializer setValue:[SVLanguage remote] forHTTPHeaderField:@"Language"];
    
    NSURLSessionDataTask *task =  [self dataTaskWithHTTPMethod:method URLString:URLString parameters:[dict copy] headers:nil uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        NSInteger errorCode = [responseObject[@"code"] integerValue];
        NSDictionary *result = responseObject[@"data"];
        
        if (0 != errorCode) {
            DebugLog(@"请求失败: errorCode=%ld %@", errorCode, responseObject[@"errMsg"]);
            if (kTokenExpiredErrorCode == errorCode) { // token 过期
                [[SVUserAccount sharedAccount] removeAccount];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
                if (responseObject[@"errMsg"]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD showInfoWithStatus:responseObject[@"errMsg"]];
                    });

                }
            }
//            else if (kBindDeviceErrorCode == errorCode) { // 该设备已被绑定，请先解绑原帐号！！
//                finished( errorCode, result );
//                return;
//            }
            result = @{ KErrorMsg : responseObject[@"errMsg"] ? : SVLocalized(@"tip_request_failed") };
        }
        DebugLog(@"请求 End");
        DebugLog(@"\n返回数据：%@", result);
        if ([result isKindOfClass:[NSNull class]]) {
            result = @{ @"errMsg" : SVLocalized(@"tip_operation_succeed") };
        }
        
        if (finished) {
            finished(errorCode, [result isKindOfClass:[NSString class]] ? @{ @"errMsg" : result } : result );
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DebugLog(@"网络请求错误 %@ errorCode=%ld", error.localizedDescription, error.code);
        NSString *text = error.localizedDescription;
        if ([text containsString:@"appears to be offline."]) {
            text = SVLocalized(@"tip_disconnected");
        } else if ([text containsString:@"timed out."]) {
            text = SVLocalized(@"tip_poor_network");
        } else if ([text containsString:@"internal server error"]) {
            text = SVLocalized(@"tip_network_request");
        } else if ([text containsString:@"请求超时"]) {
            text = SVLocalized(@"tip_poor_network");
        } else {
            text = SVLocalized(@"tip_request_error");
        }
        
        NSDictionary *result = @{ KErrorMsg : text };
        if (error.domain==NSURLErrorDomain&&error.code==-999) {
            if (finished) {
                finished(-999, result);
            }
        }else{
            if (finished) {
                finished(9999, result);
            }
        }

    }];
    [task resume];
    return task;
}

// MARK: - upload
/// 上传文件
/// @param URLString 路径
/// @param type 上传类型 0 == 图片  1 == 视频
/// @param files 文件
/// @param finished 完成回调
- (void)upload:(NSString *)URLString type:(NSInteger)type files:(NSArray<NSData *> *)files progress:(nullable void(^)(double uploadProgress))progress finished:(SVRequestCompletion)finished {
    [self upload:URLString type:type suffix:@"" name:@"filename" files:files progress:progress finished:finished];
}

- (void)upload:(NSString *)URLString type:(NSInteger)type suffix:(NSString *)suffix name:(NSString *)name files:(NSArray<NSData *> *)files progress:(nullable void(^)(double uploadProgress))progress finished:(SVRequestCompletion)finished {
    // 文件名后缀 / 类型
    NSString *mimeType = @"image/png";
    if (suffix&&suffix.length>0) {
        if (1 == type) {
            mimeType = @"video/quicktime";
        }
    }else{
        suffix = @".png";
        if (1 == type) {
            suffix = @".mp4";
            mimeType = @"video/mp4";
        }
    }
    if (name.length<=0) {
        name = @"filename";
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:URLString]];
    [manager POST:URLString parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
        
        // 遍历参数
        for (NSData *file in files) {
            NSString *fileName = [NSString stringWithFormat:@"%@%@", [file md5String], suffix];
            // 拼接表单
            [formData appendPartWithFileData:file name:name fileName:fileName mimeType:mimeType];
        }
        
    } progress:^(NSProgress *uploadProgress) {
        if (progress) {
            double completed = uploadProgress.completedUnitCount / (uploadProgress.totalUnitCount + 0.0);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(completed);
            });
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (finished) {
            NSString *value = responseObject[@"key"];
            NSNumber *code = responseObject[@"code"];
            if (nil != value && value.length > 0) {
                finished(0, responseObject);
            } else {
                if (code) {
                    finished(code.intValue, responseObject);
                }else{
                    finished(9999, responseObject);
                }
                
            }
        }

        DebugLog(@"请求 End");
        
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        
        DebugLog(@"网络请求错误 %@ errorCode=%ld", error.localizedDescription, error.code);
        NSString *text = error.localizedDescription;
        if ([text containsString:@"appears to be offline."]) {
            text = SVLocalized(@"tip_disconnected");
        } else if ([text containsString:@"timed out."]) {
            text = SVLocalized(@"tip_poor_network");
        } else if ([text containsString:@"internal server error"]) {
            text = SVLocalized(@"tip_network_request");
        } else if ([text containsString:@"请求超时"]) {
            text = SVLocalized(@"tip_poor_network");
        } else {
            text = SVLocalized(@"tip_request_error");
        }
        
        NSDictionary *result = @{ KErrorMsg : text };
        if (finished) {
            finished(9999, result);
        }
    }];
    
}

// MARK: - wechat登录

/// 获取accessToken
/// @param parameters 参数 appid secret code grant_type=authorization_code
/// @param completion 回调
- (void)accessToken:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [self wechatRequestURLString:@"sns/oauth2/access_token" parameters:parameters finished:completion];
}

/// 获取用户信息
/// @param parameters 参数 appid access_token
/// @param completion 回调
- (void)userInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [self wechatRequestURLString:@"sns/userinfo" parameters:parameters finished:completion];
}

/// 微信登录请求
/// @param URLString 路径
/// @param parameters 参数
/// @param finished 回调
- (void)wechatRequestURLString:(NSString *)URLString parameters:(NSDictionary *)parameters finished:(SVRequestCompletion)finished {
    DebugLog(@"WX parameters： %@", parameters);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.weixin.qq.com/"]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", nil];
    [[manager dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:[parameters copy] headers:nil uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        DebugLog(@"WX responseObject： %@", responseObject);
        NSString *unionid = responseObject[@"unionid"];
        if (nil != unionid) {
            finished(0, responseObject);
        } else {
            NSDictionary *result = @{ KErrorMsg : SVLocalized(@"tip_login_failure") };
            finished(9999, result);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DebugLog(@"网络请求错误 %@ errorCode=%ld", error.localizedDescription, error.code);
        NSString *text = error.localizedDescription;
        if ([text containsString:@"appears to be offline."]) {
            text = SVLocalized(@"tip_disconnected");
        } else if ([text containsString:@"timed out."]) {
            text = SVLocalized(@"tip_poor_network");
        } else if ([text containsString:@"internal server error"]) {
            text = SVLocalized(@"tip_network_request");
        } else if ([text containsString:@"请求超时"]) {
            text = SVLocalized(@"tip_poor_network");
        } else {
            text = SVLocalized(@"tip_request_error");
        }
        
        NSDictionary *result = @{ KErrorMsg : text };
        if (finished) {
            finished(9999, result);
        }
        
    }] resume];
}

@end
