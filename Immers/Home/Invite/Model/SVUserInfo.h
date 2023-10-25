//
//  SVUserInfo.h
//  Immers
//
//  Created by developer on 2023/3/10.
//

#import <Foundation/Foundation.h>
#import "SVMember.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVUserInfo : NSObject

/// 需要审核人数
@property (nonatomic, copy) NSString *auditNum;

/// 当前角色（1:主人 2:管理员 3:普通成员）
@property (nonatomic, assign) NSInteger currentRole;

/// 成员列表
@property (nonatomic, strong) NSMutableArray<SVMember *> *members;

@end

NS_ASSUME_NONNULL_END
