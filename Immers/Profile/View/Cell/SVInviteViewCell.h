//
//  SVInviteViewCell.h
//  Immers
//
//  Created by developer on 2023/2/21.
//

#import "SVTableViewCell.h"
#import "SVInvite.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVInviteViewCell : SVTableViewCell

/// 事件回调
@property (nonatomic,copy)void(^actionBlock)(NSInteger index);

/// 邀请数据
@property (nonatomic, strong) SVInvite *invite;

@end

NS_ASSUME_NONNULL_END
