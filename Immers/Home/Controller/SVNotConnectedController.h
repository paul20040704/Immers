//
//  SVNotConnectedController.h
//  Immers
//
//  Created by developer on 2022/5/20.
//

#import "SVBaseViewController.h"
#import "SVDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVNotConnectedController : SVBaseViewController
/// 设备信息
@property (nonatomic, strong) SVDevice *device;
@end

NS_ASSUME_NONNULL_END
