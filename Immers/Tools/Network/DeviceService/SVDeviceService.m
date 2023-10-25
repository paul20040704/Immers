//
//  SVDeviceService.m
//  Immers
//
//  Created by developer on 2022/5/31.
//

#import "SVDeviceService.h"

@implementation SVDeviceService

// MARK: - 绑定
/// 用户设备列表
+ (void)devicesCompletion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userFramePhoto/userDeviceList" parameters:@{} completion:completion];
}

/// 绑定设备
+ (void)bindDevice:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userFramePhoto/addUserDevice" parameters:parameters completion:completion];
}

/// 解绑设备
+ (void)unbindDevice:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userFramePhoto/delUserDevice" parameters:parameters completion:completion];
}

/// 下载资源
+ (void)downloadResource:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userFramePhoto/downloadResource" parameters:parameters completion:completion];
}

/// 获取资源
+ (NSURLSessionDataTask *)getImageResource:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    return [[SVNetworkManager sharedManager] POST:@"userFramePhoto/getImageResource" parameters:parameters completion:completion];
}

/// 设备信息
+ (void)deviceInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhoto/getDeviceInfo" parameters:parameters completion:completion];
}

/// 设备名称
+ (void)deviceName:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhoto/updateDeviceName" parameters:parameters completion:completion];
}

/// 设备是否在线
+ (void)deviceOnline:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhoto/online" parameters:parameters completion:completion];
}


// MARK: - 图集
/// 增加设备图集
+ (void)addGallery:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoGallery/addDeviceGallery" parameters:parameters completion:completion];
}

/// 删除设备图集
+ (void)removeGallery:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoGallery/delDeviceGallery" parameters:parameters completion:completion];
}

/// 设备的图集列表
+ (void)galleries:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoGallery/deviceGalleryList" parameters:parameters completion:completion];
}

/// 图集的图片（视频）
+ (void)galleryImages:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userUploadImg/galleryImageList" parameters:parameters completion:completion];
}

/// 获取相框下载列表
+ (void)tasks:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userFramePhoto/getDownImage" parameters:parameters completion:completion];
}

/// 获取相框下载数量(设备不在线时从后台获取)
+ (void)taskNum:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userFramePhoto/getDownNums" parameters:parameters completion:completion];
}

// MARK: - 上传
/// 用户上传所需的Api
+ (void)uploadApi:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    // V1.0.0 -> @"userUploadImg/uploadApi"
    // V1.1.0 -> @"userUploadImg/newUploadApi"
    [[SVNetworkManager sharedManager] POST:@"userUploadImg/getConvertApi" parameters:parameters completion:completion];
}

/// 上传图片(视频)信息
+ (void)syncFile:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    // V1.0.0 -> @"userUploadImg/uploadImg"
    // V1.1.0 -> @"userUploadImg/newUploadImg"
    [[SVNetworkManager sharedManager] POST:@"userUploadImg/newUploadImg" parameters:parameters completion:completion];
}

/// 删除图集的单（多）个图片（视频）
+ (void)removeFiles:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userUploadImg/delImg" parameters:parameters completion:completion];
}

/// 返回相框图片
/// @param parameters 参数
/// @param completion 完成回调
+ (void)framePhoto:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"userFramePhoto/getFramePhoto" parameters:parameters completion:completion];
}

// MARK: - 排序
/// 图集图片（视频）排序
/// @param parameters 参数
/// @param completion 完成回调
+ (void)sort:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"galleryImage/sortGalleryImg" parameters:parameters completion:completion];
}

@end
