//
//  SVDeviceService.h
//  Immers
//
//  Created by developer on 2022/5/31.
//

#import "SVNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDeviceService : NSObject

// MARK: - 绑定
/// 用户设备列表
/// @param completion 完成回调
+ (void)devicesCompletion:(SVRequestCompletion)completion;

/// 绑定设备
/// @param parameters 参数
/// @param completion 完成回调
+ (void)bindDevice:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 解绑设备
/// @param parameters 参数
/// @param completion 完成回调
+ (void)unbindDevice:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;


/// 下载资源
/// @param parameters 参数
/// @param completion 完成回调
+ (void)downloadResource:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 获取资源
/// @param parameters 参数
/// @param completion 完成回调
+ (NSURLSessionDataTask *)getImageResource:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;


/// 设备信息
/// @param parameters 参数
/// @param completion 完成回调
+ (void)deviceInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 设备名称
/// @param parameters 参数
/// @param completion 完成回调
+ (void)deviceName:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 设备是否在线
/// @param parameters 参数
/// @param completion 完成回调
+ (void)deviceOnline:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

// MARK: - 图集
/// 增加设备图集
/// @param parameters 参数
/// @param completion 完成回调
+ (void)addGallery:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 删除设备图集
/// @param parameters 参数
/// @param completion 完成回调
+ (void)removeGallery:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 设备的图集列表
/// @param parameters 参数
/// @param completion 完成回调
+ (void)galleries:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 图集的图片（视频）
/// @param parameters 参数
/// @param completion 完成回调
+ (void)galleryImages:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 获取相框下载列表
/// @param parameters 参数
/// @param completion 完成回调
+ (void)tasks:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 获取相框下载数量(设备不在线时从后台获取)
/// @param parameters 参数
/// @param completion 完成回调
+ (void)taskNum:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

// MARK: - 上传
/// 用户上传所需的Api
/// @param parameters 参数
/// @param completion 完成回调
+ (void)uploadApi:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 上传图片(视频)信息
/// @param parameters 参数
/// @param completion 完成回调
+ (void)syncFile:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 删除图集的单（多）个图片（视频）
/// @param parameters 参数
/// @param completion 完成回调
+ (void)removeFiles:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

/// 返回相框图片
/// @param parameters 参数
/// @param completion 完成回调
+ (void)framePhoto:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

// MARK: - 排序
/// 图集图片（视频）排序
/// @param parameters 参数
/// @param completion 完成回调
+ (void)sort:(NSDictionary *)parameters completion:(SVRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END
