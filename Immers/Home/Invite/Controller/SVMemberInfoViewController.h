//
//  SVMemberInfoViewController.h
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVBaseViewController.h"
#import "SVMember.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberInfoViewController : SVBaseViewController

/// 成员信息
@property (nonatomic, strong) SVMember *member;

/// 角色
@property (nonatomic, assign) NSInteger currentRole;

/// 删除 / 修改 回调
@property (nonatomic, copy) void(^updateMemberList)(BOOL remove);

@end

NS_ASSUME_NONNULL_END
