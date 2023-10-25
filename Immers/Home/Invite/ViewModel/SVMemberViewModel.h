//
//  SVMemberViewModel.h
//  Immers
//
//  Created by developer on 2023/3/10.
//

#import "SVBaseViewModel.h"
#import "SVUserInfo.h"
#import "SVApply.h"
#import "SVInvite.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberViewModel : SVBaseViewModel

// MARK: - 成员管理
/// 获取相框成员管理信息
/// - Parameters:
///   - memberId: 设备id
///   - completion: 完成回调
- (void)loadMembers:(NSString *)deviceId completion:(SVSuccessCompletion)completion;


/// 删除成员
/// - Parameters:
///   - memberId: 成员id
///   - completion: 完成回调
- (void)deleteMember:(NSString *)memberId completion:(SVSuccessCompletion)completion;

/// 修改成员信息
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)updateMember:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 转让设备
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)transferDevice:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 获取转让成员列表
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)transferMember:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 退出成员
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)exitDevice:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;



// MARK: - 邀请管理
/// 邀请加入相框
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)invite:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 邀请处理
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)inviteHandler:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 邀请处理
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)inviteList:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 获取待处理邀请数量
/// - Parameters:
///   - completion: 完成回调
- (void)invitesNumCompletion:(SVSuccessCompletion)completion;


// MARK: - 审核管理
/// 获取待审核列表
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)applyList:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;

/// 获取审核详情
/// - Parameters:
///   - applyId: 审核ID
///   - completion: 完成回调
- (void)applyInfo:(NSString *)applyId completion:(SVSuccessCompletion)completion;


/// 申请加入相框
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)apply:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;


/// 成员审核
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)memberApply:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;


/// 获取待审数量
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)applyNum:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion;


// MARK: - property
/// 使用者管理
@property (nonatomic, strong) SVUserInfo *userInfo;

/// 邀请列表
@property (nonatomic, strong) NSMutableArray<SVApply *> *applys;

/// 被邀请列表
@property (nonatomic, strong) NSMutableArray<SVInvite *> *invites;

/// 管理员列表
@property (nonatomic, strong) NSMutableArray<SVMember *> *members;

@end

NS_ASSUME_NONNULL_END
