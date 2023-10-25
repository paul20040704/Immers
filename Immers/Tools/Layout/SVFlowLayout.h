//
//  SVFlowLayout.h
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 相框设备
#define kDeviceScale 1.46
@interface SVDeviceLayout : UICollectionViewFlowLayout

@end

/// 文件
@interface SVFilesLayout : UICollectionViewFlowLayout

@end

/// 相册
@interface SVAlbumLayout : UICollectionViewFlowLayout

@end

/// 相框
@interface SVPhotoFrameLayout : UICollectionViewFlowLayout

@end

/// 资源
@interface SVResourceFrameLayout : UICollectionViewFlowLayout

@end

//AI
@interface SVAIFrameLayout : UICollectionViewFlowLayout

@end

/// 宠物
@interface SVPetFrameLayout : UICollectionViewFlowLayout

@end

/// 宠物动作
@interface SVPetActionFrameLayout : UICollectionViewFlowLayout

@end
NS_ASSUME_NONNULL_END
