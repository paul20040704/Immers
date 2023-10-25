//
//  SVUserAccount.m
//  Immers
//
//  Created by developer on 2022/5/30.
//

#import "SVUserAccount.h"

/// 保存路径
#define kAccountPath (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject)

#import "SVUserAccount.h"

/// 保存文件名
static NSString *const kAccountFileName = @"userAccount.json";

@implementation SVUserAccount

/// 单例
+ (instancetype)sharedAccount {
    static SVUserAccount *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SVUserAccount alloc] init];
    });
    return instance;
}

/// 初始化
- (instancetype)init {
    if (self = [super init]) {
        // 加载文件
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[kAccountPath stringByAppendingPathComponent:kAccountFileName]];
        if (dict) {
            // 设置用户信息
            [self setValuesForKeysWithDictionary:dict];
        }
    }
    return self;
}

/// 是否登录
- (BOOL)isLogon {
    return self.userId && self.userId.length > 0 && self.loginKey && self.loginKey.length > 0;
}

/// 帐号
- (NSString *)account {
    return (nil != self.email && self.email.length > 0) ? self.email : self.phone;
}

- (NSString *)email {
    return _email ? : @"";
}

- (NSString *)phone {
    return _phone ? : @"";
}

- (NSString *)userImage {
    return _userImage ? : @"";
}

/// 保存帐号信息
- (void)saveAccount {
    NSArray<NSString *> *keys = @[ @"email", @"phone", @"loginKey", @"userImage", @"userId", @"userName" ];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryWithValuesForKeys:keys]];
    [dict writeToFile:[kAccountPath stringByAppendingPathComponent:kAccountFileName] atomically:YES];
}

/// 删除帐号信息
- (void)removeAccount {
    self.userId = nil;
    self.loginKey = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[kAccountPath stringByAppendingPathComponent:kAccountFileName] error:NULL];
}

// MARK: - KVC 设置值
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"userSex"]) {
        self.userSex = [value integerValue]; // [value isKindOfClass:[NSString class]] ? [value integerValue] : []
        return;
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
