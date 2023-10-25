//
//  SVFilesViewController.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SVFilesType) {
    SVFilesTypeImage = 100, // 图片
    SVFilesTypeVideo // 视频
};


@interface SVFilesViewController : SVBaseViewController

/// 文件管理
/// @param type 文件类型
/// @param deviceId 设备id
/// @param data 上传数据
+ (instancetype)viewControllerWithType:(SVFilesType)type deviceId:(NSString *)deviceId data:(nullable NSData * )data;

/// 播放图集回调
@property (nonatomic, copy) void(^playGalleryCallback)(NSString *name);

@end

NS_ASSUME_NONNULL_END
