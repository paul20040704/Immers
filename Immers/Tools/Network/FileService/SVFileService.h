//
//  SVFileService.h
//  Immers
//
//  Created by developer on 2022/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVFileService : NSObject

/// 上传图片
/// @param avarat 图片数据
/// @param credentials 阿里证书
/// @param completion 完成回调
+ (void)uploadAvarat:(UIImage *)avarat credentials:(NSDictionary *)credentials completion:(void(^)(NSString *path, BOOL isSuccess))completion;


+ (void)uploadURL:(NSString *)URLString convertId:(NSString *)convertIdString image:(NSData *)data fileType:(NSString *)type progress:(nullable void(^)(double uploadProgress))progress completion:(void(^)(NSString *path, BOOL isSuccess))completion;

/// 2转3 转换进度
/// @param urlString 路径
/// @param completion 完成回调
+ (void)converted:(NSString *)urlString completion:(void(^)(BOOL isSuccess, NSDictionary *info))completion;

@end

NS_ASSUME_NONNULL_END
