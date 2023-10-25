//
//  SVInvite.h
//  Immers
//
//  Created by developer on 2023/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVInvite : NSObject

/// 相框ID
@property (nonatomic, copy) NSString *framePhotoId;
/// 相框名称
@property (nonatomic, copy) NSString *framePhotoName;
/// id
@property (nonatomic, copy) NSString *i_id;
/// 被邀请者邮箱
@property (nonatomic, copy) NSString *inviteeEmail;
/// 被邀请者头像
@property (nonatomic, copy) NSString *inviteeHeadUrl;
/// 被邀请者ID
@property (nonatomic, copy) NSString *inviteeId;
/// 被邀请者名称
@property (nonatomic, copy) NSString *inviteeName;
/// 被邀请者电话
@property (nonatomic, copy) NSString *inviteePhone;
/// 邀请者邮箱
@property (nonatomic, copy) NSString *inviterEmail;
/// 邀请者头像
@property (nonatomic, copy) NSString *inviterHeadUrl;
/// 邀请者ID
@property (nonatomic, copy) NSString *inviterId;
/// 邀请者名称
@property (nonatomic, copy) NSString *inviterName;
/// 邀请者电话
@property (nonatomic, copy) NSString *inviterPhone;
/// 状态: 0: 待答复 1:同意 2:拒接
@property (nonatomic, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
