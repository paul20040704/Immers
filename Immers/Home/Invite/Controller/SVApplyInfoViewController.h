//
//  SVApplyInfoViewController.h
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVBaseViewController.h"
#import "SVApply.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVApplyInfoViewController : SVBaseViewController

/// 申请人信息
@property (nonatomic, strong) SVApply *apply;

/// 更新申请列表
@property (nonatomic, copy) void(^updateApplyList)(void);

@end

NS_ASSUME_NONNULL_END
