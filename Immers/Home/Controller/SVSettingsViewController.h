//
//  SVSettingViewController.h
//  Immers
//
//  Created by developer on 2022/5/18.
//

#import "SVBaseViewController.h"
#import "SVDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVSettingsViewController : SVBaseViewController

/// 设备信息
@property (nonatomic, strong) SVDevice *device;

/// 更新设备名
@property (nonatomic, copy) void(^updateDeviceNameCallback)(NSString *name);

@end

NS_ASSUME_NONNULL_END
