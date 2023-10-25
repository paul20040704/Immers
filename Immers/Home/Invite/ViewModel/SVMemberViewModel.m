//
//  SVMemberViewModel.m
//  Immers
//
//  Created by developer on 2023/3/10.
//

#import "SVMemberViewModel.h"
#import "SVMemberService.h"

@implementation SVMemberViewModel

// MARK: - 成员管理
/// 获取相框成员管理信息
/// - Parameters:
///   - memberId: 设备id
///   - completion: 完成回调
- (void)loadMembers:(NSString *)deviceId completion:(SVSuccessCompletion)completion {
    if (nil == deviceId || [deviceId trimming].length < 0 ) {
        completion(NO, @"设备id有误");
    }
    [SVMemberService loadMembers:@{ @"framePhotoId" : deviceId } completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            self.userInfo = [SVUserInfo yy_modelWithDictionary:info];
            completion(YES, nil);
            
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 删除成员
/// - Parameters:
///   - memberId: 成员id
///   - completion: 完成回调
- (void)deleteMember:(NSString *)memberId completion:(SVSuccessCompletion)completion {
    if (nil == memberId || memberId.length < 0 ) {
        completion(NO, SVLocalized(@"tip_delete_failed"));
    }
    
    [SVMemberService deleteMember:@{ @"memberId" : memberId } completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_delete_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}


/// 修改成员信息
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)updateMember:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService updateMember:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_modification_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 转让设备
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)transferDevice:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService transferDevice:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 获取转让成员列表
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)transferMember:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService transferMember:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [self.members removeAllObjects];
            [self.members addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVMember class] json:info]];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 退出成员
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)exitDevice:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService exitDevice:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_exit_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}


// MARK: - 邀请管理
/// 邀请加入相框
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)invite:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService invite:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_invite_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 邀请处理
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)inviteHandler:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService inviteHandler:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_operation_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}


/// 邀请处理
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)inviteList:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService inviteList:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [self.invites removeAllObjects];
            NSArray <NSDictionary *> *memberInvites = info[@"memberInvites"];
            [self.invites addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVInvite class] json:memberInvites]];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 获取待处理邀请数量
/// - Parameters:
///   - completion: 完成回调
- (void)invitesNumCompletion:(SVSuccessCompletion)completion {
    [SVMemberService invitesNumCompletion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, [NSString stringWithFormat:@"%@", info]);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

// MARK: - 审核管理
/// 获取待审核列表
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)applyList:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService applyList:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [self.applys removeAllObjects];
            NSArray <NSDictionary *> *applys = info[@"memberApplys"];
            [self.applys addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SVApply class] json:applys]];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 获取审核详情
/// - Parameters:
///   - applyId: 审核ID
///   - completion: 完成回调
- (void)applyInfo:(NSString *)applyId completion:(SVSuccessCompletion)completion {
    if (nil == applyId || [applyId trimming].length < 0 ) {
        completion(NO, @"申请id有误");
    }
    [SVMemberService applyInfo:@{ @"id" : applyId } completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_operation_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}


/// 申请加入相框
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)apply:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService apply:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_operation_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 成员审核
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)memberApply:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService memberApply:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_operation_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}


/// 获取待审数量
/// - Parameters:
///   - parameters: 参数
///   - completion: 完成回调
- (void)applyNum:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVMemberService applyNum:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            self.userInfo.auditNum = [NSString stringWithFormat:@"%@", info];
            completion(YES, nil);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

// MARK: - lazy
- (NSMutableArray<SVApply *> *)applys {
    if (!_applys) {
        _applys = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _applys;
}

- (NSMutableArray<SVInvite *> *)invites {
    if (!_invites) {
        _invites = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _invites;
}

- (NSMutableArray<SVMember *> *)members {
    if (!_members) {
        _members = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _members;
}

@end
