//
//  SVUserViewModel.m
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import "SVUserViewModel.h"
#import "SVUserService.h"
#import "SVFileService.h"

@implementation SVUserViewModel

/// 登录
- (void)login:(NSDictionary *)parameters completion:(SVMessageCompletion)completion {
    [SVUserService login:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if(0 == errorCode) {
            [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:info];
            [[SVUserAccount sharedAccount] saveAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(info[KErrorMsg]);
        }
    }];
}

/// 注册
- (void)register:(NSDictionary *)parameters completion:(SVMessageCompletion)completion {
    [SVUserService register:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if(0 == errorCode) {
            [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:info];
            [[SVUserAccount sharedAccount] saveAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(info[KErrorMsg]);
        }
    }];
}

/// 帐号检查
- (void)account:(NSString *)account completion:(SVSuccessCompletion)completion {
    if (account.length <= 0 || nil == account) {
        completion(NO, SVLocalized(@"home_account_exist"));
        return;
    }
    [SVUserService account:@{ @"account" : account } completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
//            BOOL bind = [info[@"bind"] integerValue]; // 0 不存在  1 存在
//            (0 == bind) ? completion(YES, nil) : completion(NO, @"该手机号或邮箱已被绑定");
            completion(YES, [NSString stringWithFormat:@"%@", info[@"bind"]]);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 用户名字帐号密码全检查
- (void)verifyUser:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService verifyUser:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        0 == errorCode ? completion(YES, nil) :  completion(NO, info[KErrorMsg]);
    }];
}

/// 忘记密码
- (void)forget:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService forget:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_modification_succeed"));
            [[SVUserAccount sharedAccount] removeAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 修改密码
- (void)updatePassword:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService updatePassword:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_modification_succeed"));
            [[SVUserAccount sharedAccount] removeAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 用户登出
- (void)logoutCompletion:(SVSuccessCompletion)completion {
    [SVUserService logoutCompletion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_quit_succeed"));
            [[SVUserAccount sharedAccount] removeAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 发送验证码
- (void)sendCode:(NSString *)account  countryCode:(NSString *)code completion:(SVSuccessCompletion)completion {
    if (account.length <= 0 || nil == account) {
        completion(NO, SVLocalized(@"tip_verification_code"));
        return;
    }
    [SVUserService sendCode:@{ @"account" : account, @"countryCode" : code} completion:^(NSInteger errorCode, NSDictionary *info) {
        0 == errorCode ? completion(YES, info[@"msgId"]) :  completion(NO, info[KErrorMsg]);
    }];
}

/// 校验验证码
/// @param parameters 参数
/// @param completion 完成回调
- (void)validCode:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService validCode:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, info[@"token"]);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 用户信息
/// @param completion 完成回调
- (void)userCompletion:(SVRequestCompletion)completion {
    [SVUserService userCompletion:^(NSInteger errorCode, NSDictionary *info) {
        if(0 == errorCode) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:info];
            [dict removeObjectForKey:@"loginKey"];
            [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:dict];
            [[SVUserAccount sharedAccount] saveAccount];
        }
    }];
}

/// 修改用户信息
/// @param parameters 参数
/// @param completion 完成回调
- (void)update:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService update:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [self userCompletion:^(NSInteger errorCode, NSDictionary *info) {}];
            [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:parameters];
            [[SVUserAccount sharedAccount] saveAccount];
            completion(YES, SVLocalized(@"tip_modification_succeed"));
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditedToUpdateUserProfileNotification object:nil];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 修改用户头像
- (void)updateAvarat:(UIImage *)avarat completion:(SVSuccessCompletion)completion {
    [SVUserService aliCompletion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [SVFileService uploadAvarat:avarat credentials:info[@"credentials"] completion:^(NSString *path, BOOL isSuccess) {
                if (isSuccess) {
                    NSDictionary *dict = @{ @"userImage" : path };
                    [self update:dict completion:completion];
                } else {
                    completion(NO, SVLocalized(@"tip_uploading_succeed"));
                }
            }];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 校验原密码
- (void)validPassword:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService validPassword:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, info[@"checkToken"]);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 注销帐号
- (void)removeAccount:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService removeAccount:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            completion(YES, SVLocalized(@"tip_logout_succeed"));
            [[SVUserAccount sharedAccount] removeAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 苹果登录
- (void)appleLogin:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService appleLogin:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:info];
            [[SVUserAccount sharedAccount] saveAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 微信登录
/// @param parameters 参数
/// @param completion 完成回调
- (void)wechatLogin:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService wechatLogin:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:info];
            [[SVUserAccount sharedAccount] saveAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 判断第三方登录是否已经注册
/// @param parameters 参数
/// @param completion 完成回调
- (void)verifyThirdParty:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService verifyThirdParty:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            BOOL isRegister = [info[@"register"] boolValue];
            if (isRegister) { // 已经注册
                NSDictionary *dict = info[@"immersUserVo"];
                [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:dict];
                [[SVUserAccount sharedAccount] saveAccount];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchRootViewControllerNotification object:nil];
            } else {
                completion(YES, nil);
            }
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

/// 绑定手机号、邮箱
/// @param parameters 参数
/// @param completion 完成回调
- (void)bindAccount:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService bindAccount:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [[SVUserAccount sharedAccount] setValuesForKeysWithDictionary:info];
            [[SVUserAccount sharedAccount] saveAccount];
            completion(YES, SVLocalized(@"tip_binding_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

///  手机号、邮箱登录 第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
- (void)bindThirdParty:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService bindThirdParty:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [SVUserAccount sharedAccount].bindWx = YES;
            completion(YES, SVLocalized(@"tip_binding_succeed"));
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

///  手机号、邮箱登录 解绑第三方帐号
/// @param parameters 参数
/// @param completion 完成回调
- (void)unbindThirdParty:(NSDictionary *)parameters completion:(SVSuccessCompletion)completion {
    [SVUserService unbindThirdParty:parameters completion:^(NSInteger errorCode, NSDictionary *info) {
        if (0 == errorCode) {
            [SVUserAccount sharedAccount].bindWx = NO;
            completion(YES, [NSString stringWithFormat:@"%@ %@", SVLocalized(@"home_cancel"), SVLocalized(@"tip_binding_succeed")]);
        } else {
            completion(NO, info[KErrorMsg]);
        }
    }];
}

@end
