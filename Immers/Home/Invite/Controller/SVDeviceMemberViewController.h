//
//  SVDeviceMemberViewController.h
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVBaseViewController.h"
#import "SVDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDeviceMemberViewController : SVBaseViewController

/// 设备信息
@property (nonatomic, strong) SVDevice *device;

@end

NS_ASSUME_NONNULL_END
