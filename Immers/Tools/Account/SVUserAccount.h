//
//  SVUserAccount.h
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import <Foundation/Foundation.h>
#import "SVDeviceInfo.h"
#import "SVDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVUserAccount : NSObject

/// 邮箱
@property (nonatomic, copy) NSString *email;
/// 电话
@property (nonatomic, copy) NSString *phone;
/// 用户登录令牌 token
@property (nonatomic, copy, nullable) NSString *loginKey;
/// 用户id
@property (nonatomic, copy, nullable) NSString *userId;
/// 用户头像
@property (nonatomic, copy) NSString *userImage;
/// 用户名
@property (nonatomic, copy) NSString *userName;
/// 用户性别（0女；1男；2未知）
@property (nonatomic, assign) NSUInteger userSex;
/// 是否绑定微信(0否1是)
@property (nonatomic, assign) NSUInteger bindWx;
/// 帐号
@property (nonatomic, copy, readonly) NSString *account;
/// 是否登录
@property (nonatomic, assign, readonly, getter=isLogon) BOOL logon;
/// 当前选中的相框信息
@property (nonatomic, strong)SVDeviceInfo *deviceInfo;
/// 当前选中的相框
@property (nonatomic, strong,nullable) SVDevice *device;
/// 当前登录用户
+ (instancetype)sharedAccount;

/// 保存帐号信息
- (void)saveAccount;

/// 删除帐号信息
- (void)removeAccount;

@end

NS_ASSUME_NONNULL_END
