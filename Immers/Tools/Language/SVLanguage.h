//
//  SVLanguage.h
//  Immers
//
//  Created by developer on 2022/5/25.
//

#import <Foundation/Foundation.h>

#define Localized(key) [SVLanguage localizedForKey:key]

NS_ASSUME_NONNULL_BEGIN

@interface SVLanguage : NSObject

/// 获取语言
+ (void)sharedLanguage;

/// 设置语言
+ (void)saveLanguage:(NSString *)language;

/// 本地话
+ (NSString *)localizedForKey:(NSString *)key;

/// 请求 服务器 header 语言
+ (NSString *)remote;

/// 本地保存语言
+ (NSString *)local;

/// 所有语言
+ (NSArray <NSDictionary <NSString *, NSString *> *> *)items;

/// 当前设置语言
+ (NSString *)current;


@end

NS_ASSUME_NONNULL_END
