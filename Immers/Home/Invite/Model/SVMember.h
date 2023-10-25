//
//  SVMember.h
//  Immers
//
//  Created by developer on 2023/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMember : NSObject

/// 相框ID
@property (nonatomic, copy) NSString *framePhotoId;

/// 邮箱
@property (nonatomic, copy) NSString *memberEmail;

/// 成员头像
@property (nonatomic, copy) NSString *memberHeadUrl;

/// 用户ID
@property (nonatomic, copy) NSString *userId;

/// 成员名称
@property (nonatomic, copy) NSString *memberName;

/// 电话
@property (nonatomic, copy) NSString *memberPhone;

/// 成员角色（1:主人 2:管理员 3:普通成员）
@property (nonatomic, assign) NSInteger memberRole;

/// 成员ID
@property (nonatomic, assign) NSInteger memberId;

/// 角色
@property (nonatomic, copy, readonly) NSString *role;

/// 角色颜色
@property (nonatomic, copy, readonly) NSString *roleColor;

@end

NS_ASSUME_NONNULL_END
