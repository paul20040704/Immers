//
//  SVFileService.m
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import "SVFileService.h"
#import "SVFileManager.h"
#import "SVGlobalMacro.h"

#define kAliyunProfileAvaratKey  @"image/header_image/" // 个人头像路径

@implementation SVFileService

/// 上传图片
/// @param avarat 图片数据
/// @param credentials 阿里证书
/// @param completion 完成回调
+ (void)uploadAvarat:(UIImage *)avarat credentials:(NSDictionary *)credentials completion:(void(^)(NSString *path, BOOL isSuccess))completion {
    if (nil == avarat || ![avarat isKindOfClass:[UIImage class]]) {
        completion(@"图片数据有问题", NO);
        return;
    }
    
    if (nil == credentials || ![credentials isKindOfClass:[NSDictionary class]]) {
        completion(@"证书有问题", NO);
        return;
    }
    [[SVFileManager sharedManager] prepareClient:credentials];
    NSString *key = [NSString stringWithFormat:@"%@/%@", kPath, kAliyunProfileAvaratKey];
    [[SVFileManager sharedManager] uploadImages:@[avarat] objectKey:key completion:^(NSArray *filePaths, BOOL isSuccess) {
        completion(filePaths.firstObject, isSuccess);
    }];
}

+ (void)uploadURL:(NSString *)URLString convertId:(NSString *)convertIdString image:(NSData *)data fileType:(NSString *)type progress:(nullable void(^)(double uploadProgress))progress completion:(void(^)(NSString *path, BOOL isSuccess))completion {
    if (nil == data || ![data isKindOfClass:[NSData class]]) {
        completion(@"图片数据有问题", NO);
        return;
    }
    if ([type isEqual:@"1"]) {
        [[SVFileManager sharedManager] uploadURL:URLString convertId:convertIdString images:@[data] progress:progress completion:^(NSInteger errorCode, NSDictionary * info) {
            DebugLog(@"文件 2转3 返回：%@", info);
            NSDictionary *dataDict = info[@"data"];
            completion(dataDict[@"convertId"], 0 == errorCode);
        }];
    }else {
        [[SVFileManager sharedManager] uploadURL:URLString convertId:convertIdString video:data progress:progress completion:^(NSInteger errorCode, NSDictionary * info) {
            DebugLog(@"文件 2转3 返回：%@", info);
            NSDictionary *dataDict = info[@"data"];
            completion(dataDict[@"convertId"], 0 == errorCode);
        }];
    }
    
}

/// 2转3 转换进度
/// @param urlString 路径
/// @param completion 完成回调
+ (void)converted:(NSString *)urlString completion:(void (^)(BOOL isSuccess, NSDictionary *))completion {
    [[SVFileManager sharedManager] converted:urlString completion:^(NSInteger errorCode, NSDictionary *info) {
        completion(0 == errorCode, info);
    }];
}
@end
