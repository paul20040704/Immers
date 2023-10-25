//
//  SVTransferViewController.h
//  Immers
//
//  Created by developer on 2023/3/13.
//

#import "SVBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVTransferViewController : SVBaseViewController

/// 设备id
@property (nonatomic, copy) NSString *deviceId;

/// 更新角色
@property (nonatomic, copy) void(^updateRole)(void);

@end

NS_ASSUME_NONNULL_END
