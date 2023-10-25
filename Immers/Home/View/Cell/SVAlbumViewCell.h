//
//  SVAlbumViewCell.h
//  Immers
//
//  Created by developer on 2022/5/23.
//

#import "SVCollectionViewCell.h"
#import "SVAsset.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVAlbumViewCell : SVCollectionViewCell

/// 图集
@property (nonatomic, strong) SVFile *file;

/// 相册
@property (nonatomic, strong) SVPhoto *photo;

/// 本地文件
@property (nonatomic, strong) SVLocalFile *localFile;

@end

NS_ASSUME_NONNULL_END
