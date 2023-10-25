//
//  SVMemberService.m
//  Immers
//
//  Created by developer on 2023/3/10.
//

#import "SVMemberService.h"

@implementation SVMemberService

// MARK: - 成员管理
/// 获取相框成员管理信息
/// - Parameters:
///   - deviceId: 参数
///   - completion: 完成回调
+ (void)loadMembers:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoMember/getFramePhotoMemberManageInfo" parameters:parameters completion:completion];
}

/// 删除成员
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)deleteMember:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoMember/deleteFramePhotoMember" parameters:parameters completion:completion];
}


/// 修改成员信息
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)updateMember:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoMember/updateFramePhotoMember" parameters:parameters completion:completion];
}

/// 转让设备
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)transferDevice:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoMember/transferDevice" parameters:parameters completion:completion];
}

/// 获取转让成员列表
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)transferMember:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoMember/getTransferMemberList" parameters:parameters completion:completion];
}

/// 退出成员
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)exitDevice:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"framePhotoMember/exitFramePhotoMember" parameters:parameters completion:completion];
}

// MARK: - 邀请管理

/// 邀请加入相框
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)invite:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberInvite/memberInviteJionFramePhoto" parameters:parameters completion:completion];
}


/// 邀请处理
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)inviteHandler:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberInvite/memberInviteHandler" parameters:parameters completion:completion];
}

/// 邀请处理
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)inviteList:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberInvite/getMemberInvitePageList" parameters:parameters completion:completion];
}

/// 获取待处理邀请数量
/// - Parameters:
///   - completion: 完成回调
+ (void)invitesNumCompletion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberInvite/getMemberInvitesNum" parameters:@{} completion:completion];
}

// MARK: - 审核管理

/// 获取待审核列表
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)applyList:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberApply/getMemberApplyList" parameters:parameters completion:completion];
}

/// 获取审核详情
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)applyInfo:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberApply/getMemberApplyInfo" parameters:parameters completion:completion];
}


/// 申请加入相框
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)apply:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberApply/applyJionFramePhoto" parameters:parameters completion:completion];
}

/// 成员审核
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)memberApply:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberApply/memberApply" parameters:parameters completion:completion];
}


/// 获取待审数量
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
+ (void)applyNum:(NSDictionary *)parameters completion:(SVRequestCompletion)completion {
    [[SVNetworkManager sharedManager] POST:@"memberApply/getMemberApplyNum" parameters:parameters completion:completion];
}

@end
