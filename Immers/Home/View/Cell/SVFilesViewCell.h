//
//  SVFilesViewCell.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVCollectionViewCell.h"
#import "SVAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVFilesViewCell : SVCollectionViewCell

/// 图集
@property (nonatomic, strong) SVAsset *asset;

/// 删除回调
@property (nonatomic, copy) void(^removeCallback)(NSString *aid);

@end

NS_ASSUME_NONNULL_END
