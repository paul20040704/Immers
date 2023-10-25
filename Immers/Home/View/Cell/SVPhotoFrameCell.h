//
//  SVPhotoFrameCell.h
//  Immers
//
//  Created by developer on 2022/9/13.
//

#import "SVCollectionViewCell.h"
#import "SVDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVPhotoFrameCell : SVCollectionViewCell

@property (nonatomic, strong) SVDevice *device;

@property (nonatomic, copy) void(^selectedCallback)(SVDevice *device);

@end

NS_ASSUME_NONNULL_END
