//
//  SVInterfaces.h
//  Immers
//
//  Created by developer on 2022/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVInterfaces : NSObject

/// 创建实例
+ (instancetype)interfaces;

/// 获取ssid
/// @param interface 获取ssid 回调
/// @param denied 拒绝 回调
- (void)ssid:(void((^)(NSString *ssid)))interface denied:(void((^)(void)))denied;

/// 获取当前ssid
- (NSString *)ssid;

@end

NS_ASSUME_NONNULL_END
