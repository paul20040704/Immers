//
//  SVFileManager.m
//  Immers
//
//  Created by developer on 2022/5/31.
//

#import "SVFileManager.h"
#import "NSData+Extension.h"
#import <AliyunOSSiOS/OSSService.h>
#import "SVGlobalMacro.h"

#define kAliyunEndpointKey       @"https://oss-cn-hangzhou.aliyuncs.com"
#define kAliyunDomainName        @"https://immers.oss-cn-hangzhou.aliyuncs.com"
#define kAliyunBucketName        @"immers"

@implementation SVFileManager {
    OSSClient *_fileClient;
}

+ (instancetype)sharedManager {
    static SVFileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 创建OSSClient
/// @param parameters 参数
- (void)prepareClient:(NSDictionary *)parameters {
    if (parameters.allKeys.count < 4) {
        return;
    }
    OSSFederationCredentialProvider<OSSCredentialProvider> *provider = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken *{
        OSSFederationToken *token = [[OSSFederationToken alloc] init];
        // 从STS服务获取的临时访问密钥（AccessKey ID和AccessKey Secret）。
        token.tAccessKey = parameters[@"accessKeyId"];
        token.tSecretKey = parameters[@"accessKeySecret"];
        // 从STS服务获取的安全令牌（SecurityToken）。
        token.tToken = parameters[@"securityToken"];
        // 临时访问凭证的过期时间。
        token.expirationTimeInGMTFormat = parameters[@"expiration"];
        return token;
    }];
    
    _fileClient = [[OSSClient alloc] initWithEndpoint:kAliyunEndpointKey credentialProvider:provider];
}

// MARK: - ali upload
/// 上传图片
- (void)uploadImages:(NSArray<UIImage *> *)images objectKey:(NSString *)objectKey completion:(void(^)(NSArray *filePaths, BOOL isSuccess))completion {
    if (nil == _fileClient) {
        if (completion) {
            completion(@[@"请选创建 OSSClient"], NO);
        }
        return;
    }
    
    if (images.count <= 0 || nil == objectKey || objectKey.length <= 0) {
        if (completion) {
            completion(@[@"image或key 为空"], NO);
        }
        return;
    }
    
    // 记录是否成功
    __block BOOL success = NO;
    // 保存链接
    NSMutableArray <NSString *> *filePaths = [NSMutableArray arrayWithCapacity:images.count];
    // 创建子线程
    dispatch_async(dispatch_queue_create(0, 0), ^{
        // 调度组
        dispatch_group_t group = dispatch_group_create();
        // 遍历图片数据
        for (UIImage *avarat in images) {
            // 上传对象
            OSSPutObjectRequest *put = [[OSSPutObjectRequest alloc] init];
            // 桶名
            put.bucketName = kAliyunBucketName;
            // 图片 / 图片名
            NSData *avaratData = UIImagePNGRepresentation(avarat);
            NSString *fileName = [NSString stringWithFormat:@"%@.png", avaratData.md5String];
            // 路径
            put.objectKey = [objectKey stringByAppendingString:fileName];
            // 上传的数据
            put.uploadingData = avaratData;
            // 入组
            dispatch_group_enter(group);
            // 开始上传
            OSSTask *task = [self->_fileClient putObject:put];
            // 等待完成
            [task waitUntilFinished];
            // 完成回调
            [task continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    NSLog(@"upload object success!");
                    // 拼接路径
                    [filePaths addObject:[kAliyunDomainName stringByAppendingFormat:@"/%@", put.objectKey]];
                    success = YES; // 设置成功
                } else {
                    // 上传失败
                    NSLog(@"upload object failed, error: %@" , task.error);
                    success = NO;
                }
                // 出组
                dispatch_group_leave(group);
                return nil;
            }];
        }

        // 全部完成 通知 及 回调
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (completion) {
                completion(filePaths, success);
            }
        });
    });
}

// MARK: - 2转3 upload
/// 上传图片
- (void)uploadURL:(NSString *)URLString convertId:(NSString *)convertIdString images:(NSArray<NSData *> *)images progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion {
    [self upload:URLString convertId:convertIdString type:1 files:images progress:progress finished:completion];
}

- (void)uploadURL:(NSString *)URLString convertId:(NSString *)convertIdString video:(NSData *)video progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion {
    if (nil == video) { return; }
    [self upload:URLString convertId:convertIdString type:2 files:@[video] progress:progress finished:completion];
}


/// 上传文件
/// @param URLString 路径
/// @param type 上传类型 1 == 图片  2 == 视频
/// @param files 文件
/// @param finished 完成回调
- (void)upload:(NSString *)URLString convertId:(NSString *)convertIdString type:(NSInteger)type files:(NSArray<NSData *> *)files progress:(nullable void(^)(double uploadProgress))progress finished:(SVRequestCompletion)finished {
    // 文件名后缀 / 类型
    NSString *suffix = @".png";
    NSString *mimeType = @"image/png";
    if (2 == type) {
        suffix = @".mp4";
        mimeType = @"video/mp4";
    }
    
    NSDictionary *dict = @{ @"api_server" : 0 == kRelease ? @"2" : @"1" };

    DebugLog(@"上传：%@", dict);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:URLString]];
    [manager POST:URLString parameters:dict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
        
        // 遍历参数
        for (NSData *file in files) {
            NSString *fileName = [NSString stringWithFormat:@"%@%@", [file md5String], suffix];
            // 拼接表单
            [formData appendPartWithFileData:file name:@"file" fileName:fileName mimeType:mimeType];
        }
        
        NSData *paramData = [convertIdString dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:paramData name:@"convertId"];
        
    } progress:^(NSProgress *uploadProgress) {
        if (progress) {
            double completed = uploadProgress.completedUnitCount / (uploadProgress.totalUnitCount + 0.0);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(completed);
            });
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dataDict = responseObject[@"data"];
        NSString *value = dataDict[@"convertId"];
        if (nil != value && value.length > 0) {
            finished(0, responseObject);
        } else {
            finished(9999, responseObject);
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
        finished(9999, result);
    }];
}

/// 2转3 转换进度
/// @param urlString 路径
/// @param completion 完成回调
- (void)converted:(NSString *)urlString completion:(SVRequestCompletion)completion {
    DebugLog(@"converted：%@", urlString);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://get3dfrom2d.com/get_converted/ph79f/"]];
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if (responseObject.allValues.count > 1) {
            completion(0, responseObject);
            DebugLog(@"converted response -> %@", responseObject);
        } else {
            completion(9999, @{ KErrorMsg : SVLocalized(@"tip_request_failed") });
        }
        
        DebugLog(@"converted End");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(9999, @{ KErrorMsg : SVLocalized(@"tip_request_failed") });
        DebugLog(@"converted %@", error);
    }];
}

@end
