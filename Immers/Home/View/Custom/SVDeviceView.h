//
//  SVDeviceView.h
//  Immers
//
//  Created by developer on 2022/5/16.
//

#import <UIKit/UIKit.h>
#import "SVDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDeviceView : UICollectionView

/// 设备
@property (nonatomic, strong) NSMutableArray <SVDevice *> *devices;

/// 更新选中设备
@property (nonatomic, copy) void(^updateSelectedDeviceCallback)(SVDevice *device);

- (void)updateDeviceStatus;

@end

NS_ASSUME_NONNULL_END
