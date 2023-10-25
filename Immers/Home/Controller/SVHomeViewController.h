//
//  SVHomeViewController.h
//  Immers
//
//  Created by developer on 2022/5/12.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVHomeViewController : SVBaseViewController

/// 设备状态
- (void)deviceStatus:(void(^)(void))callback;

@end

NS_ASSUME_NONNULL_END
