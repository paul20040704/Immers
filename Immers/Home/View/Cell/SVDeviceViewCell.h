//
//  SVDeviceViewCell.h
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import "SVCollectionViewCell.h"
#import "SVDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDeviceViewCell : SVCollectionViewCell

@property (nonatomic, strong) SVDevice *device;

@end

NS_ASSUME_NONNULL_END
