//
//  SVAlbumViewController.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVBaseViewController.h"
#import "SVAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVAlbumViewController : SVBaseViewController

/// 图集
@property (nonatomic, strong) SVAsset *asset;

/// 设备id
@property (nonatomic, copy) NSString *deviceId;

/// 要上传的图片数据
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
