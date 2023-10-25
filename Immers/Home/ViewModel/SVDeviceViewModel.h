//
//  SVDeviceViewModel.h
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVBaseViewModel.h"
#import "SVSettings.h"
#import "SVPlaySection.h"
#import "SVAsset.h"
#import "SVDevice.h"
#import "SVDown.h"
#import "SVDeviceData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDeviceViewModel : SVBaseViewModel

// MARK: - 绑定

/// 用户设备列表
/// @param completion 完成回调
- (void)devicesCompletion:(SVSuccessCompletion)completion;

/// 绑定设备
/// @param parameters 参数
/// @param completion 完成回调
- (void)bindDevice:(NSDictionary *)parameters completion:(SVCodeCompletion)completion;

/// 解绑设备
/// @param parameters 参数
/// @param completion 完成回调
- (void)unbindDevice:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 设备信息
/// @param parameters 参数
/// @param completion 完成回调
- (void)deviceInfo:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 设备信息/在线状态
/// @param parameters 参数
/// @param completion 完成回调
- (void)deviceStatus:(NSDictionary *)parameters completion:(SVCodeCompletion)completion;

/// 设备存储空间
/// @param parameters 参数
/// @param completion 完成回调
- (void)deviceRAM:(NSDictionary *)parameters completion:(SVCodeCompletion)completion;

/// 设备名称
/// @param parameters 参数
/// @param completion 完成回调
- (void)deviceName:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 设备是否在线
/// @param parameters 参数
/// @param completion 完成回调
- (void)deviceOnline:(NSDictionary *)parameters completion:(SVResultCompletion)completion;

/// 获取任务中心下载数量
/// @param parameters 参数
/// @param completion 完成回调
- (void)taskNum:(NSDictionary *)parameters completion:(SVResultCompletion)completion;

// MARK: - 图集
/// 增加设备图集
/// @param parameters 参数
/// @param completion 完成回调
- (void)addGallery:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 删除设备图集
/// @param parameters 参数
/// @param completion 完成回调
- (void)removeGallery:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 设备的图集列表
/// @param parameters 参数
/// @param completion 完成回调
- (void)galleries:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 图集的图片（视频）
/// @param parameters 参数
/// @param completion 完成回调
- (void)galleryImages:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 获取相框下载列表
/// @param parameters 参数
/// @param completion 完成回调
- (void)tasks:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

// MARK: - 上传
/// 上传图片
/// @param data 图片信息
/// @param parameters 参数
/// @param progress 上传进度
/// @param completion 完成回调
- (void)uploadImage:(NSData *)data parameters:(NSDictionary *)parameters progress:(nullable void(^)(double uploadProgress))progress completion:(SVSuccessCompletion)completion;

/// 删除图集的单（多）个图片（视频）
/// @param parameters 参数
/// @param completion 完成回调
- (void)removeFiles:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 返回相框图片
/// @param parameters 参数
/// @param completion 完成回调
- (void)framePhoto:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 2转3 转换进度
/// @param urlString 路径
/// @param completion 完成回调
- (void)converted:(NSString *)urlString completion:(SVCodeCompletion)completion;

// MARK: - 排序
/// 图集图片（视频）排序
/// @param parameters 参数
/// @param completion 完成回调
- (void)sort:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

// MARK: - 文件管理
/// 获取文件列表
/// @param reload 是否刷新
/// @param completion 完成回调
- (void)localFiles:(BOOL )reload storageType:(NSInteger )storageType completion:(SVSuccessCompletion)completion;

/// 收到文件列表
- (void)requestLocalFiles:(SVSuccessCompletion)completion;

/// 获取单个文件封面
/// @param path 文件路径
/// @param completion 完成回调
- (void)localFileCover:(NSString *)path completion:(SVSuccessCompletion)completion;

/// 收到文件相关其他mqtt信息
- (void)requestFileOtherResult:(SVResultCompletion)completion;

/// 删除文件
- (void)deleteLocalFile:(SVSuccessCompletion)completion;

///将文件添加到播放列表
- (void)addFileToPlay:(SVSuccessCompletion)completion;

@property (nonatomic,copy)NSString *deviceId;

// MARK: - Lsit
/// 设置选项
@property (nonatomic, strong) NSArray<SVSettings *> *settings;

/// 无网络设置选项
@property (nonatomic, strong) NSArray<SVSettings *> *noNetSettings;

/// 播放设置
@property (nonatomic, strong) NSArray <SVPlaySection *> *sections;

/// 图集
@property (nonatomic, strong) NSMutableArray <SVAsset *> *assets;

/// 设备
@property (nonatomic, strong) NSMutableArray <SVDevice *> *devices;

/// 文件
@property (nonatomic, strong) NSMutableArray <SVFile *> *files;

/// V1.1.0 服务器返回 图片数据
@property (nonatomic, strong) NSMutableArray <SVPhoto *> *photos;

/// 下载任务
@property (nonatomic, strong) NSMutableArray <SVDown *> *downs;

/// 文件管理本地数据
@property (nonatomic, strong) SVLocalFileRequest *localFile;

/// 文件管理U盘数据
@property (nonatomic, strong) SVLocalFileRequest *usbFile;

/// 选中的文件
@property (nonatomic, strong) NSMutableArray <SVLocalFile *> *selectLocalFiles;

/// 设备信息
@property (nonatomic, strong) SVDeviceData *deviceData;

@end

NS_ASSUME_NONNULL_END
