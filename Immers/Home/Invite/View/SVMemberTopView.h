//
//  SVMemberTopView.h
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import <UIKit/UIKit.h>
#import "SVDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberTopView : UIView

/// 事件回调
@property (nonatomic, copy) void(^actionBlock)(NSInteger type);

/// 设备信息
@property (nonatomic, strong) SVDevice *device;

/// 需要审核人数
@property (nonatomic, copy) NSString *auditNum;

/// 当前角色（1:主人 2:管理员 3:普通成员）
@property (nonatomic, assign) NSInteger currentRole;

@end

NS_ASSUME_NONNULL_END
