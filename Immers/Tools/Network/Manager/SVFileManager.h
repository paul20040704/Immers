//
//  SVFileManager.h
//  Immers
//
//  Created by developer on 2022/5/31.
//

#import <UIKit/UIKit.h>
#import "SVNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVFileManager : NSObject

/// 文件单例
+ (instancetype)sharedManager;

/// 创建OSSClient
/// @param parameters 参数
- (void)prepareClient:(NSDictionary *)parameters;

// MARK: - ali upload
/// 上传图片
/// @param images 图片数据
/// @param objectKey 路径
/// @param completion 完成回调
- (void)uploadImages:(NSArray<UIImage *> *)images objectKey:(NSString *)objectKey completion:(void(^)(NSArray *filePaths, BOOL isSuccess))completion;

// MARK: - 2转3 upload
/// 上传图片
- (void)uploadURL:(NSString *)URLString convertId:(NSString *)convertIdString images:(NSArray<NSData *> *)images progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion;

/// 上传视频
- (void)uploadURL:(NSString *)URLString convertId:(NSString *)convertIdString video:(NSData *)video progress:(nullable void(^)(double uploadProgress))progress completion:(SVRequestCompletion)completion;

/// 2转3 转换进度
/// @param urlString 路径
/// @param completion 完成回调
- (void)converted:(NSString *)urlString completion:(SVRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END
